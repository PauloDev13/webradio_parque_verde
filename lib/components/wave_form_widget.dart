import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/flutter_audio_visualizer.dart';
import 'package:webradio_parque_verde/constants.dart';

class WaveFormWidget extends StatelessWidget {
  const WaveFormWidget({super.key, required this.playing});
  final bool playing;

  @override
  Widget build(BuildContext context) {
    AudioVisualizer audio = AudioVisualizer(
      audioSource: AudioPlayerSource(),
      visualizationType: VisualizationType.spectrum,
      height: 70,
      style: AudioVisualizerStyle(
        waveformColor: Colors.blue,
        backgroundColor: Colors.transparent,
        barWidth: 2.6,
        barSpacing: 1.0,
        animationDuration: Duration(milliseconds: 50),
        gradient: LinearGradient(
          colors: [kColor3, kColor2],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );

    if (playing) {
      audio.audioSource?.start();
      return Center(child: audio);
    } else {
      audio.audioSource?.stop();
      return SizedBox(height: 140);
    }
  }
}
