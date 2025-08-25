import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../base_styles.dart';

class StarterPageStyles {
  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: BaseStyles.primaryBlue,
    minimumSize: const Size.fromHeight(56),
    shape: RoundedRectangleBorder(
      borderRadius: BaseStyles.radiusLarge,
    ),
  );

  // Container Styles
  static BoxDecoration frostedGlass = BoxDecoration(
    color: BaseStyles.transparentWhite,
    borderRadius: BaseStyles.radiusMedium,
  );

  // System UI Overlay Style
  static const SystemUiOverlayStyle systemUiStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle systemUiStyleWhite = SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  // Video Player Styles
  static const BoxFit videoFit = BoxFit.cover;

  // Icon Colors
  static const Color iconColor = BaseStyles.white;

  // Modal Styles
  static const double modalWidth = 0.92;
  static const double blurSigma = 60.0;
  static const Color barrierColor = BaseStyles.black30;
} 