import '../../../core/viewmodels/base_view_model.dart';
import '../repositories/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._repository);

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) =>
      runCatching(() async {
        await _repository.login(email: email, password: password);
      });
}
