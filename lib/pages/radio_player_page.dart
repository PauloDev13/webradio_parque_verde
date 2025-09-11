import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

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
    _coverUrl = kLinkLogo2;
    _waveController = WaveformController();
    // Chama startRadio da classe auxiliar radio_service
    radioService.startRadio();
  }

  // Atualiza a capa de álbum sempre que a música mudar
  Future<void> _updateCover(String currentSong, bool playing) async {
    if (_lastSong != currentSong || playing) {
      final newCover = await radioService.fetchCover();

      setState(() {
        _coverUrl = newCover ?? kLinkLogo2;
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
      body: StreamBuilder<RadioStatus>(
        stream: radioService.statusStream,
        builder: (context, snapshot) {
          final status = snapshot.data ?? RadioStatus.idle;

          if (status == RadioStatus.ready) {
            return Center(
              child: Container(
                width: double.infinity,
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

                        final playing = player.playing;
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

                        if (rawTitle.isNotEmpty || playing) {
                          // chama função que retorna a url com
                          _updateCover(rawTitle, playing);
                        }
                        // Retorna o Widget customizado
                        return ViewData(
                          player: player,
                          waveController: _waveController,
                          radioService: radioService,
                          coverUrl: _coverUrl,
                          artist: artist,
                          song: song,
                        );
                      }, //Builder
                    ),
                  ],
                ),
              ),
            );
          } else if (status == RadioStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: kColor2),
            );
          } else if (status == RadioStatus.error) {
            return const Center(
              child: Text(
                'Erro conectar à rádio',
                style: TextStyle(fontSize: 20, color: kColor2),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Erro conectar à rádio',
                style: TextStyle(fontSize: 20, color: kColor2),
              ),
            );
          } // fim if
        }, // Builder
      ),
    );
  }
}
