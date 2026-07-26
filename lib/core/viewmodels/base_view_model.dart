import 'package:flutter/foundation.dart';

import '../network/api_exception.dart';

enum ViewState { idle, loading, loaded, error }

/// Base class every feature ViewModel extends. Wraps async work in
/// [runCatching] so loading/loaded/error transitions and [ApiException]
/// handling don't need to be repeated in every ViewModel method.
abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;

  @protected
  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  @protected
  Future<void> runCatching(Future<void> Function() action) async {
    setState(ViewState.loading);

    try {
      await action();
      setState(ViewState.loaded);
    } on ApiException catch (e) {
      _errorMessage = e.userMessage;
      setState(ViewState.error);
    } catch (_) {
      _errorMessage = 'Algo deu errado. Tente novamente.';
      setState(ViewState.error);
    }
  }
}
