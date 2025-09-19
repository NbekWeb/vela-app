import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'life_vision_card.dart';
import 'goals_progress_card.dart';
import 'dreams_realized_card.dart';
import '../../../shared/widgets/profile_edit_modal.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../../../core/stores/auth_store.dart';

class ProfileContentSections extends StatefulWidget {
  const ProfileContentSections({super.key});

  @override
  State<ProfileContentSections> createState() => _ProfileContentSectionsState();
}

class _ProfileContentSectionsState extends State<ProfileContentSections> {
  String _lifeVision =
      'I feel most authentic when I embrace my true self. I am focused on pursuing my passions.';
  String _goalsInProgress =
      'Start a morning routine, feel less anxious, travel more.';
  String _dreamsRealized =
      'I\'m living in a cozy home filled with art, waking up feeling calm, working on projects that light me up...';

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStore>(
      builder: (context, authStore, child) {
        final user = authStore.user;
        final happiness =
            user?.happiness ??
            'I feel most authentic when I embrace my true self. I am focused on pursuing my passions.';
        final dream =
            user?.dream ??
            'I\'m living in a cozy home filled with art, waking up feeling calm, working on projects that light me up...';
        final goals =
            user?.goals ??
            'Start a morning routine, feel less anxious, travel more.';

        return Column(
          children: [
            // Life Vision and Goals in Progress row
            IntrinsicHeight(
              child: Row(
                children: [
                  // Life Vision
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title outside the card
                        Row(
                          children: [
                            Text(
                              'Life Vision',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _showLifeVisionModal(happiness),
                              child: const SvgIcon(
                                assetName: 'assets/icons/edit.svg',
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Life Vision Card
                        LifeVisionCard(
                          height: 160,
                          onEdit: () => _showLifeVisionModal(happiness),
                          content: happiness,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Goals in Progress
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title outside the card
                        Row(
                          children: [
                            Text(
                              'Goals in Progress',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Satoshi',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _showGoalsInProgressModal(goals),
                              child: const SvgIcon(
                                assetName: 'assets/icons/edit.svg',
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Goals Progress Card
                        GoalsProgressCard(
                          height: 160,
                          onEdit: () => _showGoalsInProgressModal(goals),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Dreams Realized
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title outside the card
                Row(
                  children: [
                    Text(
                      'Dreams Realized',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showDreamsRealizedModal(dream),
                      child: const SvgIcon(
                        assetName: 'assets/icons/edit.svg',
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Dreams Realized Card
                DreamsRealizedCard(
                  height: 120,
                  onEdit: () => _showDreamsRealizedModal(dream),
                  content: dream,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showLifeVisionModal(String initialValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ProfileEditModal(
            title: 'Life Vision',
            prompt: 'What makes you feel the most "you"?',
            hintText:
                'I feel most myself when I laugh freely, make art, and spend time in nature.',
            initialValue: initialValue,
            onSave: (String newVision) async {
              final authStore = Provider.of<AuthStore>(context, listen: false);
              final user = authStore.user;

              if (user != null) {
                await authStore.updateUserDetail(
                  gender: user.gender ?? '',
                  ageRange: user.ageRange ?? '',
                  dream: user.dream ?? '',
                  goals: user.goals ?? '',
                  happiness: newVision, // happiness field'iga saqlanadi
                  onSuccess: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showGoalsInProgressModal(String initialValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ProfileEditModal(
            title: 'Goals in Progress',
            prompt:
                'Are there specific goals you want to accomplish, experiences you want to have, or habits you want to form or change?',
            hintText:
                'Start a morning routine, feel less anxious, travel more.',
            initialValue: initialValue,
            onSave: (String newGoals) async {
              final authStore = Provider.of<AuthStore>(context, listen: false);
              final user = authStore.user;

              if (user != null) {
                await authStore.updateUserDetail(
                  gender: user.gender ?? '',
                  ageRange: user.ageRange ?? '',
                  dream: user.dream ?? '',
                  goals: newGoals, // goals field'iga saqlanadi
                  happiness: user.happiness ?? '',
                  onSuccess: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showDreamsRealizedModal(String initialValue) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ProfileEditModal(
            title: 'Dreams Realized',
            prompt:
                'Be sure to include Sensory Details: What does it look and feel like? What are you doing? Who are you with? What do you see, hear, smell?',
            hintText:
                'I\'m living in a cozy home filled with art, waking up feeling calm, working on projects that light me up...',
            initialValue: initialValue,
            onSave: (String newDreams) async {
              final authStore = Provider.of<AuthStore>(context, listen: false);
              final user = authStore.user;

              if (user != null) {
                await authStore.updateUserDetail(
                  gender: user.gender ?? '',
                  ageRange: user.ageRange ?? '',
                  dream: newDreams, // dream field'iga saqlanadi
                  goals: user.goals ?? '',
                  happiness: user.happiness ?? '',
                  onSuccess: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
