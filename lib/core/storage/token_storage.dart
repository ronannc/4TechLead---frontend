import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over [FlutterSecureStorage] for persisting the auth token
/// (Keychain on macOS/iOS, Credential Manager on Windows, Keystore on
/// Android) and the minimal user access claims needed by route guards.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_user_role';
  static const _personIdKey = 'auth_person_id';

  Future<String?> read() => _storage.read(key: _tokenKey);

  Future<void> write(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> writeAccess({required String role, int? personId}) async {
    await _storage.write(key: _roleKey, value: role);

    if (personId == null) {
      await _storage.delete(key: _personIdKey);
      return;
    }

    await _storage.write(key: _personIdKey, value: personId.toString());
  }

  Future<String?> readRole() => _storage.read(key: _roleKey);

  Future<int?> readPersonId() async {
    final rawPersonId = await _storage.read(key: _personIdKey);

    return rawPersonId == null ? null : int.tryParse(rawPersonId);
  }

  Future<void> delete() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _personIdKey);
  }
}
