import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class StarterModal extends StatelessWidget {
  final VoidCallback? onClose;
  const StarterModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;

    return Center(
      child: ClipRRect(
        borderRadius: AppStyles.radiusMedium,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: modalWidth,
            padding: AppStyles.paddingModal,
            decoration: AppStyles.frostedGlass,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppStyles.white, size: 28),
                          onPressed: onClose ?? () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Expanded(
                          child: Text(
                            'Why this works',
                            textAlign: TextAlign.center,
                            style: AppStyles.headingMedium,
                          ),
                        ),
                        // O‘ng tomonda soxta icon (ko‘rinmaydi, lekin joy egallaydi)
                        Opacity(
                          opacity: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: null,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                Text(
                  'Visualizing your dream life activates key brain systems—Default Mode Network, Prefrontal Cortex, Reticular Activating System, and dopaminergic reward circuits.\n\n'
                  'These govern identity, goal setting, decision-making, and motivation. Reflecting inward engages your DMN—your brain\'s future-visioning network. This primes you for clarity and creativity, while the RAS begins filtering your attention toward aligned opportunities. Your Prefrontal Cortex builds the map forward, and imagining fulfillment releases dopamine, motivating action.\n\n'
                  'Studies from Stanford and NYU show that intentional life design increases hope, self-awareness, and emotional resilience.',
                  style: AppStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppStyles.spacingLarge,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: AppStyles.modalButton,
                    child: Text(
                      'Continue',
                      style: AppStyles.buttonTextSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}