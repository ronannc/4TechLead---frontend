import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

class NotificationService {
  NotificationService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int perPage = 15,
  }) {
    return _get('/notifications', query: {'page': page, 'per_page': perPage});
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
