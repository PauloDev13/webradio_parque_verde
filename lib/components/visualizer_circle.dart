import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webradio_parque_verde/components/radio_wave_form.dart';

class RadioVisualizerCircle extends StatelessWidget {
  final AudioPlayer player;

  const RadioVisualizerCircle({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 120,
        height: 120,
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: AnimatedGradientRadioVisualizer(
            player: player,
            barCount: 24,
            maxHeight: 100,
            gradientColors: const [
              Colors.greenAccent,
              Colors.deepPurpleAccent,
              Colors.purpleAccent,
            ],
          ),
        ),
      ),
    );
  }
}
