import 'package:flutter/material.dart';
import '../../../shared/widgets/svg_icon.dart';

class ProfileIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const ProfileIcon({
    this.size = 30,
    this.filled = false,
    this.opacity = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SvgIcon(
        assetName: filled
            ? 'assets/menu/profile-active.svg'
            : 'assets/menu/profile.svg',
        size: size,
      ),
    );
  }
}
