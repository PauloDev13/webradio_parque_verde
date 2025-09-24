import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webradio_parque_verde/components/erro_dialog_connection.dart';

import '../components/background_container.dart';
import '../components/load_spinner.dart';
import '../components/view_data.dart';
import '../constants.dart';
// Imports locais
import '../main.dart';
import '../utils/radio_service.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage>
    with WidgetsBindingObserver {
  // variáveis locais
  String? _coverUrl;
  String? _lastSong;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    // coloca a instância da RadioPlayerPage no observer
    WidgetsBinding.instance.addObserver(this);
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
    radioService.stop();
    // destrói a instancia do waveform
    super.dispose();
  }

  // Atualiza a capa do álbum quando a música muda
  Future<void> _updateCover({
    required String artist,
    required String song,
  }) async {
    if (_lastSong != song) {
      // final newCover = await radioService.fetchCover();
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
        title: const Text(
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
              alignment: Alignment.topCenter,
            ),
          ),
          child: StreamBuilder<RadioStatus>(
            stream: radioService.statusStream,
            builder: (context, snapshot) {
              final status = snapshot.data ?? RadioStatus.idle;
              final player = radioService.player;

              if (status == RadioStatus.ready) {
                return StreamBuilder<IcyMetadata?>(
                  stream: player.icyMetadataStream,
                  builder: (context, snapshot) {
                    // variáveis locais
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

                    if (rawTitle.isNotEmpty && playing) {
                      // chama função que retorna a capa do álbum da música em
                      // execução
                      _updateCover(artist: artist, song: song);
                    } else {
                      _updateCover(artist: 'Web Rádio', song: 'Parque Verde');
                    } // fim if
                    // Retorna o Widget customizado que exibe a capa, o nome
                    // do artista, o nome da música e o botão player/stop
                    return BackgroundContainer(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: ViewData(
                          radioService: radioService,
                          coverUrl: _coverUrl,
                          artist: artist,
                          song: song,
                        ),
                      ),
                    );
                  }, //Builder
                );
              } // fim if
              else if (status == RadioStatus.loading) {
                return const LoadSpinner(padding: EdgeInsets.only(top: 210));
              } // fim if
              else if (status == RadioStatus.error && !_dialogOpen) {
                _dialogOpen = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return ErroDialogConnection(
                        onRetry: () {
                          radioService.startRadio();
                          _dialogOpen = false;
                          Navigator.of(dialogContext).pop();
                        },
                      );
                    },
                  ).then((_) => _dialogOpen = false);
                }); // WidgetsBinding
              } // fim if
              else if (status == RadioStatus.completed &&
                  !_dialogOpen &&
                  player.playing) {
                _dialogOpen = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return ErroDialogConnection(
                        onRetry: () {
                          radioService.startRadio();
                          _dialogOpen = false;
                          Navigator.of(dialogContext).pop();
                        },
                      );
                    },
                  ).then((_) => _dialogOpen = false);
                }); // WidgetsBinding
              }
              // deixa o spinner ativo por trás do dialog de erro
              return const LoadSpinner(padding: EdgeInsets.only(top: 210));
            }, // Builder
          ),
        ),
      ),
    );
  }
}
