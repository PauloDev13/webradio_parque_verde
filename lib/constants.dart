import 'package:flutter/material.dart';

// Cores usadas na identidade visual
const kColor1 = Color(0xFF05aaea);
const kColor2 = Color(0xFF03ebff);
const kColor3 = Color(0xFF000b11);

// urls
const kUrlServer = 'https://usa13.fastcast4u.com/proxy/parqueverde?mp=/1';
const kUrlCover = 'https://usa13.fastcast4u.com/rpc/parqueverde/streaminfo.get';
const kUrlFallback = 'assets/logo_retangular.jpg';

// estilo de texto para o nome do artista
const kArtistTextStyle = TextStyle(
  fontSize: 16,
  color: kColor2,
  fontFamily: 'Michroma',
  fontWeight: FontWeight.bold,
);

// estilo de texto para o nome da música
const kSongTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontFamily: 'Michroma',
  fontStyle: FontStyle.italic,
);

// estilo de texto para o conteúdo do Dialog
const kDialogContentStyle = TextStyle(
  fontSize: 12,
  fontFamily: 'Michroma',
  color: kColor2,
  fontWeight: FontWeight.bold,
);
