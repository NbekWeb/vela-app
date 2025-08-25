import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/stores/auth_store.dart';
import '../settings_page.dart';
import '../main.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

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
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/dashboard'),
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