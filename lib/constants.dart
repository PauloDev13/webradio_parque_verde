import 'package:flutter/material.dart';

// Cores usadas na identidade visual
const kColor1 = Color(0xFF05aaea);
const kColor2 = Color(0xFF03ebff);
const kColor3 = Color(0xFF000b11);
const kColor4 = Color(0xFFFFFFFF);

// urls
const kUrlServerLink = 'https://stm6.xradios.com.br:6886/stream';
const kUrlServerCentova = 'https://centova2.ipstm.net/proxy/bmjceqts/stream';
const kUrlServer = 'https://usa13.fastcast4u.com/proxy/parqueverde?mp=/1';
const kUrlCover = 'https://centova2.ipstm.net/rpc/bmjceqts/streaminfo.get';

// Imagens
const kUrlFallback = 'assets/logo.png';
const kBackgroundImg = 'assets/animation/animated_background.png';
const kPhonesImg = 'assets/phones.png';
const kAstePhonesImg = 'assets/haste_phones.png';
const kBrandingImg = 'assets/brandingimage.png';
const kLocucaoImg = 'assets/locucao.png';

// Animações .json
const kWaveFormJson = 'assets/animation/Sound voice waves.json';
const kWalkCycleJson = 'assets/animation/Walk_Cycle.json';

// Fontes
const kMichromaFont = 'Michroma';

// estilo de texto para o nome do artista
const kArtistTextStyle = TextStyle(
  fontSize: 16,
  color: kColor2,
  fontFamily: kMichromaFont,
  fontWeight: FontWeight.bold,
);

// estilo de texto para o nome da música
const kSongTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontFamily: kMichromaFont,
  fontStyle: FontStyle.italic,
);

// estilo de texto para o conteúdo do Dialog
const kDialogContentStyle = TextStyle(
  fontSize: 12,
  fontFamily: kMichromaFont,
  color: kColor2,
  fontWeight: FontWeight.bold,
);

// estilo de texto para o conteúdo do Dialog
const kTitleStyle = TextStyle(
  fontSize: 21,
  fontFamily: kMichromaFont,
  color: kColor2,
);
