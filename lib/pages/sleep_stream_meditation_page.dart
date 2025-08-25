import 'package:flutter/material.dart';
import 'dart:io';
import '../shared/widgets/stars_animation.dart';
import '../shared/widgets/personalized_meditation_modal.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_session/audio_session.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/sleep_meditation_header.dart';
import 'components/sleep_meditation_audio_player.dart';
import 'components/sleep_meditation_control_bar.dart';
import 'components/sleep_meditation_action_buttons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../core/stores/meditation_store.dart';
import '../core/stores/like_store.dart';
import 'generator/direct_ritual_page.dart';

final _secureStorage = FlutterSecureStorage();

class SleepStreamMeditationPage extends StatefulWidget {
  final String? meditationId;
  final bool isDirectRitual;

  const SleepStreamMeditationPage({
    super.key, 
    this.meditationId,
    this.isDirectRitual = false,
  });

  @override
  State<SleepStreamMeditationPage> createState() =>
      _SleepStreamMeditationPageState();
}

class _SleepStreamMeditationPageState extends State<SleepStreamMeditationPage> {
  just_audio.AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isAudioReady = false;
  PlayerController? _waveformController;
  bool _waveformReady = false;
  Duration _duration = const Duration(minutes: 3, seconds: 29);
  Duration _position = Duration.zero;
  bool _isLiked = false;
  bool _isMuted = false;
  String? fileUrl;

  @override
  void initState() {
    super.initState();
    _configureAudioSession();
    _loadAndPlayMeditation();
  }

  Future<void> _configureAudioSession() async {
    try {
      // iOS uchun audio session configuration
      if (Platform.isIOS) {
        // iOS specific audio configuration
        debugPrint('Configuring iOS audio session...');
      }
    } catch (e) {
      debugPrint('Error configuring audio session: $e');
    }
  }

  Future<void> _loadAndPlayMeditation() async {
    try {
      debugPrint('Loading meditation audio...');

      // MeditationStore dan meditation profile ni olish
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      final profileData = meditationStore.meditationProfile;

      // Agar meditationId berilgan bo'lsa, uni ishlat
      if (widget.meditationId != null) {
        debugPrint('Using provided meditationId: ${widget.meditationId}');
        // Bu yerda meditationId bo'yicha meditation ni yuklash logikasi bo'lishi kerak
        // Hozircha store dan olishni davom ettiramiz
      }

      fileUrl = meditationStore.fileUrl;
      debugPrint('Got fileUrl from store: $fileUrl');

      // Agar fileUrl null bo'lsa, qisqa kutish va qayta urinish
      if (fileUrl == null || fileUrl!.isEmpty) {
        debugPrint('FileUrl is null, waiting a bit and retrying...');
        await Future.delayed(const Duration(milliseconds: 500));
        fileUrl = meditationStore.fileUrl;
        debugPrint('Retried fileUrl from store: $fileUrl');
      }

      // Dispose previous audio player if exists
      await _audioPlayer?.dispose();
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();

      if (fileUrl != null && fileUrl!.isNotEmpty) {
        debugPrint('Setting audio URL: $fileUrl');
        await _audioPlayer!.setUrl(fileUrl!);
        debugPrint('Audio URL set successfully');

        // Listen to player state changes
        _audioPlayer!.playerStateStream.listen((state) {
          debugPrint(
            'Player state: ${state.processingState} - playing: ${state.playing}',
          );
          if (mounted) {
            setState(() {
              _isPlaying = state.playing;
              _isAudioReady =
                  state.processingState == just_audio.ProcessingState.ready;
            });
          }
        });

        // Listen to duration changes
        _audioPlayer!.durationStream.listen((duration) {
          debugPrint('Duration: $duration');
          if (mounted) {
            setState(() {
              _duration = duration ?? const Duration(minutes: 3, seconds: 29);
            });
          }
        });

        // Listen to position changes
        _audioPlayer!.positionStream.listen((position) {
          if (mounted) {
            setState(() {
              _position = position;
            });
          }
        });

        setState(() {
          _isAudioReady = true;
        });

        debugPrint('Audio player initialized successfully');

        // Prepare waveform after audio player is ready
        await _prepareWaveform();
      } else {
        debugPrint(
          'No fileUrl available from store: ${meditationStore.fileUrl}',
        );
        setState(() {
          _isAudioReady = true;
        });
      }
    } catch (e) {
      debugPrint('Error in _loadAndPlayMeditation: $e');
      setState(() {
        _isAudioReady = true;
      });
    }
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();

      // MeditationStore dan meditation profile ni olish
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );
      final profileData = meditationStore.meditationProfile;

      String? audioFileUrl = meditationStore.fileUrl;

      // Agar audioFileUrl null bo'lsa, qisqa kutish va qayta urinish
      if (audioFileUrl == null || audioFileUrl.isEmpty) {
        debugPrint('AudioFileUrl is null, waiting a bit and retrying...');
        await Future.delayed(const Duration(milliseconds: 500));
        audioFileUrl = meditationStore.fileUrl;
        debugPrint('Retried audioFileUrl from store: $audioFileUrl');
      }

