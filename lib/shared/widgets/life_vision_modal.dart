import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class LifeVisionModal extends StatefulWidget {
  final String initialVision;
  final Function(String) onSave;
  final VoidCallback? onClose;
  
  const LifeVisionModal({
    super.key,
    required this.initialVision,
    required this.onSave,
    this.onClose,
  });

  @override
  State<LifeVisionModal> createState() => _LifeVisionModalState();
}

class _LifeVisionModalState extends State<LifeVisionModal> {
  late TextEditingController _controller;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
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
      _hasChanges = _controller.text.trim() != widget.initialVision.trim();
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
                        'Life Vision',
                        textAlign: TextAlign.center,
                        style: AppStyles.headingMedium,
                      ),
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                
                // Question
                Text(
                  'What makes you feel the most "you"?',
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
                      hintText: 'I feel most myself when I laugh freely, make art, and spend time in nature.',
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