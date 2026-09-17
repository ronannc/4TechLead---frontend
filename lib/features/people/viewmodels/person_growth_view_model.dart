import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../integrations/models/integration_models.dart';
import '../models/person_growth_models.dart';
import '../repositories/person_growth_repository.dart';

class PersonGrowthViewModel extends BaseViewModel {
  PersonGrowthViewModel(
    this._repository,
    this.personId, {
    this.canManageGrowth = true,
  });

  final PersonGrowthRepository _repository;
  final int personId;
  final bool canManageGrowth;

  List<OneOnOneTemplate> templates = [];
  List<OneOnOneSession> sessions = [];
  List<DevelopmentPlan> plans = [];
  List<PersonDeliveryMetric> deliveryMetrics = [];
  DeliveryKpiSummary? deliveryKpis;
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

  Future<void> loadOneOnOneHistory() => runCatching(() async {
    await _ensureSessions();
  });

  Future<void> loadOneOnOneTemplates() => runCatching(() async {
    await _ensureTemplates();
  });

  Future<void> loadOneOnOneSuggestions() => runCatching(() async {
    await _ensureSuggestions();
  });

  Future<void> loadPdiTracking() => runCatching(() async {
    await _ensurePlans();
  });

  Future<void> loadPdiSuggestions() => runCatching(() async {
    await _ensureSuggestions();
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

  Future<bool> createTemplate({
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

  Future<bool> createSession({
    required String title,
    String? notes,
    int? templateId,
    List<String>? questions,
    Map<String, dynamic>? answers,
  }) => _runMutation(() async {
    await _repository.createSession(
      personId: personId,
      title: title,
      notes: notes,
      heldAt: DateTime.now(),
      templateId: templateId,
      questions: questions,
      answers: answers,
    );
    sessions = await _repository.getSessions(
      personId: personId,
      page: sessionPage,
      search: sessionSearch,
    );
    sessionsLoaded = true;
  });

  Future<bool> createPlan({
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
    plans = await _getReadableDevelopmentPlans();
    plansLoaded = true;
  });

  Future<bool> deletePlan(int id) async {
    return _runMutation(() async {
      await _repository.deleteDevelopmentPlan(id);
      plans = await _getReadableDevelopmentPlans();
      plansLoaded = true;
    });
  }

  Future<bool> updatePlan({
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
    plans = await _getReadableDevelopmentPlans();
    plansLoaded = true;
  });

  Future<bool> createPlanItem({
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
    plans = await _getReadableDevelopmentPlans();
    plansLoaded = true;
  });

  Future<bool> generateSuggestions({String? focusArea, String? context}) =>
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

  Future<bool> _runMutation(Future<void> Function() action) async {
    if (isMutating) {
      return false;
    }

    actionErrorMessage = null;
    isMutating = true;
    notifyListeners();

    try {
      await action();
      return actionErrorMessage == null;
    } on ApiException catch (e) {
      actionErrorMessage = e.userMessage;
    } catch (_) {
      actionErrorMessage = 'Algo deu errado. Tente novamente.';
    } finally {
      isMutating = false;
      notifyListeners();
    }

    return false;
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
    plans = await _getReadableDevelopmentPlans();
    plansLoaded = true;
  }

  Future<List<DevelopmentPlan>> _getReadableDevelopmentPlans() {
    if (canManageGrowth) {
      return _repository.getDevelopmentPlans(personId);
    }

    return _repository.getMyDevelopmentPlans();
  }

  Future<void> _ensureMetrics() async {
    if (metricsLoaded) {
      return;
    }
    if (canManageGrowth) {
      deliveryKpis = await _repository.getDeliveryKpis(personId);
    }
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
