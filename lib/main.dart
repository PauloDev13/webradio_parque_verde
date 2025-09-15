import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
// Importes locais
import 'package:webradio_parque_verde/pages/radio_player_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.webradio_parque_verde',
    androidNotificationChannelName: 'WebRádio',
    androidNotificationOngoing: true,
  );
  runApp(const WebradioApp());
}

// void main() {
//   runApp(const WebradioApp());
// }

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
