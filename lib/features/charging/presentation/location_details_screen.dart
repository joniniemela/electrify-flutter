import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Paikka valittu (Location selected) — parameterized for variants 02–10.
/// Figma node `174:1464`.
class LocationDetailsScreen extends ConsumerWidget {
  const LocationDetailsScreen({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(logic): fetch location by id from provider
    return Scaffold(
      appBar: XrAppBar(
        title: 'Latauspiste',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asema #$locationId',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Skinnarilankatu 34, 53850 Lappeenranta',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      _Chip(icon: Icons.flash_on, label: '50 kW'),
                      SizedBox(width: 8),
                      _Chip(icon: Icons.euro, label: '0,32 €/kWh'),
                      SizedBox(width: 8),
                      _Chip(icon: Icons.access_time, label: '24/7'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Pistokkeet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(3, (i) {
            return ListTile(
              leading: const Icon(Icons.power, color: AppColors.primary),
              title: Text('Pistoke ${i + 1}'),
              subtitle: const Text('Vapaana'),
              trailing: const Icon(Icons.check_circle, color: AppColors.primary),
            );
          }),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.charging),
            child: const Text('Aloita lataus'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
