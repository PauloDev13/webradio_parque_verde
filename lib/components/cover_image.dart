import 'package:flutter/material.dart';

// imports locais
import '/constants.dart';

// exibe a capa do álbum
class Cover extends StatelessWidget {
  const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;

  final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 135,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: Image.network(
          _coverUrl,
          width: 250, // deve ser o dobro do radius
          height: 250,
          fit: BoxFit.cover, // mantém a proporção e cobre todo o círculo
          errorBuilder: (context, error, stackTrace) =>
              Image.network(kUrlCloudinaryLogo),
        ),
      ),
    );
  }
}
