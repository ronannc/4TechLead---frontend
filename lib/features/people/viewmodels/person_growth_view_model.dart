import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../integrations/models/integration_models.dart';
import '../models/person_growth_models.dart';
import '../repositories/person_growth_repository.dart';

class PersonGrowthViewModel extends BaseViewModel {
  PersonGrowthViewModel(this._repository, this.personId);

  final PersonGrowthRepository _repository;
  final int personId;

  List<OneOnOneTemplate> templates = [];
  List<OneOnOneSession> sessions = [];
  List<DevelopmentPlan> plans = [];
  List<PersonDeliveryMetric> deliveryMetrics = [];
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
      _repository.getSuggestions(personId: personId),
      _repository.getDeliveryMetrics(personId),
    ]);

    templates = results[0] as List<OneOnOneTemplate>;
    sessions = results[1] as List<OneOnOneSession>;
    plans = results[2] as List<DevelopmentPlan>;
    suggestions = results[3] as GrowthSuggestions;
    deliveryMetrics = results[4] as List<PersonDeliveryMetric>;
  }
}
