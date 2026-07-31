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

  // Live focus-mode flow: deliberately top-level (outside the ShellRoute),
  // same as /login and /register — the nav bar/rail must NOT stay reachable
  // mid-session, since that would let a stray tap destroy a live daily.
  static const dailySession = '/teams/:teamId/daily';

  // History screens are nested under Team, same pattern as `people`.
  static const dailyHistory = '/teams/:teamId/daily/history';
  static const dailyMeetingDetail = '/teams/:teamId/daily/history/:meetingId';

  static String teamDetailPath(String id) => '/teams/$id';

  static String personCreatePath(String teamId) => '/teams/$teamId/people/new';

  static String personDetailPath(String teamId, String personId) =>
      '/teams/$teamId/people/$personId';

  static String dailySessionPath(String teamId) => '/teams/$teamId/daily';

  static String dailyHistoryPath(String teamId) =>
      '/teams/$teamId/daily/history';

  static String dailyMeetingDetailPath(String teamId, String meetingId) =>
      '/teams/$teamId/daily/history/$meetingId';
}
