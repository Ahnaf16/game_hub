import 'package:flutter/material.dart';
import 'package:game_hub/core/extension/context_extension.dart';
import 'package:game_hub/features/whiteboard/whiteboard_large.dart';
import 'package:game_hub/features/whiteboard/whiteboard_small.dart';

const availableColors = [Colors.black, Colors.white, ...Colors.accents];

class WhiteBoard extends StatelessWidget {
  const WhiteBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return context.width < 1100
        ? const WhiteBoardSmall(availableColors)
        : const WhiteBoardLarge(availableColors);
  }
}

class ColoredBoxBuilder extends StatelessWidget {
  const ColoredBoxBuilder({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final Function(Color color) onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = color == Colors.white ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () => onTap(color),
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
