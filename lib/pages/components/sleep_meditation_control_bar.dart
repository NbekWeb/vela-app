import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepMeditationControlBar extends StatelessWidget {
  final bool isMuted;
  final bool isLiked;
  final VoidCallback onMuteToggle;
  final VoidCallback onLikeToggle;
  final VoidCallback onShare;

  const SleepMeditationControlBar({
    super.key,
    required this.isMuted,
    required this.isLiked,
    required this.onMuteToggle,
    required this.onLikeToggle,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Mute icon
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              color: Colors.white,
            ),
            onPressed: onMuteToggle,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          // Center button - full width
          Expanded(
            child: GestureDetector(
              onTap: onLikeToggle,
              child: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Resonating?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Satoshi',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          // Right (share) icon
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}
