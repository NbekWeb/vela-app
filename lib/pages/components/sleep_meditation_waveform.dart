import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class SleepMeditationWaveform extends StatelessWidget {
  final bool waveformReady;
  final PlayerController? waveformController;

  const SleepMeditationWaveform({
    super.key,
    required this.waveformReady,
    this.waveformController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: waveformReady && waveformController != null
          ? AudioFileWaveforms(
              size: const Size(double.infinity, 56),
              playerController: waveformController!,
              waveformType: WaveformType.fitWidth,
              enableSeekGesture: true,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.white38,
                liveWaveColor: Colors.white,
                spacing: 2,
                showSeekLine: true,
                waveThickness: 4,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
