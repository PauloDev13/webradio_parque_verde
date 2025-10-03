import 'package:flutter/material.dart';

// imports locais
import '../components/clip_rect_cover.dart';
import '../constants.dart';

class Cover extends StatelessWidget {
  const Cover({super.key, required String coverUrl}) : _coverUrl = coverUrl;

  final String _coverUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.225,
      width: size.width * 0.48,
      decoration: BoxDecoration(
        border: Border.all(
          color: kColor4.withValues(alpha: 0.5), // cor da borda
          width: 15,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRectCover(coverUrl: _coverUrl),
    );
  }
}
