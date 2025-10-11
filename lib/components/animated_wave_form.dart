import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';

// imports locais
import '/constants.dart';

class AnimatedWaveform extends StatefulWidget {
  final AudioPlayer player;
  final int barCount;
  final double circleDiameter;
  final Color color;
  final Duration animationSpeed;

  const AnimatedWaveform({
    super.key,
    required this.player,
    this.barCount = 20,
    this.circleDiameter = 180,
    this.color = kColor2,
    this.animationSpeed = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform>
    with SingleTickerProviderStateMixin {
  late List<double> _barHeights;
  late final Random _random;
  bool _isPlaying = false;
  late final Stream<bool> _playingStream;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _barHeights = List.generate(widget.barCount, (_) => 5.0);
    _playingStream = widget.player.playingStream;

    _ticker = createTicker((_) {
      if (!_isPlaying) return;
      setState(() {
        _barHeights = List.generate(
          widget.barCount,
          (_) => _random.nextDouble() * (widget.circleDiameter / 2),
        );
      });
    })..start();

    // Escuta mudanças de play/pause
    _playingStream.listen((playing) {
      if (mounted) setState(() => _isPlaying = playing);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isPlaying ? 1 : 0.4,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: widget.circleDiameter,
            height: widget.circleDiameter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(widget.barCount, (index) {
                return AnimatedContainer(
                  duration: widget.animationSpeed,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  height: _barHeights[index],
                  width: 4,
                  decoration: BoxDecoration(
                    color: kColor2.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: kColor3.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
