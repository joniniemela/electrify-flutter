import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Tapahtumalista (Charging history) — Figma node `199:2640`.
class ChargingHistoryScreen extends ConsumerWidget {
  const ChargingHistoryScreen({super.key});

  // TODO(logic): replace with provider-driven session list
  static const _sessions = [
    _Session(id: '1', date: '12.3.2026', location: 'Mannerheimintie 12', cost: '3,86 €'),
    _Session(id: '2', date: '08.3.2026', location: 'Kampin parkkihalli', cost: '5,12 €'),
    _Session(id: '3', date: '01.3.2026', location: 'Kalasatama', cost: '7,94 €'),
    _Session(id: '4', date: '24.2.2026', location: 'Hakaniemi P-City', cost: '2,40 €'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Tapahtumat',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _sessions.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final s = _sessions[index];
          return Card(
            elevation: 0,
            color: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.bolt, color: Colors.white),
              ),
              title: Text(s.location),
              subtitle: Text(s.date),
              trailing: Text(
                s.cost,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onTap: () => context.go(AppRoutes.sessionDetailsFor(s.id)),
            ),
          );
        },
      ),
    );
  }
}

class _Session {
  const _Session({
    required this.id,
    required this.date,
    required this.location,
    required this.cost,
  });
  final String id;
  final String date;
  final String location;
  final String cost;
}
