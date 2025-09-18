import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class ClipRectCover extends StatelessWidget {
  const ClipRectCover({
    super.key,
    required String? coverUrl,
    required this.urlCover,
  }) : _coverUrl = coverUrl;

  final String? _coverUrl;
  final bool urlCover;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: urlCover
          ? Image.network(
              _coverUrl!,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                kUrlFallback,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
            )
          : Image.asset(
              kUrlFallback,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                kUrlFallback,
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
