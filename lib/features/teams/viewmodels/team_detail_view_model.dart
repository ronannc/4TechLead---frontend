import '../../../core/viewmodels/base_view_model.dart';
import '../models/team.dart';
import '../repositories/team_repository.dart';

class TeamDetailViewModel extends BaseViewModel {
  TeamDetailViewModel(this._repository, this.teamId);

  final TeamRepository _repository;
  final int teamId;

  Team? _team;
  Team? get team => _team;

  Future<void> load() => runCatching(() async {
    _team = await _repository.getTeam(teamId);
  });
}
