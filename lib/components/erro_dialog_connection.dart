import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webradio_parque_verde/constants.dart';

import 'button_social_media.dart';

class ErroDialogConnection extends StatelessWidget {
  final VoidCallback onRetry;
  const ErroDialogConnection({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('WR Parque Verde'),
      titleTextStyle: TextStyle(color: kColor2, backgroundColor: kColor3),
      content: const Text('Conexão perdida. Clique em Conectar'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 2, color: kColor2.withAlpha(100)),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      backgroundColor: kColor3,
      contentTextStyle: kArtistTextStyle,
      surfaceTintColor: kColor2,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ButtonSocialMedia(
          onPressed: onRetry,
          icon: FontAwesomeIcons.connectdevelop,
          iconColor: kColor2,
          borderColor: kColorBorderButton.withValues(alpha: 0.6),
          labelColor: kColor2,
          label: 'Conectar',
          iconSize: 20,
        ),
      ],
    );
  }
}
