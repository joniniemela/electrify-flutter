import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';

/// Profiilinäkymä (Profile / Account) — Figma node `23:252`.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(logic): replace with auth/user provider
    return Scaffold(
      appBar: XrAppBar(
        title: 'Profiili',
        leadingIcon: Icons.menu,
        onLeadingTap: () => Scaffold.of(context).openDrawer(),
        showTrailing: false,
      ),
      body: Builder(
        builder: (context) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(Icons.person, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Joni Niemelä',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'joni@example.com',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _Tile(
              icon: Icons.notifications_outlined,
              label: 'Ilmoitukset',
              onTap: () => context.go(AppRoutes.notifications),
            ),
            _Tile(
              icon: Icons.history,
              label: 'Tapahtumat',
              onTap: () => context.go(AppRoutes.history),
            ),
            _Tile(
              icon: Icons.credit_card,
              label: 'Maksutavat',
              onTap: () {},
            ),
            _Tile(
              icon: Icons.lock_outline,
              label: 'Tietoturva',
              onTap: () {},
            ),
            _Tile(
              icon: Icons.help_outline,
              label: 'Apua',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Kirjaudu ulos'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
