import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeVideoBackground extends StatefulWidget {
  final Widget child;
  final double topOffset;
  final bool isMuted;

  const HomeVideoBackground({
    super.key,
    required this.child,
    this.topOffset = 0,
    this.isMuted = true,
  });

  @override
  State<HomeVideoBackground> createState() => _HomeVideoBackgroundState();
}

class _HomeVideoBackgroundState extends State<HomeVideoBackground> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _controller = VideoPlayerController.asset('assets/videos/starteropt.mp4');
      await _controller!.initialize();
      _controller!
        ..setLooping(true)
        ..setVolume(widget.isMuted ? 0.0 : 1.0);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });

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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFF5398DA),
      body: Stack(
        children: [
          // Video background that scrolls with content
          if (_isInitialized && _controller != null && !_isLoading)
            Positioned(
              top: widget.topOffset,
              left: 0,
              right: 0,
              height: screenHeight + 300, // 100vh + 300px
              child: Column(
                children: [
                  // Video section - 100vh
                  SizedBox(
                    height: screenHeight,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                  // Red background section - 300px
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'RED BACKGROUND',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Content that can scroll
          SafeArea(
            child: Container(
              color: Colors.transparent,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

