import '../../../core/viewmodels/base_view_model.dart';
import '../models/person.dart';
import '../repositories/person_repository.dart';

class PersonDetailViewModel extends BaseViewModel {
  PersonDetailViewModel(this._repository, this.personId);

  final PersonRepository _repository;
  final int personId;

  Person? _person;
  Person? get person => _person;

  Future<void> load() => runCatching(() async {
    _person = await _repository.getPerson(personId);
  });
}
