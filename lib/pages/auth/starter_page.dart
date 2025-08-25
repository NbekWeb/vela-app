import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../shared/widgets/svg_icon.dart';
import '../../shared/widgets/starter_modal.dart';
import '../../styles/pages/starter_page_styles.dart';
import '../../styles/components/button_styles.dart';
import '../../styles/components/text_styles.dart';
import '../../styles/components/spacing_styles.dart';
import '../../styles/base_styles.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  VideoPlayerController? _controller;
  bool isMuted = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(StarterPageStyles.systemUiStyle);
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset('assets/videos/starteropt.mp4');

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        _controller!
          ..setLooping(true)
          ..setVolume(1.0)
          ..play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: StarterPageStyles.systemUiStyleWhite,
      child: Scaffold(
        backgroundColor: const Color(0xFF5398DA),
        body: Stack(
          children: [
            // Video background
            if (_isInitialized && _controller != null)
              Positioned(
                top: 0,
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
                  // Header
                  Padding(
                    padding: SpacingStyles.starterPagePadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isMuted = !isMuted;
                              _controller?.setVolume(isMuted ? 0.0 : 1.0);
                            });
                          },
                          child: SvgIcon(
                            assetName: isMuted
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
                  Expanded(child: Container()),

                  // Bottom content container
                  Container(
                    padding: SpacingStyles.paddingHorizontal,
                    child: Column(
                      children: [
                        Text(
                          'Navigate\nfrom Within',
                          textAlign: TextAlign.center,
                          style: TextStyles.headingLarge,
                        ),

                        const SizedBox(height: 40),

                        Text(
                          'Vela is the only meditation app built \n specifically for you',
                          textAlign: TextAlign.center,
                          style: TextStyles.bodyLarge,
                        ),

                        const SizedBox(height: 40),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ButtonStyles.primary,
                          child: Text('Next', style: ButtonStyles.primaryText),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: ButtonStyles.text,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: BaseStyles.signInLinkText,
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: BaseStyles.signInUnderlinedText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SpacingStyles.spacingSmall,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openPopupFromTop(BuildContext context, Widget child) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: StarterPageStyles.barrierColor,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation =
            Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}
