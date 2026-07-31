import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/viewmodels/base_view_model.dart';
import 'package:frontend/features/auth/models/app_user.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';
import 'package:frontend/features/auth/viewmodels/login_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late LoginViewModel viewModel;

  setUp(() {
    repository = _MockAuthRepository();
    viewModel = LoginViewModel(repository);
  });

  test('login() sets state to loaded on success', () async {
    when(
      () => repository.login(email: 'ada@example.com', password: 'password123'),
    ).thenAnswer(
      (_) async => AppUser(
        id: 1,
        name: 'Ada',
        email: 'ada@example.com',
        createdAt: DateTime.utc(2026),
      ),
    );

    await viewModel.login(email: 'ada@example.com', password: 'password123');

    expect(viewModel.state, ViewState.loaded);
  });

  test(
    'login() sets state to error with the repository error message on failure',
    () async {
      when(
        () => repository.login(email: 'ada@example.com', password: 'wrong'),
      ).thenThrow(
        const UnauthenticatedException(
          'These credentials do not match our records.',
        ),
      );

      await viewModel.login(email: 'ada@example.com', password: 'wrong');

      expect(viewModel.state, ViewState.error);
      expect(
        viewModel.errorMessage,
        'These credentials do not match our records.',
      );
    },
  );
}
