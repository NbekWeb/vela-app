import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import '../../shared/widgets/stars_animation.dart';
import '../../core/stores/meditation_store.dart';
import '../../core/stores/auth_store.dart';
import 'components/dashboard_audio_player.dart';
import 'main.dart';
import '../../main.dart' show shouldNavigateToProfile;

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
    // Fetch meditation library when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.fetchMeditationLibrary();
    });
  }

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
                      GestureDetector(
                        onTap: () {
                          // Set global flag and navigate to dashboard
                          shouldNavigateToProfile = true;
                          print(
                            'Archive: Setting shouldNavigateToProfile = true',
                          );
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/dashboard');
                        },
                        child: Consumer<AuthStore>(
                          builder: (context, authStore, child) {
                            final user = authStore.user;
                            final avatarUrl = user?.avatar;

                            if (avatarUrl != null && avatarUrl.isNotEmpty) {
                              return Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Container(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    child: const Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meditations library',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Select meditations selected by the Vela team',
                  style: TextStyle(
                    color: Color(0xFFDCE6F0),
                    fontSize: 16,
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Consumer<MeditationStore>(
                    builder: (context, meditationStore, child) {
                      // Show loading indicator while fetching data
                      if (meditationStore.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      final libraryDatas = meditationStore.libraryDatas;
                      final libraryCount = libraryDatas?.length ?? 0;

                      if (libraryCount > 0) {
                        // Show all cards in vertical scroll
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(libraryCount, (index) {
                              final meditation = libraryDatas![index];
                              final name =
                                  meditation['name'] ?? 'Morning Meditation';

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index < libraryCount - 1 ? 16.0 : 0,
                                ),
                                child: VaultRitualCard(
                                  name: name,
                                  meditationId: meditation['id']?.toString(),
                                  file: meditation['file'],
                                  imageUrl: meditation['image'],
                                  title: meditation['name'],
                                  description: meditation['description'],
                                  onAudioPlay: (meditationId) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DashboardAudioPlayer(
                                              meditationId: meditationId,
                                              title: meditation['name'],
                                              description:
                                                  meditation['description'],
                                              imageUrl: meditation['image'],
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        );
                      } else {
                        // Show empty state if no library meditations - centered vertically
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: VaultRitualCard(
                              isEmpty: true,
                              emptyText: 'Library is empty  ',
                              showButton: false,
                            ),
                          ),
                        );
                      }
                    },
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
