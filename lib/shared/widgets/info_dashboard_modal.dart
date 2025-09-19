import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoDashboardModal extends StatelessWidget {
  final VoidCallback? onClose;
  const InfoDashboardModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: modalWidth,
            padding: AppStyles.paddingModal,
            decoration: AppStyles.frostedGlass,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppStyles.white,
                        size: 28,
                      ),
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dashboard Info',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Canela',
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                Text(
                  'Welcome to your meditation dashboard! \nHere you can track your daily progress, access your personal meditations, and explore our library.\n\n'
                  'Daily Streaks: \nMonitor your weekly meditation consistency\n\n'
                  'My Meditations: \nAccess your personalized meditation sessions\n\n'
                  'Meditation Library: \nDiscover curated content for your journey\n\n'
                  'Start building your meditation habit today and watch your streaks grow!',
                  style: AppStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppStyles.spacingLarge,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: AppStyles.modalButton,
                    child: Text('Got it', style: AppStyles.buttonTextSmall),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
