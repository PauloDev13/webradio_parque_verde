import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Imports locais
import '../constants.dart';

// Enum
enum RadioStatus { idle, loading, ready, error }

class RadioService extends BaseAudioHandler {
  // Variáveis globais
  final AudioPlayer player;

  // Construtor
  RadioService({required this.player}) {
    // Atualiza o estado de playback para o sistema
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Status interno para UI
    player.processingStateStream
        .map((state) {
          switch (state) {
            case ProcessingState.loading:
            case ProcessingState.buffering:
              return RadioStatus.loading;
            case ProcessingState.ready:
              return RadioStatus.ready;
            case ProcessingState.completed:
            case ProcessingState.idle:
              return RadioStatus.idle;
          }
        })
        .handleError((_) => RadioStatus.error)
        .pipe(_statusController);
  }

  // StreamController para status interno
  final _statusController = StreamController<RadioStatus>.broadcast();
  Stream<RadioStatus> get statusStream => _statusController.stream;

  // Converte eventos do just_audio para AudioService PlaybackState
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [MediaControl.play, MediaControl.pause, MediaControl.stop],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
      },
      androidCompactActionIndices: const [0, 1],
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }

  // Inicia o player e conecta ao servidor de stream
  Future<void> startRadio() async {
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(kUrlServer)));
      await player.play();
    } catch (e) {
      debugPrint("Erro ao iniciar rádio: $e");
    }
  }

  // Ativa o play
  @override
  Future<void> play() => player.play();
  // Ativa o pause
  @override
  Future<void> pause() => player.pause();
  // Ativa o pause
  @override
  Future<void> stop() async {
    await player.stop();
    await super.stop();
  }

  // Controla o botão de play/stop
  Future<void> togglePlayPause() async {
    if (player.playing) {
      await pause();
    } else {
      await startRadio();
    }
  }

  // Exclui do nome da música os caracteres que vêm por padrão dentro de [] no
  // final do nome da música
  String limparTitulo(String titulo) {
    // Remove qualquer [conteúdo] no final do título
    return titulo.replaceAll(RegExp(r'\s*\[[^\]]*\]$'), '').trim();
  }

  // Usa a API do iTunes para buscar a capa do álbum passando o nome do
  // artista e o título da música
  Future<String> fetchCoverItunes(String artist, String music) async {
    try {
      final query = Uri.encodeComponent('$artist $music');
      const country = "US";
      final url = Uri.parse(
        'https://itunes.apple.com/search'
        '?term=$query'
        '&entity=musicTrack'
        '&limit=1'
        '&country=$country',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(response.body);
        final List<dynamic>? results = jsonBody['results'];

        if (results != null && results.isNotEmpty) {
          final first = results.first as Map<String, dynamic>;
          final artworkUrl = first['artworkUrl100'] as String?;

          if (artworkUrl != null) {
            return artworkUrl;
          }
        }
      } else {
        debugPrint('iTunes API retornou status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar capa: $e');
    }
    return kUrlFallback;
  }
}
