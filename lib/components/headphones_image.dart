import 'package:flutter/material.dart';

// imports local
import '/constants.dart';

class HeadphonesImage extends StatelessWidget {
  const HeadphonesImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kHeadPhonesImg,
      height: 230,
      width: 300,
      fit: BoxFit.contain,
    );
  }
}
