import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/features/integrations/repositories/integration_repository.dart';
import 'package:for_tech_lead/features/integrations/services/integration_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockIntegrationService extends Mock implements IntegrationService {}

void main() {
  late _MockIntegrationService service;
  late IntegrationRepository repository;

  setUp(() {
    service = _MockIntegrationService();
    repository = IntegrationRepository(service);
  });

  test('maps integration systems with a one time token', () async {
    when(service.getSystems).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'name': 'GitHub Produto',
            'provider': 'github',
            'description': 'PRs e CI',
            'token_prefix': 'abc12345',
            'webhook_token': 'secret-token',
            'active': true,
            'last_received_at': null,
          },
        ],
      },
    );

    final systems = await repository.getSystems();

    expect(systems.single.name, 'GitHub Produto');
    expect(systems.single.webhookToken, 'secret-token');
  });

  test('maps external identities', () async {
    when(service.getExternalIdentities).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'person_id': 2,
            'integration_system_id': 3,
            'external_code': 'lucas-github',
            'external_username': 'Lucas',
            'active': true,
          },
        ],
      },
    );

    final identities = await repository.getExternalIdentities();

    expect(identities.single.personId, 2);
    expect(identities.single.externalCode, 'lucas-github');
  });

  test('maps delivery metrics', () async {
    when(() => service.getDeliveryMetrics(page: 1)).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'person_id': 2,
            'integration_system_id': 3,
            'metric_type': 'code_quality_score',
            'metric_value': '91.00',
            'unit': 'score',
            'source_ref': 'org/repo#42',
            'occurred_at': '2026-08-08T18:00:00Z',
          },
        ],
      },
    );

    final metrics = await repository.getDeliveryMetrics();

    expect(metrics.single.metricType, 'code_quality_score');
    expect(metrics.single.metricValue, 91);
    expect(metrics.single.sourceRef, 'org/repo#42');
  });
}
