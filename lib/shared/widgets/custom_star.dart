import 'package:flutter/material.dart';

class CustomStar extends StatelessWidget {
  final bool isFilled;
  final double size;
  final String title;

  const CustomStar({
    super.key,
    this.isFilled = true,
    this.size = 36,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFA4C7EA).withAlpha(128),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              isFilled ? 'assets/img/star_fill.png' : 'assets/img/star_empty.png',
              width: size * 0.6,
              height: size * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
} 