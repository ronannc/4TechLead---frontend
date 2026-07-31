import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/viewmodels/base_view_model.dart';
import 'package:frontend/features/auth/models/app_user.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';
import 'package:frontend/features/auth/viewmodels/register_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late RegisterViewModel viewModel;

  setUp(() {
    repository = _MockAuthRepository();
    viewModel = RegisterViewModel(repository);
  });

  test('register() sets state to loaded on success (auto-login)', () async {
    when(
      () => repository.register(
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      ),
    ).thenAnswer(
      (_) async => AppUser(
        id: 1,
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        createdAt: DateTime.utc(2026),
      ),
    );

    await viewModel.register(
      name: 'Ada Lovelace',
      email: 'ada@example.com',
      password: 'password123',
      passwordConfirmation: 'password123',
    );

    expect(viewModel.state, ViewState.loaded);
  });

  test(
    'register() sets state to error with a validation message on failure',
    () async {
      when(
        () => repository.register(
          name: 'Ada Lovelace',
          email: 'taken@example.com',
          password: 'password123',
          passwordConfirmation: 'password123',
        ),
      ).thenThrow(
        ValidationException({
          'email': ['The email has already been taken.'],
        }),
      );

      await viewModel.register(
        name: 'Ada Lovelace',
        email: 'taken@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, 'The email has already been taken.');
    },
  );
}
