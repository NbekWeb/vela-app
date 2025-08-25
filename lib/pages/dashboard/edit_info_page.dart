import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/auth_store.dart';
import 'components/edit_info_header.dart';
import 'components/edit_info_form.dart';
import 'components/edit_info_buttons.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({super.key});

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedAge = '25-34';
  String _selectedGender = 'Female';

  final List<String> _ageOptions = ['18-24', '25-34', '35-44', '45-54', '55+'];
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

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
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleAgeChanged(String? value) {
    if (mounted) {
      setState(() {
        _selectedAge = value!;
      });
    }
  }

  void _handleGenderChanged(String? value) {
    if (mounted) {
      setState(() {
        _selectedGender = value!;
      });
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
                  const EditInfoHeader(),
                  SizedBox(height: 30.h),
                  Text(
                    'Edit Info',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 239, 234),
                      fontSize: 38.sp,
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                EditInfoForm(
                                  firstNameController: _firstNameController,
                                  lastNameController: _lastNameController,
                                  emailController: _emailController,
                                  selectedAge: _selectedAge,
                                  selectedGender: _selectedGender,
                                  ageOptions: _ageOptions,
                                  genderOptions: _genderOptions,
                                  onAgeChanged: _handleAgeChanged,
                                  onGenderChanged: _handleGenderChanged,
                                ),
                                SizedBox(height: 30),
                                EditInfoButtons(isSaving: _isSaving),
                                SizedBox(height: 20),
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
}
