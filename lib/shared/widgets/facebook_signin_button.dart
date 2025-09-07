import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../styles/pages/login_page_styles.dart';

class FacebookSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const FacebookSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B6EAA), // Same as Google button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        icon: SvgPicture.asset(
          'assets/icons/facebook.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
             Color(0xDDC9DFF4), // Same as Google button text color
            BlendMode.srcIn,
          ),
        ),
        label: const SizedBox.shrink(), // Remove text, show only icon
      ),
    );
  }
}
