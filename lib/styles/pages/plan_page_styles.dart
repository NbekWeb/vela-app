import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlanPageStyles {
  static const Color pillBg = Color.fromRGBO(21, 43, 86, 0.1);
  static const Color pillBorder = Color(0x33FFFFFF);
  static const Color badgeText = Color(0xFFF2EFEA);
  static const Color cardBg = Color(0x80A4C7EA);
  static const Color bullet = Color(0xFFB6D0F7);
  static const Color leftBorder = Color(0xFFC9DFF4);

  static TextStyle badge = TextStyle(
    color: Color(0xFFF2EFEA),
    fontFamily: 'Satoshi',
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle pill = TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: Color(0xFFF2EFEA),
  );

  static TextStyle cardTitle = TextStyle(
    color: Color(0xFFF2EFEA),
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
  );

  static TextStyle cardBody = TextStyle(
    color: Color.fromARGB(148, 242, 239, 234),
    fontSize: 14.sp,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
  );

  static TextStyle cardSection = TextStyle(
    color: Color(0xFFF2EFEA),
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
  );

  static TextStyle price = TextStyle(
    color: Color(0xFFF2EFEA),
    fontFamily: 'Canela',
    fontSize: 36.sp,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w300,
  );

  static TextStyle priceSub = TextStyle(
    color: Color(0xFFF2EFEA),
    fontSize: 16.sp,
    fontFamily: 'Satoshi',
    fontWeight: FontWeight.w700,
  );

  static final ButtonStyle mainButton = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF3C6EAB),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  );

  static TextStyle pageTitle = TextStyle(
    color: Colors.white,
    fontFamily: 'Canela',
    fontSize: 36.sp,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w300,
  );

  static const LinearGradient badgeBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF54A0ED), // start color
      Color(0xFF9ECFFF), // end color
    ],
  );
}
