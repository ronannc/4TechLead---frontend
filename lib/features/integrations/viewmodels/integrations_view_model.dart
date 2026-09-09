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
  List<IntegrationWebhookEvent> webhookEvents = [];
  int systemsPage = 1;
  int identitiesPage = 1;
  int metricsPage = 1;
  int metricsLastPage = 1;
  int metricsTotal = 0;
  int webhookEventsPage = 1;
  int webhookEventsLastPage = 1;
  int webhookEventsTotal = 0;
  String webhookEventSearch = '';
  int? webhookEventSystemId;
  int? webhookEventPersonId;
  String? webhookEventStatus;
  bool webhookEventsOnlyUnmapped = false;
  bool webhookEventsOnlyFailures = false;
  String webhookEventsOrderDirection = 'desc';
  IntegrationWebhookEvent? selectedWebhookEvent;
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

  Future<void> changeWebhookEventsPage(int page) async {
    final nextPage = page.clamp(1, webhookEventsLastPage).toInt();
    await _runMutation(() async {
      await _loadWebhookEvents(page: nextPage);
    });
  }

  Future<void> updateWebhookEventFilters({
    String? search,
    int? systemId,
    bool clearSystemId = false,
    int? personId,
    bool clearPersonId = false,
    String? status,
    bool clearStatus = false,
    bool? onlyUnmapped,
    bool? onlyFailures,
    String? orderDirection,
  }) async {
    webhookEventSearch = search ?? webhookEventSearch;
    webhookEventSystemId = clearSystemId
        ? null
        : systemId ?? webhookEventSystemId;
    webhookEventPersonId = clearPersonId
        ? null
        : personId ?? webhookEventPersonId;
    webhookEventStatus = clearStatus ? null : status ?? webhookEventStatus;
    webhookEventsOnlyUnmapped = onlyUnmapped ?? webhookEventsOnlyUnmapped;
    webhookEventsOnlyFailures = onlyFailures ?? webhookEventsOnlyFailures;
    webhookEventsOrderDirection = orderDirection ?? webhookEventsOrderDirection;

    await _runMutation(() async {
      await _loadWebhookEvents(page: 1);
    });
  }

  Future<void> clearWebhookEventFilters() async {
    webhookEventSearch = '';
    webhookEventSystemId = null;
    webhookEventPersonId = null;
    webhookEventStatus = null;
    webhookEventsOnlyUnmapped = false;
    webhookEventsOnlyFailures = false;
    webhookEventsOrderDirection = 'desc';

    await _runMutation(() async {
      await _loadWebhookEvents(page: 1);
    });
  }

  Future<bool> loadWebhookEventDetail(int eventId) => _runMutation(() async {
    selectedWebhookEvent = await _repository.getWebhookEvent(eventId);
  });

  Future<bool> archiveWebhookEvent(int eventId) => _runMutation(() async {
    await _repository.archiveWebhookEvent(eventId);
    if (selectedWebhookEvent?.id == eventId) {
      selectedWebhookEvent = null;
    }
    await _loadWebhookEvents(page: webhookEventsPage);
  });

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
    await _loadWebhookEvents(page: 1);
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

  Future<void> _loadWebhookEvents({required int page}) async {
    final eventsPageResponse = await _repository.getWebhookEvents(
      page: page,
      search: webhookEventSearch,
      integrationSystemId: webhookEventSystemId,
      personId: webhookEventPersonId,
      status: webhookEventStatus,
      unmapped: webhookEventsOnlyUnmapped,
      withFailure: webhookEventsOnlyFailures,
      orderDirection: webhookEventsOrderDirection,
    );

    webhookEvents = eventsPageResponse.items;
    webhookEventsPage = eventsPageResponse.currentPage;
    webhookEventsLastPage = eventsPageResponse.lastPage;
    webhookEventsTotal = eventsPageResponse.total;
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
