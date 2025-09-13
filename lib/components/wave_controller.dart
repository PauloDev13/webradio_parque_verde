import 'package:flutter/material.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';
import 'package:webradio_parque_verde/constants.dart';

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
          waveColor: kColor2,
          backgroundColor: Colors.transparent,
          barCount: 40,
          barSpacing: 1.0,
          strokeWidth: 1.0,
          showGradient: false,
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
