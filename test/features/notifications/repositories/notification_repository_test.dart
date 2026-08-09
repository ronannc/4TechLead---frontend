import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/features/notifications/repositories/notification_repository.dart';
import 'package:for_tech_lead/features/notifications/services/notification_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotificationService extends Mock implements NotificationService {}

void main() {
  late _MockNotificationService service;
  late NotificationRepository repository;

  setUp(() {
    service = _MockNotificationService();
    repository = NotificationRepository(service);
  });

  test('maps a paginated notifications page', () async {
    when(() => service.getNotifications(page: 1)).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 1,
            'integration_system_id': 2,
            'integration_system': {
              'id': 2,
              'name': 'GitHub Actions',
              'provider': 'github',
            },
            'event_id': 'event-1',
            'title': 'Deploy finalizado',
            'message': 'Pipeline finalizou com sucesso.',
            'type': 'deploy',
            'severity': 'success',
            'source_ref': 'org/repo/actions/42',
            'payload': {'workflow': 'deploy'},
            'metadata': {'environment': 'production'},
            'received_at': '2026-08-09T12:00:00.000000Z',
            'created_at': '2026-08-09T12:00:01.000000Z',
          },
        ],
        'meta': {'current_page': 1, 'last_page': 2, 'total': 16},
      },
    );

    final page = await repository.getNotifications();

    expect(page.currentPage, 1);
    expect(page.lastPage, 2);
    expect(page.total, 16);
    expect(page.items.single.title, 'Deploy finalizado');
    expect(page.items.single.integrationSystem?.name, 'GitHub Actions');
    expect(page.items.single.payload, {'workflow': 'deploy'});
  });
}
