import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class InheritedCover extends InheritedWidget {
  final String cover;

  const InheritedCover({super.key, required this.cover, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedCover oldWidget) {
    return oldWidget.cover != cover;
  }
}

class Artwork extends StatelessWidget {
  const Artwork({super.key});

  @override
  Widget build(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<InheritedCover>()!;
    final coverUrl = inherited.cover;
    return Image.network(
      coverUrl,
      width: 240, // deve ser o dobro do radius
      height: 240,
      fit: BoxFit.cover, // mantém a proporção e cobre o círculo
      errorBuilder: (context, error, stackTrace) =>
          Image.network(kUrlCloudinaryLogo),
    );
  }
}
