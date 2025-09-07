import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/svg_icon.dart';

class DreamsRealizedCard extends StatelessWidget {
  final double? height;
  final VoidCallback onEdit;
  final String? content;

  const DreamsRealizedCard({
    super.key,
    this.height,
    required this.onEdit,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You\'re becoming your trust self',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content
          Center(
            child: Text(
              content ?? 'Embarking on a journey to realize my dreams has been transformative. I feel most alive when I chase my aspirations and stay true to who I am.',
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