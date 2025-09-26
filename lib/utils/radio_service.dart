import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Imports locais
import '../constants.dart';
import '../main.dart';

// Enum
enum RadioStatus { idle, loading, ready, completed, error }

class RadioService extends BaseAudioHandler {
  // Variáveis globais
  final AudioPlayer player;
  // Flag para saber se o player estava tocando
  bool wasPlaying = false;
  bool hasError = false;
  final _statusController = StreamController<RadioStatus>.broadcast();

  Stream<RadioStatus> get statusStream => _statusController.stream;

  // Construtor
  RadioService({required this.player}) {
    // Atualiza o estado de playback para o sistema
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Status interno para UI
    player.playerStateStream.listen(
      (state) {
        final processingState = state.processingState;
        final isPlaying = state.playing;

        if (isPlaying) {
          wasPlaying = true;
        }
        if (hasError) {
          return;
        }

        switch (processingState) {
          case ProcessingState.loading:
          case ProcessingState.buffering:
            _statusController.add(RadioStatus.loading);
            break;
          case ProcessingState.ready:
            if (wasPlaying) {
              _statusController.add(RadioStatus.ready);
            } else {
              _statusController.add(RadioStatus.idle);
            }
            break;
          case ProcessingState.completed:
          case ProcessingState.idle:
            radioService.play();

            if (wasPlaying) {
              _statusController.add(RadioStatus.error);
              hasError = true;
            } else {
              _statusController.add(RadioStatus.idle);
            }
            wasPlaying = false;
            break;
        }
      },
      onError: (e, st) {
        hasError = true;
        _statusController.add(RadioStatus.error);
        debugPrint('RADIO SERVICE - playerStateStream.onError: $e');
      },
    );
  }
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
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.idle: AudioProcessingState.idle,
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
    hasError = false;

    try {
      _statusController.add(RadioStatus.loading);
      await player.setAudioSource(AudioSource.uri(Uri.parse(kUrlServerLink)));
      await player.play();
      wasPlaying = true;
      _statusController.add(RadioStatus.ready);
    } catch (e) {
      debugPrint("Erro ao conectar servidor de stream: $e");
      hasError = true;
      wasPlaying = false;
      _statusController.add(RadioStatus.error);
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
    wasPlaying = false;
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

  // Busca a capa do álbum usando a url do provedor de stream
  Future<String?> fetchCover() async {
    try {
      final response = await http.get(Uri.parse(kUrlCover));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]?[0]?["track"]?["imageurl"];
      } else {
        return kUrlFallback;
      }
    } catch (e) {
      debugPrint("Erro ao buscar capa: $e");
    }
    return kUrlFallback;
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
