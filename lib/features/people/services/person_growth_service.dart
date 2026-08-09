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
    required int personId,
    int page = 1,
    String? search,
  }) {
    return _get(
      '/one-on-one-sessions',
      query: {
        'page': page,
        'per_page': 10,
        'filters[person_id]': personId,
        'order[held_at]': 'desc',
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
  }

  Future<Map<String, dynamic>> createSession({
    required int personId,
    required String title,
    String? notes,
    DateTime? heldAt,
    int? templateId,
    List<String>? questions,
  }) {
    return _post(
      '/one-on-one-sessions',
      data: {
        'person_id': personId,
        'title': title,
        'status': 'completed',
        'held_at': heldAt == null ? null : _dateFormat.format(heldAt),
        'one_on_one_template_id': ?templateId,
        'questions': ?questions,
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

  Future<Map<String, dynamic>> getOkrs(int personId) {
    return _get(
      '/okrs',
      query: {'filters[person_id]': personId, 'order[created_at]': 'desc'},
    );
  }

  Future<Map<String, dynamic>> createOkr({
    required int personId,
    required String objective,
    String? cycle,
    String? focusArea,
    String? diagnosis,
    String? evidenceSource,
    String? baseline,
    String? target,
  }) {
    return _post(
      '/okrs',
      data: {
        'person_id': personId,
        'objective': objective,
        'cycle': ?cycle,
        'focus_area': ?focusArea,
        'diagnosis': ?diagnosis,
        'evidence_source': ?evidenceSource,
        'baseline': ?baseline,
        'target': ?target,
        'status': 'active',
        'confidence': 50,
        'progress': 0,
      },
    );
  }

  Future<Map<String, dynamic>> updateOkr({
    required int id,
    String? objective,
    String? cycle,
    String? status,
    String? focusArea,
    String? diagnosis,
    String? evidenceSource,
    String? baseline,
    String? target,
    int? confidence,
    int? progress,
  }) {
    return _put(
      '/okrs/$id',
      data: {
        'objective': ?objective,
        'cycle': ?cycle,
        'status': ?status,
        'focus_area': ?focusArea,
        'diagnosis': ?diagnosis,
        'evidence_source': ?evidenceSource,
        'baseline': ?baseline,
        'target': ?target,
        'confidence': ?confidence,
        'progress': ?progress,
      },
    );
  }

  Future<Map<String, dynamic>> createKeyResult({
    required int okrId,
    required String title,
    String? metricName,
    String? dataSource,
    num? initialValue,
    num? currentValue,
    num? targetValue,
    String? unit,
    String? evidence,
    int? confidence,
    int? progress,
    DateTime? dueDate,
  }) {
    return _post(
      '/okr-key-results',
      data: {
        'okr_id': okrId,
        'title': title,
        'metric_name': ?metricName,
        'data_source': ?dataSource,
        'initial_value': ?initialValue,
        'current_value': ?currentValue,
        'target_value': ?targetValue,
        'unit': ?unit,
        'evidence': ?evidence,
        'confidence': ?confidence,
        'due_date': dueDate == null ? null : _dateFormat.format(dueDate),
        'status': 'todo',
        'progress': ?progress,
      },
    );
  }

  Future<Map<String, dynamic>> updateKeyResult({
    required int id,
    String? title,
    String? metricName,
    String? dataSource,
    num? initialValue,
    num? currentValue,
    num? targetValue,
    String? unit,
    String? status,
    String? evidence,
    int? confidence,
    int? progress,
    DateTime? dueDate,
  }) {
    return _put(
      '/okr-key-results/$id',
      data: {
        'title': ?title,
        'metric_name': ?metricName,
        'data_source': ?dataSource,
        'initial_value': ?initialValue,
        'current_value': ?currentValue,
        'target_value': ?targetValue,
        'unit': ?unit,
        'status': ?status,
        'evidence': ?evidence,
        'confidence': ?confidence,
        'progress': ?progress,
        'due_date': dueDate == null ? null : _dateFormat.format(dueDate),
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
