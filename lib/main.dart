import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// import '../pages/radio_player_page.dart';
import 'package:webradio_parque_verde/utils/radio_service.dart';

// Importes locais
import '../components/splash_screen_widget.dart';

late final RadioService radioService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  radioService = await AudioService.init(
    builder: () => RadioService(player: AudioPlayer()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.webradio_parque_verde',
      androidNotificationChannelName: 'WebRádio',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcer',
    ),
  );
  runApp(const WebradioApp());
}

class WebradioApp extends StatelessWidget {
  const WebradioApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreenWidget(),
      // home: RadioPlayerPage(),
    );
  }
}
