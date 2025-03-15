import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration totalDuration;
  final Function(Duration) onSeek;

  const ProgressBar({super.key, required this.currentPosition, required this.totalDuration, required this.onSeek});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          min: 0,
          max: totalDuration.inSeconds.toDouble(),
          value: currentPosition.inSeconds.toDouble(),
          onChanged: (value) => onSeek(Duration(seconds: value.toInt())),
        ),
      ],
    );
  }
}
