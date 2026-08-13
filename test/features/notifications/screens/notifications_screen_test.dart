import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/bootstrap.dart';
import 'package:for_tech_lead/features/notifications/models/external_notification.dart';
import 'package:for_tech_lead/features/notifications/repositories/notification_repository.dart';
import 'package:for_tech_lead/features/notifications/screens/notifications_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  tearDown(getIt.reset);

  testWidgets('renders notifications and paginates through pages', (
    tester,
  ) async {
    final repository = _MockNotificationRepository();

    when(() => repository.getNotifications(page: 1)).thenAnswer(
      (_) async => NotificationsPage(
        items: [
          _notification(id: 1, title: 'Deploy finalizado', severity: 'success'),
        ],
        currentPage: 1,
        lastPage: 2,
        total: 2,
      ),
    );
    when(() => repository.getNotifications(page: 2)).thenAnswer(
      (_) async => NotificationsPage(
        items: [_notification(id: 2, title: 'CI falhou', severity: 'error')],
        currentPage: 2,
        lastPage: 2,
        total: 2,
      ),
    );

    getIt.registerSingleton<NotificationRepository>(repository);

    await tester.pumpWidget(const MaterialApp(home: NotificationsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Deploy finalizado'), findsOneWidget);
    expect(find.text('2 notificações recebidas'), findsOneWidget);

    await tester.tap(find.text('→'));
    await tester.pumpAndSettle();

    expect(find.text('CI falhou'), findsOneWidget);
    expect(find.text('Página 2 de 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

ExternalNotification _notification({
  required int id,
  required String title,
  required String severity,
}) {
  return ExternalNotification(
    id: id,
    integrationSystemId: 1,
    integrationSystem: const NotificationIntegrationSystem(
      id: 1,
      name: 'GitHub Actions',
      provider: 'github',
    ),
    title: title,
    message: 'Mensagem enviada por sistema externo.',
    source: 'GitHub Actions',
    type: 'deploy',
    severity: severity,
    sourceRef: 'org/repo#42',
    receivedAt: DateTime(2026, 8, 9, 12),
  );
}
