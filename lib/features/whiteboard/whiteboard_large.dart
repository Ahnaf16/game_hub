import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_hub/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'draw_point.dart';
import 'painter.dart';

const availableColors = Colors.accents;

class WhiteBoardLarge extends HookConsumerWidget {
  const WhiteBoardLarge(this.availableColors, {super.key});

  final List<Color> availableColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = useState(<DrawPoint>[]);
    final eraserPoints = useState(<Offset>[]);
    final undoHistory = useState(<DrawPoint>[]);
    final selectedColor = useState(availableColors.first);
    final selectedMode = useState(DrawMode.pen);
    final strokeWidth = useState(5.0);
    final isFilled = useState(false);
    final currentPoint = useState<DrawPoint?>(null);
    final key = useMemoized(GlobalKey.new);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          IconButton(
            onPressed: () {
              log(points.value.length.toString());
            },
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stroke'),
                    Slider(
                      label: '${strokeWidth.value.floor()}',
                      divisions: 50,
                      value: strokeWidth.value,
                      max: 50,
                      onChanged: (value) => strokeWidth.value = value,
                    ),
                    const SizedBox(height: 10),
                    const Text('Colors'),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        ...availableColors.map(
                          (e) => Stack(
                            children: [
                              InkWell(
                                onTap: () => selectedColor.value = e,
                                child: Container(
                                  clipBehavior: Clip.none,
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: e,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: context.colorTheme.outline,
                                    ),
                                  ),
                                ),
                              ),
                              if (e == selectedColor.value)
                                Positioned.fill(
                                  child: Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: e.computeLuminance() > .5
                                          ? context.colorTheme.primary
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Styles'),
                    const SizedBox(height: 5),
                    SegmentedButton<int>(
                      segments: [
                        ButtonSegment(
                          value: 0,
                          icon: Icon(MdiIcons.square),
                          label: const Text('Filled'),
                        ),
                        ButtonSegment(
                          value: 1,
                          icon: Icon(MdiIcons.squareOutline),
                          label: const Text('Stroked'),
                        ),
                      ],
                      selected: {isFilled.value ? 0 : 1},
                      onSelectionChanged: (value) {
                        isFilled.value = value.contains(0);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Tools'),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        KIconButton(
                          icon: Icons.undo_rounded,
                          label: 'undo',
                          onPressed: () {
                            if (points.value.isEmpty) return;
                            undoHistory.value.add(points.value.last);
                            points.value.removeLast();
                          },
                        ),
                        KIconButton(
                          icon: Icons.redo_rounded,
                          label: 'redo',
                          onPressed: () {
                            if (undoHistory.value.isEmpty) return;
                            points.value.add(undoHistory.value.last);
                            undoHistory.value.removeLast();
                          },
                        ),
                        KIconButton(
                          icon: Icons.delete_outline,
                          label: 'clear canvas',
                          onPressed: () {
                            if (points.value.isEmpty) return;
                            undoHistory.value.addAll(points.value);
                            points.value.clear();
                            currentPoint.value = null;
                          },
                          warning: true,
                        ),
                        KIconButton(
                          icon: Icons.delete_forever_outlined,
                          label: 'clear canvas with history',
                          onPressed: () {
                            undoHistory.value.clear();
                            points.value.clear();
                            currentPoint.value = null;
                          },
                          warning: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Shapes'),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        ...DrawMode.values.map(
                          (e) => KIconButton(
                            icon: e.icon,
                            label: e.name,
                            onPressed: () => selectedMode.value = e,
                            selected: e == selectedMode.value,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Card(
              elevation: 3,
              child: GestureDetector(
                onPanStart: (details) {
                  currentPoint.value = DrawPoint(
                    id: DateTime.now().microsecond,
                    offsets: [details.localPosition],
                    stockWidth: strokeWidth.value,
                    color: selectedColor.value,
                    mode: selectedMode.value,
                    filled: isFilled.value,
                  );

                  if (currentPoint.value == null) return;

                  points.value.add(currentPoint.value!);
                },
                onPanUpdate: (details) {
                  if (currentPoint.value == null) return;
                  currentPoint.value =
                      currentPoint.value!.addOffset(details.localPosition);

                  points.value.last = currentPoint.value!;
                },
                onPanEnd: (d) {
                  currentPoint.value = null;
                },
                child: CustomPaint(
                  key: key,
                  painter: WhiteBoardPainter(points.value, eraserPoints.value),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KIconButton extends StatelessWidget {
  const KIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.label,
    this.warning = false,
    this.selected = false,
  });

  const KIconButton.warn({
    super.key,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.label,
    this.selected = false,
  }) : warning = false;

  final void Function()? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final String? label;
  final bool warning;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Color bg = backgroundColor ?? context.colorTheme.surface;
    Color borderColor =
        warning ? context.colorTheme.error : context.colorTheme.outline;

    if (selected) {
      bg = context.colorTheme.primary.withOpacity(.1);
      borderColor = context.colorTheme.primary;
    }

    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: borderColor),
        ),
        backgroundColor: bg,
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: warning ? context.colorTheme.error : null),
      tooltip: label,
    );
  }
}
