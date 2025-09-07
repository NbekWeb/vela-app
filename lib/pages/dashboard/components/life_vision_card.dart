import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/svg_icon.dart';

class LifeVisionCard extends StatelessWidget {
  final double? height;
  final VoidCallback onEdit;
  final String? content;

  const LifeVisionCard({
    super.key, 
    this.height, 
    required this.onEdit,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(164, 199, 234, 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(Icons.star_outline, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Your North Star',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Satoshi',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content
          Expanded(
            child: Text(
              content ?? 'I feel most authentic when I embrace my true self. I am focused on pursuing my passions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Satoshi',
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
