import '../../../core/viewmodels/base_view_model.dart';
import '../../teams/repositories/team_repository.dart';

/// Drives the Home dashboard's summary cards. Loads whatever cross-feature
/// counts are cheap to fetch on entry — currently just Teams; extend with
/// more Repository calls as more features exist (e.g. People, once the
/// frontend has its own `people` feature).
class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._teamRepository);

  final TeamRepository _teamRepository;

  int _teamsCount = 0;
  int get teamsCount => _teamsCount;

  Future<void> load() => runCatching(() async {
    final teams = await _teamRepository.getTeams();
    _teamsCount = teams.length;
  });
}
