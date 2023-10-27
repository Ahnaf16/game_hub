import 'package:flutter/material.dart';

import 'draw_point.dart';

class WhiteBoardPainter extends CustomPainter {
  WhiteBoardPainter(this.points);

  final List<DrawPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      final paint = Paint()
        ..color = point.color
        ..strokeWidth = point.stockWidth
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      for (var i = 0; i < point.offsets.length; i++) {
        final isNotLast = i != point.offsets.length - 1;

        if (isNotLast) {
          final current = point.offsets[i];
          final next = point.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(WhiteBoardPainter oldDelegate) => true;
}
