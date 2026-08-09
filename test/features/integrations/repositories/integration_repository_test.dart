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

  test('maps regenerated integration system token', () async {
    when(() => service.regenerateSystemToken(1)).thenAnswer(
      (_) async => {
        'data': {
          'id': 1,
          'name': 'GitHub Produto',
          'provider': 'github',
          'description': 'PRs e CI',
          'token_prefix': 'new12345',
          'webhook_token': 'new-secret-token',
          'active': true,
          'last_received_at': null,
        },
      },
    );

    final system = await repository.regenerateSystemToken(1);

    expect(system.tokenPrefix, 'new12345');
    expect(system.webhookToken, 'new-secret-token');
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
            'active': true,
          },
        ],
      },
    );

    final identities = await repository.getExternalIdentities();

    expect(identities.single.personId, 2);
    expect(identities.single.externalCode, 'lucas-github');
  });

  test('maps a paginated delivery metrics page', () async {
    when(() => service.getDeliveryMetrics(page: 1)).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'person_id': 2,
            'integration_system_id': 3,
            'metric_type': 'code_quality_score',
            'metric_value': '55.00',
            'unit': 'score',
            'source_ref': 'org/repo#42',
            'occurred_at': '2026-08-08T18:00:00Z',
          },
        ],
        'meta': {'current_page': 1, 'last_page': 3, 'total': 41},
      },
    );

    final page = await repository.getDeliveryMetrics();

    expect(page.currentPage, 1);
    expect(page.lastPage, 3);
    expect(page.total, 41);
    expect(page.items.single.metricType, 'code_quality_score');
    expect(page.items.single.metricValue, 55);
    expect(page.items.single.sourceRef, 'org/repo#42');
  });

  test(
    'keeps delivery metric rows numeric even with legacy metadata',
    () async {
      when(() => service.getDeliveryMetrics(page: 1)).thenAnswer(
        (_) async => {
          'data': [
            {
              'id': 1,
              'person_id': 2,
              'integration_system_id': 3,
              'metric_type': 'code_quality_score',
              'metric_value': '66.00',
              'unit': 'score',
              'source_ref': 'org/repo#44',
              'occurred_at': '2026-08-08T18:00:00Z',
              'metadata': {
                'analysis': {'summary': 'Should not render here.'},
              },
            },
          ],
        },
      );

      final page = await repository.getDeliveryMetrics();

      expect(page.items.single.metricType, 'code_quality_score');
    },
  );

  test('getDeliveryMetrics returns only the requested metric page', () async {
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
        'meta': {'last_page': 2},
      },
    );
    when(() => service.getDeliveryMetrics(page: 2)).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 2,
            'person_id': 2,
            'integration_system_id': 3,
            'metric_type': 'delivery_points',
            'metric_value': '8.00',
            'unit': 'points',
            'source_ref': 'org/repo#43',
            'occurred_at': '2026-08-09T18:00:00Z',
          },
        ],
        'meta': {'last_page': 2},
      },
    );

    final page = await repository.getDeliveryMetrics(page: 1);

    expect(page.items, hasLength(1));
    expect(page.items.single.metricType, 'code_quality_score');
    verifyNever(() => service.getDeliveryMetrics(page: 2));
  });
}
