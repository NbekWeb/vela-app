import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class ProfileEditModal extends StatefulWidget {
  final String title;
  final String prompt;
  final String hintText;
  final String initialValue;
  final Function(String) onSave;
  final VoidCallback? onClose;
  
  const ProfileEditModal({
    super.key,
    required this.title,
    required this.prompt,
    required this.hintText,
    required this.initialValue,
    required this.onSave,
    this.onClose,
  });

  @override
  State<ProfileEditModal> createState() => _ProfileEditModalState();
}

class _ProfileEditModalState extends State<ProfileEditModal> {
  late TextEditingController _controller;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Agar initialValue hintText bilan bir xil bo'lsa, bo'sh qoldirish
    final shouldShowHint = widget.initialValue.trim() == widget.hintText.trim();
    _controller = TextEditingController(text: shouldShowHint ? '' : widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Agar initialValue hintText bilan bir xil bo'lsa, har qanday o'zgarishni o'zgarish deb hisoblash
      final originalValue = widget.initialValue.trim() == widget.hintText.trim() ? '' : widget.initialValue.trim();
      _hasChanges = _controller.text.trim() != originalValue;
    });
  }

  void _handleSave() {
    if (_hasChanges) {
      widget.onSave(_controller.text);
    }
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth = screenWidth - 30;

    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: modalWidth,
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.frostedGlass,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: AppStyles.headingMedium,
                      ),
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                
                // Question/Prompt
                Text(
                  widget.prompt,
                  style: AppStyles.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppStyles.spacingMedium,
                
                // Text input field
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(21, 43, 86, 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromRGBO(21, 43, 86, 0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    style: AppStyles.bodyMedium.copyWith(
                      fontSize: 14,
                      color: AppStyles.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppStyles.white.withOpacity(0.6),
                      ),
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                AppStyles.spacingLarge,
                
                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.white,
                          foregroundColor: AppStyles.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: AppStyles.buttonTextSmall.copyWith(
                            color: AppStyles.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Save button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _hasChanges ? _handleSave : null,
                        style: AppStyles.modalButton.copyWith(
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(WidgetState.disabled)) {
                                return const Color.fromARGB(255, 59, 110, 170).withValues(alpha: 0.5);
                              }
                              return const Color.fromARGB(255, 59, 110, 170);
                            },
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: AppStyles.buttonTextSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 