import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/stores/like_store.dart';

class LikeButton extends StatelessWidget {
  final String meditationId;
  final double? size;
  final Color? color;
  final Color? likedColor;
  final VoidCallback? onPressed;

  const LikeButton({
    super.key,
    required this.meditationId,
    this.size = 24.0,
    this.color = Colors.white,
    this.likedColor = Colors.red,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LikeStore>(
      builder: (context, likeStore, child) {
        final isLiked = likeStore.isLiked(meditationId);
        final isLoading = likeStore.isLoading;

        return IconButton(
          icon: isLoading
              ? SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isLiked ? likedColor! : color!,
                    ),
                  ),
                )
              : Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: size,
                  color: isLiked ? likedColor : color,
                ),
          onPressed: isLoading
              ? null
              : () async {
                  await likeStore.toggleLike(meditationId);
                  onPressed?.call();
                },
        );
      },
    );
  }
} 