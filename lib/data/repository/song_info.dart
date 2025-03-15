import 'dart:math' as math;
import 'package:flutter/material.dart';

class SongInfo extends StatelessWidget {
  final String imageUrl;
  final AnimationController rotationController;

  const SongInfo({super.key, required this.imageUrl, required this.rotationController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotationController,
      builder: (_, child) {
        return Transform.rotate(
          angle: rotationController.value * 2 * math.pi,
          child: child,
        );
      },
      child: ClipOval(
        child: Image.network(imageUrl, width: 250, height: 250, fit: BoxFit.cover),
      ),
    );
  }
}
