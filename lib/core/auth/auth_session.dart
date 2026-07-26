import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

/// App-wide authentication state — cross-cutting infrastructure (like
/// [DioClient]), not a screen ViewModel. Used as go_router's
/// `refreshListenable` to re-evaluate route guards on sign-in/out, and by
/// [AuthInterceptor] to attach/clear the bearer token.
class AuthSession extends ChangeNotifier {
  AuthSession(this._tokenStorage);

  final TokenStorage _tokenStorage;

  String? _token;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  /// Loads a previously persisted token, if any. Must be awaited before the
  /// first frame (see `bootstrap.dart`) so the router's first redirect
  /// decision is correct.
  Future<void> restore() async {
    _token = await _tokenStorage.read();
    notifyListeners();
  }

  Future<void> signIn(String token) async {
    _token = token;
    await _tokenStorage.write(token);
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    await _tokenStorage.delete();
    notifyListeners();
  }
}
