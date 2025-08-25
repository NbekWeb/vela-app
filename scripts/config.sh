#!/bin/bash

# TestFlight Deployment Configuration
# Copy this file to config.local.sh and update with your actual values

# Apple Developer Account
export APPLE_ID="your-apple-id@example.com"
export APPLE_APP_SPECIFIC_PASSWORD="your-app-specific-password"

# App Configuration
export APP_BUNDLE_ID="com.nbekdev.vela"
export APP_NAME="Vela"
export TEAM_ID="YOUR_TEAM_ID"

# Build Configuration
export BUILD_CONFIGURATION="Release"
export EXPORT_METHOD="app-store"

# Optional: Fastlane configuration
export FASTLANE_APPLE_ID="$APPLE_ID"
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="$APPLE_APP_SPECIFIC_PASSWORD"
export FASTLANE_TEAM_ID="$TEAM_ID"

echo "Configuration loaded. Make sure to update config.local.sh with your actual values." 