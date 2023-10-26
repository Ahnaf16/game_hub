import 'package:flutter/material.dart';
import 'package:game_hub/route/page/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/whiteboard.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
// final GlobalKey<NavigatorState> _shellNavigator =
//     GlobalKey(debugLabel: 'shell');

final routesProvider = Provider.autoDispose<GoRouter>((ref) {
  final routeList = ref.watch(routes);
  final router = GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: RouteNames.whiteboard.path,
    routes: routeList,
  );

  return router;
});

final routes = Provider<List<RouteBase>>(
  (ref) => [
    GoRoute(
      path: RouteNames.splash.path,
      name: RouteNames.splash.name,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: RouteNames.whiteboard.path,
      name: RouteNames.whiteboard.name,
      builder: (context, state) => const WhiteBoard(),
    ),
  ],
);
