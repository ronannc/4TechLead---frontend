/// Centralized route path/name constants, so screens and go_router config
/// don't hardcode path strings in more than one place.
class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const teams = '/teams';
  static const teamDetail = '/teams/:id';
  static const notifications = '/notifications';
  static const profile = '/profile';

  static String teamDetailPath(String id) => '/teams/$id';
}
