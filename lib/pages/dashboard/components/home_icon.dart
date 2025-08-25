import 'package:flutter/material.dart';
import '../../../shared/widgets/svg_icon.dart';

class HomeIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;

  const HomeIcon({
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
            ? 'assets/menu/home-active.svg'
            : 'assets/menu/home.svg',
        size: size,
      ),
    );
  }
}
