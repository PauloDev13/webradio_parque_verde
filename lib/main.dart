import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:siri_wave/siri_wave.dart';

void main() {
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

  String? _coverUrl;
  String? _lastSong;

  late IOS9SiriWaveformController _waveformController;

  @override
  void initState() {
    super.initState();

    _waveformController = IOS9SiriWaveformController(
      color1: Color(0xFFAD394C),
      color2: Color(0xFF30DC9B),
      color3: Color(0xFF0F52A9),
      amplitude: 1.0,
      speed: 0.15,
    );

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
      // Reinicia stream para garantir áudio ao vivo
      await player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
        ),
      );
      await player.play();
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
    return null;
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
    // Remove qualquer [conteudo] no final do título
    return titulo.replaceAll(RegExp(r'\s*\[[^\]]*\]$'), '').trim();
  }

  Widget _formWave(bool playing) {
    _waveformController.amplitude = playing ? 1.0 : 0.0;
    _waveformController.speed = playing ? 0.15 : 0.0;
    return SiriWaveform.ios9(
      controller: _waveformController,
      options: IOS9SiriWaveformOptions(
        height: 100,
        width: 250,
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
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

                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      if (_coverUrl != null
                          && _coverUrl!.isNotEmpty
                          && artist.isNotEmpty)... [
                        Image.network(
                          _coverUrl!,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/logo.png',
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ] else... [
                        Image.asset(
                          'assets/logo.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ],

                      // Exibe o wave form quando a música está tocando
                      StreamBuilder(
                          stream: player.playingStream,
                          initialData: player.playing,
                          builder: (context, snapshot) {
                            // final playing = snapshot.data ?? false;
                            return _formWave(true);
                          }),
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
                            // fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  );
                }
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: player.playingStream,
                  initialData: player.playing,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    // return ElevatedButton.icon(
                    //     onPressed: _togglePlayPause,
                    //     icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    //     label: Text(playing ? 'Pausar' : 'Reproduzir'),
                    // );
                    return IconButton(
                        onPressed: _togglePlayPause,
                        icon: Icon(
                          playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                          color: Color((0xFF03ebff),
                          ),
                        ),
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

