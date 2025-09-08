import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:waveform_visualizer/waveform_visualizer.dart';

void main() {
  WaveformVisualizer.initialize();
  runApp(const WebradioApp());
}

class WebradioApp extends StatelessWidget {
  const WebradioApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RadioPlayerPage(),
    );
  }
}

class RadioPlayerPage extends StatefulWidget {
  const RadioPlayerPage({super.key});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  final AudioPlayer player = AudioPlayer();
  final String streamUrl = 'https://usa13.fastcast4u.com/proxy/parqueverde?mp=/1';
  late WaveformController _waveController;

  String? _coverUrl;
  String? _lastSong;


  @override
  void initState() {
    super.initState();
    _waveController = WaveformController();
    _startRadio();
  }

  Future<void> _startRadio() async {
    try {
      // Conectar ao servidor de stream
      await player.setAudioSource(
        AudioSource.uri(
            Uri.parse(streamUrl),
        ),
      );
      // Ativa o play e faz o audio tocar
      await player.play();
    }catch (e) {
      debugPrint("Erro ao iniciar rádio: $e");
    }
  }

  // Controla os botões de pausa e play
  Future <void> _togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      try {
        // Reinicia stream para garantir áudio ao vivo
        await player.setAudioSource(
          AudioSource.uri(
            Uri.parse(streamUrl),
          ),
        );
        await player.play();
      } catch (e) {
        debugPrint("Erro ao iniciar rádio: $e");
      }
    }
  }

  // Acessa a URL para buscar a imagem da capa do álbum
  Future<String?> fetchCover() async {
    try {
      final response = await http.get(
        Uri.parse("https://usa13.fastcast4u.com/rpc/parqueverde/streaminfo.get"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]?[0]?["track"]?["imageurl"];
      }
    } catch (e) {
      debugPrint("Erro ao buscar capa: $e");
    }
    return 'https://drive.google.com/file/d/1t_Q8u_ouwmjctpgSGzDMFnYhe8x8DKEb/view';
  }

  // Atualiza a capa de álbum sempre que a música mudar
  Future<void> _updateCover(String currentSong) async {
    // if (_lastSong == currentSong) return; // evita chamadas desnecessárias

    if (_lastSong != currentSong) {

      final newCover = await fetchCover();

      setState(() {
        _coverUrl = newCover;
        _lastSong = currentSong;
      });
    }
  }

  String limparTitulo(String titulo) {
    // Remove qualquer [conteúdo] no final do título
    return titulo.replaceAll(RegExp(r'\s*\[[^\]]*\]$'), '').trim();
  }

  Widget _waveFormControler(bool playing) {
    if (playing) {
      _waveController.start();
      return WaveformWidget(
        controller: _waveController,
        height: 180,
        width: 240,
        style: WaveformStyle(
          waveformStyle: WaveformDrawStyle.bars,
          waveColor: Color(0xFF03ebff),
          backgroundColor: Color(0x00ff5722),
          barCount: 10,
          barSpacing: 2.0,
          strokeWidth: 2.0,
          showGradient: true,
          gradientBegin: Alignment.topCenter,
          gradientEnd: Alignment.bottomCenter,
          animationDuration: playing
              ? Duration(milliseconds: 150)
              : Duration.zero
        ),
      );
    } else {
      _waveController.stop();
      return SizedBox(
        height: 180,
      );
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
        title: Text(
            'Radio Web',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF03ebff),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover
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
                  final song = parts.length > 1
                  ? limparTitulo(parts.sublist(1).join(' - ').trim())
                      : 'Desconhecido';

                  if (rawTitle.isNotEmpty) {
                    // chama função que retorna a url com
                    _updateCover(rawTitle);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            StreamBuilder(
                                stream: player.playingStream,
                                initialData: player.playing,
                                builder: (context, snapshot) {
                                  final playing = snapshot.data ?? false;
                                  return _waveFormControler(playing);
                                }),
                            if (_coverUrl != null
                                && _coverUrl!.isNotEmpty
                                && artist.isNotEmpty)... [
                              Image.network(
                                _coverUrl!,
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                      'assets/logo.png',
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    ),
                              ),
                            ] else... [
                              Image.asset(
                                'assets/logo.png',
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          artist.isNotEmpty
                              ? artist
                              :"Carregando artista...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          song.isNotEmpty
                              ? song
                              :"Carregando música...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: player.playingStream,
                  initialData: player.playing,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return FloatingActionButton(
                      onPressed: _togglePlayPause,
                      backgroundColor: Color(0x8003ebff),
                      // child: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                      child: Icon(playing
                          ? Icons.pause
                          : Icons.play_arrow,
                        size: 30,
                      ),
                    );
                    // return ElevatedButton.icon(
                    //     onPressed: _togglePlayPause,
                    //     icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    //     label: Text(playing ? 'Pausar' : 'Reproduzir'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Color(0xFF03ebff),
                    //   ),
                    // );
                    // return IconButton(
                    //     onPressed: _togglePlayPause,
                    //     icon: Icon(
                    //       playing
                    //           ? Icons.pause
                    //           : Icons.play_arrow,
                    //       size: 50,
                    //       color: Color((0xFF03ebff),
                    //       ),
                    //     ),
                    // );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

