# TestFlight Deployment Guide for Vela

This guide will help you deploy the Vela app to TestFlight for beta testing.

## Prerequisites

1. **Apple Developer Account** ($99/year)
2. **Xcode** (latest version recommended)
3. **Flutter** (latest stable version)
4. **App Store Connect Access**

## Setup Steps

### 1. Apple Developer Account Setup

1. Go to [Apple Developer](https://developer.apple.com)
2. Sign in with your Apple ID
3. Enroll in the Apple Developer Program if not already enrolled
4. Create an App ID for your app:
   - Bundle ID: `com.nbekdev.vela`
   - Enable necessary capabilities (Push Notifications, etc.)

### 2. App Store Connect Setup

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create a new app:
   - Platform: iOS
   - Bundle ID: `com.nbekdev.vela`
   - App Name: Vela
   - Primary Language: English
   - SKU: vela-ios

### 3. Xcode Setup

1. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configure signing:
   - Select your team in the signing settings
   - Ensure "Automatically manage signing" is checked
   - Xcode will create necessary certificates and provisioning profiles

3. Update the export options file:
   - Open `ios/exportOptions.plist`
   - Replace `YOUR_TEAM_ID` with your actual Team ID
   - Update the provisioning profile name if needed

### 4. Environment Variables

Set up environment variables for the deployment script:

```bash
export APPLE_ID="your-apple-id@example.com"
export APPLE_APP_SPECIFIC_PASSWORD="your-app-specific-password"
```

To generate an app-specific password:
1. Go to [Apple ID](https://appleid.apple.com)
2. Security > App-Specific Passwords
3. Generate a new password for "App Store Connect"

## Deployment Process

### Option 1: Using the Automated Script

1. Make sure you're in the project root directory
2. Run the deployment script:
   ```bash
   ./scripts/deploy_testflight.sh
   ```

### Option 2: Manual Deployment

1. **Clean and build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build ios --release --no-codesign
   ```

2. **Archive in Xcode:**
   - Open `ios/Runner.xcworkspace`
   - Select "Any iOS Device" as the target
   - Product > Archive

3. **Export and upload:**
   - In the Organizer window, select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Follow the wizard to upload

## Post-Upload Steps

1. **Wait for processing** (5-15 minutes)
2. **Add testers:**
   - Go to App Store Connect > Your App > TestFlight
   - Add internal testers (up to 100)
   - Create external testing groups if needed

3. **Submit for Beta App Review** (if required for external testers):
   - Fill out the required information
   - Submit for review (usually 24-48 hours)

## Troubleshooting

### Common Issues

1. **Code signing errors:**
   - Ensure your certificates are valid
   - Check that provisioning profiles match your bundle ID
   - Try refreshing certificates in Xcode

2. **Upload failures:**
   - Verify your Apple ID and app-specific password
   - Check that the app version is higher than the previous version
   - Ensure all required metadata is provided

3. **Processing failures:**
   - Check that all required permissions are properly configured
   - Verify that the app doesn't use any private APIs
   - Ensure the app size is within limits

### Version Management

- Update version in `pubspec.yaml` before each deployment
- Format: `version: 1.0.0+2` (version+build_number)
- Build number must be higher than the previous version

## Testing Checklist

Before deploying to TestFlight, ensure:

- [ ] App launches without crashes
- [ ] All features work as expected
- [ ] Audio playback works correctly
- [ ] Google Sign-In works
- [ ] All assets are properly included
- [ ] App icon and launch screen are correct
- [ ] No debug code or test data remains

## Support

If you encounter issues:

1. Check the [Apple Developer Documentation](https://developer.apple.com/documentation/)
2. Review [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
3. Check Xcode console for detailed error messages
4. Verify App Store Connect status page for any service issues

## Notes

- TestFlight builds expire after 90 days
- You can have up to 100 internal testers
- External testers require Beta App Review
- Each build can be tested by up to 10,000 external testers
- Builds are automatically distributed to internal testers 