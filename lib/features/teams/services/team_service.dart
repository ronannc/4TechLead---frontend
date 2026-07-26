import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// Raw HTTP calls to `/teams`. Returns decoded JSON — mapping JSON into
/// [Team] instances is the [TeamRepository]'s job, not this class's.
class TeamService {
  TeamService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> index({int page = 1}) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/teams',
        queryParameters: {'page': page},
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> show(int id) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>('/teams/$id');

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> store({required String name}) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/teams',
        data: {'name': name},
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> update(int id, {required String name}) async {
    try {
      final response = await _client.dio.put<Map<String, dynamic>>(
        '/teams/$id',
        data: {'name': name},
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> destroy(int id) async {
    try {
      await _client.dio.delete<void>('/teams/$id');
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
