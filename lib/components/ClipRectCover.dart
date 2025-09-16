import 'package:flutter/material.dart';

import '../constants.dart';

class ClipRectCover extends StatelessWidget {
  const ClipRectCover({super.key, required String? coverUrl})
    : _coverUrl = coverUrl;

  final String? _coverUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        _coverUrl ?? '',
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
