import '../models/integration_models.dart';
import '../services/integration_service.dart';

class IntegrationRepository {
  IntegrationRepository(this._service);

  final IntegrationService _service;

  Future<List<IntegrationSystem>> getSystems() async {
    final json = await _service.getSystems();
    return _list(json, IntegrationSystem.fromJson);
  }

  Future<IntegrationSystem> createSystem({
    required String name,
    required String provider,
    String? description,
  }) async {
    final json = await _service.createSystem(
      name: name,
      provider: provider,
      description: description,
    );

    return IntegrationSystem.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<IntegrationSystem> regenerateSystemToken(int systemId) async {
    final json = await _service.regenerateSystemToken(systemId);

    return IntegrationSystem.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<List<PersonExternalIdentity>> getExternalIdentities() async {
    final json = await _service.getExternalIdentities();
    return _list(json, PersonExternalIdentity.fromJson);
  }

  Future<PersonExternalIdentity> createExternalIdentity({
    required int personId,
    required int integrationSystemId,
  }) async {
    final json = await _service.createExternalIdentity(
      personId: personId,
      integrationSystemId: integrationSystemId,
    );

    return PersonExternalIdentity.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }

  Future<DeliveryMetricsPage> getDeliveryMetrics({int page = 1}) async {
    final json = await _service.getDeliveryMetrics(page: page);
    return DeliveryMetricsPage.fromJson(json);
  }

  Future<WebhookEventsPage> getWebhookEvents({
    int page = 1,
    String? search,
    int? integrationSystemId,
    int? personId,
    String? status,
    bool unmapped = false,
    bool withFailure = false,
    String orderDirection = 'desc',
  }) async {
    final json = await _service.getWebhookEvents(
      page: page,
      search: search,
      integrationSystemId: integrationSystemId,
      personId: personId,
      status: status,
      unmapped: unmapped,
      withFailure: withFailure,
      orderDirection: orderDirection,
    );
    return WebhookEventsPage.fromJson(json);
  }

  Future<IntegrationWebhookEvent> getWebhookEvent(int eventId) async {
    final json = await _service.getWebhookEvent(eventId);
    return IntegrationWebhookEvent.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }

  Future<void> archiveWebhookEvent(int eventId) {
    return _service.archiveWebhookEvent(eventId);
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
