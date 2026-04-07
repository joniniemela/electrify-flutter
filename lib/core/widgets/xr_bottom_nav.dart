import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Bottom navigation bar from the Electrify Figma
/// (`Navigation Bar: Vertical items`, 3 destinations).
///
/// Order matches the design: Asetukset (Settings/Profile) · Koti (Home) ·
/// Kartta (Map). The default selected tab in Figma is "Koti" (index 1).
class XrBottomNav extends StatelessWidget {
  const XrBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: AppColors.surfaceContainer,
      indicatorColor: AppColors.secondaryContainer,
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings, color: Colors.white),
          label: 'Asetukset',
        ),
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Koti',
        ),
        NavigationDestination(
          icon: Icon(Icons.map_outlined),
          selectedIcon: Icon(Icons.map, color: Colors.white),
          label: 'Kartta',
        ),
      ],
    );
  }
}
