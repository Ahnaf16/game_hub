import 'package:flutter/material.dart';
import 'package:game_hub/core/extension/context_extension.dart';

const availableColors = Colors.accents;

class WhiteBoard extends StatefulWidget {
  const WhiteBoard({super.key});

  @override
  State<WhiteBoard> createState() => _WhiteBoardState();
}

class _WhiteBoardState extends State<WhiteBoard> {
  List<DrawPoint> points = [];
  Color selectedColor = Colors.black;
  double stockWidth = 5;
  DrawPoint? currentPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanStart: (details) {
          currentPoint = DrawPoint(
            id: DateTime.now().microsecond,
            offsets: [details.localPosition],
            stockWidth: stockWidth,
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
          painter: _WhiteBoardPainter(points),
          child: Container(
            constraints: const BoxConstraints.expand(),
          ),
        ),
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
                IconButton.outlined(
                  onPressed: () => points.clear(),
                  icon: const Icon(Icons.clear),
                ),
                Flexible(
                  child: Slider(
                    value: stockWidth,
                    max: 50,
                    onChanged: (value) => setState(() => stockWidth = value),
                  ),
                )
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
                  coloredBoxBuilder(Colors.white),
                  coloredBoxBuilder(Colors.black),
                  ...availableColors.map((e) => coloredBoxBuilder(e)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector coloredBoxBuilder(Color color) {
    final borderColor = color == Colors.white ? Colors.black : Colors.white;
    final isSelected = color == selectedColor;

    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isSelected ? 35 : 30,
        width: isSelected ? 35 : 30,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: borderColor, width: 3) : null,
        ),
      ),
    );
  }
}

class _WhiteBoardPainter extends CustomPainter {
  _WhiteBoardPainter(this.points);

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
  bool shouldRepaint(_WhiteBoardPainter oldDelegate) => true;
}

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
