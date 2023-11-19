import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:game_hub/core/util/utility.dart';
import 'package:game_hub/route/route_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'theme/app_theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      scaffoldMessengerKey: Utility.key,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(routesProvider),
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
