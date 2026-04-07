import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/app_colors.dart';

/// Drawer content shown when the user taps the leading icon on the
/// `XrAppBar`. Mirrors the `Hamburger Menu` screen from Figma.
class XrAppDrawer extends StatelessWidget {
  const XrAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Text(
                'Electrify',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.home_outlined,
              label: 'Koti',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.home);
              },
            ),
            _DrawerItem(
              icon: Icons.map_outlined,
              label: 'Kartta',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.map);
              },
            ),
            _DrawerItem(
              icon: Icons.history,
              label: 'Tapahtumat',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.history);
              },
            ),
            _DrawerItem(
              icon: Icons.notifications_outlined,
              label: 'Ilmoitukset',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.notifications);
              },
            ),
            _DrawerItem(
              icon: Icons.person_outline,
              label: 'Profiili',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.profile);
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Kirjaudu ulos',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.login);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}
