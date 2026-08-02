import '../../../core/viewmodels/base_view_model.dart';
import '../models/person_growth_models.dart';
import '../repositories/person_growth_repository.dart';

class PersonGrowthViewModel extends BaseViewModel {
  PersonGrowthViewModel(this._repository, this.personId);

  final PersonGrowthRepository _repository;
  final int personId;

  List<OneOnOneTemplate> templates = [];
  List<OneOnOneSession> sessions = [];
  List<DevelopmentPlan> plans = [];
  List<PersonOkr> okrs = [];
  GrowthSuggestions? suggestions;

  int sessionPage = 1;
  String sessionSearch = '';

  Future<void> load() => runCatching(() async {
    await _loadAll();
  });

  Future<void> searchSessions(String value) => runCatching(() async {
    sessionSearch = value;
    sessionPage = 1;
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
  });

  Future<void> nextSessionPage() => runCatching(() async {
    sessionPage += 1;
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
  });

  Future<void> previousSessionPage() => runCatching(() async {
    if (sessionPage == 1) {
      return;
    }
    sessionPage -= 1;
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
  });

  Future<void> createTemplate({
    required String title,
    required List<String> questions,
    String? description,
  }) => runCatching(() async {
    await _repository.createTemplate(
      title: title,
      questions: questions,
      description: description,
    );
    templates = await _repository.getTemplates();
  });

  Future<void> createSession({
    required String title,
    String? notes,
    int? templateId,
    List<String>? questions,
  }) => runCatching(() async {
    await _repository.createSession(
      personId: personId,
      title: title,
      notes: notes,
      heldAt: DateTime.now(),
      templateId: templateId,
      questions: questions,
    );
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
  });

  Future<void> createPlan({
    required String title,
    String? summary,
    String? targetRole,
  }) => runCatching(() async {
    await _repository.createDevelopmentPlan(
      personId: personId,
      title: title,
      summary: summary,
      targetRole: targetRole,
    );
    plans = await _repository.getDevelopmentPlans(personId);
  });

  Future<void> updatePlan({
    required int id,
    String? title,
    String? summary,
    String? status,
    int? progress,
  }) => runCatching(() async {
    await _repository.updateDevelopmentPlan(
      id: id,
      title: title,
      summary: summary,
      status: status,
      progress: progress,
    );
    plans = await _repository.getDevelopmentPlans(personId);
  });

  Future<void> createPlanItem({
    required int planId,
    required String title,
    String? competency,
    String? evidence,
  }) => runCatching(() async {
    await _repository.createDevelopmentPlanItem(
      planId: planId,
      title: title,
      competency: competency,
      evidence: evidence,
    );
    plans = await _repository.getDevelopmentPlans(personId);
  });

  Future<void> createOkr({
    required String objective,
    String? focusArea,
    String? diagnosis,
    String? evidenceSource,
    String? target,
  }) => runCatching(() async {
    await _repository.createOkr(
      personId: personId,
      objective: objective,
      focusArea: focusArea,
      diagnosis: diagnosis,
      evidenceSource: evidenceSource,
      target: target,
    );
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> updateOkr({
    required int id,
    String? objective,
    String? status,
    int? confidence,
    int? progress,
  }) => runCatching(() async {
    await _repository.updateOkr(
      id: id,
      objective: objective,
      status: status,
      confidence: confidence,
      progress: progress,
    );
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> createKeyResult({
    required int okrId,
    required String title,
    String? metricName,
    num? targetValue,
  }) => runCatching(() async {
    await _repository.createKeyResult(
      okrId: okrId,
      title: title,
      metricName: metricName,
      targetValue: targetValue,
    );
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> generateSuggestions({String? focusArea, String? context}) =>
      runCatching(() async {
        suggestions = await _repository.getSuggestions(
          personId: personId,
          focusArea: focusArea,
          context: context,
        );
      });

  Future<void> _loadAll() async {
    final results = await Future.wait([
      _repository.getTemplates(),
      _repository.getSessions(personId: personId),
      _repository.getDevelopmentPlans(personId),
      _repository.getOkrs(personId),
      _repository.getSuggestions(personId: personId),
    ]);

    templates = results[0] as List<OneOnOneTemplate>;
    sessions = results[1] as List<OneOnOneSession>;
    plans = results[2] as List<DevelopmentPlan>;
    okrs = results[3] as List<PersonOkr>;
    suggestions = results[4] as GrowthSuggestions;
  }
}
