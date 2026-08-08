import '../../../core/network/api_exception.dart';
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
  String? actionErrorMessage;
  bool isMutating = false;

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
  }) => _runMutation(() async {
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
  }) => _runMutation(() async {
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
  }) => _runMutation(() async {
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
  }) => _runMutation(() async {
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
  }) => _runMutation(() async {
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
    String? cycle,
    String? focusArea,
    String? diagnosis,
    String? evidenceSource,
    String? baseline,
    String? target,
  }) => _runMutation(() async {
    await _repository.createOkr(
      personId: personId,
      objective: objective,
      cycle: cycle,
      focusArea: focusArea,
      diagnosis: diagnosis,
      evidenceSource: evidenceSource,
      baseline: baseline,
      target: target,
    );
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> updateOkr({
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
  }) => _runMutation(() async {
    await _repository.updateOkr(
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
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> createKeyResult({
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
  }) => _runMutation(() async {
    await _repository.createKeyResult(
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
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> updateKeyResult({
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
  }) => _runMutation(() async {
    await _repository.updateKeyResult(
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
    okrs = await _repository.getOkrs(personId);
  });

  Future<void> generateSuggestions({String? focusArea, String? context}) =>
      _runMutation(() async {
        suggestions = await _repository.getSuggestions(
          personId: personId,
          focusArea: focusArea,
          context: context,
        );
      });

  void clearActionError() {
    actionErrorMessage = null;
    notifyListeners();
  }

  Future<void> _runMutation(Future<void> Function() action) async {
    actionErrorMessage = null;
    isMutating = true;
    notifyListeners();

    try {
      await action();
    } on ApiException catch (e) {
      actionErrorMessage = e.userMessage;
    } catch (_) {
      actionErrorMessage = 'Algo deu errado. Tente novamente.';
    } finally {
      isMutating = false;
      notifyListeners();
    }
  }

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
