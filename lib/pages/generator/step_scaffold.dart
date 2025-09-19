import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../shared/widgets/starter_modal.dart';
import '../../shared/widgets/stars_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final int currentStep;
  final int totalSteps;
  final bool showInfo;
  final VoidCallback? onInfo;
  final bool nextEnabled;
  final String? nextLabel;
  final bool showStepper;
  final bool showTitles;
  final int? stepperIndex;
  final int? stepperCount;

  const StepScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.onNext,
    required this.currentStep,
    required this.totalSteps,
    this.showInfo = true,
    this.onInfo,
    this.nextEnabled = true,
    this.nextLabel,
    this.showStepper = true,
    this.showTitles = true,
    this.stepperIndex,
    this.stepperCount,
  });

  @override
  Widget build(BuildContext context) {
    void showInfoPopover() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Starter",
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.topCenter,
            child: StarterModal(onClose: () => Navigator.of(context).pop()),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
            child: child,
          );
        },
      );
    }

    return KeyboardVisibilityBuilder(
      controller: KeyboardVisibilityController(),
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              const Positioned.fill(child: StarsAnimation()),
              // Main content area
              Column(
                children: [
                  // Top section with header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 4,
                        ),
                        // Back, Stepper, Info icon bitta qatorda
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: onBack,
                            ),
                            if (showStepper &&
                                stepperIndex != null &&
                                stepperCount != null)
                              Expanded(
                                child: Center(
                                  child: _StepperIndicator(
                                    currentStep: stepperIndex!,
                                    totalSteps: stepperCount!,
                                  ),
                                ),
                              ),
                            if (!showStepper ||
                                stepperIndex == null ||
                                stepperCount == null)
                              const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: onInfo ?? showInfoPopover,
                            ),
                          ],
                        ),
                        if (showTitles) ...[
                          const Text(
                            'Dream life intake',
                            style: TextStyle(
                              fontFamily: 'Canela',
                              fontWeight: FontWeight.w400,
                              fontSize: 32,
                              color: Color(0xFFF2EFEA),
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'The Vision Builder',
                            style: TextStyle(
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFFF2EFEA),
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Content area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: isKeyboardVisible ? 100 : 0, // Keyboard ochilganda padding qo'shamiz
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          height: isKeyboardVisible 
                            ? null // Keyboard ochilganda natural height
                            : MediaQuery.of(context).size.height - 200, // Keyboard yo'q bo'lganda fixed height
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (title.isNotEmpty) ...[
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontFamily: 'Canela',
                                    fontWeight: FontWeight.w300,
                                    fontSize: 36,
                                    color: Color(0xFFF2EFEA),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                              ],
                              child,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom button area
                  if (onNext != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 40,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'The Universe responds to specifics. The more detail you share, the more powerful and personalized your Vela journey becomes.',
                            style: TextStyle(
                              color: Color(0xFFDCE6F0),
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                              letterSpacing: -0.5,
                              height: 1.25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: nextEnabled ? onNext : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.disabled,
                                      )) {
                                        return const Color(
                                          0xFF3B6EAA,
                                        ).withOpacity(0.5);
                                      }
                                      return const Color(0xFF3B6EAA);
                                    }),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.disabled,
                                      )) {
                                        return Colors.white.withOpacity(
                                          0.7,
                                        );
                                      }
                                      return Colors.white;
                                    }),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    nextLabel ?? 'Next',
                                    style: const TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Color(0xFFF2EFEA),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StepperIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepperIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: 35,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
