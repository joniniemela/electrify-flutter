import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Yhteenveto (Session summary) — parameterized for variants 2–10.
/// Figma node `174:2608`.
class SessionSummaryScreen extends ConsumerWidget {
  const SessionSummaryScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Yhteenveto',
        leadingIcon: Icons.close,
        onLeadingTap: () => context.go(AppRoutes.home),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 56),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lataus valmis',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          _SummaryRow(label: 'Tunniste', value: '#$sessionId'),
          const _SummaryRow(label: 'Aika', value: '01:14:32'),
          const _SummaryRow(label: 'Energia', value: '24,8 kWh'),
          const _SummaryRow(label: 'Hinta', value: '7,94 €'),
          const _SummaryRow(label: 'CO₂ säästö', value: '4,2 kg'),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Valmis'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
