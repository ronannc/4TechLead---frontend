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
  bool templatesLoaded = false;
  bool sessionsLoaded = false;
  bool plansLoaded = false;
  bool metricsLoaded = false;
  bool suggestionsLoaded = false;

  Future<void> loadOneOnOne() => runCatching(() async {
    await Future.wait([
      _ensureTemplates(),
      _ensureSessions(),
      _ensureSuggestions(),
    ]);
  });

  Future<void> loadPdi() => runCatching(() async {
    await Future.wait([_ensurePlans(), _ensureSuggestions()]);
  });

  Future<void> loadAnalysis() => runCatching(() async {
    await Future.wait([_ensureMetrics(), _ensureSuggestions()]);
  });

  Future<void> searchSessions(String value) => runCatching(() async {
    sessionSearch = value;
    sessionPage = 1;
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
    sessionsLoaded = true;
  });

  Future<void> nextSessionPage() => runCatching(() async {
    sessionPage += 1;
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
    sessionsLoaded = true;
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
    sessionsLoaded = true;
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
    templatesLoaded = true;
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
    sessionsLoaded = true;
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
    plansLoaded = true;
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
    plansLoaded = true;
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
    plansLoaded = true;
  });

  Future<void> generateSuggestions({String? focusArea, String? context}) =>
      _runMutation(() async {
        suggestions = await _repository.getSuggestions(
          personId: personId,
          focusArea: focusArea,
          context: context,
        );
        suggestionsLoaded = true;
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

  Future<void> _ensureTemplates() async {
    if (templatesLoaded) {
      return;
    }
    templates = await _repository.getTemplates();
    templatesLoaded = true;
  }

  Future<void> _ensureSessions() async {
    if (sessionsLoaded) {
      return;
    }
    sessions = await _repository.getSessions(personId: personId);
    sessionsLoaded = true;
  }

  Future<void> _ensurePlans() async {
    if (plansLoaded) {
      return;
    }
    plans = await _repository.getDevelopmentPlans(personId);
    plansLoaded = true;
  }

  Future<void> _ensureMetrics() async {
    if (metricsLoaded) {
      return;
    }
    deliveryMetrics = await _repository.getDeliveryMetrics(personId);
    metricsLoaded = true;
  }

  Future<void> _ensureSuggestions() async {
    if (suggestionsLoaded) {
      return;
    }
    suggestions = await _repository.getSuggestions(personId: personId);
    suggestionsLoaded = true;
  }
}
