import '../../../core/viewmodels/base_view_model.dart';
import '../models/team.dart';
import '../repositories/team_repository.dart';

class TeamsListViewModel extends BaseViewModel {
  TeamsListViewModel(this._repository);

  final TeamRepository _repository;

  List<Team> _teams = [];
  List<Team> get teams => List.unmodifiable(_teams);

  Future<void> load() => runCatching(() async {
    _teams = await _repository.getTeams();
  });

  Future<void> createTeam(String name) => runCatching(() async {
    final team = await _repository.createTeam(name: name);
    _teams = [team, ..._teams];
  });
}
