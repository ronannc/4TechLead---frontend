import '../models/person_growth_models.dart';
import '../services/person_growth_service.dart';

class PersonGrowthRepository {
  PersonGrowthRepository(this._service);

  final PersonGrowthService _service;

  Future<List<OneOnOneTemplate>> getTemplates() async {
    final json = await _service.getTemplates();
    return _list(json, OneOnOneTemplate.fromJson);
  }

  Future<OneOnOneTemplate> createTemplate({
    required String title,
    required List<String> questions,
    String? description,
  }) async {
    final json = await _service.createTemplate(
      title: title,
      questions: questions,
      description: description,
    );
    return OneOnOneTemplate.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<OneOnOneSession>> getSessions({
    required int personId,
    int page = 1,
    String? search,
  }) async {
    final json = await _service.getSessions(
      personId: personId,
      page: page,
      search: search,
    );
    return _list(json, OneOnOneSession.fromJson);
  }

  Future<OneOnOneSession> createSession({
    required int personId,
    required String title,
    String? notes,
    DateTime? heldAt,
    int? templateId,
    List<String>? questions,
  }) async {
    final json = await _service.createSession(
      personId: personId,
      title: title,
      notes: notes,
      heldAt: heldAt,
      templateId: templateId,
      questions: questions,
    );
    return OneOnOneSession.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<DevelopmentPlan>> getDevelopmentPlans(int personId) async {
    final json = await _service.getDevelopmentPlans(personId);
    return _list(json, DevelopmentPlan.fromJson);
  }

  Future<DevelopmentPlan> createDevelopmentPlan({
    required int personId,
    required String title,
    String? summary,
    String? targetRole,
  }) async {
    final json = await _service.createDevelopmentPlan(
      personId: personId,
      title: title,
      summary: summary,
      targetRole: targetRole,
    );
    return DevelopmentPlan.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<DevelopmentPlan> updateDevelopmentPlan({
    required int id,
    String? title,
    String? summary,
    String? status,
    int? progress,
  }) async {
    final json = await _service.updateDevelopmentPlan(
      id: id,
      title: title,
      summary: summary,
      status: status,
      progress: progress,
    );
    return DevelopmentPlan.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<DevelopmentPlanItem> createDevelopmentPlanItem({
    required int planId,
    required String title,
    String? competency,
    String? evidence,
  }) async {
    final json = await _service.createDevelopmentPlanItem(
      planId: planId,
      title: title,
      competency: competency,
      evidence: evidence,
    );
    return DevelopmentPlanItem.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<PersonOkr>> getOkrs(int personId) async {
    final json = await _service.getOkrs(personId);
    return _list(json, PersonOkr.fromJson);
  }

  Future<PersonOkr> createOkr({
    required int personId,
    required String objective,
    String? cycle,
    String? focusArea,
    String? diagnosis,
    String? evidenceSource,
    String? baseline,
    String? target,
  }) async {
    final json = await _service.createOkr(
      personId: personId,
      objective: objective,
      cycle: cycle,
      focusArea: focusArea,
      diagnosis: diagnosis,
      evidenceSource: evidenceSource,
      baseline: baseline,
      target: target,
    );
    return PersonOkr.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<PersonOkr> updateOkr({
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
  }) async {
    final json = await _service.updateOkr(
      id: id,
      objective: objective,
      cycle: cycle,
      status: status,
      focusArea: focusArea,
      diagnosis: diagnosis,
      evidenceSource: evidenceSource,
      baseline: baseline,
      target: target,
      confidence: confidence,
      progress: progress,
    );
    return PersonOkr.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<OkrKeyResult> createKeyResult({
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
  }) async {
    final json = await _service.createKeyResult(
      okrId: okrId,
      title: title,
      metricName: metricName,
      dataSource: dataSource,
      initialValue: initialValue,
      currentValue: currentValue,
      targetValue: targetValue,
      unit: unit,
      evidence: evidence,
      confidence: confidence,
      progress: progress,
      dueDate: dueDate,
    );
    return OkrKeyResult.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<OkrKeyResult> updateKeyResult({
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
  }) async {
    final json = await _service.updateKeyResult(
      id: id,
      title: title,
      metricName: metricName,
      dataSource: dataSource,
      initialValue: initialValue,
      currentValue: currentValue,
      targetValue: targetValue,
      unit: unit,
      status: status,
      evidence: evidence,
      confidence: confidence,
      progress: progress,
      dueDate: dueDate,
    );
    return OkrKeyResult.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<GrowthSuggestions> getSuggestions({
    required int personId,
    String? focusArea,
    String? context,
  }) async {
    final json = await _service.getSuggestions(
      personId: personId,
      focusArea: focusArea,
      context: context,
    );
    return GrowthSuggestions.fromJson(json['data'] as Map<String, dynamic>);
  }

  List<T> _list<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) map,
  ) {
    return [
      for (final item in json['data'] as List<dynamic>)
        map(item as Map<String, dynamic>),
    ];
  }
}
