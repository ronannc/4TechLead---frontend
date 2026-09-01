import '../../integrations/models/integration_models.dart';
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
    int? personId,
    int page = 1,
    String? search,
    String? status,
    int perPage = 10,
  }) async {
    final json = await _service.getSessions(
      personId: personId,
      page: page,
      search: search,
      status: status,
      perPage: perPage,
    );
    return _list(json, OneOnOneSession.fromJson);
  }

  Future<OneOnOneSession> createSession({
    required int personId,
    required String title,
    String? notes,
    DateTime? heldAt,
    DateTime? scheduledFor,
    int? templateId,
    List<String>? questions,
    Map<String, dynamic>? answers,
    String status = 'completed',
  }) async {
    final json = await _service.createSession(
      personId: personId,
      title: title,
      notes: notes,
      heldAt: heldAt,
      scheduledFor: scheduledFor,
      templateId: templateId,
      questions: questions,
      answers: answers,
      status: status,
    );
    return OneOnOneSession.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<PersonOneOnOneNote>> getPersonOneOnOneNotes({
    int? personId,
    String? status,
  }) async {
    final json = await _service.getPersonOneOnOneNotes(
      personId: personId,
      status: status,
    );
    return _list(json, PersonOneOnOneNote.fromJson);
  }

  Future<PersonOneOnOneNote> createPersonOneOnOneNote({
    required int personId,
    required String title,
    String? body,
    DateTime? occurredAt,
  }) async {
    final json = await _service.createPersonOneOnOneNote(
      personId: personId,
      title: title,
      body: body,
      occurredAt: occurredAt,
    );
    return PersonOneOnOneNote.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<PersonOneOnOneNote> updatePersonOneOnOneNote({
    required int id,
    String? status,
    int? sessionId,
  }) async {
    final json = await _service.updatePersonOneOnOneNote(
      id: id,
      status: status,
      sessionId: sessionId,
    );
    return PersonOneOnOneNote.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<DevelopmentPlan>> getDevelopmentPlans(int personId) async {
    final json = await _service.getDevelopmentPlans(personId);
    return _list(json, DevelopmentPlan.fromJson);
  }

  Future<List<DevelopmentPlan>> getMyDevelopmentPlans() async {
    final json = await _service.getMyDevelopmentPlans();
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

  Future<List<PersonDeliveryMetric>> getDeliveryMetrics(int personId) async {
    final json = await _service.getDeliveryMetrics(personId);
    return _list(json, PersonDeliveryMetric.fromJson);
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
