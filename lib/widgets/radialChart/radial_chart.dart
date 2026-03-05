import 'package:baseproject/widgets/radialChart/constants.dart';
import 'package:baseproject/widgets/radialChart/radial_painter.dart';
import 'package:flutter/material.dart';

class RadialChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color lineColor;
  final double percent;

  const RadialChart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.percent,
    this.lineColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: CustomPaint(
            foregroundPainter: RadialPainter(
              bgColor: Colors.grey.withOpacity(0.15),
              lineColor: lineColor,
              percent: percent.clamp(0, 1),
              width: 7,
            ),
            child: Center(
              child: Text(
                "${(percent * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        )
      ],
    );
  }
}
