import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Imports locais
import '../constants.dart';

enum RadioStatus{idle, loading, ready, error}

class RadioService {
  final AudioPlayer player;
  final String streamUrl;
  late final Stream<RadioStatus> statusStream;

  RadioService({required this.player, required this.streamUrl}){
    statusStream = player.processingStateStream.map((state) {
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
    }).handleError((_) => RadioStatus.error);
  }

  Future<void> startRadio() async {
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(streamUrl)));
      await player.play();
    } catch (e) {
      debugPrint("Erro ao iniciar rádio: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      try {
        // Reinicia stream para garantir áudio ao vivo
        await player.setAudioSource(AudioSource.uri(Uri.parse(streamUrl)));
        await player.play();
      } catch (e) {
        debugPrint("Erro ao iniciar rádio: $e");
      }
    }
  }

  // Future<void> stopRadio() async {
  //   try {
  //     await player.stop();
  //   } catch (e) {
  //     debugPrint("Erro ao parar rádio: $e");
  //   }
  // }

  Future<String?> fetchCover() async {
    try {
      final response = await http.get(Uri.parse(kUrlCover));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]?[0]?["track"]?["imageurl"];
      } else {
        return kLinkLogo;
      }
    } catch (e) {
      debugPrint("Erro ao buscar capa: $e");
    }
    return kLinkLogo;
  }

  String limparTitulo(String titulo) {
    // Remove qualquer [conteúdo] no final do título
    return titulo.replaceAll(RegExp(r'\s*\[[^\]]*\]$'), '').trim();
  }

  Future<String> fetchCoverItunes(String artist, String music) async {
    try {
      final query = Uri.encodeComponent('$artist $music');
      const country = "US";
      final url = Uri.parse('https://itunes.apple.com/search'
          '?term=$query'
          '&entity=musicTrack'
          '&limit=1'
          '&country=$country'
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
    return 'https://via.placeholder.com/100.png?text=Sem+Capa';
  }
}
