/// Centralized route path/name constants, so screens and go_router config
/// don't hardcode path strings in more than one place.
class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const teams = '/teams';
  static const teamDetail = '/teams/:id';
  static const personCreate = '/teams/:teamId/people/new';
  static const personDetail = '/teams/:teamId/people/:personId';
  static const notifications = '/notifications';
  static const profile = '/profile';

  static String teamDetailPath(String id) => '/teams/$id';

  static String personCreatePath(String teamId) => '/teams/$teamId/people/new';

  static String personDetailPath(String teamId, String personId) =>
      '/teams/$teamId/people/$personId';
}
