import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseStyles {
  // Colors
  static const Color primaryBlue = Color(0xFF3B6EAA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xFFF2EFEA);
  static const Color cream = Color(0xFFF2EFEA);
  static const Color transparentWhite = Color(0x2EFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black10 = Color(0x1A000000);
  static const Color black15 = Color(0x26000000);
  static const Color black30 = Color(0x4D000000);
  static const Color lightBlue = Color(0xFFA4C7EA);

  // Typography
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Canela',
    fontSize: 64,
    color: cream,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none,
    letterSpacing: -2,
    height: 1.05,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Canela',
    fontSize: 36,
    color: cream,
    letterSpacing: -2,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Canela',
    fontSize: 28,
    color: white,
    fontWeight: FontWeight.w400,
    letterSpacing: 2,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    color: white70,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w600,
    height: 1.25,
    decoration: TextDecoration.none,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: white70,
    fontFamily: 'Satoshi',
    height: 1.25,
    decoration: TextDecoration.none,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontFamily: 'Satoshi',
    color: white,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
    height: 1.5,
  );

  static const TextStyle buttonTextSmall = TextStyle(
    fontSize: 16,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    color: white,
    decoration: TextDecoration.none,
  );

  static const TextStyle linkText = TextStyle(
    color: white70,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
  );

  static const TextStyle signInLinkText = TextStyle(
    color: Color.fromARGB(255, 220, 230, 240),
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
    fontSize: 16,
  );

  static const TextStyle signInUnderlinedText = TextStyle(
    color: Color.fromARGB(255, 249, 249, 249),
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  // Spacing
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(
    horizontal: 24.0,
  );
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: 32.0,
  );
  static const EdgeInsets paddingAll = EdgeInsets.all(16.0);
  static const EdgeInsets paddingModal = EdgeInsets.fromLTRB(24, 32, 24, 32);

  static const SizedBox spacingSmall = SizedBox(height: 16);
  static const SizedBox spacingMedium = SizedBox(height: 24);
  static const SizedBox spacingLarge = SizedBox(height: 32);

  // Border Radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusMedium = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(28));
  static const BorderRadius radiusExtraLarge = BorderRadius.all(
    Radius.circular(30),
  );

  // Shadows
  static List<BoxShadow> shadowLight = [
    BoxShadow(color: black10, blurRadius: 10, offset: const Offset(0, 2)),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(color: black15, blurRadius: 20, offset: const Offset(0, 4)),
  ];
}

// Utility functions
void openPopupFromTop(BuildContext context, Widget child) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      );
    },
  );
}
