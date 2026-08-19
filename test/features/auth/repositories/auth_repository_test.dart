import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/auth/auth_session.dart';
import 'package:for_tech_lead/core/storage/token_storage.dart';
import 'package:for_tech_lead/features/auth/repositories/auth_repository.dart';
import 'package:for_tech_lead/features/auth/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late _MockAuthService service;
  late _MockTokenStorage tokenStorage;
  late AuthSession authSession;
  late AuthRepository repository;

  final userJson = {
    'data': {
      'id': 1,
      'name': 'Ada Lovelace',
      'email': 'ada@example.com',
      'role': 'tech_lead',
      'person_id': null,
      'created_at': '2026-01-01T10:00:00.000000Z',
    },
    'token': 'plain-text-token',
  };

  setUp(() {
    service = _MockAuthService();
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.write(any())).thenAnswer((_) async {});
    when(
      () => tokenStorage.writeAccess(
        role: any(named: 'role'),
        personId: any(named: 'personId'),
      ),
    ).thenAnswer((_) async {});
    when(() => tokenStorage.delete()).thenAnswer((_) async {});
    when(() => tokenStorage.read()).thenAnswer((_) async => null);
    when(() => tokenStorage.readRole()).thenAnswer((_) async => null);
    when(() => tokenStorage.readPersonId()).thenAnswer((_) async => null);
    authSession = AuthSession(tokenStorage);
    repository = AuthRepository(service, authSession);
  });

  test('register() signs the session in with the returned token', () async {
    when(
      () => service.register(
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
    ).thenAnswer((_) async => userJson);

    final user = await repository.register(
      name: 'Ada Lovelace',
      email: 'ada@example.com',
      password: 'password123',
      passwordConfirmation: 'password123',
    );

    expect(user.email, 'ada@example.com');
    expect(authSession.isAuthenticated, isTrue);
    expect(authSession.isTechLead, isTrue);
    expect(authSession.token, 'plain-text-token');
    verify(() => tokenStorage.write('plain-text-token')).called(1);
    verify(
      () => tokenStorage.writeAccess(role: 'tech_lead', personId: null),
    ).called(1);
  });

  test('login() signs the session in with the returned token', () async {
    when(
      () => service.login(email: 'ada@example.com', password: 'password123'),
    ).thenAnswer((_) async => userJson);

    final user = await repository.login(
      email: 'ada@example.com',
      password: 'password123',
    );

    expect(user.id, 1);
    expect(authSession.isAuthenticated, isTrue);
    expect(authSession.role, 'tech_lead');
  });

  test('acceptPersonInvitation() stores member access claims', () async {
    when(
      () => service.acceptPersonInvitation(
        email: 'ada@example.com',
        token: 'invite-token',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
    ).thenAnswer(
      (_) async => {
        'data': {
          'id': 2,
          'name': 'Ada Lovelace',
          'email': 'ada@example.com',
          'role': 'member',
          'person_id': 10,
          'created_at': '2026-01-01T10:00:00.000000Z',
        },
        'token': 'member-token',
      },
    );

    final user = await repository.acceptPersonInvitation(
      email: 'ada@example.com',
      token: 'invite-token',
      password: 'password123',
      passwordConfirmation: 'password123',
    );

    expect(user.isMember, isTrue);
    expect(authSession.isMember, isTrue);
    expect(authSession.personId, 10);
    verify(
      () => tokenStorage.writeAccess(role: 'member', personId: 10),
    ).called(1);
  });

  test('logout() calls the service and signs the session out', () async {
    when(() => service.logout()).thenAnswer((_) async {});
    await authSession.signIn('plain-text-token', role: 'tech_lead');

    await repository.logout();

    verify(() => service.logout()).called(1);
    expect(authSession.isAuthenticated, isFalse);
    verify(() => tokenStorage.delete()).called(1);
  });

  test('me() refreshes stored access claims from the backend user', () async {
    when(() => service.me()).thenAnswer(
      (_) async => {
        'data': {
          'id': 2,
          'name': 'Grace Hopper',
          'email': 'grace@example.com',
          'role': 'member',
          'person_id': 42,
          'created_at': '2026-01-01T10:00:00.000000Z',
        },
      },
    );

    final user = await repository.me();

    expect(user.personId, 42);
    expect(authSession.isMember, isTrue);
    verify(
      () => tokenStorage.writeAccess(role: 'member', personId: 42),
    ).called(1);
  });
}
