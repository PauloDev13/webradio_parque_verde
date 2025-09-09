import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

// Imports locais
import '../components/button_play_stop.dart';
import '../components/cover_image2.dart';
import '../components/cover_image.dart';
import '../components/text_info.dart';
import '../components/wave_controller.dart';
import '../constants.dart';
import '../utils/radio_service.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  final AudioPlayer player = AudioPlayer();
  final String streamUrl = kUrlServer;
  late WaveformController _waveController;
  // late RadioService radioService = RadioService(
  //   player: player,
  //   streamUrl: streamUrl,
  // );
  late RadioService radioService;

  String? _coverUrl;
  String? _lastSong;

  @override
  void initState() {
    super.initState();
    radioService = RadioService(player: player, streamUrl: streamUrl);
    _waveController = WaveformController();
    // Chama startRadio da classe auxiliar radio_service
    radioService.startRadio();
  }

  // Atualiza a capa de álbum sempre que a música mudar
  Future<void> _updateCover(String currentSong) async {
    if (_lastSong != currentSong) {
      final newCover = await radioService.fetchCover();

      setState(() {
        _coverUrl = newCover;
        _lastSong = currentSong;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001a2c),
      appBar: AppBar(
        title: Text('Radio Web', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        backgroundColor: kColor2,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(top: 150),
          child: Column(
            children: <Widget>[
              StreamBuilder<IcyMetadata?>(
                stream: player.icyMetadataStream,
                builder: (context, snapshot) {
                  final icy = snapshot.data;

                  final rawTitle = icy?.info?.title ?? '';
                  final parts = rawTitle.split(' - ');
                  final artist = parts.isNotEmpty
                      ? parts.first.trim()
                      : 'Desconhecido';
                  final nameSong = parts.sublist(1).join(' - ').trim();
                  // Chama função limpaTitulo da classe auxiliar radio_service
                  final song = parts.length > 1
                      ? radioService.limparTitulo(nameSong)
                      : 'Desconhecido';

                  if (rawTitle.isNotEmpty) {
                    // chama função que retorna a url com
                    _updateCover(rawTitle);
                  }

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

                            if (_coverUrl != null &&
                                _coverUrl!.isNotEmpty &&
                                artist.isNotEmpty) ...[
                              // Chama o widget que exite a imagem dos álbuns
                              Cover(coverUrl: _coverUrl),
                            ] else ...[
                              Cover2(),
                            ], // If...Else
                          ],
                        ),

                        TextInfo(metadata: artist, textStyle: kArtistTextStyle),
                        TextInfo(metadata: song, textStyle: kASongTextStyle),
                      ],
                    ),
                  );
                }, //Builder
              ),

              SizedBox(height: 10),

              PlayPauseButton(
                playingStream: player.playingStream,
                backgroundColor: kColor3,
                borderColor: kColorBorderButton,
                initialPlaying: player.playing,
                onPressed: radioService.togglePlayPause,
                // onPressed: _togglePlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
