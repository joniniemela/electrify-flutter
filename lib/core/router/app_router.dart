import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/charging/presentation/active_charging_screen.dart';
import '../../features/charging/presentation/connector_selection_screen.dart';
import '../../features/charging/presentation/location_details_screen.dart';
import '../../features/charging/presentation/session_summary_screen.dart';
import '../../features/history/presentation/charging_history_screen.dart';
import '../../features/history/presentation/session_details_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/map/presentation/map_search_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../widgets/xr_app_drawer.dart';
import '../widgets/xr_bottom_nav.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profileTab');
final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final GlobalKey<NavigatorState> _mapNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'mapTab');

/// Top-level go_router for the Electrify app.
///
/// Layout:
/// - `/login` is a fullscreen route outside the shell.
/// - The `StatefulShellRoute.indexedStack` wraps three branches
///   (Profile / Home / Map). Each branch has its own navigator key so
///   tabs keep independent back stacks.
/// - The shell's `Scaffold` mounts `XrBottomNav` and `XrAppDrawer`.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _ShellScaffold(navigationShell: navigationShell),
      branches: [
        // ──────────── Branch 0: Profile / Asetukset ────────────
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => const ChargingHistoryScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (context, state) => SessionDetailsScreen(
                        sessionId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // ──────────── Branch 1: Home / Koti ────────────
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'connector',
                  builder: (context, state) =>
                      const ConnectorSelectionScreen(),
                ),
                GoRoute(
                  path: 'location/:id',
                  builder: (context, state) => LocationDetailsScreen(
                    locationId: state.pathParameters['id'] ?? '',
                  ),
                ),
                GoRoute(
                  path: 'charging',
                  builder: (context, state) => const ActiveChargingScreen(),
                ),
                GoRoute(
                  path: 'summary/:id',
                  builder: (context, state) => SessionSummaryScreen(
                    sessionId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        // ──────────── Branch 2: Map / Kartta ────────────
        StatefulShellBranch(
          navigatorKey: _mapNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.map,
              builder: (context, state) => const MapScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) => const MapSearchScreen(),
                ),
                GoRoute(
                  path: 'location/:id',
                  builder: (context, state) => LocationDetailsScreen(
                    locationId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const XrAppDrawer(),
      body: navigationShell,
      bottomNavigationBar: XrBottomNav(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
      ),
    );
  }
}
