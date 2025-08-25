import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class HowWorkModal extends StatelessWidget {
  final VoidCallback? onClose;
  const HowWorkModal({super.key, this.onClose});

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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppStyles.white,
                        size: 28,
                      ),
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'How it works',
                        textAlign: TextAlign.center,
                        style: AppStyles.headingMedium,
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                AppStyles.spacingMedium,
                Text(
                  'Your Dream Vault trains the Default Mode Network and Prefrontal Cortex to update your future vision in sync with your evolving self.\n\n'
                  'Reflection + emotional salience + identity alignment = neuroplasticity.\n\n'
                  "Updating your vision improves motivation, coherence, and sustained behavior change—your brain is constantly learning from the future you're choosing.",
                  style: AppStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppStyles.spacingLarge,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: AppStyles.modalButton,
                    child: Text('Continue', style: AppStyles.buttonTextSmall),
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
