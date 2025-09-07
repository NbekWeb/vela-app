import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/stars_animation.dart';

class AboutVelaPage extends StatelessWidget {
  const AboutVelaPage({super.key});

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
                    'About Vela',
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
                            'Our Mission',
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
                            child: Text(
                              'Vela is dedicated to helping you create personalized meditation experiences that align with your unique vision and dreams. We believe everyone deserves access to transformative mindfulness practices.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 242, 239, 234),
                                fontSize: 14.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Features',
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
                                _buildFeatureItem('AI-Powered Meditation Generation'),
                                const SizedBox(height: 12),
                                _buildFeatureItem('Personalized Dream Vault'),
                                const SizedBox(height: 12),
                                _buildFeatureItem('Guided Sleep Streams'),
                                const SizedBox(height: 12),
                                _buildFeatureItem('Progress Tracking'),
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

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: const Color(0xFF3B6EAA),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            feature,
            style: TextStyle(
              color: const Color.fromARGB(255, 242, 239, 234),
              fontSize: 14.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
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
