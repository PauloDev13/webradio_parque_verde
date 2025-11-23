import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/artwork.dart';

// imports locais
import '/constants.dart';

// exibe a capa do álbum
class Cover extends StatelessWidget {
  const Cover({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: CircleAvatar(
        radius: 130,
        backgroundColor: kColor2.withAlpha(80),
        child: const ClipOval(child: Artwork()),
      ),
    );
  }
}
