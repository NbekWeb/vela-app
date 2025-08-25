import 'package:flutter/material.dart';
import '../base_styles.dart';

class LoginPageStyles {
  // Colors
  static const Color translucentBackground = Color(0xFF5882B6);
  static const Color borderColor = Color(0x1A152B56);
  static const Color linkColor = Color(0xFFDCE6F0);
  static const Color termsColor = Color(0xFFDCE6F0);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Canela',
    fontSize: 36,
    color: BaseStyles.cream,
    letterSpacing: -1,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: BaseStyles.cream,
    fontFamily: 'Satoshi',
  );

  static const TextStyle brandStyle = TextStyle(
    fontFamily: 'Canela',
    fontSize: 36,
    color: BaseStyles.cream,
    fontWeight: FontWeight.w300,
    letterSpacing: 1.5,
  );

  static const TextStyle orContinueStyle = TextStyle(
    color: BaseStyles.cream,
    fontSize: 16,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle signUpTextStyle = TextStyle(
    color: BaseStyles.cream,
    fontSize: 12,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle signUpLinkStyle = TextStyle(
    color: linkColor,
    decoration: TextDecoration.underline,
    decorationColor: linkColor,
    decorationThickness: 2,
    fontWeight: FontWeight.w700,
    fontFamily: 'Satoshi',
  );

  static const TextStyle termsStyle = TextStyle(
    color: BaseStyles.cream,
    fontFamily: 'Satoshi',
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  // Button Styles
  static ButtonStyle loginButton = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    minimumSize: const Size.fromHeight(60),
  );

  static ButtonStyle socialButton = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    minimumSize: const Size.fromHeight(48),
  );

  // Input Field Styles
  static InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: borderColor, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    filled: true,
    fillColor: translucentBackground,
  );

  // Spacing
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 0,
  );

  static const SizedBox spacing8 = SizedBox(height: 8);
  static const SizedBox spacing12 = SizedBox(height: 12);
  static const SizedBox spacing16 = SizedBox(height: 16);
  static const SizedBox spacing20 = SizedBox(height: 20);
  static const SizedBox spacing24 = SizedBox(height: 24);
  static const SizedBox spacing32 = SizedBox(height: 32);
  static const SizedBox spacing36 = SizedBox(height: 36);

  static const SizedBox width4 = SizedBox(width: 4);
  static const SizedBox width16 = SizedBox(width: 16);
  static const SizedBox width24 = SizedBox(width: 24);

  // Icon Styles
  static const IconThemeData backIconTheme = IconThemeData(
    color: BaseStyles.white,
    size: 24,
  );

  static const IconThemeData infoIconTheme = IconThemeData(
    color: BaseStyles.white,
    size: 24,
  );

  static const IconThemeData starIconTheme = IconThemeData(
    color: BaseStyles.white,
    size: 18,
  );

  static const IconThemeData prefixIconTheme = IconThemeData(
    color: BaseStyles.cream,
  );

  static const IconThemeData suffixIconTheme = IconThemeData(
    color: BaseStyles.cream,
  );

  // Container Styles
  static BoxDecoration socialButtonDecoration = BoxDecoration(
    color: BaseStyles.primaryBlue,
    borderRadius: BorderRadius.circular(24),
  );
}
