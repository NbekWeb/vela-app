import 'package:flutter/material.dart';
import '../../../shared/widgets/svg_icon.dart';

class NeuroplasticityButton extends StatelessWidget {
  const NeuroplasticityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B6EAA),
        borderRadius: BorderRadius.circular(200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            assetName: 'assets/icons/brain.svg',
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          const Text(
            'Neuroplasticity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
} 