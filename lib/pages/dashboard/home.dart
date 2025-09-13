import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:card_swiper/card_swiper.dart';
import '../vault/vault_ritual_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/custom_star.dart';
import '../../shared/widgets/info_dashboard_modal.dart';
import '../../shared/widgets/show_check_in_modal.dart';
import '../dashboard/my_meditations_page.dart';
import '../dashboard/archive_page.dart';
import '../generator/direct_ritual_page.dart';
import '../../core/stores/auth_store.dart';
import '../../core/stores/meditation_store.dart';
import '../dashboard/components/dashboard_audio_player.dart';
import 'main.dart';
import '../../main.dart' show shouldNavigateToProfile;

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  bool _hasShownCheckInModal = false;
  VideoPlayerController? _videoController;
  
  // Check if modal was shown today using SharedPreferences
  Future<bool> _hasShownModalToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final savedDate = prefs.getString('check_in_modal_date');
    return savedDate == todayString;
  }

  // Mark modal as shown today
  Future<void> _markModalAsShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await prefs.setString('check_in_modal_date', todayString);
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    _loadMeditationData();
    _initializeVideoController();
  }

  Future<bool> _shouldShowCheckInModal() async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final user = authStore.user;

    if (user == null || _hasShownCheckInModal) {
      return false;
    }

    // If user has check-ins, it means they checked in today - don't show modal
    if (!user.checkIns.isEmpty) {
      return false;
    }

    // Check if user has already checked in today
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final hasCheckedInToday = user.checkIns.any((checkIn) {
      // Parse the check-in date and compare with today
      try {
        final checkInDate = DateTime.parse(checkIn.checkInDate);
        final checkInDateString = '${checkInDate.year}-${checkInDate.month.toString().padLeft(2, '0')}-${checkInDate.day.toString().padLeft(2, '0')}';
        return checkInDateString == todayString;
      } catch (e) {
        // If date parsing fails, fall back to string comparison
        return checkIn.checkInDate.contains(todayString);
      }
    });

    // Show modal if user has check-ins but hasn't checked in today
    return !hasCheckedInToday;
  }

  Future<void> _showCheckInModalIfNeeded() async {
    // Check if modal was already shown today using localStorage
    final hasShownToday = await _hasShownModalToday();
    if (hasShownToday) {
      return;
    }
    
    final shouldShow = await _shouldShowCheckInModal();
    
    if (shouldShow) {
      // Mark modal as shown today in localStorage
      await _markModalAsShownToday();
      
      // Add a small delay to ensure the page is fully loaded
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          showCheckInModal(context);
        }
      });
    }
  }



  Future<void> _getUserDetails() async {
    // Use Provider to access AuthStore
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      await authStore.getUserDetails();
      
      // Show check-in modal after user details are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showCheckInModalIfNeeded();
      });
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
    return Scaffold(
      backgroundColor: const Color(0xFF5398DA),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Video background that scrolls with content
            _buildVideoBackground(),
            
            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.sp, // left
                MediaQuery.of(context).padding.top + 8, // top
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return const InfoDashboardModal();
                            },
                          );
                        },
                        child: Container(
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
                      ),
                      Image.asset(
                        'assets/img/logo.png',
                        width: 60,
                        height: 39,
                      ),
                      // Avatar on the right, size 30x30
                      GestureDetector(
                        onTap: () {
                          // Navigate to profile tab using dashboard navigation
                          final dashboardState = context.findAncestorStateOfType<DashboardMainPageState>();
                          if (dashboardState != null) {
                            dashboardState.navigateToProfile();
                          } else {
                            // Fallback: use global flag
                            shouldNavigateToProfile = true;
                          }
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
                        fontFamily: "Satoshi",
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
                   final meditationCount = myMeditations?.length ?? 0;
                   
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

                  return SizedBox(
                    height: 100,
                    child: Swiper(
                      itemCount: meditationCount ,
                      loop: false,
                      itemBuilder: (context, index) {
                        final meditation = myMeditations[index];
                        final details = meditation['details'] ?? {};
                        final name = details['name'] ?? 'Untitled';
                        final meditationId = meditation['id']?.toString() ?? '';
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: VaultRitualCard(
                            name: name,
                            meditationId: meditationId,
                            file: meditation['file'],
                            onAudioPlay: _onAudioPlay,
                          ),
                        );
                      },
                      viewportFraction: 1,
                      scale: 1,
                    ),
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
                              fontFamily: "Satoshi",
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
                   final libraryCount = libraryMeditations?.length ?? 0;
                   
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

                  return SizedBox(
                    height: 100,
                    child: Swiper(
                      itemCount:  libraryCount,
                      loop: false,
                      itemBuilder: (context, index) {
                        final meditation = libraryMeditations[index];
                        final name = meditation['name'] ?? 'Untitled';
                        final meditationId = meditation['id']?.toString() ?? '';
                        final imageUrl = meditation['image'];
                        final description = meditation['description'];
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      },
                      viewportFraction: 1,
                      scale: 1,
                    ),
                  );
                },
              ),

              SizedBox(height: 32.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeVideoController() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/2.mp4');
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(0.0); // Mute the video
      _videoController!.play();
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Widget _buildVideoBackground() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const SizedBox.shrink();
    }
    
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Positioned(
      top: -40,
      left: 0,
      right: 0,
      height: screenHeight + 270, // 100vh + 300px
      child: Column(
        children: [
          // Video section - 100vh
          SizedBox(
            height: screenHeight,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),
          // Red background section - 300px
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              height: 270,
              width: double.infinity,
              color: const Color(0xFF5799D6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
