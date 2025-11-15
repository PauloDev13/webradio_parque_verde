import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// import locais
import '/constants.dart';

class LoadingJson extends StatelessWidget {
  final bool status;
  const LoadingJson({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // se o player está em execução, exibe waveform, senão, exibe size box vazio
    return !status
        ? Column(
            children: [
              Lottie.asset(
                kLoadingJson,
                height: 150,
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
