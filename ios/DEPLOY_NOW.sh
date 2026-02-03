#!/bin/bash

# ==============================================================================
# MASTER DEPLOYMENT SCRIPT - EVERYTHING AUTOMATED
# ==============================================================================
# This is THE ONLY script you need to run
# It does EVERYTHING for you automatically
# ==============================================================================

chmod +x deploy_ios.sh 2>/dev/null
chmod +x check_deployment.sh 2>/dev/null
chmod +x setup_complete.sh 2>/dev/null
chmod +x auto_deploy.sh 2>/dev/null
chmod +x COMMANDS_REFERENCE.sh 2>/dev/null

clear

cat << "EOF"

╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║                    🚀 iOS DEPLOYMENT - MASTER SCRIPT 🚀                    ║
║                                                                            ║
║                      Everything Automated For You!                         ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝

EOF

echo ""
echo "Starting in 3 seconds..."
sleep 3

# Run the automated deployment script
if [ -f "auto_deploy.sh" ]; then
    ./auto_deploy.sh
else
    echo "Error: auto_deploy.sh not found!"
    echo ""
    echo "Available deployment scripts:"
    ls -1 *.sh 2>/dev/null
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
echo "✅ Setup complete!"
echo ""
echo "Next: Review DEPLOYMENT_REPORT.txt and open Xcode:"
echo ""
echo "  open ios/Runner.xcworkspace"
echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
