import '../../../core/viewmodels/base_view_model.dart';
import '../../auth/models/app_user.dart';
import '../../auth/repositories/auth_repository.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(this._authRepository);

  final AuthRepository _authRepository;

  AppUser? _user;
  AppUser? get user => _user;

  Future<void> load() => runCatching(() async {
    _user = await _authRepository.me();
  });

  Future<void> signOut() => _authRepository.logout();
}
