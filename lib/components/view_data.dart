import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

import '../constants.dart';
import '../utils/radio_service.dart';
import 'button_play_stop.dart';
import 'cover_image.dart';
import 'text_info.dart';
import 'wave_controller.dart';

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

                  // Carrega o widget customizado WaveForm que exibe ondas
                  // de aúdio
                  return WaveForm(
                    waveController: _waveController,
                    playing: playing,
                  );
                }, // builder
              ),

              // Carrega o widget customizado Cover que exibe a capa do
              // álbum do artista que está em execução
              Cover(coverUrl: _coverUrl),
            ],
          ),

          // Carrega os widgets customizado TextInfo que exibe os nome do
          // artista e música
          TextInfo(metadata: artist, textStyle: kArtistTextStyle),
          TextInfo(metadata: song, textStyle: kASongTextStyle),

          SizedBox(height: 10),

          // Carrega o widget customizado PlayPauseButton que controla o
          // play/stop do player
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
  }
}
