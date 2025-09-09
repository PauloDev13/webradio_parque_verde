import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class Cover2 extends StatelessWidget {
  const Cover2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: kColorBorderCover, // cor da borda
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/logo_retangular.jpg',
          height: 140,
          width: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
