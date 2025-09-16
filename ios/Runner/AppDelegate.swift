import Flutter
import UIKit
import AVFoundation
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase first with error handling
    do {
      FirebaseApp.configure()
      print("✅ Firebase configured successfully")
    } catch {
      print("❌ Firebase configuration failed: \(error)")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure audio session for iOS
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to configure audio session: \(error)")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
