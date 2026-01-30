#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                    CRITICAL UI BREAKING COMMIT DETECTOR                       ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║ This script uses git bisect to find the FIRST commit where critical UI       ║
# ║ tests started failing.                                                        ║
# ║                                                                               ║
# ║ Usage:                                                                        ║
# ║   ./scripts/find_breaking_commit.sh                                           ║
# ║   ./scripts/find_breaking_commit.sh --good <commit> --bad <commit>            ║
# ║   ./scripts/find_breaking_commit.sh --test <specific_test_file>               ║
# ║                                                                               ║
# ║ Requirements:                                                                 ║
# ║   - Git repository                                                            ║
# ║   - Flutter SDK                                                               ║
# ║                                                                               ║
# ║ Output:                                                                       ║
# ║   - Commit hash of first breaking commit                                      ║
# ║   - Commit message                                                            ║
# ║   - Author info                                                               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_TEST_PATH="test/critical_ui/"
DEFAULT_GOOD_COMMIT=""  # Will use last known good tag/commit
DEFAULT_BAD_COMMIT="HEAD"

# Parse arguments
GOOD_COMMIT=""
BAD_COMMIT="HEAD"
TEST_PATH="$DEFAULT_TEST_PATH"
SPECIFIC_TEST=""
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --good)
            GOOD_COMMIT="$2"
            shift 2
            ;;
        --bad)
            BAD_COMMIT="$2"
            shift 2
            ;;
        --test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --good <commit>    Known good commit (tests pass)"
            echo "  --bad <commit>     Known bad commit (tests fail, default: HEAD)"
            echo "  --test <file>      Specific test file to check"
            echo "  --verbose, -v      Show detailed output"
            echo "  --help, -h         Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Find a known good commit if not specified
find_good_commit() {
    if [ -n "$GOOD_COMMIT" ]; then
        echo "$GOOD_COMMIT"
        return
    fi

    # Try to find last passing CI commit
    # Look for commits with passing CI status
    local last_good=$(git log --oneline -50 | while read hash msg; do
        # Check if critical_ui tests existed and passed at this commit
        if git show "$hash:test/critical_ui/critical_ui_regression_test.dart" &>/dev/null; then
            echo "$hash"
            break
        fi
    done)

    if [ -n "$last_good" ]; then
        echo "$last_good"
        return
    fi

    # Fallback: use commit from 20 commits ago
    local fallback=$(git rev-parse HEAD~20 2>/dev/null || git rev-list --max-parents=0 HEAD)
    echo "$fallback"
}

# Run critical UI tests and return exit code
run_critical_tests() {
    local test_target="$1"

    # Ensure dependencies are installed
    flutter pub get --offline 2>/dev/null || flutter pub get

    # Run the tests
    if [ -n "$SPECIFIC_TEST" ]; then
        flutter test "$SPECIFIC_TEST" --no-pub 2>&1
    else
        flutter test "$test_target" --no-pub 2>&1
    fi

    return $?
}

# Git bisect test script
create_bisect_script() {
    local script_path="/tmp/critical_ui_bisect_test.sh"

    cat > "$script_path" << 'BISECT_SCRIPT'
#!/bin/bash

# This script is run by git bisect at each commit
# Exit 0 = good commit (tests pass)
# Exit 1 = bad commit (tests fail)
# Exit 125 = skip (cannot test this commit)

cd "$(git rev-parse --show-toplevel)"

# Check if Flutter project exists
if [ ! -f "pubspec.yaml" ]; then
    exit 125  # Skip - not a valid Flutter project
fi

# Check if critical UI tests exist
if [ ! -d "test/critical_ui" ]; then
    exit 125  # Skip - tests don't exist yet
fi

# Get dependencies
flutter pub get --offline 2>/dev/null || flutter pub get 2>/dev/null
if [ $? -ne 0 ]; then
    exit 125  # Skip - cannot get dependencies
fi

# Run critical UI tests
flutter test test/critical_ui/critical_ui_regression_test.dart --no-pub 2>&1
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "BISECT: Tests PASSED at $(git rev-parse --short HEAD)"
    exit 0
else
    echo "BISECT: Tests FAILED at $(git rev-parse --short HEAD)"
    exit 1
fi
BISECT_SCRIPT

    chmod +x "$script_path"
    echo "$script_path"
}

# ═══════════════════════════════════════════════════════════════════════════════
# MAIN EXECUTION
# ═══════════════════════════════════════════════════════════════════════════════

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║              CRITICAL UI BREAKING COMMIT DETECTOR                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Verify we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "Not a git repository"
    exit 1
fi

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

log_info "Repository: $REPO_ROOT"

