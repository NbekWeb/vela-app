import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  
  const ProfileHeader({this.onBackPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.sp,
        0.sp,
        0.sp,
        0.sp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back arrow in a circle, size 24x24
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    // Check if there's a previous page to go back to
                    final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
                    if (dashboardState != null) {
                      // If previous index is the same as current (no previous page), go to home
                      if (dashboardState.previousIndex == dashboardState.selectedIndex) {
                        dashboardState.navigateToHome();
                      } else {
                        // Go back to previous page
                        dashboardState.navigateBack();
                      }
                    } else {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    }
                  }
                },
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(
              3,
              0,
            ), // ← сдвиг вправо на 10 пикселей
            child: Image.asset('assets/img/logo.png', width: 60, height: 39),
          ),
          // Settings icon on the right, size 24x24
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 24),
              onPressed: () {
                // Navigate to settings page using dashboard navigation
                final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
                if (dashboardState != null) {
                  dashboardState.navigateToSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 