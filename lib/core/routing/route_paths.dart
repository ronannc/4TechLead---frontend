/// Centralized route path/name constants, so screens and go_router config
/// don't hardcode path strings in more than one place.
class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const register = '/register';

  static const teams = '/teams';
  static const teamDetail = '/teams/:id';

  static String teamDetailPath(String id) => '/teams/$id';
}
