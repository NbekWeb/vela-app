import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/video_background_wrapper.dart';
import '../../styles/components/button_styles.dart';
import '../../styles/components/text_styles.dart';
import '../../styles/components/spacing_styles.dart';
import '../../styles/base_styles.dart';

class OnboardingPage3 extends StatefulWidget {
  const OnboardingPage3({super.key});

  @override
  State<OnboardingPage3> createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VideoBackgroundWrapper(
      topOffset: 0,
      showControls: true,
      isMuted: false,
      child: Column(
        children: [
          // Main content
          Expanded(child: Container()),

          // Bottom content container
          Container(
            padding: SpacingStyles.paddingHorizontal,
            child: Column(
              children: [
                Text(
                  'Set sail to your dream life, with Vela',
                  textAlign: TextAlign.center,
                  style: TextStyles.headingLarge.copyWith(
                    fontSize: 46.sp,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Vela is designed to rewire your inner world — and reshape your outer one. Your vision, on repeat. Your dream life, in motion.',
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyLarge,
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyles.primary,
                  child: Text(
                    'Get Started',
                    style: ButtonStyles.primaryText,
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