# Find good commit
if [ -z "$GOOD_COMMIT" ]; then
    log_info "Finding last known good commit..."
    GOOD_COMMIT=$(find_good_commit)
fi

log_info "Good commit: $GOOD_COMMIT"
log_info "Bad commit: $BAD_COMMIT"

# Verify commits exist
if ! git rev-parse "$GOOD_COMMIT" > /dev/null 2>&1; then
    log_error "Good commit not found: $GOOD_COMMIT"
    exit 1
fi

if ! git rev-parse "$BAD_COMMIT" > /dev/null 2>&1; then
    log_error "Bad commit not found: $BAD_COMMIT"
    exit 1
fi

# First, verify that current HEAD actually fails
log_info "Verifying current HEAD has failing tests..."
if run_critical_tests "$TEST_PATH" > /dev/null 2>&1; then
    log_success "All critical UI tests are passing! No breaking commit to find."
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║  RESULT: No breaking commit found - all tests pass                           ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    exit 0
fi

log_warning "Tests are failing at HEAD. Starting bisect..."

# Create bisect test script
BISECT_SCRIPT=$(create_bisect_script)
log_info "Bisect script: $BISECT_SCRIPT"

# Save current state
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")
STASH_RESULT=$(git stash push -m "critical-ui-bisect-stash" 2>&1) || true

# Start bisect
log_info "Starting git bisect..."
git bisect start

# Mark commits
git bisect bad "$BAD_COMMIT"
git bisect good "$GOOD_COMMIT"

# Run automated bisect
log_info "Running automated bisect (this may take a while)..."
echo ""

BISECT_OUTPUT=$(git bisect run "$BISECT_SCRIPT" 2>&1)
BISECT_EXIT=$?

if $VERBOSE; then
    echo "$BISECT_OUTPUT"
fi

# Get the result
BREAKING_COMMIT=$(git bisect view --oneline 2>/dev/null | head -1 | cut -d' ' -f1)

# End bisect
git bisect reset > /dev/null 2>&1

# Restore state
if [[ "$STASH_RESULT" != *"No local changes"* ]]; then
    git stash pop > /dev/null 2>&1 || true
fi

# Return to original branch
git checkout "$CURRENT_BRANCH" > /dev/null 2>&1 || true

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                           BISECT RESULTS                                      ║"
echo "╠══════════════════════════════════════════════════════════════════════════════╣"

if [ -n "$BREAKING_COMMIT" ]; then
    COMMIT_INFO=$(git log -1 --format="%H%n%an%n%ae%n%s%n%ci" "$BREAKING_COMMIT" 2>/dev/null)

    if [ -n "$COMMIT_INFO" ]; then
        FULL_HASH=$(echo "$COMMIT_INFO" | sed -n '1p')
        AUTHOR=$(echo "$COMMIT_INFO" | sed -n '2p')
        EMAIL=$(echo "$COMMIT_INFO" | sed -n '3p')
        MESSAGE=$(echo "$COMMIT_INFO" | sed -n '4p')
        DATE=$(echo "$COMMIT_INFO" | sed -n '5p')

        echo "║                                                                              ║"
        echo "║  FIRST BREAKING COMMIT FOUND:                                                ║"
        echo "║                                                                              ║"
        printf "║  Commit:  %-66s ║\n" "$BREAKING_COMMIT"
        printf "║  Full:    %-66s ║\n" "$FULL_HASH"
        printf "║  Author:  %-66s ║\n" "$AUTHOR <$EMAIL>"
        printf "║  Date:    %-66s ║\n" "$DATE"
        printf "║  Message: %-66s ║\n" "${MESSAGE:0:66}"
        echo "║                                                                              ║"
        echo "║  To see full diff:                                                           ║"
        printf "║    git show %s                                              ║\n" "$BREAKING_COMMIT"
        echo "║                                                                              ║"
        echo "║  To see changed files:                                                       ║"
        printf "║    git diff-tree --no-commit-id --name-only -r %s           ║\n" "$BREAKING_COMMIT"
        echo "║                                                                              ║"
    fi

    log_error "Breaking commit identified: $BREAKING_COMMIT"
else
    echo "║                                                                              ║"
    echo "║  Could not identify a specific breaking commit.                              ║"
    echo "║  This may indicate:                                                          ║"
    echo "║    - Tests were always failing in the range                                  ║"
    echo "║    - The good/bad range is incorrect                                         ║"
    echo "║    - Some commits couldn't be tested                                         ║"
    echo "║                                                                              ║"
fi

echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Cleanup
rm -f "$BISECT_SCRIPT"

# Exit with appropriate code
if [ -n "$BREAKING_COMMIT" ]; then
    exit 1  # Breaking commit found
else
    exit 0  # No breaking commit (or couldn't find one)
fi
