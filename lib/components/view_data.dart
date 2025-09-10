import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

import 'button_play_stop.dart';
import 'text_info.dart';
import 'wave_controller.dart';
import '../utils/radio_service.dart';

import '../constants.dart';
import 'cover_image.dart';


class ViewData extends StatelessWidget {
  const ViewData({
    super.key,
    required this.player,
    required WaveformController waveController,
    required this.radioService,
    required String? coverUrl,
    required this.artist,
    required this.song,
  }) : _waveController = waveController,
       _coverUrl = coverUrl;

  final AudioPlayer player;
  final WaveformController _waveController;
  final RadioService radioService;
  final String? _coverUrl;
  final String artist;
  final String song;

  @override
  Widget build(BuildContext context) {
    final bool playing = player.playing;

    if (playing && artist.isNotEmpty && _coverUrl != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: player.playingStream,
                  initialData: player.playing,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;

                    // Chama no retorno o widget WaveForm customizado
                    return WaveForm(
                      waveController: _waveController,
                      playing: playing,
                    );
                  },
                ),

                Cover(coverUrl: _coverUrl),

              ],
            ),

            TextInfo(metadata: artist, textStyle: kArtistTextStyle),
            TextInfo(metadata: song, textStyle: kASongTextStyle),

            SizedBox(height: 10),

            PlayPauseButton(
              playingStream: player.playingStream,
              backgroundColor: kColor3,
              borderColor: kColorBorderButton,
              initialPlaying: player.playing,
              onPressed: radioService.togglePlayPause,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 50,
        child: Text(
          'Conectando...',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      );
    }
  }
}
