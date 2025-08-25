import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MeditationActionBar extends StatelessWidget {
  final bool isMuted;
  final bool isLiked;
  final VoidCallback onMuteToggle;
  final VoidCallback onLikeToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onShare;

  const MeditationActionBar({
    super.key,
    required this.isMuted,
    required this.isLiked,
    required this.onMuteToggle,
    required this.onLikeToggle,
    required this.onDelete,
    required this.onEdit,
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
          // Delete button
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF), // #FFFFFF1A
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              onPressed: onDelete,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          // Like button
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF), // #FFFFFF1A
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: onLikeToggle,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          // Edit button
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF), // #FFFFFF1A
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
              onPressed: onEdit,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
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