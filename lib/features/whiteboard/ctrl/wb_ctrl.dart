import 'package:flutter/material.dart';
import 'package:game_hub/features/whiteboard/whiteboard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../draw_point.dart';

final whiteBoardCtrlProvider =
    StateNotifierProvider.autoDispose<WhiteBoardCtrlNotifier, DrawingState>(
        (ref) {
  return WhiteBoardCtrlNotifier();
});

class WhiteBoardCtrlNotifier extends StateNotifier<DrawingState> {
  WhiteBoardCtrlNotifier() : super(DrawingState.empty);

  setMode(DrawMode mode) => state = state.copyWith(selectedMode: mode);
  setStrokeWidth(double width) => state = state.copyWith(strokeWidth: width);
  toggleIsFilled(bool isFilled) => state = state.copyWith(isFilled: isFilled);
  setColor(Color color) => state = state.copyWith(selectedColor: color);

  undo() {
    if (state.points.isEmpty) return;

    state = state.copyWith(
      undoHistory: [...state.undoHistory, state.points.last],
    );
    state = state.copyWith(
      points: [
        for (final p in state.points)
          if (p.id != state.points.last.id) p
      ],
    );
  }

  redo() {
    if (state.undoHistory.isEmpty) return;

    state = state.copyWith(
      points: [...state.points, state.undoHistory.last],
    );
    state = state.copyWith(
      undoHistory: [
        for (final p in state.undoHistory)
          if (p.id != state.points.last.id) p
      ],
    );
  }

  clearCanvas([bool fullClear = false]) {
    return state = state.copyWith(
      points: List.empty(),
      undoHistory: fullClear ? List.empty() : state.points,
    );
  }

  addPoint(Offset offset) {
    final point = DrawPoint(
      id: DateTime.now().microsecond,
      offsets: [offset],
      stockWidth: state.strokeWidth,
      color: state.selectedColor,
      mode: state.selectedMode,
      filled: state.isFilled,
    );

    state = state.copyWith(currentPoint: () => point);
    _addCurrentToPoints(false);
  }

  updateCurrent(Offset? offset) {
    if (state.currentPoint == null) return;
    state = state.copyWith(
      currentPoint: () =>
          offset == null ? null : state.currentPoint!.addOffset(offset),
    );
    _addCurrentToPoints(true);
  }

  _addCurrentToPoints(bool update) {
    if (state.currentPoint == null) return;
    if (update) {
      List<DrawPoint> points = state.points;
      points.last = state.currentPoint!;
      state = state.copyWith(points: points);
    } else {
      state = state.copyWith(points: [...state.points, state.currentPoint!]);
    }
  }
}

class DrawingState {
  const DrawingState({
    required this.points,
    required this.undoHistory,
    required this.selectedColor,
    required this.selectedMode,
    required this.strokeWidth,
    required this.isFilled,
    required this.currentPoint,
  });

  static final DrawingState empty = DrawingState(
    points: [],
    undoHistory: [],
    selectedColor: availableColors.first,
    selectedMode: DrawMode.pen,
    strokeWidth: 5,
    isFilled: false,
    currentPoint: null,
  );

  final DrawPoint? currentPoint;
  final bool isFilled;
  final List<DrawPoint> points;
  final Color selectedColor;
  final DrawMode selectedMode;
  final double strokeWidth;
  final List<DrawPoint> undoHistory;

  DrawingState copyWith({
    DrawPoint? Function()? currentPoint,
    bool? isFilled,
    List<DrawPoint>? points,
    Color? selectedColor,
    DrawMode? selectedMode,
    double? strokeWidth,
    List<DrawPoint>? undoHistory,
  }) {
    return DrawingState(
      currentPoint: currentPoint == null ? this.currentPoint : currentPoint(),
      isFilled: isFilled ?? this.isFilled,
      points: points ?? this.points,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedMode: selectedMode ?? this.selectedMode,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      undoHistory: undoHistory ?? this.undoHistory,
    );
  }
}
