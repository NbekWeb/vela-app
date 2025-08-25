import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../vault/vault_ritual_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/video_background_wrapper.dart';
import '../../shared/widgets/custom_star.dart';
import '../dashboard/my_meditations_page.dart';
import '../dashboard/archive_page.dart';
import '../generator/direct_ritual_page.dart';
import '../sleep_stream_meditation_page.dart';
import '../../core/stores/auth_store.dart';
import '../../core/stores/meditation_store.dart';
import '../dashboard/components/dashboard_audio_player.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _loadMeditationData();
  }

  Future<void> _getUserDetails() async {
    // Use Provider to access AuthStore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      authStore.getUserDetails();
    });
  }

  Future<void> _loadMeditationData() async {
    // Use Provider to access MeditationStore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      meditationStore.fetchMyMeditations();
      meditationStore.fetchMeditationLibrary();
    });
  }

  void _onAudioPlay(
    String meditationId, {
    String? title,
    String? description,
    String? imageUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardAudioPlayer(
          meditationId: meditationId,
          title: title,
          description: description,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VideoBackgroundWrapper(
      topOffset: -40,
      showControls: false,
      isMuted: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16.sp, // left
            8.sp, // top
            16.sp, // right
            20.sp, // bottom
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Info icon in a circle, size 24x24
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/img/logo.png',
                    width: 60,
                    height: 39,
                  ),
                  // Avatar on the right, size 30x30
                  Consumer<AuthStore>(
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
                ],
              ),

              const SizedBox(height: 300),

              // Daily Streaks section
              Center(
                child: Text(
                  'Daily Streaks',
                  style: TextStyle(
                    fontFamily: 'Canela',
                    fontSize: 36.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 8.sp),
              Consumer<AuthStore>(
                builder: (context, authStore, child) {
                  final user = authStore.user;
                  final weeklyStats = user?.weeklyLoginStats;
                  
                  int totalLogins = 0;
                  if (weeklyStats != null && weeklyStats.days.isNotEmpty) {
                    totalLogins = weeklyStats.days
                        .where((day) => day.login)
                        .length;
                  }

                  String streakText;
                  if (totalLogins == 0) {
                    streakText = 'Start your meditation journey today';
                  } else if (totalLogins == 1) {
                    streakText = 'You\'ve shown up 1 day this week';
                  } else {
                    streakText = 'You\'ve shown up $totalLogins days this week';
                  }

                  return Center(
                    child: Text(
                      streakText,
                      style: TextStyle(
                        color: Color(0xFFDCE6F0),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.sp),
              Consumer<AuthStore>(
                builder: (context, authStore, child) {
                  final user = authStore.user;
                  final weeklyStats = user?.weeklyLoginStats;

                  if (weeklyStats != null && weeklyStats.days.isNotEmpty) {
                    final dayLabels = [
                      'M',
                      'T',
                      'W',
                      'T',
                      'F',
                      'S',
                      'S',
                    ];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        final dayData = weeklyStats.days[index];
                        final isFilled = dayData.login;

                        return CustomStar(
                          isFilled: isFilled,
                          title: dayLabels[index],
                          size: 36,
                        );
                      }),
                    );
                  } else {
                    // Fallback if no weekly stats
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        7,
                        (index) => CustomStar(
                          isFilled: false,
                          title: [
                            'M',
                            'T',
                            'W',
                            'T',
                            'F',
                            'S',
                            'S',
                          ][index],
                          size: 36,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 32.sp),

              // My Meditations section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyMeditationsPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Meditations',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Canela',
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFFDCE6F0),
                      size: 36,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.sp),

                             // My Meditations list
               Consumer<MeditationStore>(
                 builder: (context, meditationStore, child) {
                   final myMeditations = meditationStore.myMeditations;
                   
                   if (myMeditations == null || myMeditations.isEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(164, 199, 234, 0.5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Create your first meditation to get started',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 242, 239, 234),
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                                     return Column(
                     children: myMeditations!.take(3).map((meditation) {
                       final details = meditation['details'] ?? {};
                       final name = details['name'] ?? 'Untitled';
                       final meditationId = meditation['id']?.toString() ?? '';
                       
                       return Container(
                         margin: EdgeInsets.only(bottom: 12.sp),
                         child: VaultRitualCard(
                           name: name,
                           meditationId: meditationId,
                           file: meditation['file'],
                           onAudioPlay: _onAudioPlay,
                         ),
                       );
                     }).toList(),
                   );
                },
              ),

              SizedBox(height: 24.sp),
              SizedBox(
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
                    backgroundColor: Color(0xFF3B6EAA),
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
                      Expanded(
                        child: Center(
                          child: Text(
                            'Generate New Meditation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
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
              SizedBox(height: 32.sp),

              // Meditation Library section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArchivePage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Meditation Library',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Canela',
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFFDCE6F0),
                    size: 36,
                  ),
                ],
              ),
              ),

              SizedBox(height: 16.sp),

                             // Meditation Library list
               Consumer<MeditationStore>(
                 builder: (context, meditationStore, child) {
                   final libraryMeditations = meditationStore.libraryDatas;
                   
                   if (libraryMeditations == null || libraryMeditations.isEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(164, 199, 234, 0.5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Check back later for new meditations',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 242, 239, 234),
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                                     return Column(
                     children: libraryMeditations!.take(3).map((meditation) {
                       final name = meditation['name'] ?? 'Untitled';
                       final meditationId = meditation['id']?.toString() ?? '';
                       final imageUrl = meditation['image'];
                       final description = meditation['description'];
                       
                       return Container(
                         margin: EdgeInsets.only(bottom: 12.sp),
                         child: VaultRitualCard(
                           name: name,
                           meditationId: meditationId,
                           file: meditation['file'],
                           imageUrl: imageUrl,
                           title: name,
                           description: description,
                           onAudioPlay: (id) => _onAudioPlay(
                             id,
                             title: name,
                             description: description,
                             imageUrl: imageUrl,
                           ),
                         ),
                       );
                     }).toList(),
                   );
                },
              ),

              SizedBox(height: 32.sp),
            ],
          ),
        ),
      ),
    );
  }
}
