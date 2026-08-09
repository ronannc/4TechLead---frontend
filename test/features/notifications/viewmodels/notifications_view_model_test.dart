import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/notifications/models/external_notification.dart';
import 'package:for_tech_lead/features/notifications/repositories/notification_repository.dart';
import 'package:for_tech_lead/features/notifications/viewmodels/notifications_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late _MockNotificationRepository repository;
  late NotificationsViewModel viewModel;

  setUp(() {
    repository = _MockNotificationRepository();
    viewModel = NotificationsViewModel(repository);
  });

  test('load() exposes the first notifications page', () async {
    when(() => repository.getNotifications(page: 1)).thenAnswer(
      (_) async => NotificationsPage(
        items: [_notification(id: 1, title: 'Deploy finalizado')],
        currentPage: 1,
        lastPage: 3,
        total: 31,
      ),
    );

    await viewModel.load();

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.notifications.single.title, 'Deploy finalizado');
    expect(viewModel.page, 1);
    expect(viewModel.lastPage, 3);
    expect(viewModel.total, 31);
  });

  test('changePage() loads only the requested page', () async {
    when(() => repository.getNotifications(page: 1)).thenAnswer(
      (_) async => NotificationsPage(
        items: [_notification(id: 1, title: 'Página 1')],
        currentPage: 1,
        lastPage: 2,
        total: 2,
      ),
    );
    when(() => repository.getNotifications(page: 2)).thenAnswer(
      (_) async => NotificationsPage(
        items: [_notification(id: 2, title: 'Página 2')],
        currentPage: 2,
        lastPage: 2,
        total: 2,
      ),
    );

    await viewModel.load();
    await viewModel.changePage(2);

    expect(viewModel.notifications.single.title, 'Página 2');
    expect(viewModel.page, 2);
    verifyNever(() => repository.getNotifications(page: 3));
  });

  test(
    'changePage() keeps current page visible when the request fails',
    () async {
      when(() => repository.getNotifications(page: 2)).thenThrow(
        ValidationException({
          'page': ['Página inválida.'],
        }),
      );
      viewModel.notifications = [_notification(id: 1, title: 'Página 1')];
      viewModel.page = 1;
      viewModel.lastPage = 2;

      await viewModel.changePage(2);

      expect(viewModel.notifications.single.title, 'Página 1');
      expect(viewModel.page, 1);
      expect(viewModel.pageErrorMessage, 'Página inválida.');
      expect(viewModel.isChangingPage, isFalse);
    },
  );

  test(
    'refresh() reloads the current page without returning to page one',
    () async {
      when(() => repository.getNotifications(page: 2)).thenAnswer(
        (_) async => NotificationsPage(
          items: [_notification(id: 2, title: 'Página 2 atualizada')],
          currentPage: 2,
          lastPage: 3,
          total: 30,
        ),
      );
      viewModel.notifications = [_notification(id: 2, title: 'Página 2')];
      viewModel.page = 2;
      viewModel.lastPage = 3;
      viewModel.total = 30;

      await viewModel.refresh();

      expect(viewModel.notifications.single.title, 'Página 2 atualizada');
      expect(viewModel.page, 2);
      verifyNever(() => repository.getNotifications(page: 1));
    },
  );

  test(
    'refresh() keeps loaded content visible when the request fails',
    () async {
      when(
        () => repository.getNotifications(page: 2),
      ).thenThrow(const ServerException('Sem conexão.'));
      viewModel.notifications = [_notification(id: 2, title: 'Página 2')];
      viewModel.page = 2;
      viewModel.lastPage = 3;
      viewModel.total = 30;

      await viewModel.refresh();

      expect(viewModel.notifications.single.title, 'Página 2');
      expect(viewModel.page, 2);
      expect(viewModel.pageErrorMessage, 'Sem conexão.');
    },
  );
}

ExternalNotification _notification({required int id, required String title}) {
  return ExternalNotification(
    id: id,
    integrationSystemId: 1,
    title: title,
    message: 'Mensagem',
    source: 'GitHub Actions',
    severity: 'info',
    receivedAt: DateTime(2026, 8, 9, 12),
  );
}
