import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

// Imports locais
import '../constants.dart';

class RadioService {
  final AudioPlayer player;
  final String streamUrl;

  RadioService({required this.player, required this.streamUrl});

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
}
