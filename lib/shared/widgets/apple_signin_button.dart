import 'package:flutter/material.dart';
import '../../styles/pages/login_page_styles.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const AppleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text = 'Continue with Apple',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        icon: const Icon(
          Icons.apple,
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          text,
          style: LoginPageStyles.orContinueStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
