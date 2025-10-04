import 'package:flutter/material.dart';

// imports locais
import '/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          fontFamily: 'Michroma',
          color: kColor3,
        ),
      ),
      centerTitle: true,
      backgroundColor: kColor2,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
