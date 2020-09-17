import 'dart:math';

import 'package:flutter/widgets.dart';

class ProgressPainter extends CustomPainter {
  final Color defaultCircleColor;
  final Color percentageCompletedCircleColor;
  final double completedPercentage;
  final double circleW;

  ProgressPainter({
    this.defaultCircleColor,
    this.percentageCompletedCircleColor,
    this.completedPercentage,
    this.circleW,
  });

  getPaint(Color color) {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleW;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint defaultCirclePaint = getPaint(defaultCircleColor);
    Paint progressCirclePaint = getPaint(percentageCompletedCircleColor);

    // Draw the default circle.
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, defaultCirclePaint);

    // Draw the completed circle (Arc).
    double arcAngle = 2 * pi * (completedPercentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      progressCirclePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }
}
