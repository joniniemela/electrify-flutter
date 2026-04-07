import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Pistokepaikan valinta (Connector selection) — Figma node `103:1131`.
class ConnectorSelectionScreen extends ConsumerWidget {
  const ConnectorSelectionScreen({super.key});

  // TODO(logic): replace with provider-driven connector list
  static const _connectors = [
    _Connector(id: 'type2-22', label: 'Type 2', power: '22 kW', icon: Icons.power),
    _Connector(id: 'ccs-50', label: 'CCS', power: '50 kW', icon: Icons.flash_on),
    _Connector(id: 'chademo-50', label: 'CHAdeMO', power: '50 kW', icon: Icons.bolt),
    _Connector(id: 'type2-11', label: 'Type 2', power: '11 kW', icon: Icons.power),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Pistokepaikat',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _connectors.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = _connectors[index];
          return Card(
            elevation: 0,
            color: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Icon(c.icon, color: Colors.white),
              ),
              title: Text(c.label, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(c.power),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go(AppRoutes.locationFor(c.id)),
            ),
          );
        },
      ),
    );
  }
}

class _Connector {
  const _Connector({
    required this.id,
    required this.label,
    required this.power,
    required this.icon,
  });
  final String id;
  final String label;
  final String power;
  final IconData icon;
}
