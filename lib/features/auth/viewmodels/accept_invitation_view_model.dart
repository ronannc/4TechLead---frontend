import '../../../core/viewmodels/base_view_model.dart';
import '../repositories/auth_repository.dart';

class AcceptInvitationViewModel extends BaseViewModel {
  AcceptInvitationViewModel(this._repository);

  final AuthRepository _repository;

  Future<void> accept({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) => runCatching(() async {
    await _repository.acceptPersonInvitation(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  });
}
