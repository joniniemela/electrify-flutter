import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Haku kartasta (Map search) — Figma node `83:1792`.
class MapSearchScreen extends ConsumerWidget {
  const MapSearchScreen({super.key});

  // TODO(logic): provider-driven search results
  static const _results = [
    'Skinnarilankatu 34 — LUT-yliopisto',
    'Laserkatu 6 — Tiedepuisto',
    'Sammontorin Citymarket',
    'Punkkerikatu 1 — Skinnarilan urheilukenttä',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Hae sijaintia',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Hae osoitetta tai paikkaa',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(_results[index]),
                onTap: () => context.go(AppRoutes.mapLocationFor('$index')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
