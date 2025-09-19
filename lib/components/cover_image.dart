import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/ClipRectCover.dart';
import 'package:webradio_parque_verde/constants.dart';

class Cover extends StatelessWidget {
  const Cover({super.key, required String? coverUrl, required String artist})
    : _coverUrl = coverUrl,
      _artist = artist;

  final String? _coverUrl;
  final String _artist;

  @override
  Widget build(BuildContext context) {
    final bool urlCover;
    _coverUrl != null && _coverUrl.startsWith('http')
        ? urlCover = true
        : urlCover = false;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kColorBorderCover, // cor da borda
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _artist.isNotEmpty && _artist.startsWith('Paulo') && !urlCover
          ? ClipRectCover(coverUrl: 'assets/locucao.png', urlCover: urlCover)
          : ClipRectCover(coverUrl: _coverUrl, urlCover: urlCover),
    );
  }
}
