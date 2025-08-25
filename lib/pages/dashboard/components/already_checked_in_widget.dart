import 'package:flutter/material.dart';
import '../../generator/direct_ritual_page.dart';

class AlreadyCheckedInWidget extends StatelessWidget {
  const AlreadyCheckedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'You have already checked in today',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Generate New Meditation Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const DirectRitualPage(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Generate New Meditation',
                  style: TextStyle(
                    color: Color(0xFF3B6EAA),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF3B6EAA),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 