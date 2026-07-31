import '../../../core/viewmodels/base_view_model.dart';
import '../models/person.dart';
import '../repositories/person_repository.dart';

/// Lists the members of a single team (scoped by [teamId]) — see
/// `TeamDetailScreen`'s "Membros" section.
class PeopleListViewModel extends BaseViewModel {
  PeopleListViewModel(this._repository, this.teamId);

  final PersonRepository _repository;
  final int teamId;

  List<Person> _people = [];
  String _query = '';

  bool get hasPeople => _people.isNotEmpty;

  /// Filtered by [search] — always the full list when the query is empty.
  List<Person> get people {
    if (_query.isEmpty) {
      return List.unmodifiable(_people);
    }

    final lowerQuery = _query.toLowerCase();

    return List.unmodifiable(
      _people.where((person) => person.name.toLowerCase().contains(lowerQuery)),
    );
  }

  Future<void> load() => runCatching(() async {
    _people = await _repository.getPeople(teamId: teamId, perPage: 100);
  });

  void search(String query) {
    _query = query;
    notifyListeners();
  }
}
