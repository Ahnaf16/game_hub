import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:game_hub/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GridsLightning extends HookConsumerWidget {
  const GridsLightning({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lp = useState(Offset.zero);
    final showCursor = useState(false);
    final Size size = Size.square(context.width / 3 - 31);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grids'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          onHover: (event) {
            lp.value = event.localPosition;
          },
          onEnter: (event) => showCursor.value = true,
          onExit: (event) => showCursor.value = false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                if (showCursor.value)
                  Positioned(
                    left: lp.value.dx - (size.width * 1.5 / 2) - 20,
                    top: lp.value.dy - (size.height * 1.5 / 2) - 20,
                    child: Container(
                      height: size.height * 1.5,
                      width: size.width * 1.5,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            context.colorTheme.primary,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    ...List.generate(
                      6,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          ///* main container
                          Container(
                            height: size.height,
                            width: size.width,
                            decoration: BoxDecoration(
                              color:
                                  context.colorTheme.background.withOpacity(.9),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('AHNAF SAKIL'),
                                Text('$index'),
                              ],
                            ),
                          ),

                          ///* border container
                          Container(
                            height: size.height + 12,
                            width: size.width + 12,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(width: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
