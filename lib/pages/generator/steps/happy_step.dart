import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../../shared/models/meditation_profile_data.dart';
import '../../../core/stores/meditation_store.dart';
import '../step_scaffold.dart';
import 'package:provider/provider.dart';

class HappyStep extends StatefulWidget {
  final MeditationProfileData profileData;
  final Function(MeditationProfileData) onProfileDataChanged;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const HappyStep({
    required this.profileData,
    required this.onProfileDataChanged,
    this.onBack,
    this.onNext,
    required this.currentStep,
    required this.totalSteps,
    required this.stepperIndex,
    required this.stepperCount,
    super.key,
  });

  @override
  State<HappyStep> createState() => _HappyStepState();
}

class _HappyStepState extends State<HappyStep> {
  final TextEditingController _controller = TextEditingController();
  bool _nextEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    // Avvalgi qiymatni ko‘rsatish uchun
    if (widget.profileData.happiness != null &&
        widget.profileData.happiness!.isNotEmpty) {
      _controller.text = widget.profileData.happiness!.join(', ');
    }
  }

  void _onTextChanged() {
    setState(() {
      _nextEnabled = _controller.text.trim().isNotEmpty;
    });
    // Matnni vergul orqali massivga aylantiramiz
    final happiness = _controller.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Update local profile data
    final updatedProfile = widget.profileData.copyWith(happiness: happiness);
    widget.onProfileDataChanged(updatedProfile);

    // Save to store
    final meditationStore = Provider.of<MeditationStore>(
      context,
      listen: false,
    );
    meditationStore.setMeditationProfile(updatedProfile);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'What makes you happy?',
                style: TextStyle(
                  fontFamily: 'Canela',
                  fontWeight: FontWeight.w300,
                  fontSize: 36,
                  color: Color(0xFFF2EFEA),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'What makes you feel the most "you"?',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  color: Color(0xFFF2EFEA),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'I feel most myself when I laugh freely,\n make art, and spend time in nature.',
                    hintStyle: const TextStyle(color: Color(0xFFFfffff)),
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
                  onChanged: (_) => _onTextChanged(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}
