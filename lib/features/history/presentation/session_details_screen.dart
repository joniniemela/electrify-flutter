import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Tapahtuman tiedot (Session details) — Figma node `203:3097`.
class SessionDetailsScreen extends ConsumerWidget {
  const SessionDetailsScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(logic): fetch session by id from provider
    return Scaffold(
      appBar: XrAppBar(
        title: 'Tapahtuma',
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
                    'Tapahtuma #$sessionId',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Mannerheimintie 12, Helsinki'),
                  const SizedBox(height: 4),
                  const Text('12.3.2026 · 14:32 – 15:46'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Mittarit', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const _Row(label: 'Energia', value: '24,8 kWh'),
          const _Row(label: 'Aika', value: '01:14:32'),
          const _Row(label: 'Hinta', value: '7,94 €'),
          const _Row(label: 'CO₂ säästö', value: '4,2 kg'),
          const SizedBox(height: 24),
          Text('Kuitti', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text('Lataa kuitti PDF'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
