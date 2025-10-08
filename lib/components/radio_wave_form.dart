import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AnimatedGradientRadioVisualizer extends StatefulWidget {
  final AudioPlayer player;
  final int barCount;
  final double maxHeight;
  final List<Color> gradientColors;
  final Duration animationSpeed;
  final Duration colorCycleDuration;

  const AnimatedGradientRadioVisualizer({
    super.key,
    required this.player,
    this.barCount = 20,
    this.maxHeight = 100,
    this.gradientColors = const [
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.blueAccent,
    ],
    this.animationSpeed = const Duration(milliseconds: 300),
    this.colorCycleDuration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedGradientRadioVisualizer> createState() =>
      _AnimatedGradientRadioVisualizerState();
}

class _AnimatedGradientRadioVisualizerState
    extends State<AnimatedGradientRadioVisualizer>
    with TickerProviderStateMixin {
  late List<double> _barHeights;
  late final Random _random;
  bool _isPlaying = false;

  late final AnimationController _colorController;
  late final AnimationController _heightTicker;
  late final Animation<Color?> _colorAnimation1;
  late final Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();

    _random = Random();
    _barHeights = List.generate(widget.barCount, (_) => 5.0);

    // controla o ciclo de cores
    _colorController = AnimationController(
      vsync: this,
      duration: widget.colorCycleDuration,
    )..repeat(reverse: true);

    _colorAnimation1 = ColorTween(
      begin: widget.gradientColors.first,
      end: widget.gradientColors[1 % widget.gradientColors.length],
    ).animate(_colorController);

    _colorAnimation2 = ColorTween(
      begin: widget.gradientColors[1 % widget.gradientColors.length],
      end: widget.gradientColors[2 % widget.gradientColors.length],
    ).animate(_colorController);

    // controla as alturas das barras
    _heightTicker = AnimationController(
      vsync: this,
      duration: widget.animationSpeed,
    )..addListener(_updateBars);

    widget.player.playingStream.listen((playing) {
      setState(() {
        _isPlaying = playing;
        if (playing) {
          _heightTicker.repeat(reverse: true);
        } else {
          _heightTicker.stop();
        }
      });
    });
  }

  void _updateBars() {
    if (_isPlaying) {
      setState(() {
        _barHeights = List.generate(
          widget.barCount,
          (_) => _random.nextDouble() * widget.maxHeight,
        );
      });
    }
  }

  @override
  void dispose() {
    _colorController.dispose();
    _heightTicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorController,
      builder: (context, _) {
        final color1 = _colorAnimation1.value ?? widget.gradientColors.first;
        final color2 = _colorAnimation2.value ?? widget.gradientColors.last;

        return AnimatedOpacity(
          opacity: _isPlaying ? 1 : 0.4,
          duration: const Duration(milliseconds: 300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.barCount, (index) {
              return AnimatedContainer(
                duration: widget.animationSpeed,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: _barHeights[index],
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [color1, color2],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
