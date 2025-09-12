import 'package:flutter/material.dart';

import '../constants.dart';

class LoadSpinner extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  const LoadSpinner({super.key, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: padding,
        child: CircularProgressIndicator(color: kColor2),
      ),
    );
  }
}
