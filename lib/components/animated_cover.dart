import 'dart:math';

import 'package:flutter/material.dart';
import 'package:webradio_parque_verde/components/cover_image.dart';

class AnimatedCover extends StatefulWidget {
  final String coverUrl;
  const AnimatedCover({super.key, required this.coverUrl});

  @override
  State<AnimatedCover> createState() => _AnimatedCoverState();
}

class _AnimatedCoverState extends State<AnimatedCover>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();

  double _currentTarget = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

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
    final double nextScale = 0.95 + _random.nextDouble() * 0.1; // 0.95–1.05
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
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Cover(coverUrl: widget.coverUrl),
    );
  }
}
