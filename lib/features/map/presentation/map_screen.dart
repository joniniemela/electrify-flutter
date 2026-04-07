import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Karttanäkymä (Map view) — Figma node `34:1794`.
/// Includes the bottom-sheet popup variant `87:365` triggered from a pin.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Kartta',
        leadingIcon: Icons.menu,
        onLeadingTap: () => Scaffold.of(context).openDrawer(),
        trailingIcon: Icons.search,
        onTrailingTap: () => context.go(AppRoutes.mapSearch),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: [
            // TODO(logic): integrate google_maps_flutter / mapbox here
            Container(
              color: AppColors.surfaceContainer,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined,
                        size: 96, color: AppColors.onSurfaceVariant),
                    SizedBox(height: 16),
                    Text(
                      'Kartta',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Pin samples
            Positioned(
              left: 80,
              top: 200,
              child: _Pin(onTap: () => _showStationSheet(context, '01')),
            ),
            Positioned(
              right: 60,
              top: 320,
              child: _Pin(onTap: () => _showStationSheet(context, '02')),
            ),
          ],
        ),
      ),
    );
  }

  void _showStationSheet(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asema #$id',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Mannerheimintie 12, 00100 Helsinki'),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.flash_on,
                    size: 16, color: AppColors.onSurfaceVariant),
                SizedBox(width: 4),
                Text('50 kW · 0,32 €/kWh · Vapaana 3/4'),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                context.go(AppRoutes.mapLocationFor(id));
              },
              child: const Text('Näytä lisätiedot'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.bolt, color: Colors.white),
      ),
    );
  }
}
