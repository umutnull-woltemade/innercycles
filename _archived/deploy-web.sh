#!/bin/bash
# Venus One - Web Deployment Script

set -e  # Exit on error

echo "🚀 Venus One Web Deployment"
echo "============================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Cleaning previous build...${NC}"
flutter clean

echo -e "${YELLOW}📥 Getting dependencies...${NC}"
flutter pub get

echo -e "${YELLOW}🔨 Building web (release mode)...${NC}"
flutter build web --release --no-tree-shake-icons

echo ""
echo -e "${GREEN}✅ Build completed successfully!${NC}"
echo ""
echo "📂 Build output: build/web/"
echo ""

# Check build size
BUILD_SIZE=$(du -sh build/web | cut -f1)
echo "📊 Build size: $BUILD_SIZE"
echo ""

# Test locally option
read -p "🧪 Do you want to test locally? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🌐 Starting local server on http://localhost:8080${NC}"
    echo "Press Ctrl+C to stop"
    cd build/web && python3 -m http.server 8080
    exit 0
fi

echo ""
echo "📋 Deployment Options:"
echo "======================"
echo ""
echo "1. Firebase Hosting:"
echo "   firebase deploy --only hosting"
echo ""
echo "2. Netlify:"
echo "   netlify deploy --prod --dir=build/web"
echo ""
echo "3. Vercel:"
echo "   vercel --prod build/web"
echo ""
echo "4. GitHub Pages:"
echo "   gh-pages -d build/web"
echo ""
echo "See DEPLOYMENT.md for detailed instructions."
echo ""
echo -e "${GREEN}✨ Ready for deployment!${NC}"
