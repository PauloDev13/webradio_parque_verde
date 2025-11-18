import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/artwork.dart';

// imports locais
import '/constants.dart';

// exibe a capa do álbum
class Cover extends StatelessWidget {
  const Cover({super.key});

  // const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;
  //
  // final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: CircleAvatar(
        radius: 130,
        backgroundColor: kColor2.withAlpha(30),
        child: const ClipOval(child: Artwork()),
      ),
    );
  }
}
