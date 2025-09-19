import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../../shared/models/meditation_profile_data.dart';
import '../../../core/stores/meditation_store.dart';
import '../step_scaffold.dart';
import 'package:provider/provider.dart';

class GoalsStep extends StatefulWidget {
  final MeditationProfileData profileData;
  final Function(MeditationProfileData) onProfileDataChanged;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const GoalsStep({
    required this.profileData,
    required this.onProfileDataChanged,
    required this.onNext,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    super.key,
  });

  @override
  State<GoalsStep> createState() => _GoalsStepState();
}

class _GoalsStepState extends State<GoalsStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Avvalgi qiymatni ko'rsatish uchun
    if (widget.profileData.goals != null &&
        widget.profileData.goals!.isNotEmpty) {
      _controller.text = widget.profileData.goals!.join(', ');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onGoalsChanged(String value) {
    // Maqsadlarni vergul orqali massivga aylantiramiz
    final goals = value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Update local profile data
    final updatedProfile = widget.profileData.copyWith(goals: goals);
    widget.onProfileDataChanged(updatedProfile);

    // Save to store
    final meditationStore = Provider.of<MeditationStore>(
      context,
      listen: false,
    );
    meditationStore.setMeditationProfile(updatedProfile);

    setState(() {}); // UI yangilash uchun
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      controller: KeyboardVisibilityController(),
      builder: (context, isKeyboardVisible) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(physics: const NeverScrollableScrollPhysics()),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: StepScaffold(
              title: '',
              onBack: widget.onBack,
              onNext: widget.onNext,
              currentStep: widget.currentStep,
              totalSteps: widget.totalSteps,
              nextEnabled: _controller.text.trim().isNotEmpty,
              stepperIndex: widget.stepperIndex,
              stepperCount: widget.stepperCount,
              showTitles: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Specific goals',
                    style: TextStyle(
                      fontFamily: 'Canela',
                      fontWeight: FontWeight.w300,
                      fontSize: 36,
                      color: Color(0xFFF2EFEA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Are there specific goals you want to accomplish, experiences you want to have, or habits you want to form or change?',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      color: Color(0xFFF2EFEA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _controller,
                      minLines: 3,
                      maxLines: isKeyboardVisible ? 4 : 6,
                      scrollPhysics: const ClampingScrollPhysics(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Start a morning routine, feel less anxious, travel more.',
                        hintStyle: const TextStyle(color: Color(0xFFffffff)),
                        filled: true,
                        fillColor: Color(0xFF5882B6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0x152B561A),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF152B56),
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      onChanged: _onGoalsChanged,
                    ),
                  ),
                  SizedBox(height: isKeyboardVisible ? 10 : 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
