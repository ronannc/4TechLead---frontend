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

  Future<List<PersonExternalIdentity>> getExternalIdentities() async {
    final json = await _service.getExternalIdentities();
    return _list(json, PersonExternalIdentity.fromJson);
  }

  Future<PersonExternalIdentity> createExternalIdentity({
    required int personId,
    required int integrationSystemId,
    required String externalCode,
    String? externalUsername,
  }) async {
    final json = await _service.createExternalIdentity(
      personId: personId,
      integrationSystemId: integrationSystemId,
      externalCode: externalCode,
      externalUsername: externalUsername,
    );

    return PersonExternalIdentity.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }

  Future<List<PersonDeliveryMetric>> getDeliveryMetrics({int page = 1}) async {
    final json = await _service.getDeliveryMetrics(page: page);
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
