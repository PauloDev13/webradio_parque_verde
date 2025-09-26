import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webradio_parque_verde/constants.dart';

class WaveFormJson extends StatelessWidget {
  final bool playing;
  const WaveFormJson({super.key, required this.playing});

  @override
  Widget build(BuildContext context) {
    // se o player está em execução, exibe waveform, senão, exibe size box vazio
    return playing
        ? Lottie.asset(
            kWaveFormJson,
            height: 210,
            alignment: Alignment.topCenter,
          )
        : const SizedBox.shrink();
  }
}
