import 'package:flutter/material.dart';
import 'dart:io';
import '../shared/widgets/stars_animation.dart';
import '../shared/widgets/personalized_meditation_modal.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/sleep_meditation_header.dart';
import 'components/sleep_meditation_audio_player.dart';
import 'components/sleep_meditation_control_bar.dart';
import 'components/sleep_meditation_action_buttons.dart';
import 'package:provider/provider.dart';
import '../core/stores/meditation_store.dart';
import '../core/stores/like_store.dart';
import 'generator/direct_ritual_page.dart';


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
  bool _isDragging = false;
  bool _wasPlayingBeforeDrag = false;
  String? fileUrl;

  @override
  void initState() {
    super.initState();
    _configureAudioSession();
    _loadAndPlayMeditation();
  }

  Future<void> _configureAudioSession() async {
    try {
      if (Platform.isIOS) {
        // iOS audio session configuration
      } else if (Platform.isAndroid) {
        // Android audio session configuration
      }
    } catch (e) {
      // Error configuring audio session
    }
  }

  Future<void> _loadAndPlayMeditation() async {
    try {
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );

      if (widget.meditationId != null) {
      }

      // First try to get fileUrl from store
      fileUrl = meditationStore.fileUrl;

      // If not in store, wait a bit and retry
      if (fileUrl == null || fileUrl!.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 500));
        fileUrl = meditationStore.fileUrl;
      }

      // Dispose previous audio player safely
      if (_audioPlayer != null) {
        try {
          await _audioPlayer!.stop();
        } catch (e) {
          // Ignore stop errors
        }
        
        try {
          await _audioPlayer!.dispose();
        } catch (e) {
          // Ignore dispose errors
        }
        _audioPlayer = null;
      }

      // Dispose previous waveform controller safely
      if (_waveformController != null) {
        try {
          _waveformController!.dispose();
        } catch (e) {
          // Ignore dispose errors
        }
        _waveformController = null;
      }

      // Create new instances
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();

      if (fileUrl != null && fileUrl!.isNotEmpty && _audioPlayer != null) {
        try {
          await _audioPlayer!.setUrl(fileUrl!);
        } catch (e) {
          return;
        }

        _audioPlayer!.playerStateStream.listen((state) {
          if (mounted) {
            setState(() {
              _isPlaying = state.playing;
              _isAudioReady =
                  state.processingState == just_audio.ProcessingState.ready;
            });
          }
        });

        _audioPlayer!.durationStream.listen((duration) {
          if (mounted) {
            setState(() {
              _duration = duration ?? const Duration(minutes: 3, seconds: 29);
            });
          }
        });

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

  Future<void> _initializeAudioPlayer() async {
    try {
      // Dispose previous instances if they exist
      if (_audioPlayer != null) {
        try {
          await _audioPlayer!.stop();
        } catch (e) {
          // Ignore stop errors
        }
        
        try {
          await _audioPlayer!.dispose();
        } catch (e) {
          // Ignore dispose errors
        }
        _audioPlayer = null;
      }

      if (_waveformController != null) {
        try {
          _waveformController!.dispose();
        } catch (e) {
          // Ignore dispose errors
        }
        _waveformController = null;
      }

      // Create new instances
      _audioPlayer = just_audio.AudioPlayer();
      _waveformController = PlayerController();

      // MeditationStore dan meditation profile ni olish
      final meditationStore = Provider.of<MeditationStore>(
        context,
        listen: false,
      );

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
    // Safely dispose audio player
    if (_audioPlayer != null) {
      try {
        _audioPlayer!.stop();
      } catch (e) {
        // Ignore stop errors
      }
      
      try {
        _audioPlayer!.dispose();
      } catch (e) {
        // Ignore dispose errors
      }
      _audioPlayer = null;
    }

    // Safely dispose waveform controller
    if (_waveformController != null) {
      try {
        _waveformController!.dispose();
      } catch (e) {
        // Ignore dispose errors
      }
      _waveformController = null;
    }

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
        setState(() {
          _isPlaying = false;
        });
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
        setState(() {
          _isPlaying = true;
        });
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

  void _resetMeditation() async {
    final meditationStore = context.read<MeditationStore>();
    final meditationId = meditationStore.meditationProfile?.id?.toString();
    
    print('🔄 Reset meditation - ID: $meditationId');
    print('🔄 Meditation profile: ${meditationStore.meditationProfile?.toJson()}');
    
    // Delete meditation from server if ID exists
    if (meditationId != null && meditationId.isNotEmpty) {
      print('🗑️ Deleting meditation with ID: $meditationId');
      await meditationStore.deleteMeditation(meditationId);
    } else {
      print('⚠️ No meditation ID found, just clearing local data');
      // If no ID, just clear local data
      meditationStore.completeReset();
    }
    
    // Navigate to DirectRitualPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DirectRitualPage(),
      ),
    );
  }

  void _saveToVault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirst = prefs.getBool('first') ?? false;
      
      if (isFirst) {
        // First time - go to vault and remove first flag
        await prefs.remove('first');
        // Clear navigation stack to prevent back navigation to auth pages
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/vault',
          (route) {
            // Keep only vault and dashboard routes, remove auth pages
            return route.settings.name == '/vault' || 
                   route.settings.name == '/dashboard' ||
                   route.settings.name == '/my-meditations' ||
                   route.settings.name == '/archive' ||
                   route.settings.name == '/generator';
          }
        );
      } else {
        // Not first time - go to dashboard
        // Clear navigation stack to prevent back navigation to auth pages
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/dashboard',
          (route) {
            // Keep only dashboard and its sub-routes, remove auth pages
            return route.settings.name == '/dashboard' || 
                   route.settings.name == '/my-meditations' ||
                   route.settings.name == '/archive' ||
                   route.settings.name == '/vault' ||
                   route.settings.name == '/generator';
          }
        );
      }
    } catch (e) {
      // Error handling - default to dashboard with cleared stack
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/dashboard',
        (route) {
          // Keep only dashboard and its sub-routes, remove auth pages
          return route.settings.name == '/dashboard' || 
                 route.settings.name == '/my-meditations' ||
                 route.settings.name == '/archive' ||
                 route.settings.name == '/vault' ||
                 route.settings.name == '/generator';
        }
      );
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Clear navigation stack to prevent back navigation to auth pages
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/dashboard',
            (route) {
              // Keep only dashboard and its sub-routes, remove auth pages
              return route.settings.name == '/dashboard' || 
                     route.settings.name == '/my-meditations' ||
                     route.settings.name == '/archive' ||
                     route.settings.name == '/vault' ||
                     route.settings.name == '/generator';
            }
          );
        }
      },
      child: Scaffold(
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
                                   // If this is the first change during drag, pause audio
                                   if (!_isDragging && _isPlaying) {
                                     await _audioPlayer?.pause();
                                     setState(() {
                                       _isDragging = true;
                                       _wasPlayingBeforeDrag = true;
                                     });
                                   }
                                   
                                   final newPosition = Duration(
                                     seconds: value.toInt(),
                                   );
                                   await _audioPlayer?.seek(newPosition);
                                   setState(() {
                                     _position = newPosition;
                                   });
                                 },
                                                                 onChangeStart: (value) {
                                   setState(() {
                                     _isDragging = true;
                                     _wasPlayingBeforeDrag = _isPlaying;
                                   });
                                   // Pause audio while seeking
                                   if (_isPlaying) {
                                     _audioPlayer?.pause();
                                   }
                                 },
                                                                 onChangeEnd: (value) async {
                                   setState(() {
                                     _isDragging = false;
                                   });
                                   // Resume audio after seeking if it was playing before drag
                                   if (_wasPlayingBeforeDrag) {
                                     await _audioPlayer?.play();
                                     // The audio player state listener will update _isPlaying automatically
                                   }
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
      ),
    );
  }
}
