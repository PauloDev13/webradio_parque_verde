import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

// Imports locais
import '../components/background_container.dart';
import '../components/button_social_media.dart';
import '../components/load_spinner.dart';
import '../components/view_data.dart';
import '../constants.dart';
import '../utils/radio_service.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage>
    with WidgetsBindingObserver {
  // variáveis locais
  final AudioPlayer player = AudioPlayer();
  late WaveformController _waveController;
  late final RadioService radioService = RadioService(player: player);
  String? _coverUrl;
  String? _lastSong;

  @override
  void initState() {
    super.initState();
    // coloca a instância da RadioPlayerPage no observer
    WidgetsBinding.instance.addObserver(this);
    _waveController = WaveformController();
    //iniciar o player
    radioService.startRadio();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      radioService.stop();
    }
  }

  @override
  void dispose() {
    // remove a instancia da RadioPlayerPage do observer
    WidgetsBinding.instance.removeObserver(this);
    // para o player se o aplicativo for fechado
    () async {
      await radioService.stop();
    }();
    // destrói a instancia do player
    player.dispose();
    // destrói a instancia do waveform
    _waveController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001a2c),
      appBar: AppBar(
        title: Text(
          'Web Rádio',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            fontFamily: 'Michroma',
            color: kColor3,
          ),
        ),
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
                      padding: EdgeInsets.only(top: 170),
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
                return Padding(
                  padding: EdgeInsets.only(top: 220),
                  child: Column(
                    children: [
                      Text('Erro conectar à rádio', style: kErroConexaoStyle),
                      BackgroundContainer(
                        padding: EdgeInsets.only(top: 10),
                        child: ButtonSocialMedia(
                          onPressed: radioService.startRadio,
                          icon: FontAwesomeIcons.connectdevelop,
                          iconColor: kColor2,
                          borderColor: kColorBorderButton,
                          labelColor: kColor2,
                          label: 'Conectar',
                          iconSize: 30,
                        ),
                      ),
                    ],
                  ),
                );
              } // fim if
            }, // Builder
          ),
        ),
      ),
    );
  }
}
