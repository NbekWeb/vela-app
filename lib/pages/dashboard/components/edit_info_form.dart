import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../styles/pages/login_page_styles.dart';

class EditInfoForm extends StatefulWidget {
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
  State<EditInfoForm> createState() => _EditInfoFormState();
}

class _EditInfoFormState extends State<EditInfoForm> {
  bool _isAgeDropdownOpen = false;
  bool _isGenderDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopRow(),
        // SizedBox(height: 15.h),
        // _buildEmailField(),
      ],
    );
  }



  Widget _buildTopRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInputField(
                label: 'First name',
                controller: widget.firstNameController,
              ),
              _buildCustomDropdownField(
                label: 'How old are you?',
                value: widget.selectedAge,
                items: widget.ageOptions,
                onChanged: widget.onAgeChanged,
                isOpen: _isAgeDropdownOpen,
                onTap: () => _showDropdownDialog(context, widget.ageOptions, widget.onAgeChanged, 'age'),
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
                controller: widget.lastNameController,
              ),
              _buildCustomDropdownField(
                label: 'Gender',
                value: widget.selectedGender,
                items: widget.genderOptions,
                onChanged: widget.onGenderChanged,
                isOpen: _isGenderDropdownOpen,
                onTap: () => _showDropdownDialog(context, widget.genderOptions, widget.onGenderChanged, 'gender'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDropdownDialog(
    BuildContext context,
    List<String> items,
    Function(String?) onChanged,
    String type,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF3B6EAA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    type == 'age' ? 'Select Age' : 'Select Gender',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                ...items.map((item) => _buildDropdownItem(item, onChanged, context)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownItem(String item, Function(String?) onChanged, BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(item);
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Text(
          item,
          style: LoginPageStyles.subtitleStyle.copyWith(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildInputField(
      label: 'Email address',
      controller: widget.emailController,
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
          _buildLabel(label),
          SizedBox(height: 8.h),
          _buildTextField(label, controller),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color.fromARGB(255, 242, 239, 234),
        fontSize: 16.sp,
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      style: LoginPageStyles.subtitleStyle.copyWith(color: Colors.white),
      decoration: _getInputDecoration(label),
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
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
      border: _getBorder(),
      enabledBorder: _getBorder(),
      focusedBorder: _getBorder(),
    );
  }

  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: LoginPageStyles.borderColor,
        width: 1,
      ),
    );
  }

  Widget _buildCustomDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdownLabel(label),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: _getDropdownDecoration(),
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 20.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: LoginPageStyles.subtitleStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color.fromARGB(255, 242, 239, 234),
        fontSize: 16.sp,
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  BoxDecoration _getDropdownDecoration() {
    return BoxDecoration(
      color: LoginPageStyles.translucentBackground,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: LoginPageStyles.borderColor, width: 1),
    );
  }
} 