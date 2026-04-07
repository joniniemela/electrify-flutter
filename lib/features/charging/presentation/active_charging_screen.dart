import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';
import '../../home/presentation/widgets/location_dial.dart';

/// Ajastin käynnissä (Active charging timer) — Figma node `174:3424`.
class ActiveChargingScreen extends ConsumerWidget {
  const ActiveChargingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Lataus käynnissä',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          // TODO(logic): replace with timer-state-driven dial widget
          LocationDial(
            size: 320,
            onPlayTap: () {},
          ),
          const SizedBox(height: 24),
          const _MetricRow(label: 'Aika', value: '00:42:18'),
          const _MetricRow(label: 'Energia', value: '12,4 kWh'),
          const _MetricRow(label: 'Hinta', value: '3,86 €'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () => context.go(AppRoutes.summaryFor('demo')),
              child: const Text('Lopeta lataus'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
