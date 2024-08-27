import 'package:baseproject/widgets/radialChart/constants.dart';
import 'package:baseproject/widgets/radialChart/radial_painter.dart';
import 'package:flutter/material.dart';

class RadialChart extends StatelessWidget {
  final String title;
  final Color lineColor;
  final double percent; // Added parameter to make it more flexible

  const RadialChart({
    Key? key,
    required this.title,
    this.lineColor = Colors.blueAccent,
    this.percent = 0.7, // Default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var chartSize =
            constraints.maxWidth * 0.6; // Adjusted for grid item size
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: chartSize,
                  width: chartSize,
                  child: CustomPaint(
                    foregroundPainter: RadialPainter(
                      bgColor: textColor.withOpacity(0.1),
                      lineColor: lineColor,
                      percent: percent,
                      width: 8.0,
                    ),
                    child: Center(
                      child: Text(
                        '${(percent * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Space between chart and text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: lineColor,
                      size: 10,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
