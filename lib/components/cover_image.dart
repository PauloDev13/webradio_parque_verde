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
          color: kColor4.withValues(alpha: 0.5), // cor da borda
          width: 15,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: CircleAvatar(
        backgroundImage: _coverUrl.startsWith('http')
            ? NetworkImage(_coverUrl)
            : AssetImage(_coverUrl),
        backgroundColor: Color(0xFF808b92),
        onBackgroundImageError: (exception, stackTrace) =>
            AssetImage(kUrlFallback),
      ),
    );
  }
}
