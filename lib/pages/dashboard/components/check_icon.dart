import 'package:flutter/material.dart';
import '../../../shared/widgets/svg_icon.dart';

class CheckIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const CheckIcon({
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
            ? 'assets/menu/checkin-active.svg'
            : 'assets/menu/checkin.svg',
        size: size,
      ),
    );
  }
}
