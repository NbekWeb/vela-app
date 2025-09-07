import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final bool isLoading;

  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign-In Button
        if (onGooglePressed != null)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 12.h),
            child: OutlinedButton(
              onPressed: isLoading ? null : onGooglePressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/google.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: const Color(0xFF3B6EAA),
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Facebook Sign-In Button
        if (onFacebookPressed != null)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 12.h),
            child: OutlinedButton(
              onPressed: isLoading ? null : onFacebookPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/facebook.svg',
                    width: 20.w,
                    height: 20.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Continue with Facebook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Divider
        if (onGooglePressed != null || onFacebookPressed != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14.sp,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
} 