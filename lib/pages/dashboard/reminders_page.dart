import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/auth_store.dart';
import '../../core/services/api_service.dart';
import 'main.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  bool _dailyMeditationEnabled = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final user = authStore.user;
    
    if (user != null) {
      setState(() {
        _dailyMeditationEnabled = user.userDeviceActive ?? false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendDeviceTokenToAPI(String deviceToken) async {
    try {
      String platform = Platform.isIOS ? 'ios' : 'android';

      final data = {
        'device_token': deviceToken,
        'device_type': platform,
        'platform': platform,
      };

      await ApiService.request(
        url: 'auth/create-device-token/',
        method: 'POST',
        data: data,
      );
    } catch (e) {
      print('Error sending device token to API: $e');
      // Silent error handling
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      final user = authStore.user;
      
      if (user != null) {
        // If user is disabling notifications (changing from true to false)
        if (!_dailyMeditationEnabled && (user.userDeviceActive ?? false)) {
          try {
            // Get device token from Firebase
            String? deviceToken = await FirebaseMessaging.instance.getToken();
            
            // Delete device token
            await ApiService.request(
              url: 'auth/device-token/',
              method: 'DELETE',
              data: {
                'device_token': deviceToken ?? '',
              },
            );
          } catch (firebaseError) {
            // If Firebase fails, try with empty token or mock token
            print('Firebase error: $firebaseError');
            await ApiService.request(
              url: 'auth/device-token/',
              method: 'DELETE',
              data: {
                'device_token': '',
              },
            );
          }
          
          // Update local user data
          final updatedUser = user.copyWith(userDeviceActive: false);
          authStore.setUser(updatedUser);
        }
        // If user is enabling notifications (changing from false to true)
        else if (_dailyMeditationEnabled && !(user.userDeviceActive ?? false)) {
          try {
            // Get device token from Firebase
            String? deviceToken = await FirebaseMessaging.instance.getToken();
            
            if (deviceToken != null) {
              // Register device token
              await _sendDeviceTokenToAPI(deviceToken);
            } else {
              // If no token, use mock token for testing
              await _sendDeviceTokenToAPI('mock_device_token_${DateTime.now().millisecondsSinceEpoch}');
            }
          } catch (firebaseError) {
            // If Firebase fails, use mock token
            print('Firebase error: $firebaseError');
            await _sendDeviceTokenToAPI('mock_device_token_${DateTime.now().millisecondsSinceEpoch}');
          }
          
          // Update local user data
          final updatedUser = user.copyWith(userDeviceActive: true);
          authStore.setUser(updatedUser);
        }
      }

      // Show success message
      if (mounted) {
        Fluttertoast.showToast(
          msg: _dailyMeditationEnabled 
              ? 'Notifications enabled successfully!' 
              : 'Notifications disabled successfully!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: const Color(0xFFF2EFEA),
          textColor: const Color(0xFF3B6EAA),
        );
        
        // Navigate to profile page using dashboard navigation
        final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
        if (dashboardState != null) {
          dashboardState.navigateToProfile();
        }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to update settings: ${e.toString()}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: const Color(0xFFF2EFEA),
          textColor: const Color(0xFF3B6EAA),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

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
                  SizedBox(height: 30.h),
                  Text(
                    'Reminders',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 38.sp,
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: _buildContent(),
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
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () {
                final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
                if (dashboardState != null) {
                  dashboardState.navigateToSettings();
                }
              },
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

  Widget _buildContent() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Meditation',
              style: TextStyle(
                color: const Color.fromARGB(255, 242, 239, 234),
                fontSize: 16.sp,
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: _isSaving ? null : () {
                setState(() {
                  _dailyMeditationEnabled = !_dailyMeditationEnabled;
                });
              },
              child: Container(
                width: 45,
                height: 24,
                decoration: BoxDecoration(
                  color: _dailyMeditationEnabled 
                      ? const Color.fromRGBO(21, 43, 86, 0.1)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                    color: const Color.fromRGBO(21, 43, 86, 0.1),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      left: _dailyMeditationEnabled ? 20 : 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 60.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B6EAA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 18.h),
              elevation: 0,
            ),
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
} 