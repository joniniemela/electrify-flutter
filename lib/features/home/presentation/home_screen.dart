import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/xr_app_bar.dart';
import 'widgets/location_dial.dart';

/// Päänäkymä (Home / Main view) — Figma node `13:322`.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: XrAppBar(
        title: 'Electrify',
        onLeadingTap: () => Scaffold.of(context).openDrawer(),
        onTrailingTap: () => context.go(AppRoutes.notifications),
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            // Notification accordion item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Card(
                elevation: 0,
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                  title: const Text('Ilmoitus'),
                  subtitle: const Text('12.3.2026 Maksu veloitettu 3,86€'),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                  ),
                  onTap: () => context.go(AppRoutes.notifications),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Welcome text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    'Tervetuloa!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Et ole vielä valinnut pistokepaikkaa',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Dial — tap navigates to connector selection
            LocationDial(
              size: 320,
              onPlayTap: () => context.go(AppRoutes.connector),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
