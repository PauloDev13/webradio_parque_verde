import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webradio_parque_verde/components/view_data_2.dart';

// Imports locais
import '../components/animated_dialog_error.dart';
import '../components/load_spinner.dart';
import '../constants.dart';
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
  String _coverUrl = kUrlFallback;
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
      var newCover = await radioService.fetchCoverItunes(artist, song);

      // se o nome do artista começa com "Paulo", exibe a foto do locutor
      // se não, exibe a capa do álbum
      artist.startsWith('Paulo') ? newCover = kLocucaoImg : newCover;

      setState(() {
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
          padding: EdgeInsets.only(
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
              final player = radioService.player;

              // se o player está com status ready, exibe a capa do álgum,
              //  o artista e o nome da música
              if (status == RadioStatus.ready) {
                return StreamBuilder<IcyMetadata?>(
                  stream: player.icyMetadataStream,
                  builder: (context, snapshot) {
                    // variáveis locais do StreamBuilder
                    final icy = snapshot.data;
                    final rawTitle = icy?.info?.title ?? '';
                    final parts = rawTitle.split(' - ');
                    final artist = parts.isNotEmpty
                        ? parts.first.trim()
                        : 'Sem informação';
                    final nameSong = parts.sublist(1).join(' - ').trim();

                    // a função limpaTitulo tira caracteres indesejáveis no
                    // final da strig com o nome da música
                    final song = parts.length > 1
                        ? nameSong
                        : 'Sem informação...';

                    // se o título da música não for vazio
                    if (rawTitle.isNotEmpty) {
                      // a função _updateCover atualiza e exibe os nomes do
                      // artista e da música em execução
                      _updateCover(artist: artist, song: song);
                    } else {
                      _updateCover(artist: 'Web Rádio', song: 'Parque Verde');
                    } // fim if

                    return ViewData2(
                      radioService: radioService,
                      coverUrl: _coverUrl,
                      artist: artist,
                      song: song,
                    );
                  }, //Builder
                );
              } // fim if

              // se o status for loading, exibe um spinner
              if (status == RadioStatus.loading) {
                return const LoadSpinner(padding: EdgeInsets.only(top: 210));
              }

              // se o status for error, exibe um AlertDialog
              if (status == RadioStatus.error) {
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

                  // deixa o spinner ativo por trás do dialog de erro
                  return const LoadSpinner(padding: EdgeInsets.only(top: 210));
                } // fim if
              }

              // exibe um spinner para qualquer outros status do player
              return const LoadSpinner(padding: EdgeInsets.only(top: 210));
            }, // Builder
          ),
        ),
      ),
    );
  }
}
