import 'package:flutter/material.dart';
import '../base_styles.dart';

class ButtonStyles {
  // Primary Button
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    minimumSize: const Size.fromHeight(60),
    shape: RoundedRectangleBorder(borderRadius: BaseStyles.radiusLarge),
    elevation: 0,
  );

  // Modal Button
  static ButtonStyle modal = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BaseStyles.radiusExtraLarge),
    padding: const EdgeInsets.symmetric(vertical: 18),
    elevation: 0,
  );

  // Text Button
  static ButtonStyle text = TextButton.styleFrom(
    foregroundColor: BaseStyles.cream,
    textStyle: const TextStyle(
      fontFamily: 'Satoshi',
      fontWeight: FontWeight.w700,
    ),
  );

  // Icon Button
  static ButtonStyle icon = IconButton.styleFrom(
    foregroundColor: BaseStyles.white,
    padding: EdgeInsets.zero,
  );

  // Text Styles
  static const TextStyle primaryText = BaseStyles.buttonText;
  static const TextStyle modalText = BaseStyles.buttonTextSmall;
  static const TextStyle linkText = BaseStyles.linkText;
}
