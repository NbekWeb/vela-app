import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../styles/pages/login_page_styles.dart';

class EditInfoForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final String selectedAge;
  final String selectedGender;
  final List<String> ageOptions;
  final List<String> genderOptions;
  final Function(String?) onAgeChanged;
  final Function(String?) onGenderChanged;

  const EditInfoForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.selectedAge,
    required this.selectedGender,
    required this.ageOptions,
    required this.genderOptions,
    required this.onAgeChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildInputField(
                    label: 'First name',
                    controller: firstNameController,
                  ),
                  _buildDropdownField(
                    label: 'How old are you?',
                    value: selectedAge,
                    items: ageOptions,
                    onChanged: onAgeChanged,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                children: [
                  _buildInputField(
                    label: 'Last name',
                    controller: lastNameController,
                  ),
                  _buildDropdownField(
                    label: 'Gender',
                    value: selectedGender,
                    items: genderOptions,
                    onChanged: onGenderChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        _buildInputField(
          label: 'Email address',
          controller: emailController,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(255, 242, 239, 234),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            cursorColor: Colors.white,
            style: LoginPageStyles.subtitleStyle.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: LoginPageStyles.subtitleStyle.copyWith(
                color: const Color(0xFFDCE6F0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: LoginPageStyles.translucentBackground,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 20.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: LoginPageStyles.borderColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: LoginPageStyles.borderColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: LoginPageStyles.borderColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(255, 242, 239, 234),
              fontSize: 16.sp,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: LoginPageStyles.translucentBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LoginPageStyles.borderColor, width: 1),
            ),
            child: PopupMenuButton<String>(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 20.w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: LoginPageStyles.subtitleStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              itemBuilder: (context) => items.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 65.w,
                    child: Text(
                      item,
                      style: LoginPageStyles.subtitleStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onSelected: onChanged,
              color: const Color(0xFF3B6EAA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 