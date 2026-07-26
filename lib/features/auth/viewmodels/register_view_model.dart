import '../../../core/viewmodels/base_view_model.dart';
import '../repositories/auth_repository.dart';

/// On success, the user is already signed in (the backend's register
/// endpoint returns a token just like login) — no separate login step
/// needed after registering.
class RegisterViewModel extends BaseViewModel {
  RegisterViewModel(this._repository);

  final AuthRepository _repository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) => runCatching(() async {
    await _repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  });
}
