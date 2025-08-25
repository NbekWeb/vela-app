import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vela/shared/widgets/stars_animation.dart';
import 'steps/ritual_step.dart';
import '../../shared/models/meditation_profile_data.dart';
import '../../core/stores/meditation_store.dart';

class DirectRitualPage extends StatefulWidget {
  const DirectRitualPage({super.key});

  @override
  State<DirectRitualPage> createState() => _DirectRitualPageState();
}

class _DirectRitualPageState extends State<DirectRitualPage> {
  MeditationProfileData profileData = MeditationProfileData();

  void updateProfileData(MeditationProfileData newData) {
    setState(() {
      profileData = newData;
    });
  }

  void _goBackToHome() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const StarsAnimation(),
          RitualStep(
            profileData: profileData,
            onProfileDataChanged: updateProfileData,
            onBack: _goBackToHome,
            currentStep: 1,
            totalSteps: 1,
            showStepper: false,
            isDirectRitual: true,
          ),
        ],
      ),
    );
  }
} 