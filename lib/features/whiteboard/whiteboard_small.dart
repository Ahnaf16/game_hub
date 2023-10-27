import 'package:flutter/material.dart';
import 'package:game_hub/core/core.dart';

import 'draw_point.dart';
import 'painter.dart';
import 'whiteboard.dart';

class WhiteBoardSmall extends StatefulWidget {
  const WhiteBoardSmall(this.availableColors, {super.key});

  final List<Color> availableColors;

  @override
  State<WhiteBoardSmall> createState() => _WhiteBoardSmallState();
}

class _WhiteBoardSmallState extends State<WhiteBoardSmall> {
  List<DrawPoint> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  DrawPoint? currentPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Whiteboard')),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              currentPoint = DrawPoint(
                id: DateTime.now().microsecond,
                offsets: [details.localPosition],
                stockWidth: strokeWidth,
                color: selectedColor,
              );

              if (currentPoint == null) return;

              points.add(currentPoint!);
              setState(() {});
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentPoint == null) return;
                currentPoint = currentPoint?.addOffset(details.localPosition);
                points.last = currentPoint!;
              });
            },
            onPanCancel: () {
              setState(() {
                currentPoint = null;
              });
            },
            child: CustomPaint(
              painter: WhiteBoardPainter(points, []),
              child: Container(
                constraints: const BoxConstraints.expand(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 98,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                IconButton.filled(
                  onPressed: () => points.clear(),
                  icon: const Icon(Icons.undo_rounded),
                ),
                const SizedBox(width: 5),
                IconButton.filled(
                  onPressed: () => points.clear(),
                  icon: const Icon(Icons.redo_rounded),
                ),
                Flexible(
                  child: Slider(
                    label: '${strokeWidth.floor()}',
                    divisions: 50,
                    value: strokeWidth,
                    max: 50,
                    onChanged: (value) => setState(() => strokeWidth = value),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: context.colorTheme.error,
                  ),
                  onPressed: () => points.clear(),
                  icon: const Icon(Icons.delete_outline),
                ),
                const SizedBox(width: 5),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(5),
              height: 50,
              width: context.width,
              color: Colors.black54,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.availableColors.map(
                    (e) => ColoredBoxBuilder(
                      color: e,
                      isSelected: selectedColor == e,
                      onTap: (color) => setState(() => selectedColor = color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
