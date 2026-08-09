import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

/// Raw HTTP calls to `/daily-meetings` and `/daily-meeting-entries`. Returns
/// decoded JSON — mapping JSON into models is the repository's job.
class DailyMeetingService {
  DailyMeetingService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> index({
    int? teamId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/daily-meetings',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'filters[team_id]': ?teamId,
          'order[started_at]': 'desc',
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> show(int id) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/daily-meetings/$id',
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  /// `entries` is a list of `{person_id, actual_seconds}` maps —
  /// `speaking_order`/`allotted_seconds` are derived server-side.
  Future<Map<String, dynamic>> store({
    required int timeLimitSeconds,
    required DateTime startedAt,
    required DateTime endedAt,
    required List<Map<String, dynamic>> entries,
    required List<Map<String, dynamic>> annotations,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/daily-meetings',
        data: {
          'time_limit_seconds': timeLimitSeconds,
          'started_at': startedAt.toIso8601String(),
          'ended_at': endedAt.toIso8601String(),
          'entries': entries,
          'annotations': annotations,
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> indexEntries({
    int? teamId,
    int? personId,
    int? dailyMeetingId,
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/daily-meeting-entries',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'filters[team_id]': ?teamId,
          'filters[person_id]': ?personId,
          'filters[daily_meeting_id]': ?dailyMeetingId,
          'order[created_at]': 'desc',
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
