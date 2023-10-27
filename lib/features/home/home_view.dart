import 'package:flutter/material.dart';
import 'package:game_hub/core/core.dart';
import 'package:game_hub/route/route_names.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePageView extends ConsumerWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AHNAF\'s Game-hub'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            ...RouteNames.allProjects.map(
              (e) => Card(
                elevation: 3,
                child: InkWell(
                  onTap: () => e.goNamed(context),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(e.icon, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          e.name.toTitleCase,
                          style: context.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
