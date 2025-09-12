import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';
import 'package:webradio_parque_verde/components/background_container.dart';
import 'package:webradio_parque_verde/components/load_spinner.dart';

// Imports locais
import '../components/view_data.dart';
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
  late final RadioService radioService = RadioService(
    player: player,
    streamUrl: streamUrl,
  );

  String? _coverUrl;
  // String _coverUrl = kLinkLogo;
  String? _lastSong;

  @override
  void initState() {
    super.initState();
    // _coverUrl = kLinkLogo;
    _waveController = WaveformController();
    // Chama startRadio para iniciar o player
    radioService.startRadio();
  }

  // Atualiza a capa do álbum quando a música muda
  Future<void> _updateCover({
    required String artist,
    required String song,
    required bool playing,
  }) async {
    if (_lastSong != song) {
      final newCover = await radioService.fetchCoverItunes(artist, song);

      setState(() {
        _coverUrl = newCover;
        _lastSong = song;
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder<RadioStatus>(
            stream: radioService.statusStream,
            builder: (context, snapshot) {
              final status = snapshot.data ?? RadioStatus.idle;

              if (status == RadioStatus.ready) {
                return StreamBuilder<IcyMetadata?>(
                  stream: player.icyMetadataStream,
                  builder: (context, snapshot) {
                    final icy = snapshot.data;

                    final playing = player.playing;
                    final rawTitle = icy?.info?.title ?? '';
                    final parts = rawTitle.split(' - ');
                    final artist = parts.isNotEmpty
                        ? parts.first.trim()
                        : 'Sem informação';
                    final nameSong = parts.sublist(1).join(' - ').trim();
                    // Chama função limpaTitulo da classe auxiliar radio_service
                    final song = parts.length > 1
                        ? radioService.limparTitulo(nameSong)
                        : 'Sem informação...';

                    if (rawTitle.isNotEmpty || playing) {
                      // chama função que retorna a url com
                      _updateCover(
                        artist: artist,
                        song: song,
                        playing: playing,
                      );
                    }
                    // Retorna o Widget customizado que exibe a capa, o nome
                    // do artista, o nome da música e o botão player/stop
                    return BackgroundContainer(
                      padding: EdgeInsets.only(top: 150),
                      child: ViewData(
                        player: player,
                        waveController: _waveController,
                        radioService: radioService,
                        coverUrl: _coverUrl,
                        artist: artist,
                        song: song,
                      ),
                    );
                  }, //Builder
                );
              } else if (status == RadioStatus.loading) {
                return LoadSpinner(padding: EdgeInsets.only(top: 210));
              } else if (status == RadioStatus.error) {
                return BackgroundContainer(
                  padding: EdgeInsets.only(top: 210),
                  child: Text(
                    'Erro conectar à rádio',
                    style: kErroConexaoStyle,
                  ),
                );
              } else {
                return LoadSpinner(padding: EdgeInsets.only(top: 210));
              } // fim if
            }, // Builder
          ),
        ),
      ),
    );
  }
}
