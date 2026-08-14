import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// Raw HTTP calls to `/teams`. Returns decoded JSON — mapping JSON into
/// [Team] instances is the [TeamRepository]'s job, not this class's.
class TeamService {
  TeamService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> index({int page = 1, int? perPage}) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/teams',
        queryParameters: {'page': page, 'per_page': ?perPage},
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> show(
    int id, {
    int peoplePage = 1,
    int? peoplePerPage,
    String? peopleSearch,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/teams/$id',
        queryParameters: {
          'people_page': peoplePage,
          'people_per_page': ?peoplePerPage,
          if (peopleSearch != null && peopleSearch.isNotEmpty)
            'people_search': peopleSearch,
        },
      );

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
