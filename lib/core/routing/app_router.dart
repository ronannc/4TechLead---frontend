import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/accept_invitation_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/daily/screens/daily_history_screen.dart';
import '../../features/daily/screens/daily_meeting_detail_screen.dart';
import '../../features/daily/screens/daily_session_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/integrations/screens/integrations_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/people/screens/person_detail_screen.dart';
import '../../features/people/screens/person_form_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/teams/screens/team_detail_screen.dart';
import '../../features/teams/screens/teams_list_screen.dart';
import '../auth/access_policy.dart';
import '../auth/auth_session.dart';
import '../responsive/adaptive_scaffold.dart';
import 'route_paths.dart';

List<AppNavDestination> _navDestinationsFor(AuthSession authSession) {
  if (authSession.isMember) {
    return [
      const AppNavDestination(
        label: 'Perfil',
        icon: Icons.person_outline,
        path: RoutePaths.profile,
      ),
    ];
  }

  return [
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
      label: 'Integrações',
      icon: Icons.hub_outlined,
      path: RoutePaths.integrations,
    ),
    const AppNavDestination(
      label: 'Perfil',
      icon: Icons.person_outline,
      path: RoutePaths.profile,
    ),
  ];
}

String _authenticatedLandingPath(AuthSession authSession) {
  return AccessPolicy(authSession).landingPath(
    homePath: RoutePaths.home,
    profilePath: RoutePaths.profile,
    myPersonPath: RoutePaths.myPerson,
  );
}

bool _canAccessRoute(AuthSession authSession, GoRouterState state) {
  return AccessPolicy(authSession).canAccessRoute(
    matchedLocation: state.matchedLocation,
    profilePath: RoutePaths.profile,
    myPersonPath: RoutePaths.myPerson,
    personDetailPath: RoutePaths.personDetail,
    personEditPath: RoutePaths.personEdit,
    personId: state.pathParameters['personId'],
  );
}

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
          state.matchedLocation == RoutePaths.register ||
          state.matchedLocation == RoutePaths.acceptInvitation;

      if (!authSession.isAuthenticated && !loggingIn) {
        return RoutePaths.login;
      }

      if (authSession.isAuthenticated && loggingIn) {
        return _authenticatedLandingPath(authSession);
      }

      if (authSession.isAuthenticated && !_canAccessRoute(authSession, state)) {
        return _authenticatedLandingPath(authSession);
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
      GoRoute(
        path: RoutePaths.acceptInvitation,
        builder: (context, state) => const AcceptInvitationScreen(),
      ),
      // Deliberately top-level, not inside the ShellRoute below — a live Daily
      // session is "focus mode": the nav bar/rail must not stay reachable
      // mid-session (see RoutePaths.dailySession's doc comment).
      GoRoute(
        path: RoutePaths.dailySession,
        builder: (context, state) => DailySessionScreen(
          initialTeamId: state.uri.queryParameters['team'],
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final navDestinations = _navDestinationsFor(authSession);
          final index = navDestinations.indexWhere(
            (destination) => state.matchedLocation.startsWith(destination.path),
          );

          return AdaptiveScaffold(
            destinations: navDestinations,
            selectedIndex: index < 0 ? 0 : index,
            onDestinationSelected: (i) => context.go(navDestinations[i].path),
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
            path: RoutePaths.personEdit,
            builder: (context, state) => PersonFormScreen(
              teamId: state.pathParameters['teamId']!,
              personId: state.pathParameters['personId']!,
              appBarTitle: state.uri.queryParameters['source'] == 'profile'
                  ? 'Perfil'
                  : 'Time',
            ),
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
            path: RoutePaths.integrations,
            builder: (context, state) => const IntegrationsScreen(),
          ),
          GoRoute(
            path: RoutePaths.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: RoutePaths.myPerson,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
