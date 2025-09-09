import 'package:flutter/material.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

class WaveForm extends StatelessWidget {
  const WaveForm({
    super.key,
    required WaveformController waveController,
    required this.playing,
  }) : _waveController = waveController;

  final WaveformController _waveController;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    if (playing) {
      _waveController.start();
      return WaveformWidget(
        controller: _waveController,
        height: 170,
        width: 230,
        style: WaveformStyle(
          waveformStyle: WaveformDrawStyle.bars,
          waveColor: Color(0xFF03ebff),
          backgroundColor: Color(0x00ff5722),
          barCount: 18,
          barSpacing: 2.0,
          strokeWidth: 2.0,
          showGradient: true,
          gradientBegin: Alignment.topCenter,
          gradientEnd: Alignment.bottomCenter,
          animationDuration: playing ? Duration(seconds: 1) : Duration.zero,
        ),
      );
    } else {
      _waveController.stop();
      return SizedBox(height: 170);
    }
  }
}
