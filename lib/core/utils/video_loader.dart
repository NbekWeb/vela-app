import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class VideoLoader {
  static VideoPlayerController? _starterController;
  static VideoPlayerController? _moonController;
  static bool _isInitialized = false;

  // Preload all videos at app startup
  static Future<void> initializeVideos() async {
    if (_isInitialized) return;
    
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
        print('Moon video not found: $e');
      }

      _isInitialized = true;
      print('All videos preloaded successfully');
    } catch (e) {
      print('Error preloading videos: $e');
    }
  }

  static Future<VideoPlayerController> getStarterVideo() async {
    if (_starterController == null) {
      await initializeVideos();
    }
    return _starterController!;
  }

  static Future<VideoPlayerController?> getMoonVideo() async {
    if (_moonController == null) {
      await initializeVideos();
    }
    return _moonController;
  }

  static VideoPlayerController? get starterController => _starterController;
  static VideoPlayerController? get moonController => _moonController;
  static bool get isInitialized => _isInitialized;

  static void dispose() {
    _starterController?.dispose();
    _moonController?.dispose();
    _starterController = null;
    _moonController = null;
    _isInitialized = false;
  }
}
