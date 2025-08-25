import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class PersonalizedMeditationModal extends StatelessWidget {
  final VoidCallback? onClose;
  const PersonalizedMeditationModal({super.key, this.onClose});

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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SingleChildScrollView(
                    child: Text(
                      'Personalized meditations activate the brain\'s limbic system, medial prefrontal cortex, and mirror neuron networks—centers for emotion, identity, and behavioral reinforcement.\n\n'
                      'Each meditation is crafted from your reflections, then delivered in a soothing, emotionally resonant voice. This blend of emotional salience and personal relevance creates the ideal conditions for lasting neural change.\n\n'
                      'Vela meditations speak to you in the second person ("you are…") because your brain responds more strongly to it than first person. Second-person affirmations activate emotional and motivational centers more effectively—engaging the brain as if the message is coming from a trusted guide.\n\n'
                      'This is more than relaxation. It\'s neuro-sculpting—a daily ritual to reinforce who you are becoming.',
                      style: AppStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
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