// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AccelerometerMeterPainter extends CustomPainter {
  final double xValue;
  final double yValue;
  final double zValue;
  final bool isActive;

  AccelerometerMeterPainter({
    required this.xValue,
    required this.yValue,
    required this.zValue,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw background circles for the gauge
    _drawGaugeBackgrounds(canvas, center, radius);

    if (!isActive) return;

    // Draw needle for x value (horizontal movement)
    _drawNeedle(canvas, center, radius * 0.8, xValue, Colors.red);

    // Draw needle for y value (vertical movement)
    _drawNeedle(canvas, center, radius * 0.65, yValue, Colors.green);

    // Draw needle for z value (depth movement - smaller inner circle)
    _drawNeedle(canvas, center, radius * 0.5, zValue, Colors.blue);
  }

  void _drawGaugeBackgrounds(Canvas canvas, Offset center, double radius) {
    // Outer ring - X axis
    final Paint xAxisPaint = Paint()
      ..color = Colors.red.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;
    canvas.drawCircle(center, radius * 0.8, xAxisPaint);

    // Middle ring - Y axis
    final Paint yAxisPaint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;
    canvas.drawCircle(center, radius * 0.65, yAxisPaint);

    // Inner ring - Z axis
    final Paint zAxisPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1;
    canvas.drawCircle(center, radius * 0.5, zAxisPaint);

    // Draw ticks and labels
    _drawTicksAndLabels(canvas, center, radius);
  }

  void _drawTicksAndLabels(Canvas canvas, Offset center, double radius) {
    final Paint tickPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    // Draw major ticks at -10, -5, 0, 5, 10
    for (int i = -10; i <= 10; i += 5) {
      double angle = _valueToAngle(i.toDouble());

      // Outer ticks (X axis)
      Offset start = _polarToCartesian(center, radius * 0.85, angle);
      Offset end = _polarToCartesian(center, radius * 0.75, angle);
      canvas.drawLine(start, end, tickPaint);

      // Middle ticks (Y axis)
      start = _polarToCartesian(center, radius * 0.7, angle);
      end = _polarToCartesian(center, radius * 0.6, angle);
      canvas.drawLine(start, end, tickPaint);

      // Inner ticks (Z axis)
      start = _polarToCartesian(center, radius * 0.55, angle);
      end = _polarToCartesian(center, radius * 0.45, angle);
      canvas.drawLine(start, end, tickPaint);

      // Draw labels at major ticks
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      Offset labelPosition = _polarToCartesian(
        center,
        radius * 0.9,
        angle,
      );
      labelPosition = Offset(
        labelPosition.dx - textPainter.width / 2,
        labelPosition.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelPosition);
    }
  }

  void _drawNeedle(
      Canvas canvas, Offset center, double radius, double value, Color color) {
    // Calculate angle from value
    final double angle = _valueToAngle(value);

    // Create needle path
    final Path needlePath = Path();
    needlePath.moveTo(center.dx, center.dy);

    // Needle point
    final Offset needlePoint = _polarToCartesian(center, radius, angle);
    needlePath.lineTo(needlePoint.dx, needlePoint.dy);

    // Draw the needle
    final Paint needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(needlePath, needlePaint);

    // Draw a small circle at the center
    final Paint centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);

    // Draw value at needle tip
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(1),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    Offset textPosition = _polarToCartesian(center, radius + 15, angle);
    textPosition = Offset(
      textPosition.dx - textPainter.width / 2,
      textPosition.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textPosition);
  }

  // Helper methods
  double _valueToAngle(double value) {
    // Convert acceleration value to angle (map -10...10 to 180...0 degrees)
    return math.pi - (((value + 10) / 20) * math.pi);
  }

  Offset _polarToCartesian(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(AccelerometerMeterPainter oldDelegate) {
    return oldDelegate.xValue != xValue ||
        oldDelegate.yValue != yValue ||
        oldDelegate.zValue != zValue ||
        oldDelegate.isActive != isActive;
  }
}
