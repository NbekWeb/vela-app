import 'package:flutter/material.dart';

class SleepMeditationHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onInfoPressed;

  const SleepMeditationHeader({
    super.key,
    required this.onBackPressed,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBackPressed,
        ),
        Image.asset(
          'assets/img/logo.png',
          height: 32,
          color: Colors.white,
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: onInfoPressed,
        ),
      ],
    );
  }
} 