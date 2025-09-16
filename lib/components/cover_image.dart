import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/ClipRectCover.dart';
import 'package:webradio_parque_verde/constants.dart';

class Cover extends StatelessWidget {
  const Cover({super.key, required String? coverUrl}) : _coverUrl = coverUrl;

  final String? _coverUrl;

  @override
  Widget build(BuildContext context) {
    final bool imageCover;
    _coverUrl != null && _coverUrl.startsWith('http')
        ? imageCover = true
        : imageCover = false;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kColorBorderCover, // cor da borda
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: imageCover
          ? ClipRectCover(coverUrl: _coverUrl)
          : ClipRectCover(coverUrl: _coverUrl),
    );
  }
}
