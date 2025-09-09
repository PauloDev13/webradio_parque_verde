import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  const TextInfo({super.key, required this.metadata, required this.textStyle});

  final String metadata;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      metadata.isNotEmpty ? metadata : "Carregando informação...",
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }
}
