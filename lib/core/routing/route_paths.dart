/// Centralized route path/name constants, so screens and go_router config
/// don't hardcode path strings in more than one place.
class RoutePaths {
  RoutePaths._();

  static const login = '/login';
  static const register = '/register';
  static const acceptInvitation = '/accept-invitation';

  static const home = '/home';
  static const teams = '/teams';
  static const teamDetail = '/teams/:id';
  static const personCreate = '/teams/:teamId/people/new';
  static const personDetail = '/teams/:teamId/people/:personId';
  static const personEdit = '/teams/:teamId/people/:personId/edit';
  static const notifications = '/notifications';
  static const integrations = '/integrations';
  static const profile = '/profile';
  static const myPerson = '/me/person';

  // Live focus-mode flow: deliberately top-level (outside the ShellRoute),
  // same as /login and /register — the nav bar/rail must NOT stay reachable
  // mid-session, since that would let a stray tap destroy a live daily.
  static const dailySession = '/daily';

  // History screens are nested under Team, same pattern as `people`.
  static const dailyHistory = '/teams/:teamId/daily/history';
  static const dailyMeetingDetail = '/teams/:teamId/daily/history/:meetingId';

  static String teamDetailPath(String id) => '/teams/$id';

  static String personCreatePath(String teamId) => '/teams/$teamId/people/new';

  static String personDetailPath(String teamId, String personId) =>
      '/teams/$teamId/people/$personId';

  static String personEditPath(
    String teamId,
    String personId, {
    bool fromProfile = false,
  }) {
    final path = '/teams/$teamId/people/$personId/edit';

    return fromProfile ? '$path?source=profile' : path;
  }

  static String myPersonPath() => myPerson;

  static String dailySessionPath({String? initialTeamId}) =>
      initialTeamId == null
      ? dailySession
      : '$dailySession?team=$initialTeamId';

  static String dailyHistoryPath(String teamId) =>
      '/teams/$teamId/daily/history';

  static String dailyMeetingDetailPath(String teamId, String meetingId) =>
      '/teams/$teamId/daily/history/$meetingId';
}
