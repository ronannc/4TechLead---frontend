import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';
import '../../people/repositories/person_repository.dart';
import '../models/integration_models.dart';
import '../repositories/integration_repository.dart';

class IntegrationsViewModel extends BaseViewModel {
  IntegrationsViewModel(this._repository, this._personRepository);

  final IntegrationRepository _repository;
  final PersonRepository _personRepository;

  List<IntegrationSystem> systems = [];
  List<Person> people = [];
  List<PersonExternalIdentity> identities = [];
  List<PersonDeliveryMetric> metrics = [];
  int systemsPage = 1;
  int identitiesPage = 1;
  int metricsPage = 1;
  int metricsLastPage = 1;
  int metricsTotal = 0;
  String? latestToken;
  String? actionErrorMessage;
  bool isMutating = false;

  static const int localPageSize = 5;

  List<IntegrationSystem> get pagedSystems {
    final start = (systemsPage - 1) * localPageSize;
    return systems.skip(start).take(localPageSize).toList(growable: false);
  }

  List<PersonExternalIdentity> get pagedIdentities {
    final start = (identitiesPage - 1) * localPageSize;
    return identities.skip(start).take(localPageSize).toList(growable: false);
  }

  int get systemsLastPage => _lastLocalPage(systems.length);

  int get identitiesLastPage => _lastLocalPage(identities.length);

  Future<void> load() => runCatching(() async {
    await _loadAll();
  });

  Future<bool> createSystem({
    required String name,
    required String provider,
    String? description,
  }) => _runMutation(() async {
    final system = await _repository.createSystem(
      name: name,
      provider: provider,
      description: description,
    );
    latestToken = system.webhookToken;
    systems = await _repository.getSystems();
    systemsPage = 1;
  });

  Future<bool> regenerateSystemToken(int systemId) => _runMutation(() async {
    final system = await _repository.regenerateSystemToken(systemId);
    latestToken = system.webhookToken;
    systems = await _repository.getSystems();
  });

  Future<bool> createExternalIdentity({
    required int personId,
    required int integrationSystemId,
  }) => _runMutation(() async {
    await _repository.createExternalIdentity(
      personId: personId,
      integrationSystemId: integrationSystemId,
    );
    identities = await _repository.getExternalIdentities();
    identitiesPage = 1;
  });

  void changeSystemsPage(int page) {
    systemsPage = page.clamp(1, systemsLastPage).toInt();
    notifyListeners();
  }

  void changeIdentitiesPage(int page) {
    identitiesPage = page.clamp(1, identitiesLastPage).toInt();
    notifyListeners();
  }

  Future<void> changeMetricsPage(int page) async {
    final nextPage = page.clamp(1, metricsLastPage).toInt();
    await _runMutation(() async {
      await _loadMetrics(page: nextPage);
    });
  }

  void clearActionError() {
    actionErrorMessage = null;
    notifyListeners();
  }

  String personName(int personId) {
    return people
            .where((person) => person.id == personId)
            .map((person) => person.name)
            .firstOrNull ??
        'Pessoa #$personId';
  }

  String systemName(int systemId) {
    return systems
            .where((system) => system.id == systemId)
            .map((system) => system.name)
            .firstOrNull ??
        'Integração #$systemId';
  }

  Future<void> _loadAll() async {
    final loadedSystems = await _repository.getSystems();
    final loadedPeople = await _personRepository.getPeople(perPage: 100);
    final loadedIdentities = await _repository.getExternalIdentities();

    systems = loadedSystems;
    people = loadedPeople;
    identities = loadedIdentities;
    systemsPage = 1;
    identitiesPage = 1;
    await _loadMetrics(page: 1);
  }

  Future<void> _loadMetrics({required int page}) async {
    final metricsPageResponse = await _repository.getDeliveryMetrics(
      page: page,
    );

    metrics = metricsPageResponse.items;
    metricsPage = metricsPageResponse.currentPage;
    metricsLastPage = metricsPageResponse.lastPage;
    metricsTotal = metricsPageResponse.total;
  }

  Future<bool> _runMutation(Future<void> Function() action) async {
    actionErrorMessage = null;
    isMutating = true;
    notifyListeners();

    try {
      await action();
      return true;
    } on ApiException catch (e) {
      actionErrorMessage = e.userMessage;
      return false;
    } catch (_) {
      actionErrorMessage = 'Algo deu errado. Tente novamente.';
      return false;
    } finally {
      isMutating = false;
      notifyListeners();
    }
  }

  int _lastLocalPage(int total) {
    if (total <= 0) {
      return 1;
    }

    return ((total - 1) ~/ localPageSize) + 1;
  }
}
