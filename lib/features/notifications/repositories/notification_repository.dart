import '../models/external_notification.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  NotificationRepository(this._service);

  final NotificationService _service;

  Future<NotificationsPage> getNotifications({
    int page = 1,
    int perPage = 15,
  }) async {
    final json = await _service.getNotifications(page: page, perPage: perPage);
    return NotificationsPage.fromJson(json);
  }
}
