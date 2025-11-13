import 'package:flutter/material.dart';

// imports locais
import '/constants.dart';

// exibe a capa do álbum
class Cover extends StatelessWidget {
  const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;

  final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.65,
      width: size.width * 0.65,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kColor2.withValues(alpha: 0.2), // cor da borda
          width: 10,
        ),
        shape: BoxShape.circle,
      ),

      child: CircleAvatar(
        backgroundImage: NetworkImage(_coverUrl),
        backgroundColor: kColor2.withValues(alpha: .2),
        onBackgroundImageError: (exception, stackTrace) =>
            NetworkImage(kUrlCloudinaryLogo),
      ),
    );
  }
}
