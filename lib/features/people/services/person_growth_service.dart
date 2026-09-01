import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

class PersonGrowthService {
  PersonGrowthService(this._client);

  final DioClient _client;
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<Map<String, dynamic>> getTemplates() {
    return _get('/one-on-one-templates', query: {'filters[active]': 1});
  }

  Future<Map<String, dynamic>> createTemplate({
    required String title,
    required List<String> questions,
    String? description,
  }) {
    return _post(
      '/one-on-one-templates',
      data: {
        'title': title,
        'description': ?description,
        'questions': questions,
        'active': true,
      },
    );
  }

  Future<Map<String, dynamic>> getSessions({
    int? personId,
    int page = 1,
    String? search,
    String? status,
    int perPage = 10,
  }) {
    return _get(
      '/one-on-one-sessions',
      query: {
        'page': page,
        'per_page': perPage,
        'filters[person_id]': ?personId,
        if (status != null && status.isNotEmpty) 'filters[status]': status,
        if (status == 'planned') 'order[scheduled_for]': 'asc',
        if (status != 'planned') 'order[held_at]': 'desc',
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
  }

  Future<Map<String, dynamic>> getPersonOneOnOneNotes({
    int? personId,
    String? status,
    int page = 1,
    int perPage = 50,
  }) {
    return _get(
      '/person-one-on-one-notes',
      query: {
        'page': page,
        'per_page': perPage,
        'filters[person_id]': ?personId,
        if (status != null && status.isNotEmpty) 'filters[status]': status,
        'order[occurred_at]': 'desc',
      },
    );
  }

  Future<Map<String, dynamic>> createPersonOneOnOneNote({
    required int personId,
    required String title,
    String? body,
    DateTime? occurredAt,
  }) {
    return _post(
      '/person-one-on-one-notes',
      data: {
        'person_id': personId,
        'title': title,
        'body': ?body,
        'status': 'open',
        'occurred_at': occurredAt == null
            ? null
            : _dateFormat.format(occurredAt),
      },
    );
  }

  Future<Map<String, dynamic>> updatePersonOneOnOneNote({
    required int id,
    String? status,
    int? sessionId,
  }) {
    return _put(
      '/person-one-on-one-notes/$id',
      data: {'status': ?status, 'one_on_one_session_id': ?sessionId},
    );
  }

  Future<Map<String, dynamic>> createSession({
    required int personId,
    required String title,
    String? notes,
    DateTime? heldAt,
    DateTime? scheduledFor,
    int? templateId,
    List<String>? questions,
    Map<String, dynamic>? answers,
    String status = 'completed',
  }) {
    return _post(
      '/one-on-one-sessions',
      data: {
        'person_id': personId,
        'title': title,
        'status': status,
        'held_at': heldAt == null ? null : _dateFormat.format(heldAt),
        'scheduled_for': scheduledFor == null
            ? null
            : _dateFormat.format(scheduledFor),
        'one_on_one_template_id': ?templateId,
        'questions': ?questions,
        'answers': ?answers,
        'notes': ?notes,
      },
    );
  }

  Future<Map<String, dynamic>> getDevelopmentPlans(int personId) {
    return _get(
      '/development-plans',
      query: {'filters[person_id]': personId, 'order[created_at]': 'desc'},
    );
  }

  Future<Map<String, dynamic>> getMyDevelopmentPlans() {
    return _get('/me/development-plans');
  }

  Future<Map<String, dynamic>> createDevelopmentPlan({
    required int personId,
    required String title,
    String? summary,
    String? targetRole,
  }) {
    return _post(
      '/development-plans',
      data: {
        'person_id': personId,
        'title': title,
        'summary': ?summary,
        'target_role': ?targetRole,
        'status': 'active',
        'progress': 0,
      },
    );
  }

  Future<Map<String, dynamic>> updateDevelopmentPlan({
    required int id,
    String? title,
    String? summary,
    String? status,
    int? progress,
  }) {
    return _put(
      '/development-plans/$id',
      data: {
        'title': ?title,
        'summary': ?summary,
        'status': ?status,
        'progress': ?progress,
      },
    );
  }

  Future<Map<String, dynamic>> createDevelopmentPlanItem({
    required int planId,
    required String title,
    String? competency,
    String? evidence,
  }) {
    return _post(
      '/development-plan-items',
      data: {
        'development_plan_id': planId,
        'title': title,
        'competency': ?competency,
        'evidence': ?evidence,
        'status': 'todo',
        'progress': 0,
      },
    );
  }

  Future<Map<String, dynamic>> getSuggestions({
    required int personId,
    String? focusArea,
    String? context,
  }) {
    return _get(
      '/people/$personId/growth-suggestions',
      query: {
        if (focusArea != null && focusArea.isNotEmpty) 'focus_area': focusArea,
        if (context != null && context.isNotEmpty) 'context': context,
      },
    );
  }

  Future<Map<String, dynamic>> getDeliveryMetrics(int personId) {
    return _get(
      '/person-delivery-metrics',
      query: {
        'per_page': 20,
        'filters[person_id]': personId,
        'order[occurred_at]': 'desc',
      },
    );
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

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        path,
        data: data,
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> _put(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client.dio.put<Map<String, dynamic>>(
        path,
        data: data,
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
