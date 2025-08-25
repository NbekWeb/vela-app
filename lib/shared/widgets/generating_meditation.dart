import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'stars_animation.dart';
import '../../pages/sleep_stream_meditation_page.dart';
import '../../pages/dashboard/main.dart';
import '../../core/stores/meditation_store.dart';
import '../../shared/models/meditation_profile_data.dart';

class GeneratingMeditation extends StatefulWidget {
  final String title;
  final String subtitle;
  final String videoAsset;
  final double bottomPadding;
  final MeditationProfileData? profileData; // Profile ma'lumotlari
  final bool isDirectRitual;

  const GeneratingMeditation({
    super.key,
    this.title = 'Generating meditation',
    this.subtitle = 'We\'re shaping your vision\ninto a meditative journey...',
    this.videoAsset = 'assets/videos/moon.mp4',
    this.bottomPadding = 80,
    this.profileData, // Yangi parameter
    this.isDirectRitual = false,
  });

  @override
  State<GeneratingMeditation> createState() => _GeneratingMeditationState();
}

class _GeneratingMeditationState extends State<GeneratingMeditation> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isGenerating = true;
  String _statusMessage =
      'We\'re shaping your vision\ninto a meditative journey...';

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    // initState da setState chaqirish muammosini oldini olish uchun keyingi frame da ishga tushiramiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProfileGeneration();
    });
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoAsset);

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        _controller!
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _startProfileGeneration() async {
    if (widget.profileData == null) {
      _showErrorAndNavigate();
      return;
    }

    try {
      setState(() {
        _statusMessage =
            'We\'re shaping your vision\ninto a meditative journey...';
      });

      // MeditationStore ni olish - listen: false bilan olish kerak
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );

      // Force reload ritual settings from storage to ensure latest values
      await meditationStore.loadRitualSettings();

      // Storage dan ma'lumotlarni o'qish
      final storedRitualType = meditationStore.storedRitualType;
      final storedTone = meditationStore.storedTone;
      final storedDuration = meditationStore.storedDuration;

      // Auth store dan yangi ma'lumotlarni ustun qo'yish
      final ritualTypeValue = storedRitualType?.isNotEmpty == true
          ? storedRitualType!
          : (widget.profileData!.ritualType?.isNotEmpty == true
                ? widget.profileData!.ritualType!.first
                : '');
      final toneValue = storedTone?.isNotEmpty == true
          ? storedTone!
          : (widget.profileData!.tone?.isNotEmpty == true
                ? widget.profileData!.tone!.first
                : '');
      final durationValue = storedDuration?.isNotEmpty == true
          ? storedDuration!
          : (widget.profileData!.duration?.isNotEmpty == true
                ? widget.profileData!.duration!.first
                : '5');

      // Profile ma'lumotlarini API ga yuborish
      await meditationStore.postCombinedProfile(
        gender: widget.profileData!.gender ?? '',
        dream: widget.profileData!.dream?.isNotEmpty == true
            ? widget.profileData!.dream!.first
            : '',
        goals: widget.profileData!.goals?.isNotEmpty == true
            ? widget.profileData!.goals!.first
            : '',
        ageRange: widget.profileData!.ageRange ?? '',
        happiness: widget.profileData!.happiness?.isNotEmpty == true
            ? widget.profileData!.happiness!.first
            : '',
        name: widget.profileData!.name ?? '',
        description: widget.profileData!.description ?? '',
        ritualType: ritualTypeValue,
        tone: toneValue,
        voice: widget.profileData!.voice?.isNotEmpty == true
            ? widget.profileData!.voice!.first
            : 'male',
        duration: durationValue,
        planType: widget.profileData!.planType,
        isDirectRitual: widget.isDirectRitual,
      );

      // // Free trial ni assign qilish
      // setState(() {
      //   _statusMessage = 'Setting up your free trial...';
      // });

      // await authStore.assignFreeTrial();

      // Muvaffaqiyatli natija
      if (mounted) {
        setState(() {
          _isGenerating = false;
          // _statusMessage = 'Your meditation is ready!';
        });

        // Qisqa kutish va keyin o'tish
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SleepStreamMeditationPage(
                isDirectRitual: widget.isDirectRitual,
              ),
            ),
          );
        }
      }
    } catch (e) {
      _showErrorAndNavigate();
    }
  }

  void _showErrorAndNavigate() {
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _statusMessage = 'Something went wrong.\nPlease try again.';
      });

      // Toast xabarini ko'rsatish
      Fluttertoast.showToast(
        msg: 'Failed to generate meditation',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      // Xatolik xabarini ko'rsatish va keyin dashboard pagega o'tish
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const DashboardMainPage(),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        const StarsAnimation(),
        if (_isInitialized && _controller != null)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        // Gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x663B6EAA), // 40% opacity
                Color(0xE6A4C7EA),
              ],
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFFF2EFEA),
                  fontSize: 36,
                  fontFamily: 'Canela',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage, // Dinamik status xabari
                style: const TextStyle(
                  color: Color(0xFFF2EFEA),
                  fontSize: 16,
                  fontFamily: 'Satoshi',
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: widget.bottomPadding),
            ],
          ),
        ),
      ],
    );
  }
}
