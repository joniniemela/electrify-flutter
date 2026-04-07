import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Ilmoitukset (Notifications) — Figma node `83:502`.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  // TODO(logic): provider-driven notifications stream
  static const _notifications = [
    _N(icon: Icons.payment, title: 'Maksu veloitettu', body: '12.3.2026 · 3,86 €'),
    _N(icon: Icons.event_available, title: 'Varaus vahvistettu', body: 'Skinnarilankatu 34, klo 14:00'),
    _N(icon: Icons.local_offer, title: 'Tarjous', body: '20% alennus viikonloppuna'),
    _N(icon: Icons.info_outline, title: 'Sovellus päivitetty', body: 'Uusi versio 1.4.0 saatavilla'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Ilmoitukset',
        leadingIcon: Icons.arrow_back,
        onLeadingTap: () => context.pop(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return Card(
            elevation: 0,
            color: AppColors.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryContainer,
                child: Icon(n.icon, color: Colors.white),
              ),
              title: Text(n.title),
              subtitle: Text(n.body),
            ),
          );
        },
      ),
    );
  }
}

class _N {
  const _N({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}
