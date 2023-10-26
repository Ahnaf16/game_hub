import 'package:flutter/material.dart';
import 'package:game_hub/route/route_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routesProvider),
      theme: ThemeData.light(
        useMaterial3: true,
      ),
    );
  }
}
