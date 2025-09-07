import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../core/utils/video_loader.dart';
import 'svg_icon.dart';
import 'starter_modal.dart';
import '../../styles/pages/starter_page_styles.dart';
import '../../styles/base_styles.dart';

class VideoBackgroundWrapper extends StatefulWidget {
  final Widget child;
  final double topOffset;
  final bool showControls;
  final bool isMuted;

  const VideoBackgroundWrapper({
    super.key,
    required this.child,
    this.topOffset = 0,
    this.showControls = true,
    this.isMuted = false,
  });

  @override
  State<VideoBackgroundWrapper> createState() => _VideoBackgroundWrapperState();
}

class _VideoBackgroundWrapperState extends State<VideoBackgroundWrapper> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isMuted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isMuted = widget.isMuted;
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Wait for video initialization to complete
      await VideoLoader.waitForInitialization();
      
      // Get the preloaded controller
      _controller = VideoLoader.starterController;
      
      // If still not available, create a new controller
      if (_controller == null || !_controller!.value.isInitialized) {
        _controller = VideoPlayerController.asset('assets/videos/starteropt.mp4');
        await _controller!.initialize();
        _controller!
          ..setLooping(true)
          ..setVolume(_isMuted ? 0.0 : 1.0);
      } else {
        // Ensure volume is set correctly for preloaded controller
        _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });

        // Start playing if not already playing
        if (!_controller!.value.isPlaying) {
          _controller!.play();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _isLoading = false;
        });
      }
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    // Don't dispose the controller here as it's managed by VideoLoader
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: StarterPageStyles.systemUiStyleWhite,
      child: Scaffold(
        backgroundColor: const Color(0xFF5398DA),
        body: Stack(
          children: [
            // Video background
            if (_isInitialized && _controller != null && !_isLoading)
              Positioned(
                top: widget.topOffset,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  // Header with controls
                  if (widget.showControls)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _toggleMute,
                            child: SvgIcon(
                              assetName: _isMuted
                                  ? 'assets/icons/mute.svg'
                                  : 'assets/icons/unmute.svg',
                              color: StarterPageStyles.iconColor,
                            ),
                          ),
                          Image.asset(
                            'assets/img/logo.png',
                            width: 60,
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () {
                              openPopupFromTop(context, const StarterModal());
                            },
                            child: SvgIcon(
                              assetName: 'assets/icons/brain.svg',
                              color: StarterPageStyles.iconColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Main content
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 