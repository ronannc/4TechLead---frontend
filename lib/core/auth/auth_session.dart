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
  String? _role;
  String? get role => _role;
  int? _personId;
  int? get personId => _personId;

  bool get isAuthenticated => _token != null;
  bool get isTechLead => _role == 'tech_lead';
  bool get isMember => _role == 'member';
  bool get hasResolvedAccess => _role != null;

  /// Loads a previously persisted token, if any. Must be awaited before the
  /// first frame (see `bootstrap.dart`) so the router's first redirect
  /// decision is correct.
  Future<void> restore() async {
    _token = await _tokenStorage.read();
    _role = await _tokenStorage.readRole();
    _personId = await _tokenStorage.readPersonId();
    notifyListeners();
  }

  Future<void> signIn(
    String token, {
    required String role,
    int? personId,
  }) async {
    _token = token;
    _role = role;
    _personId = personId;
    await _tokenStorage.write(token);
    await _tokenStorage.writeAccess(role: role, personId: personId);
    notifyListeners();
  }

  Future<void> updateAccess({required String role, int? personId}) async {
    _role = role;
    _personId = personId;
    await _tokenStorage.writeAccess(role: role, personId: personId);
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    _role = null;
    _personId = null;
    await _tokenStorage.delete();
    notifyListeners();
  }
}
