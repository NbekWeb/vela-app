import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditInfoHeader extends StatelessWidget {
  const EditInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Transform.translate(
            offset: const Offset(3, 0),
            child: Image.asset('assets/img/logo.png', width: 60, height: 39),
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: const Icon(
              Icons.settings,
              color: Colors.transparent,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
} 