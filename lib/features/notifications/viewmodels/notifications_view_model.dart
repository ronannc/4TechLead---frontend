import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../models/external_notification.dart';
import '../repositories/notification_repository.dart';

class NotificationsViewModel extends BaseViewModel {
  NotificationsViewModel(this._repository);

  final NotificationRepository _repository;

  List<ExternalNotification> notifications = [];
  int page = 1;
  int lastPage = 1;
  int total = 0;
  String? pageErrorMessage;
  bool isChangingPage = false;

  Future<void> load() => runCatching(() async {
    await _loadPage(1);
  });

  Future<void> refresh() async {
    if (notifications.isEmpty) {
      await load();
      return;
    }

    pageErrorMessage = null;
    notifyListeners();

    try {
      await _loadPage(page);
      setState(ViewState.loaded);
    } on ApiException catch (e) {
      pageErrorMessage = e.userMessage;
      notifyListeners();
    } catch (_) {
      pageErrorMessage = 'Algo deu errado. Tente novamente.';
      notifyListeners();
    }
  }

  Future<void> changePage(int requestedPage) async {
    final nextPage = requestedPage.clamp(1, lastPage).toInt();
    if (nextPage == page || isChangingPage) {
      return;
    }

    pageErrorMessage = null;
    isChangingPage = true;
    notifyListeners();

    try {
      await _loadPage(nextPage);
    } on ApiException catch (e) {
      pageErrorMessage = e.userMessage;
    } catch (_) {
      pageErrorMessage = 'Algo deu errado. Tente novamente.';
    } finally {
      isChangingPage = false;
      notifyListeners();
    }
  }

  void clearPageError() {
    pageErrorMessage = null;
    notifyListeners();
  }

  Future<void> _loadPage(int nextPage) async {
    final response = await _repository.getNotifications(page: nextPage);

    notifications = response.items;
    page = response.currentPage;
    lastPage = response.lastPage;
    total = response.total;
  }
}
