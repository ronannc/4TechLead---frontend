import '../../../core/auth/auth_session.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

/// Maps `AuthService`'s raw JSON into [AppUser] instances, and is the only
/// place (besides [AuthInterceptor]) that touches [AuthSession] directly —
/// on a successful register/login it signs the session in.
class AuthRepository {
  AuthRepository(this._service, this._authSession);

  final AuthService _service;
  final AuthSession _authSession;

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final json = await _service.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    return _signInFromResponse(json);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final json = await _service.login(email: email, password: password);

    return _signInFromResponse(json);
  }

  Future<void> logout() async {
    await _service.logout();
    await _authSession.signOut();
  }

  Future<AppUser> me() async {
    final json = await _service.me();

    return AppUser.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<AppUser> _signInFromResponse(Map<String, dynamic> json) async {
    final user = AppUser.fromJson(json['data'] as Map<String, dynamic>);
    await _authSession.signIn(json['token'] as String);

    return user;
  }
}
