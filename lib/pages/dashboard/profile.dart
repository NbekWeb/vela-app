import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/auth_store.dart';
import 'components/profile_header.dart';
import 'components/profile_picture_section.dart';
import 'components/profile_content_sections.dart';
import 'components/neuroplasticity_button.dart';

class DashboardProfilePage extends StatelessWidget {
  const DashboardProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: Stack(
              children: [
                // Star animation background
                const StarsAnimation(
                  starCount: 50,
                  topColor: Color(0xFF5799D6),
                  bottomColor: Color(0xFFA4C6EB),
                ),

                // Main content
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      16.sp, // left
                      8.sp, // top
                      16.sp, // right
                      0.sp, // bottom
                    ),
                    child: Column(
                      children: [
                        // Header
                        const ProfileHeader(),

                        const SizedBox(height: 30),

                        // Profile picture and name
                        const ProfilePictureSection(),

                        const SizedBox(height: 40),

                        // Content sections
                        const ProfileContentSections(),

                        const SizedBox(height: 30),

                        // Neuroplasticity button
                        const NeuroplasticityButton(),

                        const SizedBox(
                          height: 100,
                        ), // Space for bottom navigation
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
