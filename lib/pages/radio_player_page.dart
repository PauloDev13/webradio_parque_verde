import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/animated_dialog_error.dart';

import '/components/view_data.dart';
// Imports locais
import '/constants.dart';
import '/main.dart';
import '/utils/radio_service.dart';

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage>
    with WidgetsBindingObserver {
  // variáveis locais
  String _coverUrl = kUrlCloudinaryLogo;
  String? _lastSong;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    radioService.lastMediaItem;
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
      var newCover = await radioService.fetchCoverItunes(artist, song);
      // se o nome do artista começa com "Paulo", exibe a foto do locutor
      // se não, exibe a capa do álbum
      setState(() {
        artist.startsWith('Paulo')
            ? newCover = kUrlCloudinaryLocucao
            : newCover;
        artist.startsWith('Web') ||
                song.startsWith('Hora') ||
                song.startsWith('Minuto')
            ? newCover = kUrlCloudinaryLogo
            : newCover;
        _coverUrl = newCover;
        _lastSong = song;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF001a2c),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(
            top: size.width * .01,
            right: size.width * .05,
            left: size.width * .05,
          ),
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(kBackgroundImg),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: StreamBuilder<RadioStatus>(
            stream: radioService.statusStream,
            builder: (context, snapshot) {
              final status = snapshot.data ?? RadioStatus.idle;
              // se o player está com status ready, exibe a capa do álgum,
              //  o artista e o nome da música
              if (status == RadioStatus.ready) {
                // retorna o Widget que exibe os nomes do artista, música e
                // a capa do álbum em execução
                return ViewData(status: true);
              } // fim if
              // se o estatus for loading, retorna o Widget que exibe os
              // nomes do artista, música e a capa do álbum em execução
              if (status == RadioStatus.loading) {
                return ViewData(status: false);
              }
              // se o status for error, exibe um AlertDialog
              if (status == RadioStatus.error ||
                  status == RadioStatus.completed) {
                debugPrint('PROCESSANDO ESTADO NA PAGE: $status');
                if (!_dialogOpen) {
                  _dialogOpen = true;
                  // espera a tela ser construída para chamar o dialog
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showAnimatedDialog(
                      context: context,
                      dialogOpen: _dialogOpen,
                      onRetry: () {
                        radioService.startRadio();
                        _dialogOpen = false;
                        Navigator.of(context).pop();
                      },
                    ); // showAnimatedDialog
                  }); // WidgetsBinding
                  // retorna o Widget que exibe os nomes do artista, música e
                  // a capa do álbum em execução
                  return ViewData(status: false);
                } // fim if
              }
              // retorna o Widget que exibe os nomes do artista, música e
              // a capa do álbum em execução
              return ViewData(status: false);
            }, // Builder
          ),
        ),
      ),
    );
  } // fim classe Widget
}
