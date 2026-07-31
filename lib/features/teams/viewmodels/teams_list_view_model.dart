import '../../../core/viewmodels/base_view_model.dart';
import '../models/team.dart';
import '../repositories/team_repository.dart';

class TeamsListViewModel extends BaseViewModel {
  TeamsListViewModel(this._repository);

  final TeamRepository _repository;

  List<Team> _teams = [];
  String _query = '';

  bool get hasTeams => _teams.isNotEmpty;

  /// Filtered by [search] — always the full list when the query is empty.
  List<Team> get teams {
    if (_query.isEmpty) {
      return List.unmodifiable(_teams);
    }

    final lowerQuery = _query.toLowerCase();

    return List.unmodifiable(
      _teams.where((team) => team.name.toLowerCase().contains(lowerQuery)),
    );
  }

  Future<void> load() => runCatching(() async {
    _teams = await _repository.getTeams();
  });

  Future<void> createTeam(String name) => runCatching(() async {
    final team = await _repository.createTeam(name: name);
    _teams = [team, ..._teams];
  });

  void search(String query) {
    _query = query;
    notifyListeners();
  }
}
