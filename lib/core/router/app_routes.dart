/// Centralized route paths and names for `go_router`.
class AppRoutes {
  AppRoutes._();

  // Top-level
  static const String login = '/login';

  // Home tab
  static const String home = '/home';
  static const String connector = '/home/connector';
  static const String location = '/home/location/:id';
  static String locationFor(String id) => '/home/location/$id';
  static const String charging = '/home/charging';
  static const String summary = '/home/summary/:id';
  static String summaryFor(String id) => '/home/summary/$id';

  // Map tab
  static const String map = '/map';
  static const String mapSearch = '/map/search';
  static const String mapLocation = '/map/location/:id';
  static String mapLocationFor(String id) => '/map/location/$id';

  // Profile tab
  static const String profile = '/profile';
  static const String notifications = '/profile/notifications';
  static const String history = '/profile/history';
  static const String sessionDetails = '/profile/history/:id';
  static String sessionDetailsFor(String id) => '/profile/history/$id';
}
