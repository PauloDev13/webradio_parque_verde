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
      height: size.width * 0.7,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kColor2.withValues(alpha: 0.2), // cor da borda
          width: 10,
        ),
        shape: BoxShape.circle,
      ),
      // child: Image(
      //   image: _coverUrl.startsWith('http')
      //       ? NetworkImage(_coverUrl)
      //       : AssetImage(_coverUrl),
      //   fit: BoxFit.cover,
      // ),
      child: CircleAvatar(
        backgroundImage: _coverUrl.startsWith('http')
            ? NetworkImage(_coverUrl)
            : AssetImage(_coverUrl),
        backgroundColor: kColor2.withValues(alpha: .2),
        onBackgroundImageError: (exception, stackTrace) =>
            AssetImage(kUrlFallback),
      ),
    );
  }
}
