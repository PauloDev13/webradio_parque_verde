import 'dart:async';
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Imports locais
import '/constants.dart';

// Enum
enum RadioStatus { idle, loading, ready, completed, error }

class RadioService extends BaseAudioHandler {
  // Variáveis globais
  final AudioPlayer player;
  // Flag para saber se o player está tocando
  bool wasPlaying = false;
  bool hasError = false;

  final _statusController = StreamController<RadioStatus>.broadcast();
  Stream<RadioStatus> get statusStream => _statusController.stream;

  // Construtor
  RadioService({required this.player}) {
    // Setup estado de reprodução para o Android/iOS
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Observa estado interno do player para atualizar status interno
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
            // Tentativa de reconectar
            startRadio();
            //   radioService.play();

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
  // Converte evento do just_audio em PlaybackState para audio_service
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

  // Inicia o streaming da rádio
  Future<void> startRadio() async {
    hasError = false;

    try {
      _statusController.add(RadioStatus.loading);

      final initialItem = MediaItem(
        id: 'stream',
        title: 'Web Rádio',
        artist: 'Parque Verde',
        artUri: Uri.parse(kUrlCloudinaryLogo),
      );

      mediaItem.add(initialItem);

      await player.setAudioSource(
        AudioSource.uri(Uri.parse(kUrlServerCentova), tag: initialItem),
      );

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

  Future<void> updateMetadata() async {
    player.icyMetadataStream.listen((metadata) async {
      final icyInfo = metadata?.info;
      final rawTitle = icyInfo?.title ?? 'Web Rádio';
      final parts = rawTitle.split(' - ');

      late String artist = parts.isNotEmpty
          ? parts.first.trim()
          : 'Parque Verde';
      final tempTitle = parts.sublist(1).join(' - ').trim();
      final title = parts.length > 1 ? tempTitle : 'Sem informação';

      final coverUrl = await fetchCoverItunes(artist, title);

      debugPrint('TITULO $title}');
      debugPrint('ARTISTA $artist}');
      debugPrint('CAPA $coverUrl}');

      try {
        final newMedia = MediaItem(
          id: 'stream',
          title: title,
          artist: artist,
          artUri: Uri.parse(coverUrl),
        );
        mediaItem.add(newMedia);

        await updateMediaItem(newMedia);
      } catch (err) {
        debugPrint('Erro ao atualizar metadados no player: $err');
      }
    });
  }

  // Ativa o play
  @override
  Future<void> play() async {
    if (!player.playing) {
      await player.play();
    }
  }

  // Ativa o pause
  @override
  Future<void> pause() async {
    await player.pause();
    _statusController.add(RadioStatus.idle);
  }

  // Ativa o pause
  @override
  Future<void> stop() async {
    await player.stop();
    await super.stop();
    wasPlaying = false;
    _statusController.add(RadioStatus.idle);
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
        return kUrlCloudinaryLogo;
      }
    } catch (e) {
      debugPrint("Erro ao buscar capa: $e");
    }
    return kUrlCloudinaryLogo;
  }

  // Usa a API do iTunes para buscar a capa do álbum passando o nome do
  // artista e o título da música
  Future<String> fetchCoverItunes(String artist, String music) async {
    try {
      final query = Uri.encodeComponent('$artist $music');
      const country = "BR";
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
          final artworkUrl = results.first['artworkUrl100'] as String?;

          if (artworkUrl != null) {
            return artworkUrl.replaceAll('100x100bb', '300x300bb');
          }
        }
      } else {
        debugPrint('iTunes API retornou status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar capa: $e');
    }
    return kUrlCloudinaryLogo;
  }
}
