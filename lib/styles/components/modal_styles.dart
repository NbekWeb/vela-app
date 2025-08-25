import 'package:flutter/material.dart';
import '../base_styles.dart';

class ModalStyles {
  // Button Styles
  static ButtonStyle modalButton = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BaseStyles.radiusExtraLarge,
    ),
    padding: const EdgeInsets.symmetric(vertical: 18),
    elevation: 0,
  );

  // Container Styles
  static BoxDecoration frostedGlass = BoxDecoration(
    color: BaseStyles.transparentWhite,
    borderRadius: BaseStyles.radiusMedium,
  );

  // Icon Styles
  static const IconThemeData backIconTheme = IconThemeData(
    color: BaseStyles.white,
    size: 28,
  );

  static const IconThemeData placeholderIconTheme = IconThemeData(
    color: BaseStyles.white,
  );

  // Text Styles
  static const TextStyle modalTitle = BaseStyles.headingMedium;
  static const TextStyle modalBody = BaseStyles.bodyMedium;
  static const TextStyle modalButtonText = BaseStyles.buttonTextSmall;

  // Spacing
  static const EdgeInsets modalPadding = BaseStyles.paddingModal;
  static const SizedBox modalSpacing = BaseStyles.spacingMedium;
  static const SizedBox modalLargeSpacing = BaseStyles.spacingLarge;

  // Border Radius
  static const BorderRadius modalRadius = BaseStyles.radiusMedium;

  // Blur Effect
  static const double blurSigma = 60.0;
} 