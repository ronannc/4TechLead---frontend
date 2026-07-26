import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/auth/auth_session.dart';
import 'package:frontend/core/storage/token_storage.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
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
      'created_at': '2026-01-01T10:00:00.000000Z',
    },
    'token': 'plain-text-token',
  };

  setUp(() {
    service = _MockAuthService();
    tokenStorage = _MockTokenStorage();
    when(() => tokenStorage.write(any())).thenAnswer((_) async {});
    when(() => tokenStorage.delete()).thenAnswer((_) async {});
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
    expect(authSession.token, 'plain-text-token');
    verify(() => tokenStorage.write('plain-text-token')).called(1);
  });

  test('login() signs the session in with the returned token', () async {
    when(
      () => service.login(email: 'ada@example.com', password: 'password123'),
    ).thenAnswer((_) async => userJson);

    final user = await repository.login(email: 'ada@example.com', password: 'password123');

    expect(user.id, 1);
    expect(authSession.isAuthenticated, isTrue);
  });

  test('logout() calls the service and signs the session out', () async {
    when(() => service.logout()).thenAnswer((_) async {});
    await authSession.signIn('plain-text-token');

    await repository.logout();

    verify(() => service.logout()).called(1);
    expect(authSession.isAuthenticated, isFalse);
    verify(() => tokenStorage.delete()).called(1);
  });
}
