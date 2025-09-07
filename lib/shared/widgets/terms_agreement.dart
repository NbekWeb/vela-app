import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../styles/pages/login_page_styles.dart';

class TermsAgreement extends StatelessWidget {
  final Color? textColor;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;

  const TermsAgreement({
    super.key,
    this.textColor,
    this.fontSize,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20), // Add space at top
      child: GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse('https://myvela.ai/terms-of-use/');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        child: RichText(
          text: TextSpan(
            text: 'By using Vela you agree to our ',
            style: LoginPageStyles.signUpTextStyle.copyWith(
              color: textColor ?? const Color(0xFFDCE6F0),
              fontSize: fontSize ?? 14,
              letterSpacing: letterSpacing ?? -0.5,
              height: height ?? 1,
            ),
            children: [
              TextSpan(
                text: 'Terms',
                style: LoginPageStyles.signUpTextStyle.copyWith(
                  color: textColor ?? const Color(0xFFDCE6F0),
                  fontSize: fontSize ?? 14,
                  letterSpacing: letterSpacing ?? -0.5,
                  height: height ?? 21 / 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
