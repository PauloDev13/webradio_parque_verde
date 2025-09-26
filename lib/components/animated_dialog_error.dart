import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// imports locais
import '../components/button_social_media.dart';
import '../constants.dart';

// classe que cria e exibe o AlertDialog de erro de conexão
void showAnimatedDialog({
  VoidCallback? onCancel,
  required BuildContext context,
  required bool dialogOpen,
  required VoidCallback onRetry,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: kColor3.withValues(alpha: 0.8),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: AlertDialog(
          title: const Text('WR Parque Verde'),
          titleTextStyle: kArtistTextStyle,
          content: const Text('Sem Conexão. Clique em Conectar'),
          contentTextStyle: kDialogContentStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(width: 2, color: kColor2.withValues(alpha: 0.6)),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          backgroundColor: kColor3,
          surfaceTintColor: kColor2,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonSocialMedia(
                  onPressed: () {
                    if (Platform.isAndroid) SystemNavigator.pop();
                  },
                  icon: FontAwesomeIcons.ban,
                  iconColor: kColor2,
                  borderColor: kColor2.withValues(alpha: 0.6),
                  labelColor: kColor2,
                  label: 'Fechar',
                  iconSize: 18,
                ),
                ButtonSocialMedia(
                  onPressed: onRetry,
                  icon: FontAwesomeIcons.plugCircleBolt,
                  iconColor: kColor2,
                  borderColor: kColor2.withValues(alpha: 0.6),
                  labelColor: kColor2,
                  label: 'Conectar',
                  iconSize: 18,
                ),
              ],
            ),
          ],
        ),
      );
    }, // pageBuilder

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // começa de baixo
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  ).then((_) => dialogOpen = false);
}
