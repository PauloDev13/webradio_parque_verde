import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '/components/cover_image.dart';
import '/components/loading_json.dart';

class StackPhonesCoverWaveform extends StatelessWidget {
  const StackPhonesCoverWaveform({
    super.key,
    required String coverUrl,
    required AudioPlayer player,
    required bool status,
  }) : _coverUrl = coverUrl,
       _player = player,
       _status = status;
  final String _coverUrl;
  final AudioPlayer _player;
  final bool _status;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double verticalOffSet = screenHeight * .02;
    return Stack(
      alignment: Alignment.center,
      children: [
        // HeadphonesImage(),
        Transform.translate(
          offset: Offset(0, verticalOffSet),
          child: Visibility(
            visible: _status,
            replacement: LoadingJson(status: _status),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Cover(coverUrl: _coverUrl),
                // AnimatedWaveform(player: _player),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
