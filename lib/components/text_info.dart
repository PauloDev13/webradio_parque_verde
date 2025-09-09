import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  const TextInfo({
    super.key,
    required this.metadata,
    required this.fontSize,
    this.fontWeight,
    this.fontStyle,

  });

  final String metadata;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      metadata.isNotEmpty
          ? metadata
          :"Carregando informação...",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: fontWeight,
          fontStyle: fontStyle
      ),
    );
  }
}