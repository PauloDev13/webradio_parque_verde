import 'package:flutter/material.dart';

// Importes locais
import 'package:webradio_parque_verde/pages/radio_player_page.dart';

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



