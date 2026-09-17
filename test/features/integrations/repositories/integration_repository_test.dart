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
            'webhook_url': 'https://app.test/api/v1/clickup-webhooks',
            'has_provider_api_token': true,
            'active': true,
            'last_received_at': null,
          },
        ],
      },
    );

    final systems = await repository.getSystems();

    expect(systems.single.name, 'GitHub Produto');
    expect(systems.single.webhookToken, 'secret-token');
    expect(
      systems.single.webhookUrl,
      'https://app.test/api/v1/clickup-webhooks',
    );
    expect(systems.single.hasProviderApiToken, isTrue);
  });

  test(
    'forwards provider api token when creating integration systems',
    () async {
      when(
        () => service.createSystem(
          name: 'ClickUp Produto',
          provider: 'clickup',
          description: null,
          providerApiToken: 'pk_clickup_api_token',
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'id': 1,
            'name': 'ClickUp Produto',
            'provider': 'clickup',
            'description': null,
            'token_prefix': 'abc12345',
            'webhook_token': 'secret-token',
            'webhook_url': 'https://app.test/api/v1/clickup-webhooks',
            'has_provider_api_token': true,
            'active': true,
            'last_received_at': null,
          },
        },
      );

      final system = await repository.createSystem(
        name: 'ClickUp Produto',
        provider: 'clickup',
        providerApiToken: 'pk_clickup_api_token',
      );

      expect(system.provider, 'clickup');
      expect(system.hasProviderApiToken, isTrue);
    },
  );

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
          'webhook_url': 'https://app.test/api/v1/github-webhooks',
          'active': true,
          'last_received_at': null,
        },
      },
    );

    final system = await repository.regenerateSystemToken(1);

    expect(system.tokenPrefix, 'new12345');
    expect(system.webhookToken, 'new-secret-token');
    expect(system.webhookUrl, 'https://app.test/api/v1/github-webhooks');
  });

  test('maps integrations whose webhook token was revoked', () async {
    when(service.getSystems).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'name': 'ClickUp Produto',
            'provider': 'clickup',
            'token_prefix': null,
            'has_webhook_token': false,
            'has_provider_api_token': true,
            'active': true,
          },
        ],
      },
    );

    final systems = await repository.getSystems();

    expect(systems.single.tokenPrefix, isNull);
    expect(systems.single.hasWebhookToken, isFalse);
    expect(systems.single.hasProviderApiToken, isTrue);
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

  test(
    'maps historical identities after their integration is deleted',
    () async {
      when(service.getExternalIdentities).thenAnswer(
        (_) async => {
          'data': [
            {
              'id': 1,
              'person_id': 2,
              'integration_system_id': null,
              'external_code': 'lucas-github',
              'active': true,
            },
          ],
        },
      );

      final identities = await repository.getExternalIdentities();

      expect(identities.single.integrationSystemId, isNull);
    },
  );

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

  test('maps a paginated webhook events page', () async {
    when(
      () => service.getWebhookEvents(
        page: 1,
        search: null,
        integrationSystemId: null,
        personId: null,
        status: null,
        unmapped: false,
        withFailure: false,
        orderDirection: 'desc',
      ),
    ).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 10,
            'integration_system_id': 3,
            'person_id': null,
            'event_id': 'github-delivery-1',
            'event_type': 'pull_request.merged',
            'external_actor_code': 'ada',
            'status': 'unmapped_person',
            'failure_reason': null,
            'payload': {'repository': 'org/repo'},
            'payload_hash': 'abc123',
            'payload_size_bytes': 1234,
            'normalized_payload': {'task_reference': 'DRIE-21919'},
            'delivery_metrics_count': 2,
            'received_at': '2026-09-08T18:00:00Z',
            'delivery_metrics': [
              {
                'id': 1,
                'person_id': 2,
                'integration_system_id': 3,
                'metric_type': 'pull_request_count',
                'metric_value': '1.00',
                'unit': 'count',
                'source_ref': 'org/repo#42',
                'occurred_at': '2026-09-08T18:00:00Z',
              },
            ],
          },
        ],
        'meta': {'current_page': 1, 'last_page': 4, 'total': 61},
      },
    );

    final page = await repository.getWebhookEvents();

    expect(page.currentPage, 1);
    expect(page.lastPage, 4);
    expect(page.total, 61);
    expect(page.items.single.eventType, 'pull_request.merged');
    expect(page.items.single.payload['repository'], 'org/repo');
    expect(page.items.single.deliveryMetricsCount, 2);
    expect(
      page.items.single.deliveryMetrics.single.metricType,
      'pull_request_count',
    );
  });

  test('enriches a webhook event and maps the returned payload', () async {
    when(() => service.enrichWebhookEvent(42)).thenAnswer(
      (_) async => {
        'data': {
          'id': 42,
          'integration_system_id': 3,
          'event_id': 'clickup-event-42',
          'event_type': 'taskUpdated',
          'status': 'processed',
          'payload': {
            'task': {'id': 'task-42', 'name': 'Task enriquecida'},
          },
          'normalized_payload': {
            'task_id': 'task-42',
            'task_name': 'Task enriquecida',
            'task_enrichment_status': 'enriched',
          },
          'delivery_metrics': <Map<String, dynamic>>[],
        },
      },
    );

    final event = await repository.enrichWebhookEvent(42);

    expect(event.id, 42);
    expect(
      (event.payload['task'] as Map<String, dynamic>)['name'],
      'Task enriquecida',
    );
    expect(event.normalizedPayload?['task_enrichment_status'], 'enriched');
    verify(() => service.enrichWebhookEvent(42)).called(1);
  });

  test(
    'maps historical webhook events after their integration is deleted',
    () async {
      when(
        () => service.getWebhookEvents(
          page: 1,
          search: null,
          integrationSystemId: null,
          personId: null,
          status: null,
          unmapped: false,
          withFailure: false,
          orderDirection: 'desc',
        ),
      ).thenAnswer(
        (_) async => {
          'data': <Map<String, dynamic>>[
            {
              'id': 11,
              'integration_system_id': null,
              'person_id': null,
              'event_id': 'github-delivery-preserved',
              'event_type': 'pull_request.merged',
              'external_actor_code': 'ada',
              'status': 'unmapped_person',
              'failure_reason': null,
              'payload': {'repository': 'org/repo'},
              'delivery_metrics': <Map<String, dynamic>>[],
            },
          ],
        },
      );

      final page = await repository.getWebhookEvents();

      expect(page.items.single.eventId, 'github-delivery-preserved');
      expect(page.items.single.integrationSystemId, isNull);
    },
  );
}
