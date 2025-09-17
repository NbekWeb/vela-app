import 'package:flutter/material.dart';
import '../../styles/pages/plan_page_styles.dart';
import '../../shared/widgets/auth.dart';
import '../../shared/widgets/exit_modal.dart';

class DreamLifeIntroStep extends StatelessWidget {
  const DreamLifeIntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back button behavior
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Handle system back button (Android/iOS)
          ExitModal.show(
            context,
            title: 'Exit App?',
            message: 'Are you sure you want to exit the app? You can always come back to continue your journey.',
          );
        }
      },
      child: AuthScaffold(
      title: 'Set sail to your dream life ',
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: PlanPageStyles.cardBg,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'We will set up your profile based on your answers to generate your customized manifesting meditation experience, grounded in neuroscience, and tailored to you.',
            style: PlanPageStyles.cardBody,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onBack: () {
        ExitModal.show(
          context,
          title: 'Exit App?',
          message: 'Are you sure you want to exit the app? You can always come back to continue your journey.',
        );
      },
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: PlanPageStyles.mainButton,
                onPressed: () {
                  Navigator.pushNamed(context, '/generator');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Dream Life Intake',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      ),
    );
  }
}
