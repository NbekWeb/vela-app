import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/auth_store.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
            // Star animation background
            const StarsAnimation(
              starCount: 50,
              topColor: Color(0xFF5799D6),
              bottomColor: Color(0xFFA4C6EB),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),
                  
                  const SizedBox(height: 30),
                  
                  // Settings title
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 38.sp,
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  
                  const SizedBox(height: 28),
                  
                  // Settings list
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.sp),
                      child: _buildSettingsList(context),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back arrow in a circle
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () {
                  // Navigate back to profile page using dashboard navigation
                  final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
                  if (dashboardState != null) {
                    dashboardState.navigateToProfile();
                  }
                },
              ),
            ),
          ),
          
          // Logo
          Transform.translate(
            offset: const Offset(3, 0),
            child: Image.asset('assets/img/logo.png', width: 60, height: 39),
          ),
          
          // Invisible placeholder to maintain spacing
          Container(
            width: 36,
            height: 36,
            child: const Icon(Icons.settings, color: Colors.transparent, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final settingsItems = [
      {'title': 'Edit Info', 'onTap': () => _navigateToEditInfo(context)},
      {'title': 'Reminders', 'onTap': () => _navigateToReminders(context)},
      {'title': 'Subscription & Billing', 'onTap': () {}},
      {'title': 'Privacy & Security', 'onTap': () {}},
      {'title': 'Help & Support', 'onTap': () {}},
      {'title': 'About Vela', 'onTap': () {}},
      {'title': 'Log out', 'onTap': () => _handleLogout(context)},
    ];

    return ListView.separated(
      itemCount: settingsItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final item = settingsItems[index];
        return _buildSettingsItem(
          title: item['title'] as String,
          onTap: item['onTap'] as VoidCallback,
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 0.sp),
      title: Text(
        title,
        style: TextStyle(
          color: const Color.fromARGB(255, 242, 239, 234),
          fontSize: 16.sp,
          fontFamily: 'Satoshi',
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    await authStore.logout();
    if (context.mounted) {
      // Clear all routes and navigate to login
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    }
  }

  void _navigateToEditInfo(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
    if (dashboardState != null) {
      dashboardState.navigateToEditInfo();
    }
  }

  void _navigateToReminders(BuildContext context) {
    final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
    if (dashboardState != null) {
      dashboardState.navigateToReminders();
    }
  }
} 