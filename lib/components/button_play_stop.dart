import 'package:flutter/material.dart';

import '/main.dart';

class PlayPauseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;

  const PlayPauseButton({
    super.key,
    required this.onPressed,
    required this.borderColor,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = radioService.player.playing;
    final isLoading = radioService.isLoading;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 50,
        maxWidth: 50,
        minHeight: 40,
        minWidth: 40,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: borderColor, width: 3),
        ),
        child: _buildContent(isPlaying, isLoading),
      ),
    ); // builder
  }

  Widget _buildContent(bool isPlaying, bool isLoading) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(color: iconColor, strokeWidth: 2.5),
      );
    }

    return Icon(
      isPlaying ? Icons.pause : Icons.play_arrow,
      size: 25,
      color: iconColor,
    );
  }
}
