import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class VideoLoader {
  static VideoPlayerController? _starterController;
  static VideoPlayerController? _moonController;
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  // Preload all videos at app startup
  static Future<void> initializeVideos() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    
    try {
      // Preload starter video
      _starterController = VideoPlayerController.asset('assets/videos/starteropt.mp4');
      await _starterController!.initialize();
      _starterController!
        ..setLooping(true)
        ..setVolume(1.0);

      // Preload moon video if exists
      try {
        _moonController = VideoPlayerController.asset('assets/videos/moon.mp4');
        await _moonController!.initialize();
        _moonController!
          ..setLooping(true)
          ..setVolume(1.0);
      } catch (e) {
        // Moon video not found
      }

      _isInitialized = true;
      _isInitializing = false;
    } catch (e) {
      _isInitializing = false;
      // Error preloading videos
    }
  }

  static Future<VideoPlayerController> getStarterVideo() async {
    if (_starterController == null || !_starterController!.value.isInitialized) {
      await initializeVideos();
    }
    return _starterController!;
  }

  static Future<VideoPlayerController?> getMoonVideo() async {
    if (_moonController == null || !_moonController!.value.isInitialized) {
      await initializeVideos();
    }
    return _moonController;
  }

  static VideoPlayerController? get starterController => _starterController;
  static VideoPlayerController? get moonController => _moonController;
  static bool get isInitialized => _isInitialized;
  static bool get isInitializing => _isInitializing;

  // Check if starter video is ready to use
  static bool get isStarterVideoReady => 
      _starterController != null && 
      _starterController!.value.isInitialized;

  // Wait for initialization to complete
  static Future<void> waitForInitialization() async {
    if (_isInitialized) return;
    
    if (_isInitializing) {
      // Wait for initialization to complete
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    } else {
      // Start initialization if not already started
      await initializeVideos();
    }
  }

  static void dispose() {
    _starterController?.dispose();
    _moonController?.dispose();
    _starterController = null;
    _moonController = null;
    _isInitialized = false;
    _isInitializing = false;
  }
}
