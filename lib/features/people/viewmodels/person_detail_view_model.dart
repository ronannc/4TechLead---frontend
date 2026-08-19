import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../models/person.dart';
import '../repositories/person_repository.dart';

class PersonDetailViewModel extends BaseViewModel {
  PersonDetailViewModel(this._repository, this.personId);

  final PersonRepository _repository;
  final int personId;

  Person? _person;
  Person? get person => _person;

  String? _invitationToken;
  String? get invitationToken => _invitationToken;
  String? _invitationErrorMessage;
  String? get invitationErrorMessage => _invitationErrorMessage;

  Future<void> load() => runCatching(() async {
    _person = await _repository.getPerson(personId);
  });

  Future<void> createInvitationToken() async {
    try {
      _invitationErrorMessage = null;
      _invitationToken = await _repository.createInvitationToken(personId);
    } on ApiException catch (e) {
      _invitationToken = null;
      _invitationErrorMessage = e.userMessage;
    } catch (_) {
      _invitationToken = null;
      _invitationErrorMessage = 'Algo deu errado. Tente novamente.';
    }

    notifyListeners();
  }

  void clearInvitationToken() {
    _invitationToken = null;
    _invitationErrorMessage = null;
    notifyListeners();
  }
}
