import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_hub/core/core.dart';

enum MassageType {
  info,
  warning,
  error,
  loading,
  success;
}

class Utility {
  const Utility._();

  static final key = GlobalKey<ScaffoldMessengerState>();

  static showLoading(
    String? msg, {
    ValueNotifier<double>? progress,
    TextStyle? style,
    void Function()? onDismiss,
    SnackBarBehavior? behavior,
    String? dismissLabel,
  }) {
    if (msg == null) return null;

    final snackBar = _snakeBuilder(
      msg,
      progress: progress,
      type: MassageType.loading,
      style: style,
      duration: const Duration(days: 365),
      behavior: behavior,
      autoDismiss: false,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
    );

    return _show(snackBar);
  }

  static ScaffoldFeatureController? showInfo(
    String? info, {
    TextStyle? style,
    bool autoDismiss = true,
    Duration? duration,
    void Function()? onDismiss,
    SnackBarBehavior? behavior,
    String? dismissLabel,
  }) {
    if (info == null) return null;

    duration ??= _kDifDuration;

    if (!autoDismiss) duration = const Duration(days: 365);

    final snackBar = _snakeBuilder(
      info,
      type: MassageType.info,
      style: style,
      duration: duration,
      behavior: behavior,
      autoDismiss: autoDismiss,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
    );

    return _show(snackBar);
  }

  static showSuccess(
    String? massage, {
    TextStyle? style,
    void Function()? onDismiss,
    SnackBarBehavior? behavior,
    String? dismissLabel,
  }) {
    if (massage == null) return null;

    final snackBar = _snakeBuilder(
      massage,
      type: MassageType.success,
      style: style,
      duration: _kDifDuration,
      behavior: behavior,
      autoDismiss: true,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
    );

    return _show(snackBar);
  }

  static showWarning(
    String? warning, {
    TextStyle? style,
    bool autoDismiss = true,
    Duration? duration,
    void Function()? onDismiss,
    SnackBarBehavior? behavior,
    String? dismissLabel,
  }) {
    if (warning == null) return null;

    final snackBar = _snakeBuilder(
      warning,
      type: MassageType.warning,
      style: style,
      duration: duration ?? _kDifDuration,
      behavior: behavior,
      autoDismiss: autoDismiss,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
    );

    return _show(snackBar);
  }

  static showError(
    Object? error, {
    TextStyle? style,
    void Function()? onDismiss,
    SnackBarBehavior? behavior,
    String? dismissLabel,
  }) {
    if (error == null) return null;

    final snackBar = _snakeBuilder(
      error.toString(),
      type: MassageType.error,
      style: style,
      duration: const Duration(days: 365),
      behavior: behavior,
      autoDismiss: false,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
    );

    return _show(snackBar);
  }

  static SnackBar _snakeBuilder(
    String info, {
    required MassageType type,
    TextStyle? style,
    required Duration duration,
    SnackBarBehavior? behavior,
    required bool autoDismiss,
    void Function()? onDismiss,
    ValueNotifier<double>? progress,
    String? dismissLabel,
  }) {
    final leading = HookBuilder(
      builder: (context) {
        final value = progress == null ? null : useValueListenable(progress);
        return switch (type) {
          MassageType.info => Icon(
              Icons.info_outline_rounded,
              color: context.colorTheme.surface,
            ),
          MassageType.warning => Icon(
              Icons.warning_amber_rounded,
              color: context.isDark ? Colors.amber.shade800 : Colors.amber,
            ),
          MassageType.error => Icon(
              Icons.cancel_rounded,
              color: context.isDark
                  ? context.colorTheme.onError
                  : context.colorTheme.errorContainer,
            ),
          MassageType.success => Icon(
              Icons.check_rounded,
              color: context.colorTheme.surface,
            ),
          MassageType.loading => SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(value: value),
            ),
        };
      },
    );

    final snackBar = SnackBar(
      content: Row(
        children: [
          leading,
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(info, style: style),
            ),
          ),
        ],
      ),
      duration: duration,
      behavior: behavior,
      action: autoDismiss
          ? null
          : SnackBarAction(
              label: dismissLabel ?? 'Dismiss', onPressed: onDismiss ?? () {}),
    );
    return snackBar;
  }

  static const _kDifDuration = Duration(seconds: 4);

  static ScaffoldFeatureController? _show(SnackBar snackBar) {
    final keyState = key.currentState;
    if (keyState == null) return null;

    keyState.hideCurrentSnackBar();

    return keyState.showSnackBar(snackBar);
  }
}
