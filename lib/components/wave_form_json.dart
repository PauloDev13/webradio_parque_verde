import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaveFormJson extends StatelessWidget {
  final bool playing;
  const WaveFormJson({super.key, required this.playing});

  @override
  Widget build(BuildContext context) {
    // se o player está em execução, exibe waveform, senão, exibe size box vazio
    return playing
        ? Lottie.asset(
            'assets/animation/Sound voice waves.json',
            // width: 250,
            height: 240,
            alignment: Alignment.topCenter,
          )
        : const SizedBox.shrink();
  }
}
