import 'package:flutter/material.dart';
import '../../../shared/widgets/svg_icon.dart';

class VaultIcon extends StatelessWidget {
  final double size;
  final bool filled;
  final double opacity;
  const VaultIcon({
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
            ? 'assets/menu/vault-active.svg'
            : 'assets/menu/vault.svg',
        size: size,
      ),
    );
  }
}
