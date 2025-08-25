import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vela/pages/auth/onboarding_page_3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/video_background_wrapper.dart';
import '../../styles/components/button_styles.dart';
import '../../styles/components/text_styles.dart';
import '../../styles/components/spacing_styles.dart';
import '../../styles/base_styles.dart';
import '../../core/utils/video_loader.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _checkVideoStatus();
  }

  Future<void> _checkVideoStatus() async {
    // Check if videos are already preloaded
    if (VideoLoader.isInitialized) {
      setState(() {
        _isVideoReady = true;
      });
    } else {
      // Wait for videos to be loaded
      await VideoLoader.initializeVideos();
      if (mounted) {
        setState(() {
          _isVideoReady = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoBackgroundWrapper(
      topOffset: -110,
      showControls: true,
      isMuted: false,
      child: Column(
        children: [
          // Bottom content container
          Expanded(child: Container()),

          Container(
            padding: SpacingStyles.paddingHorizontal,
            child: Column(
              children: [
                Text(
                  'What is Vela?',
                  textAlign: TextAlign.center,
                  style: TextStyles.headingLarge.copyWith(
                    fontSize: 46.sp,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Vela turns your vision board into your daily meditation.\n\n'
                  'Using your words, your dreams, and your goals, Vela creates powerfully personalized audio meditations designed to rewire your neural pathways and align your inner world with the life you want to live.\n\n'
                  'Guided by AI. Backed by neuroscience.\n\n'
                  'Whether you\'re manifesting your dream future or need support in the moment, Vela meets you where you are — and helps you rise.',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyLarge,
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _isVideoReady ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage3(),
                      ),
                    );
                  } : null,
                  style: ButtonStyles.primary,
                  child: _isVideoReady 
                    ? Text('Next', style: ButtonStyles.primaryText)
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Loading...', style: ButtonStyles.primaryText),
                        ],
                      ),
                ),

                const SizedBox(height: 8),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ButtonStyles.text,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account?",
                          style: BaseStyles.signInLinkText,
                        ),
                        TextSpan(
                          text: ' Sign up',
                          style: BaseStyles.signInUnderlinedText,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
