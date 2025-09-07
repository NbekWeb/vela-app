import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/stars_animation.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            const StarsAnimation(
              starCount: 50,
              topColor: Color(0xFF5799D6),
              bottomColor: Color(0xFFA4C6EB),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 38.sp,
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get Help',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 242, 239, 234),
                              fontSize: 24.sp,
                              fontFamily: 'Canela',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildHelpOption(
                            context,
                            'FAQ',
                            'Find answers to common questions',
                            Icons.question_answer,
                            () {},
                          ),
                          const SizedBox(height: 12),
                          _buildHelpOption(
                            context,
                            'Contact Support',
                            'Get in touch with our team',
                            Icons.support_agent,
                            () {},
                          ),
                          const SizedBox(height: 12),
                          _buildHelpOption(
                            context,
                            'Report a Bug',
                            'Help us improve the app',
                            Icons.bug_report,
                            () {},
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'App Information',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 242, 239, 234),
                              fontSize: 24.sp,
                              fontFamily: 'Canela',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.sp),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildInfoRow('Version', '1.0.0'),
                                const SizedBox(height: 12),
                                _buildInfoRow('Build', '2025.09.01'),
                                const SizedBox(height: 12),
                                _buildInfoRow('Last Updated', 'September 2025'),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildHelpOption(BuildContext context, String title, String description, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3B6EAA),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 12.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 242, 239, 234),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color.fromARGB(255, 242, 239, 234),
            fontSize: 14.sp,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(3, 0),
            child: Image.asset('assets/img/logo.png', width: 60, height: 39),
          ),
          Container(
            width: 36,
            height: 36,
            child: const Icon(Icons.settings, color: Colors.transparent, size: 24),
          ),
        ],
      ),
    );
  }
}
