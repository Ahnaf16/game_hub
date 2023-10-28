import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_hub/core/core.dart';
import 'package:game_hub/features/whiteboard/ctrl/wb_ctrl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'draw_point.dart';
import 'painter.dart';

class WhiteBoardLarge extends HookConsumerWidget {
  const WhiteBoardLarge(this.availableColors, {super.key});

  final List<Color> availableColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(whiteBoardCtrlProvider);
    final selectedColor = state.selectedColor;
    final selectedMode = state.selectedMode;
    final strokeWidth = state.strokeWidth;
    final isFilled = state.isFilled;

    final reader = useCallback(() => ref.read(whiteBoardCtrlProvider.notifier));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          IconButton(
            onPressed: () {},
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
                      label: '${strokeWidth.floor()}',
                      divisions: 50,
                      value: strokeWidth,
                      max: 50,
                      onChanged: (value) => reader.call().setStrokeWidth(value),
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
                                onTap: () => reader.call().setColor(e),
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
                              if (e == selectedColor)
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
                      selected: {isFilled ? 0 : 1},
                      onSelectionChanged: (value) {
                        reader.call().toggleIsFilled(value.contains(0));
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
                            reader.call().undo();
                          },
                        ),
                        KIconButton(
                          icon: Icons.redo_rounded,
                          label: 'redo',
                          onPressed: () {
                            reader.call().redo();
                          },
                        ),
                        KIconButton(
                          icon: Icons.delete_outline,
                          label: 'clear canvas',
                          onPressed: () {
                            reader.call().clearCanvas();
                          },
                          warning: true,
                        ),
                        KIconButton(
                          icon: Icons.delete_forever_outlined,
                          label: 'clear canvas with history',
                          onPressed: () {
                            reader.call().clearCanvas(true);
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
                            onPressed: () => reader.call().setMode(e),
                            selected: e == selectedMode,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //^ painter
          const Expanded(
            flex: 3,
            child: _PainterWidget(),
          ),
        ],
      ),
    );
  }
}

class _PainterWidget extends HookConsumerWidget {
  const _PainterWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reader = useCallback(() => ref.read(whiteBoardCtrlProvider.notifier));
    final state = ref.watch(whiteBoardCtrlProvider);
    final points = state.points;

    return Card(
      elevation: 3,
      child: GestureDetector(
        onPanStart: (details) {
          reader.call().addPoint(details.localPosition);
        },
        onPanUpdate: (details) {
          reader.call().updateCurrent(details.localPosition);
        },
        onPanEnd: (d) {
          reader.call().updateCurrent(null);
        },
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.all(15),
          child: CustomPaint(
            painter: WhiteBoardPainter(points),
            child: Container(
              constraints: const BoxConstraints.expand(),
            ),
          ),
        ),
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
