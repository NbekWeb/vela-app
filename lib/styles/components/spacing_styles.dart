import 'package:flutter/material.dart';
import '../base_styles.dart';

class SpacingStyles {
  // Padding
  static const EdgeInsets paddingHorizontal = BaseStyles.paddingHorizontal;
  static const EdgeInsets paddingHorizontalLarge = BaseStyles.paddingHorizontalLarge;
  static const EdgeInsets paddingAll = BaseStyles.paddingAll;
  static const EdgeInsets paddingModal = BaseStyles.paddingModal;

  // SizedBox Spacing
  static const SizedBox spacingSmall = BaseStyles.spacingSmall;
  static const SizedBox spacingMedium = BaseStyles.spacingMedium;
  static const SizedBox spacingLarge = BaseStyles.spacingLarge;

  // Custom Spacing
  static const SizedBox spacing8 = SizedBox(height: 8);
  static const SizedBox spacing12 = SizedBox(height: 12);
  static const SizedBox spacing20 = SizedBox(height: 20);
  static const SizedBox spacing40 = SizedBox(height: 40);

  // Width Spacing
  static const SizedBox width8 = SizedBox(width: 8);
  static const SizedBox width12 = SizedBox(width: 12);
  static const SizedBox width16 = SizedBox(width: 16);
  static const SizedBox width24 = SizedBox(width: 24);

  // Page Specific Spacing
  static const EdgeInsets starterPagePadding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 16.0,
  );

  static const EdgeInsets starterPageContentPadding = EdgeInsets.fromLTRB(
    20, 20, 20, 20
  );

  // Modal Specific Spacing
  static const EdgeInsets modalContentPadding = BaseStyles.paddingModal;
} 