import 'package:flutter/material.dart';

// imports locais
import '../constants.dart';

class ButtonSocialMedia extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color labelColor;
  final String label;
  final double iconSize;
  const ButtonSocialMedia({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.labelColor,
    required this.label,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor),
      label: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Michroma',
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: kColor3.withValues(alpha: 0.8),
        side: BorderSide(color: borderColor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
