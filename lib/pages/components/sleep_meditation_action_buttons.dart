import 'package:flutter/material.dart';

class SleepMeditationActionButtons extends StatelessWidget {
  final VoidCallback onResetPressed;
  final VoidCallback onSavePressed;
  final bool isDirectRitual;

  const SleepMeditationActionButtons({
    super.key,
    required this.onResetPressed,
    required this.onSavePressed,
    this.isDirectRitual = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //ConstrainedBox(
        //  constraints: const BoxConstraints(minWidth: 100, minHeight: 60),
        //  child: ElevatedButton(
        //    onPressed: onResetPressed,
        //    style: ElevatedButton.styleFrom(
        //      backgroundColor: Colors.white,
        //      elevation: 0,
        //      shape: RoundedRectangleBorder(
        //        borderRadius: BorderRadius.circular(48),
        //      ),
        //      padding: const EdgeInsets.symmetric(horizontal: 30),
        //    ),
        //    child: Row(
        //      mainAxisAlignment: MainAxisAlignment.center,
        //      mainAxisSize: MainAxisSize.min,
        //      children: [
        //        Icon(Icons.refresh_rounded, color: Color(0xFF3B6EAA), size: 24),
        //        const SizedBox(width: 8),
        //        Text(
        //          'Reset',
        //          style: TextStyle(
        //            color: Color(0xFF3B6EAA),
        //            fontWeight: FontWeight.w600,
        //            fontSize: 16,
        //          ),
        //        ),
        //      ],
        //    ),
        //  ),
        //),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: onSavePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B6EAA),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Center(
                child: Text(
                  'Save to Dream Vault',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
