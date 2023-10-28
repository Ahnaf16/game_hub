import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawPoint {
  DrawPoint({
    required this.id,
    required this.offsets,
    this.color = Colors.black,
    this.stockWidth = 5,
    this.mode = DrawMode.pen,
    this.filled = false,
  });

  final int id;
  final List<Offset> offsets;
  final Color color;
  final double stockWidth;
  final DrawMode mode;
  final bool filled;

  addOffset(Offset offset) => DrawPoint(
        id: id,
        offsets: offsets..add(offset),
        color: color,
        stockWidth: stockWidth,
        mode: mode,
        filled: filled,
      );

  Paint paint() => Paint()
    ..color = color
    ..strokeWidth = stockWidth
    ..strokeCap = StrokeCap.round
    ..isAntiAlias = true
    ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;

  Path path() => Path()..moveTo(offsets.first.dx, offsets.first.dy);

  Rect rect() => Rect.fromPoints(offsets.first, offsets.last);
}

enum DrawMode {
  pen,
  bucket,
  eraser,
  line,
  square,
  circle;

  const DrawMode();

  IconData get icon => switch (this) {
        pen => Icons.edit_outlined,
        bucket => Icons.format_color_fill_rounded,
        eraser => MdiIcons.eraser,
        line => MdiIcons.minus,
        square => MdiIcons.squareOutline,
        circle => Icons.circle_outlined,
      };
}
