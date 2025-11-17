import 'package:flutter/material.dart';

// imports locais
import '/constants.dart';

// exibe a capa do álbum
class Cover extends StatelessWidget {
  const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;

  final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: CircleAvatar(
        radius: 125,
        backgroundColor: kColor2.withAlpha(50),
        child: ClipOval(
          child: Image.network(
            _coverUrl,
            width: 220, // deve ser o dobro do radius
            height: 220,
            fit: BoxFit.cover, // mantém a proporção e cobre o círculo
            errorBuilder: (context, error, stackTrace) =>
                Image.network(kUrlCloudinaryLogo),
          ),
        ),
      ),
    );
  }
}
