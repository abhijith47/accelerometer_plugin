import 'package:flutter/material.dart';
import 'custom_meter_painter.dart';

class AccelerometerMeterDisplay extends StatelessWidget {
  final double xValue;
  final double yValue;
  final double zValue;

  final bool isActive;

  const AccelerometerMeterDisplay({
    super.key,
    required this.xValue,
    required this.yValue,
    required this.zValue,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main meter display
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular meter background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),

              // X, Y, Z visualization using custom painter
              CustomPaint(
                painter: AccelerometerMeterPainter(
                  xValue: xValue,
                  yValue: yValue,
                  zValue: zValue,
                  isActive: isActive,
                ),
                size: Size.square(300),
              ),

              // Center label showing magnitude
            ],
          ),
        ),

        SizedBox(height: 24),

        // Detailed readings in cards
        Row(
          children: [
            Expanded(child: _buildAxisCard('X-Axis', xValue, Colors.red)),
            SizedBox(width: 8),
            Expanded(child: _buildAxisCard('Y-Axis', yValue, Colors.green)),
            SizedBox(width: 8),
            Expanded(child: _buildAxisCard('Z-Axis', zValue, Colors.blue)),
          ],
        ),
      ],
    );
  }

  Widget _buildAxisCard(String axis, double value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              axis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: _normalizeForProgress(value),
              // ignore: deprecated_member_use
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  double _normalizeForProgress(double value) {
    // Convert acceleration in range of approximately -10 to 10 to a 0-1 range for progress indicator
    return ((value + 10) / 20).clamp(0.0, 1.0);
  }
}
