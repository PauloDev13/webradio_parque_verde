import 'package:flutter/material.dart';

// imports locais
import '../components/ClipRectCover.dart';
import '../constants.dart';

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
          color: kColor4.withValues(alpha: 0.5), // cor da borda
          width: 15,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: _artist.isNotEmpty && _artist.startsWith('Paulo') && !urlCover
          ? ClipRectCover(coverUrl: kLocucaoImg, urlCover: urlCover)
          : ClipRectCover(coverUrl: _coverUrl, urlCover: urlCover),
    );
  }
}
