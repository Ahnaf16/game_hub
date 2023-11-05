import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:game_hub/core/core.dart';

enum GameState { idle, start, over }

enum SnakeDir { up, down, left, right }

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  Timer? timer;
  int row = 20;
  int column = 20;
  List<int> snakePosition = [];
  int snakeHade = 0;
  late int food;
  int score = 0;
  Duration time = Duration.zero;
  GameState state = GameState.idle;
  //
  SnakeDir dir = SnakeDir.down;

  @override
  void initState() {
    super.initState();
    init();
    startGame();
    spawnFood();
  }

  void init() {
    final r = Random().nextInt(row * column);
    snakePosition = [r, r - 1, r - 2];
    snakeHade = snakePosition.first;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void spawnFood() {
    final r = Random().nextInt(row * column);
    if (snakePosition.contains(r)) {
      spawnFood();
    }
    food = r;
  }

  void startGame() {
    if (state == GameState.idle) return;
    if (timer != null) return;
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      time = time + const Duration(seconds: 1);
      updateSnake();
    });
  }

  void updateSnake() {
    setState(() {
      final selfColl =
          snakePosition.where((element) => element == snakeHade).length;

      if (selfColl != 1) state = GameState.over;

      if (state == GameState.over) {
        timer?.cancel();
        return;
      }

      if (snakeHade == (row * column) - 1) snakeHade = -1;

      if (snakeHade == food) {
        score++;
        snakePosition = [food, ...snakePosition];
        spawnFood();
      }

      if (dir == SnakeDir.up) {
        /// check if next hades position is outside the bound
        if ((snakeHade - row).isNegative) {
          snakeHade = (row * column) + (snakeHade - row) - 1;
          log((snakeHade).toString());
        }
        snakeHade = snakeHade - row - 1;
      }

      if (dir == SnakeDir.down) {
        /// check if next hades position is outside the bound
        if (snakeHade + row > (row * column)) {
          snakeHade = snakeHade - row * column + 1;
        }
        snakeHade = snakeHade + row - 1;
      }

      if (dir == SnakeDir.left) {
        snakeHade--;
      }
      if (dir != SnakeDir.left) {
        snakeHade++;
      }

      snakePosition.insert(0, snakeHade);
      snakePosition.removeLast();
    });
  }

  void reset() {
    setState(() {
      timer?.cancel();
      timer = null;
      score = 0;
      time = Duration.zero;
      dir = SnakeDir.right;
      state = GameState.idle;
      snakePosition.clear();
    });
    init();
    startGame();
    spawnFood();
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
                state = GameState.start;
                startGame();
              },
              child: const Text('START'),
            ),
            IconButton(
              onPressed: () {
                reset();
              },
              icon: const Icon(Icons.refresh_rounded),
            ),
            Text('Score : $score'),
            Text('Time : $time'),
          ],
        ),
      ),
      // floatingActionButtonLocation: ,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.outlined(
            onPressed: () => setState(() => dir = SnakeDir.up),
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.outlined(
                onPressed: () => setState(() => dir = SnakeDir.left),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                onPressed: () => setState(() => dir = SnakeDir.right),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
          IconButton.outlined(
            onPressed: () => setState(() => dir = SnakeDir.down),
            icon: const Icon(Icons.arrow_downward_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: row,
                ),
                itemCount: grid,
                itemBuilder: (BuildContext context, int index) {
                  Color color = Colors.blueGrey.shade200;
                  if (snakePosition.contains(index)) {
                    color = Colors.blueGrey;
                  }
                  if (index == food) {
                    color = Colors.red;
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
                    child: Text('$index', style: context.textTheme.bodySmall),
                  );
                },
              ),
              if (state == GameState.over)
                SizedBox(
                  height: 200,
                  width: context.width / 1.5,
                  child: Card(
                    color: context.colorTheme.surface.withOpacity(.8),
                    child: Center(
                      child: Text(
                        'Game Over',
                        style: context.textTheme.headlineMedium,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
