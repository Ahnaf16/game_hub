import 'dart:ui';

import 'package:flutter/material.dart';

import 'draw_point.dart';

class WhiteBoardPainter extends CustomPainter {
  WhiteBoardPainter(this.points, this.eraserPoints);

  final List<DrawPoint> points;
  final List<Offset> eraserPoints;

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      Paint paint = Paint()
        ..color = point.color
        ..strokeWidth = point.stockWidth
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..style = point.filled ? PaintingStyle.fill : PaintingStyle.stroke;

      final offsets = point.offsets;
      final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);

      Rect rect = Rect.fromPoints(offsets.first, offsets.last);

      for (var i = 0; i < offsets.length; i++) {
        final isNotLast = i != offsets.length - 1;

        final current = offsets[i];

        switch (point.mode) {
          case DrawMode.pen:
            if (isNotLast) {
              final next = offsets[i + 1];
              path.quadraticBezierTo(
                current.dx,
                current.dy,
                (current.dx + next.dx) / 2,
                (current.dy + next.dy) / 2,
              );
              canvas.drawPath(path, paint);
            } else {
              canvas.drawPoints(PointMode.points, [current], paint);
            }
          case DrawMode.bucket:
            rect = Rect.fromLTRB(0, 0, size.width, size.height);
            paint.style = PaintingStyle.fill;
            canvas.drawRect(rect, paint);
          case DrawMode.eraser:
            break;
          case DrawMode.line:
            canvas.drawLine(offsets.first, offsets.last, paint);
          case DrawMode.square:
            canvas.drawRect(rect, paint);
          case DrawMode.circle:
            canvas.drawOval(rect, paint);

          default:
        }
      }
    }
  }

  @override
  bool shouldRepaint(WhiteBoardPainter oldDelegate) => true;
}
