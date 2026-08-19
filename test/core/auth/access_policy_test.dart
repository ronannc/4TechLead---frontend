import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/auth/access_policy.dart';
import 'package:for_tech_lead/core/auth/auth_session.dart';
import 'package:for_tech_lead/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockTokenStorage tokenStorage;
  late AuthSession authSession;

  setUp(() {
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.write(any())).thenAnswer((_) async {});
    when(
      () => tokenStorage.writeAccess(
        role: any(named: 'role'),
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) async {});
    when(() => tokenStorage.delete()).thenAnswer((_) async {});
    authSession = AuthSession(tokenStorage);
  });

  test('allows tech leads to reach management routes', () async {
    await authSession.signIn('token', role: 'tech_lead');

    final policy = AccessPolicy(authSession);

    expect(policy.canManageTeams, isTrue);
    expect(policy.canManageIntegrations, isTrue);
    expect(
      policy.canAccessRoute(
        matchedLocation: '/teams',
        profilePath: '/profile',
        myPersonPath: '/me/person',
        personDetailPath: '/teams/:teamId/people/:personId',
        personEditPath: '/teams/:teamId/people/:personId/edit',
      ),
      isTrue,
    );
  });

  test('keeps members on their own profile routes', () async {
    await authSession.signIn('token', role: 'member', personId: 10);

    final policy = AccessPolicy(authSession);

    expect(policy.canManageTeams, isFalse);
    expect(
      policy.landingPath(
        homePath: '/home',
        profilePath: '/profile',
        myPersonPath: '/me/person',
      ),
      '/profile',
    );
    expect(
      policy.canAccessRoute(
        matchedLocation: '/teams',
        profilePath: '/profile',
        myPersonPath: '/me/person',
        personDetailPath: '/teams/:teamId/people/:personId',
        personEditPath: '/teams/:teamId/people/:personId/edit',
      ),
      isFalse,
    );
    expect(
      policy.canAccessRoute(
        matchedLocation: '/teams/:teamId/people/:personId',
        profilePath: '/profile',
        myPersonPath: '/me/person',
        personDetailPath: '/teams/:teamId/people/:personId',
        personEditPath: '/teams/:teamId/people/:personId/edit',
        personId: '10',
      ),
      isTrue,
    );
    expect(
      policy.canAccessRoute(
        matchedLocation: '/teams/:teamId/people/:personId',
        profilePath: '/profile',
        myPersonPath: '/me/person',
        personDetailPath: '/teams/:teamId/people/:personId',
        personEditPath: '/teams/:teamId/people/:personId/edit',
        personId: '11',
      ),
      isFalse,
    );
  });
}
