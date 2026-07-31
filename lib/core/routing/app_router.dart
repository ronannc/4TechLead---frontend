import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/daily/screens/daily_history_screen.dart';
import '../../features/daily/screens/daily_meeting_detail_screen.dart';
import '../../features/daily/screens/daily_session_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/people/screens/person_detail_screen.dart';
import '../../features/people/screens/person_form_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/teams/screens/team_detail_screen.dart';
import '../../features/teams/screens/teams_list_screen.dart';
import '../auth/auth_session.dart';
import '../responsive/adaptive_scaffold.dart';
import 'route_paths.dart';

final _navDestinations = [
  const AppNavDestination(
    label: 'Início',
    icon: Icons.dashboard_outlined,
    path: RoutePaths.home,
  ),
  const AppNavDestination(
    label: 'Times',
    icon: Icons.groups_outlined,
    path: RoutePaths.teams,
  ),
  const AppNavDestination(
    label: 'Notificações',
    icon: Icons.notifications_none,
    path: RoutePaths.notifications,
  ),
  const AppNavDestination(
    label: 'Perfil',
    icon: Icons.person_outline,
    path: RoutePaths.profile,
  ),
];

/// Builds the app-wide go_router configuration. `authSession` drives the
/// login guard: `refreshListenable` re-evaluates `redirect` whenever the
/// session signs in/out, sending unauthenticated users to `/login` and
/// signed-in users away from `/login`/`/register`.
///
/// Feature routes live inside a [ShellRoute] so [AdaptiveScaffold]'s
/// navigation chrome persists across route changes; `/login` and
/// `/register` are top-level routes outside the shell (no nav chrome).
GoRouter createAppRouter(AuthSession authSession) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: authSession,
    redirect: (context, state) {
      final loggingIn =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register;

      if (!authSession.isAuthenticated && !loggingIn) {
        return RoutePaths.login;
      }

      if (authSession.isAuthenticated && loggingIn) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      // Deliberately top-level, not inside the ShellRoute below — a live Daily
      // session is "focus mode": the nav bar/rail must not stay reachable
      // mid-session (see RoutePaths.dailySession's doc comment).
      GoRoute(
        path: RoutePaths.dailySession,
        builder: (context, state) =>
            DailySessionScreen(teamId: state.pathParameters['teamId']!),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = _navDestinations.indexWhere(
            (destination) => state.matchedLocation.startsWith(destination.path),
          );

          return AdaptiveScaffold(
            destinations: _navDestinations,
            selectedIndex: index < 0 ? 0 : index,
            onDestinationSelected: (i) => context.go(_navDestinations[i].path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: RoutePaths.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RoutePaths.teams,
            builder: (context, state) => const TeamsListScreen(),
          ),
          GoRoute(
            path: RoutePaths.teamDetail,
            builder: (context, state) =>
                TeamDetailScreen(teamId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: RoutePaths.personCreate,
            builder: (context, state) =>
                PersonFormScreen(teamId: state.pathParameters['teamId']!),
          ),
          GoRoute(
            path: RoutePaths.personDetail,
            builder: (context, state) =>
                PersonDetailScreen(personId: state.pathParameters['personId']!),
          ),
          GoRoute(
            path: RoutePaths.dailyHistory,
            builder: (context, state) =>
                DailyHistoryScreen(teamId: state.pathParameters['teamId']!),
          ),
          GoRoute(
            path: RoutePaths.dailyMeetingDetail,
            builder: (context, state) => DailyMeetingDetailScreen(
              meetingId: state.pathParameters['meetingId']!,
            ),
          ),
          GoRoute(
            path: RoutePaths.notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
