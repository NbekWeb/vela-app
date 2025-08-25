import 'package:flutter/material.dart';
import '../base_styles.dart';

class InputStyles {
  // Colors
  static const Color translucentBackground = Color(0x1A152B56);
  static const Color borderColor = Color(0x1A152B56);
  static const Color textColor = BaseStyles.white;
  static const Color labelColor = BaseStyles.cream;
  static const Color prefixIconColor = BaseStyles.cream;
  static const Color suffixIconColor = BaseStyles.cream;

  // Text Styles
  static const TextStyle inputTextStyle = TextStyle(
    color: textColor,
    fontSize: 16,
  );

  static const TextStyle labelStyle = TextStyle(
    color: labelColor,
    fontSize: 16,
  );

  // Border Styles
  static const BorderSide borderSide = BorderSide(color: borderColor, width: 1);

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(10),
  );

  // Input Decoration
  static InputDecoration baseDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    filled: true,
    fillColor: translucentBackground,
  );

  // Padding
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    vertical: 20,
    horizontal: 16,
  );
}
