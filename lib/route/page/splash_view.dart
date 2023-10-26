import 'package:flutter/material.dart';
import 'package:game_hub/core/core.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'S P L A S H',
              style: context.textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}
