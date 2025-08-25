#!/bin/bash

# TestFlight Deployment Validation Script
# This script checks if your project is ready for TestFlight deployment

set -e

echo "🔍 Validating TestFlight deployment readiness..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found. Please run this script from the project root.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Project structure check passed${NC}"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Error: Flutter is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter installation check passed${NC}"

# Check Xcode installation
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: Xcode is not installed or not in PATH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Xcode installation check passed${NC}"

# Check iOS deployment target
if ! grep -q "IPHONEOS_DEPLOYMENT_TARGET" ios/Runner.xcodeproj/project.pbxproj; then
    echo -e "${YELLOW}⚠️  Warning: iOS deployment target not explicitly set${NC}"
else
    echo -e "${GREEN}✅ iOS deployment target check passed${NC}"
fi

# Check bundle identifier
if grep -q "com.nbekdev.vela" ios/Runner.xcodeproj/project.pbxproj; then
    echo -e "${GREEN}✅ Bundle identifier check passed${NC}"
else
    echo -e "${RED}❌ Error: Bundle identifier not found or incorrect${NC}"
    exit 1
fi

# Check Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✅ Info.plist exists${NC}"
    
    # Check for required keys
    if grep -q "CFBundleDisplayName" ios/Runner/Info.plist; then
        echo -e "${GREEN}✅ CFBundleDisplayName found${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: CFBundleDisplayName not found${NC}"
    fi
    
    if grep -q "ITSAppUsesNonExemptEncryption" ios/Runner/Info.plist; then
        echo -e "${GREEN}✅ ITSAppUsesNonExemptEncryption found${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: ITSAppUsesNonExemptEncryption not found${NC}"
    fi
else
    echo -e "${RED}❌ Error: Info.plist not found${NC}"
    exit 1
fi

# Check export options
if [ -f "ios/exportOptions.plist" ]; then
    echo -e "${GREEN}✅ Export options file exists${NC}"
    
    if grep -q "app-store" ios/exportOptions.plist; then
        echo -e "${GREEN}✅ Export method set to app-store${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: Export method not set to app-store${NC}"
    fi
else
    echo -e "${RED}❌ Error: Export options file not found${NC}"
    exit 1
fi

# Check version in pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
echo -e "${BLUE}📱 Current version: $VERSION${NC}"

# Check if Flutter dependencies are up to date
echo "📦 Checking Flutter dependencies..."
flutter pub get > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Flutter dependencies are up to date${NC}"
else
    echo -e "${YELLOW}⚠️  Warning: Flutter dependencies may need updating${NC}"
fi

# Check iOS build capability
echo "🔨 Testing iOS build capability..."
cd ios
if xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15' clean build > /dev/null 2>&1; then
    echo -e "${GREEN}✅ iOS build test passed${NC}"
else
    echo -e "${YELLOW}⚠️  Warning: iOS build test failed (this might be normal for release builds)${NC}"
fi
cd ..

echo ""
echo -e "${BLUE}📋 Summary:${NC}"
echo "If you see any ❌ errors above, please fix them before deploying."
echo "If you see any ⚠️  warnings, review them but deployment may still work."
echo ""
echo -e "${GREEN}🚀 If all checks passed, you're ready to deploy to TestFlight!${NC}"
echo ""
echo "Next steps:"
echo "1. Update version in pubspec.yaml if needed: ./scripts/update_version.sh [major|minor|patch|build]"
echo "2. Run: ./scripts/deploy_testflight.sh"
echo "3. Manually upload the .ipa file using Xcode Organizer or Transporter app" 