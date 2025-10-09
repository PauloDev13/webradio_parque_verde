import 'package:flutter/material.dart';

import '../constants.dart';

class Cover extends StatelessWidget {
  const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;

  final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.5,
      width: size.width * 0.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: kColor2.withValues(alpha: 0.2), // cor da borda
          width: 15,
        ),
        shape: BoxShape.circle,
      ),
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
