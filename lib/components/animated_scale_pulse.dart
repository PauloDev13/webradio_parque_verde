import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedScalePulse extends StatefulWidget {
  final Widget child;
  final bool playing;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const AnimatedScalePulse({
    super.key,
    required this.child,
    required this.playing,
    this.duration = const Duration(seconds: 3),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<AnimatedScalePulse> createState() => _AnimatedScalePulseState();
}

class _AnimatedScalePulseState extends State<AnimatedScalePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();
  double _currentTarget = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _generateNewScale();
    _controller.forward();
    _controller.addStatusListener(_onStatusChange);
  }

  void _onStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _generateNewScale();
      _controller.forward(from: 0.0);
    }
  }

  void _generateNewScale() {
    final nextScale =
        widget.minScale +
        _random.nextDouble() * (widget.maxScale - widget.minScale);
    _scaleAnimation = Tween<double>(
      begin: _currentTarget,
      end: nextScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _currentTarget = nextScale;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playing) {
      return AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      );
    } else {
      return SizedBox(child: widget.child);
    }
  }
}
