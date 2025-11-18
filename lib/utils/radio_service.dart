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
  bool wasPlaying = false;
  bool hasError = false;
  bool isLoading = false;

  // Armazena o último item válido recebido
  MediaItem? lastMediaItem;
  StreamSubscription<IcyMetadata?>? _icySubscription;

  final _statusController = StreamController<RadioStatus>.broadcast();
  Stream<RadioStatus> get statusStream => _statusController.stream;

  // ---------------------------------------------------------------------------
  // CONSTRUTOR
  // ---------------------------------------------------------------------------
  RadioService({required this.player}) {
    // Listener de metadados ICY (apenas uma vez!)
    _icySubscription = player.icyMetadataStream.listen(
      (metadata) {
        if (metadata != null) {
          processIcyMetadata(metadata);
        }
      },
      onError: (e, st) {
        hasError = true;
        _statusController.add(RadioStatus.error);
        debugPrint('Erro no Icy: $e');
      },
    );

    // Sincroniza PlaybackState com audio_service
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // Listener do estado do player
    player.playerStateStream.listen(
      processPlayerState,
      onError: (e, st) {
        hasError = true;
        _statusController.add(RadioStatus.error);
        debugPrint('RADIO SERVICE - playerStateStream.onError: $e');
      },
    );
  }

  // ---------------------------------------------------------------------------
  // PROCESSAMENTO DE METADADOS ICY
  // ---------------------------------------------------------------------------
  Future<void> processIcyMetadata(IcyMetadata metadata) async {
    final lastCover = lastMediaItem?.artUri.toString();

    final icyInfo = metadata.info;
    if (icyInfo == null) return;

    final raw = icyInfo.title?.trim() ?? '';
    if (raw.isEmpty) return;

    final lower = raw.toLowerCase();
    if (lower == 'web rádio' || lower == 'parque verde') return;

    final parts = raw.split(' - ');

    final artist = parts.first.trim();
    final title = parts.length > 1
        ? parts.sublist(1).join(' - ').trim()
        : 'Sem informação';

    var coverUrl = await fetchCoverItunes(artist, title);

    artist.startsWith('Paulo') ? coverUrl = kUrlCloudinaryLocucao : coverUrl;
    artist.startsWith('Web') ||
            title.startsWith('Hora') ||
            title.startsWith('Minuto')
        ? coverUrl = kUrlCloudinaryLogo
        : coverUrl;

    final newMedia = MediaItem(
      id: 'stream',
      title: title,
      artist: artist,
      artUri: Uri.parse(coverUrl),
    );

    if (lastCover != coverUrl) {
      mediaItem.add(newMedia);
      await updateMediaItem(newMedia);
    }
  }

  // ---------------------------------------------------------------------------
  // PROCESSAMENTO DO ESTADO DO PLAYER
  // ---------------------------------------------------------------------------
  void processPlayerState(PlayerState state) {
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
        isLoading = true;
        break;
      case ProcessingState.ready:
        if (wasPlaying) {
          _statusController.add(RadioStatus.ready);
          isLoading = false;
        } else {
          _statusController.add(RadioStatus.idle);
        }
        break;
      case ProcessingState.idle:
        if (wasPlaying) {
          _statusController.add(RadioStatus.ready);
        } else {
          _statusController.add(RadioStatus.idle);
        }
        break;
      case ProcessingState.completed:
        if (wasPlaying) {
          _statusController.add(RadioStatus.error);
        } else {
          _statusController.add(RadioStatus.idle);
        }
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // CONVERSÃO PLAYBACK EVENT
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // START RADIO
  // ---------------------------------------------------------------------------
  Future<void> startRadio() async {
    hasError = false;
    try {
      _statusController.add(RadioStatus.loading);

      final initialItem = MediaItem(
        id: 'stream',
        title: 'Conectando...',
        artist: 'Aguarde...',
        artUri: Uri.parse(kUrlCloudinaryLogo),
      );

      mediaItem.add(initialItem);

      await updateMediaItem(initialItem);

      await player.setAudioSource(
        AudioSource.uri(Uri.parse(kUrlServerCentova), tag: initialItem),
      );

      await play();
    } catch (e) {
      debugPrint("Erro ao conectar servidor de stream: $e");
      _statusController.add(RadioStatus.error);
      hasError = true;
      wasPlaying = false;
    }
  }

  // ---------------------------------------------------------------------------
  // CONTROLES
  // ---------------------------------------------------------------------------
  @override
  Future<void> play() async {
    await player.play();
    // if (lastMediaItem != null) {
    //   mediaItem.add(lastMediaItem);
    //   await updateMediaItem(lastMediaItem!);
    // }
  }

  @override
  Future<void> pause() async {
    await player.pause();
  }

  @override
  Future<void> stop() async {
    await player.stop();
    // if (lastMediaItem != null) {
    //   mediaItem.add(lastMediaItem);
    // }
    return super.stop();
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await stop();
    } else {
      await play();
    }
  }

  // ---------------------------------------------------------------------------
  // CAPA VIA ITUNES
  // ---------------------------------------------------------------------------
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
