import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// Raw HTTP calls to `/auth`. Returns decoded JSON — mapping JSON into
/// [AppUser] instances is the [AuthRepository]'s job, not this class's.
class AuthService {
  AuthService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _client.dio.post<void>('/auth/logout');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> me() async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/auth/me');

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
