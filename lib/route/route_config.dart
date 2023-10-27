import 'package:flutter/material.dart';
import 'package:game_hub/features/home/home_view.dart';
import 'package:game_hub/features/snake_game/snake_game.dart';
import 'package:game_hub/route/page/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/whiteboard/whiteboard.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
// final GlobalKey<NavigatorState> _shellNavigator =
//     GlobalKey(debugLabel: 'shell');

final routesProvider = Provider.autoDispose<GoRouter>((ref) {
  final routeList = ref.watch(routes);
  final router = GoRouter(
    navigatorKey: _rootNavigator,
    initialLocation: RouteNames.home.path,
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
        path: RouteNames.home.path,
        name: RouteNames.home.name,
        builder: (context, state) => const HomePageView(),
        routes: [
          GoRoute(
            path: RouteNames.whiteboard.path,
            name: RouteNames.whiteboard.name,
            pageBuilder: (context, state) =>
                _pageBuilder(child: const WhiteBoard()),
          ),
          GoRoute(
            path: RouteNames.snake.path,
            name: RouteNames.snake.name,
            pageBuilder: (context, state) =>
                _pageBuilder(child: const SnakeGame()),
          ),
        ]),
  ],
);

Page<dynamic> _pageBuilder({required Widget child}) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: _kTransition,
  );
}

Widget _kTransition(context, animation, secondaryAnimation, child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  final tween = Tween(begin: begin, end: end);
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
