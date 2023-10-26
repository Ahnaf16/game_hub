import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  static const RouteName splash = RouteName('/splash');
  static const RouteName notFound = RouteName('/404');

  static const RouteName whiteboard = RouteName('/whiteboard');

  // static final shellRoutes = [mySelf, projects];
}

class RouteName {
  const RouteName(this.path, {String? name}) : _name = name;
  final String path;
  final String? _name;

  String get name => _name ?? path.replaceFirst('/', '').replaceAll('/', '_');

  Future<T?> push<T extends Object?>(BuildContext context, {Object? extra}) =>
      context.push(path, extra: extra);

  Future<T?> pushNamed<T extends Object?>(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    return context.pushNamed(
      name,
      extra: extra,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );
  }

  void go(BuildContext context, {Object? extra}) =>
      context.go(path, extra: extra);

  void goNamed(
    BuildContext context, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      context.goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
}
