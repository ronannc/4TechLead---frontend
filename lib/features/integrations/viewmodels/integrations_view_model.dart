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
  String? latestToken;
  String? actionErrorMessage;
  bool isMutating = false;

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
  });

  Future<bool> createExternalIdentity({
    required int personId,
    required int integrationSystemId,
    required String externalCode,
    String? externalUsername,
  }) => _runMutation(() async {
    await _repository.createExternalIdentity(
      personId: personId,
      integrationSystemId: integrationSystemId,
      externalCode: externalCode,
      externalUsername: externalUsername,
    );
    identities = await _repository.getExternalIdentities();
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
    final loadedMetrics = await _repository.getDeliveryMetrics();

    systems = loadedSystems;
    people = loadedPeople;
    identities = loadedIdentities;
    metrics = loadedMetrics;
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
}
