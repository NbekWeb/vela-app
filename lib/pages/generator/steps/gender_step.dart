import 'package:flutter/material.dart';
import '../../../shared/models/meditation_profile_data.dart';
import '../../../core/stores/meditation_store.dart';
import '../step_scaffold.dart';
import 'package:provider/provider.dart';

class GenderStep extends StatefulWidget {
  final MeditationProfileData profileData;
  final Function(MeditationProfileData) onProfileDataChanged;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  final int stepperIndex;
  final int stepperCount;
  const GenderStep({
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
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  int? selectedIndex;
  final List<String> genders = ['Female', 'Male', 'Other'];

  @override
  void initState() {
    super.initState();
    // Initialize selectedIndex based on existing profile data
    if (widget.profileData.gender != null) {
      selectedIndex = genders.indexOf(widget.profileData.gender!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      title: '',
      onBack: widget.onBack ?? () => Navigator.of(context).pop(),
      onNext: widget.onNext,
      currentStep: widget.currentStep,
      totalSteps: widget.totalSteps,
      nextEnabled: selectedIndex != null,
      stepperIndex: widget.stepperIndex,
      stepperCount: widget.stepperCount,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Gender?',
            style: const TextStyle(
              fontFamily: 'Canela',
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _genderButton(0, 'Female')),
              const SizedBox(width: 15),
              Expanded(child: _genderButton(1, 'Male')),
            ],
          ),
          const SizedBox(height: 15),
          _genderButton(2, 'Non-binary/Other', isFullWidth: true),
        ],
      ),
    );
  }

  Widget _genderButton(int i, String label, {bool isFullWidth = false}) {
    final selected = selectedIndex == i;
    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = i);

        // Update local profile data
        final updatedProfile = widget.profileData.copyWith(gender: genders[i]);
        widget.onProfileDataChanged(updatedProfile);

        // Save to store
        final meditationStore = Provider.of<MeditationStore>(
          context,
          listen: false,
        );
        meditationStore.setMeditationProfile(updatedProfile);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: isFullWidth ? double.infinity : null,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF3B6EAA)
              : const Color.fromRGBO(21, 43, 86, 0.1),
          border: Border.all(
            color: selected
                ? const Color(0xFF3B6EAA)
                : const Color.fromRGBO(21, 43, 86, 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(70),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: selected ? Colors.white : const Color(0xFFC9DFF4),
            ),
          ),
        ),
      ),
    );
  }
}
