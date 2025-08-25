import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/meditation_store.dart';
import '../generator/direct_ritual_page.dart';

class MyMeditationsPage extends StatelessWidget {
  final Function(String)? onAudioPlay;

  const MyMeditationsPage({this.onAudioPlay, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Image.asset('assets/img/logo.png', width: 60, height: 39),
                      ClipOval(
                        child: Image.asset(
                          'assets/img/card.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'My meditations',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Pick a meditation or make your own',
                  style: TextStyle(
                    color: Color(0xFFDCE6F0),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<MeditationStore>(
                  builder: (context, meditationStore, child) {
                    final myMeditations = meditationStore.myMeditations;
                    final meditationCount = myMeditations?.length ?? 0;

                    if (meditationCount > 0) {
                      // Show cards based on meditation count
                      return Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(meditationCount, (index) {
                              final meditation = myMeditations![index];
                              final details = meditation['details'];
                              final name = details?['name'] ?? 'Sleep Stream';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: VaultRitualCard(
                                  name: name,
                                  meditationId: meditation['id']?.toString(),
                                  file: meditation['file'],
                                  onAudioPlay: onAudioPlay,
                                ),
                              );
                            }),
                          ),
                        ),
                      );
                    } else {
                      // Show empty state if no meditations - centered between subtitle and button
                      return Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: VaultRitualCard(
                              isEmpty: true,
                              emptyText: 'No meditations created',
                              onAudioPlay: onAudioPlay,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DirectRitualPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B6EAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                '     Generate New Meditation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/img/star.png',
                            width: 28,
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
