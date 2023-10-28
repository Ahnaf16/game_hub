import 'dart:ui';

import 'package:flutter/material.dart';

import 'draw_point.dart';

class WhiteBoardPainter extends CustomPainter {
  WhiteBoardPainter(this.points);

  final List<DrawPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      Paint paint = point.paint();

      final offsets = point.offsets;
      final path = point.path();

      Rect rect = point.rect();

      for (var i = 0; i < offsets.length; i++) {
        final isNotLast = i != offsets.length - 1;

        final current = offsets[i];

        if (isNotLast) {
          final next = offsets[i + 1];
          path.quadraticBezierTo(
            current.dx,
            current.dy,
            (current.dx + next.dx) / 2,
            (current.dy + next.dy) / 2,
          );
        }

        switch (point.mode) {
          case DrawMode.pen:
            if (isNotLast) {
              canvas.drawPath(path, paint);
            } else {
              canvas.drawPoints(PointMode.points, [current], paint);
            }
          case DrawMode.bucket:
            rect = Rect.fromLTRB(0, 0, size.width, size.height);
            paint.style = PaintingStyle.fill;
            canvas.drawRect(rect, paint);
          case DrawMode.eraser:
            canvas.drawPath(path, paint..color = Colors.white);

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
