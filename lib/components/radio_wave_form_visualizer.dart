import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';

class RadioWaveformVisualizer extends StatefulWidget {
  final AudioPlayer player;
  final int barCount;
  final double maxHeight;
  final Color color;
  final Duration animationSpeed;

  const RadioWaveformVisualizer({
    super.key,
    required this.player,
    this.barCount = 20,
    this.maxHeight = 40,
    this.color = Colors.greenAccent,
    this.animationSpeed = const Duration(milliseconds: 300),
  });

  @override
  State<RadioWaveformVisualizer> createState() =>
      _RadioWaveformVisualizerState();
}

class _RadioWaveformVisualizerState extends State<RadioWaveformVisualizer>
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
          (_) => _random.nextDouble() * widget.maxHeight,
        );
      });
    })..start();

    // Escuta mudanças de play/pause
    _playingStream.listen((playing) {
      setState(() => _isPlaying = playing);
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
      child: ClipOval(
        child: Container(
          width: widget.maxHeight * .5,
          height: widget.maxHeight * .5,
          color: Colors.black.withValues(alpha: 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.barCount, (index) {
              return AnimatedContainer(
                duration: widget.animationSpeed,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                height: _barHeights[index],
                width: 5,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
