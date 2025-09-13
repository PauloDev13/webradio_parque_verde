import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webradio_parque_verde/constants.dart';

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
      icon: FaIcon(icon, color: iconColor, size: iconSize),
      label: Text(label, style: TextStyle(color: labelColor, fontSize: 16)),
      style: OutlinedButton.styleFrom(
        backgroundColor: kColor3,
        side: BorderSide(color: borderColor, width: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
