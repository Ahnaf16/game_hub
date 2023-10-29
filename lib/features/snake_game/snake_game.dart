import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  int row = 20;
  int column = 20;
  List<int> snakePosition = [];
  int snakeHade = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    snakePosition = [390, 389, 388];
    snakeHade = snakePosition.first;
    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
    });
    if (snakeHade == row * column) {
      timer.cancel();
    }
  }

  void updateSnake() {
    setState(() {
      snakePosition.insert(0, snakeHade + 1);
      snakeHade = snakePosition.first;
      snakePosition.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int grid = row * column;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton(
              onPressed: () {
                setState(() {
                  snakePosition.add(snakeHade + 1);
                  snakeHade = snakePosition.last;
                  snakePosition.removeAt(0);
                });
              },
              child: const Text('START'),
            ),
            IconButton(
              onPressed: () {
                dev.log(snakePosition.toString());
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
            Text('Score : $score'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: row,
              ),
              itemCount: grid,
              itemBuilder: (BuildContext context, int index) {
                Color color = Colors.blueGrey.shade200;
                if (snakePosition.contains(index)) {
                  color = Colors.blueGrey;
                }
                if (index == snakeHade) {
                  color = Colors.blueGrey.shade700;
                }

                return Container(
                  margin: const EdgeInsets.all(.5),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text('$index'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
