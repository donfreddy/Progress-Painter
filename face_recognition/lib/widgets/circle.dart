
import 'package:face_recognition/style.dart';
import 'package:flutter/material.dart';

class CircleTop extends CustomPainter {
  Paint _paint;

  CircleTop() {
    _paint = Paint()
      ..color = orangeColor
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 100.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleBottom extends CustomPainter {
  Paint _paint;

  CircleBottom() {
    _paint = Paint()
      ..color = orangeColor.withOpacity(0.2)
      //..color = orangeColor
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(-30, 20), 300.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
