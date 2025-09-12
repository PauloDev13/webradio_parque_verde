import 'package:flutter/material.dart';

// Cores se transparência
const kColor1 = Color(0xFF05aaea);
const kColor2 = Color(0xFF03ebff);
const kColor3 = Color(0xFF000b11);

// Cores com transparência
const kColorBorderCover = Color(0x7003ebff);
const kColorBorderButton = Color(0x8003ebff);

const kUrlServer = 'https://usa13.fastcast4u.com/proxy/parqueverde?mp=/1';
const kUrlCover = 'https://usa13.fastcast4u.com/rpc/parqueverde/streaminfo.get';
const kUrlFallback = 'https://via.placeholder.com/100.png?text=Sem+Capa';

const kArtistTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const kASongTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontStyle: FontStyle.italic,
);

const kErroConexaoStyle = TextStyle(
  fontSize: 20,
  color: kColor2,
  fontWeight: FontWeight.bold,
);
