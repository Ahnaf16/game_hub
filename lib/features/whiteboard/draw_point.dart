import 'package:flutter/foundation.dart';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DrawPoint &&
        other.id == id &&
        listEquals(other.offsets, offsets) &&
        other.color == color &&
        other.stockWidth == stockWidth &&
        other.mode == mode &&
        other.filled == filled;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        offsets.hashCode ^
        color.hashCode ^
        stockWidth.hashCode ^
        mode.hashCode ^
        filled.hashCode;
  }
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
