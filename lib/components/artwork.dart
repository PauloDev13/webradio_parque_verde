import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class Artwork extends StatelessWidget {
  final String coverUrl;
  const Artwork({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      coverUrl,
      width: 220, // deve ser o dobro do radius
      height: 220,
      fit: BoxFit.cover, // mantém a proporção e cobre o círculo

      errorBuilder: (context, error, stackTrace) =>
          Image.network(kUrlCloudinaryLogo),
    );
  }
}
