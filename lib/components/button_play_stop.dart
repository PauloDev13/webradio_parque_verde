import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  final Stream<bool> playingStream;
  final bool initialPlaying;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;

  const PlayPauseButton({
    super.key,
    required this.playingStream,
    required this.initialPlaying,
    required this.onPressed,
    required this.borderColor,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: playingStream,
      initialData: initialPlaying,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
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
            child: Icon(
              playing ? Icons.pause : Icons.play_arrow,
              size: 25,
              color: iconColor,
            ),
          ),
        );
      }, // builder
    );
  }
}