      if (audioFileUrl != null && audioFileUrl.isNotEmpty) {
        await _audioPlayer!.setUrl(audioFileUrl);

        // Listen to player state changes
        _audioPlayer!.playerStateStream.listen((state) {
          if (mounted) {
            setState(() {
              _isPlaying = state.playing;
              _isAudioReady =
                  state.processingState == just_audio.ProcessingState.ready;
            });
          }
        });

        // Listen to duration changes
        _audioPlayer!.durationStream.listen((duration) {
          if (mounted) {
            setState(() {
              _duration = duration ?? const Duration(minutes: 3, seconds: 29);
            });
          }
        });

        // Listen to position changes
        _audioPlayer!.positionStream.listen((position) {
          if (mounted) {
            setState(() {
              _position = position;
            });
          }
        });

        setState(() {
          _isAudioReady = true;
        });

        // Prepare waveform after audio player is ready
        await _prepareWaveform();
      } else {
        setState(() {
          _isAudioReady = true;
        });
      }
    } catch (e) {
      setState(() {
        _isAudioReady = true;
      });
    }
  }

  Future<void> _prepareWaveform() async {
    try {
      if (_waveformController != null) {
        await _waveformController!.preparePlayer(
          path: fileUrl ?? '', // Use fileUrl here
          shouldExtractWaveform: true,
          noOfSamples: 80,
        );

        if (mounted) {
          setState(() {
            _waveformReady = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error preparing waveform: $e');
      // Continue without waveform if it fails
    }
  }

  @override
  void dispose() {
    _audioPlayer?.stop();
    _audioPlayer?.dispose();
    _waveformController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (_audioPlayer == null) {
        await _initializeAudioPlayer();
        return;
      }

      if (_isPlaying) {
        await _audioPlayer!.pause();
        if (_waveformReady && _waveformController != null) {
          try {
            _waveformController!.pausePlayer();
          } catch (e) {
            debugPrint('Error pausing waveform: $e');
          }
        }
      } else {
        if (!_isAudioReady) {
          await _audioPlayer!.setUrl(fileUrl!);
          setState(() {
            _isAudioReady = true;
            _duration = const Duration(minutes: 3, seconds: 29);
          });
        }

        await _audioPlayer!.play();
        if (_waveformReady && _waveformController != null) {
          try {
            _waveformController!.startPlayer();
          } catch (e) {
            debugPrint('Error starting waveform: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error toggling play/pause: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer?.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _toggleLike() async {
    final meditationStore = context.read<MeditationStore>();
    final likeStore = context.read<LikeStore>();

    // Get meditation ID from ritual data
    final meditationId = meditationStore.meditationProfile?.ritual?['id']
        ?.toString();

    if (meditationId != null) {
      await likeStore.toggleLike(meditationId);
      setState(() {
        _isLiked = likeStore.isLiked(meditationId);
      });
    } else {
      // Fallback to local state if no meditation ID
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  void _shareMeditation() async {
    await Share.share('Vela - Navigate fron Within. https://myvela.ai/');
  }

  void _resetMeditation() {
    // Complete reset of meditation store
    context.read<MeditationStore>().completeReset();
    
    // Agar isDirectRitual true bo'lsa, DirectRitualPage ga o't
    if (widget.isDirectRitual) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DirectRitualPage(),
        ),
      );
    } else {
      // Aks holda generator page ga o't
      Navigator.pushReplacementNamed(context, '/generator');
    }
  }

  void _saveToVault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirst = prefs.getBool('first') ?? false;
      
      if (isFirst) {
        // First time - go to vault and remove first flag
        await prefs.remove('first');
        Navigator.pushReplacementNamed(context, '/vault');
      } else {
        // Not first time - go to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      // Error handling - default to dashboard
      print('Error checking first flag: $e');
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _showPersonalizedMeditationInfo() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const PersonalizedMeditationModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(204), // 0.8 * 255 ≈ 204
      body: Stack(
        children: [
          const StarsAnimation(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SleepMeditationHeader(
                            onBackPressed: () => Navigator.of(context).pop(),
                            onInfoPressed: _showPersonalizedMeditationInfo,
                          ),
                          Consumer<MeditationStore>(
                            builder: (context, meditationStore, child) {
                              return SleepMeditationAudioPlayer(
                                isPlaying: _isPlaying,
                                onPlayPausePressed: _togglePlayPause,
                                profileData: meditationStore.meditationProfile,
                              );
                            },
                          ),
                          const SizedBox(height:0),
                          SleepMeditationControlBar(
                            isMuted: _isMuted,
                            isLiked: _isLiked,
                            onMuteToggle: _toggleMute,
                            onLikeToggle: _toggleLike,
                            onShare: _shareMeditation,
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: [
                              Slider(
                                value: _position.inSeconds.toDouble().clamp(
                                  0,
                                  _duration.inSeconds.toDouble(),
                                ),
                                min: 0,
                                max: _duration.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  final newPosition = Duration(
                                    seconds: value.toInt(),
                                  );
                                  await _audioPlayer?.seek(newPosition);
                                  setState(() {
                                    _position = newPosition;
                                  });
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.white.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons outside scroll
                  SleepMeditationActionButtons(
                    onResetPressed: _resetMeditation,
                    onSavePressed: _saveToVault,
                    isDirectRitual: widget.isDirectRitual,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
