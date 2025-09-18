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
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: FloatingActionButton.small(
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              playing ? Icons.stop : Icons.play_arrow,
              size: 30,
              color: iconColor,
            ),
          ),
        );
      }, // builder
    );
  }
}
