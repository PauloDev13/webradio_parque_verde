import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class Cover extends StatelessWidget {
  const Cover({
    super.key,
    required String? coverUrl,
  }) : _coverUrl = coverUrl;

  final String? _coverUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kColor2, // cor da borda
          width: 4,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          _coverUrl!,
          height: 140,
          width: 140,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(
                'assets/logo.png',
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
        ),
      ),
    );
  }
}