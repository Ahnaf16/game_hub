import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DrawPoint {
  DrawPoint({
    required this.id,
    required this.offsets,
    this.color = Colors.black,
    this.stockWidth = 5,
  });

  final int id;
  final List<Offset> offsets;
  final Color color;
  final double stockWidth;

  addOffset(Offset offset) => DrawPoint(
        id: id,
        offsets: offsets..add(offset),
        color: color,
        stockWidth: stockWidth,
      );
}

enum DrawMode {
  pen,
  marker,
  eraser,
  line,
  square,
  circle,
  triangle;

  const DrawMode();

  IconData get icon => switch (this) {
        pen => Icons.edit_outlined,
        marker => MdiIcons.marker,
        eraser => MdiIcons.eraser,
        line => MdiIcons.minus,
        square => MdiIcons.squareOutline,
        circle => Icons.circle_outlined,
        triangle => MdiIcons.triangleOutline,
      };
}
