import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/constants.dart';

class Cover2 extends StatelessWidget {
  const Cover2({
    super.key,
  });

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
        child: Image.asset(
          'assets/logo.png',
          height: 140,
          width: 140,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}