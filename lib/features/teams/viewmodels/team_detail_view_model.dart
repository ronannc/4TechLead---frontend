import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';
import '../models/team.dart';
import '../repositories/team_repository.dart';

class TeamDetailViewModel extends BaseViewModel {
  TeamDetailViewModel(this._repository, this.teamId);

  final TeamRepository _repository;
  final int teamId;

  Team? _team;
  Team? get team => _team;
  String _membersQuery = '';
  bool isChangingMembersPage = false;
  String? membersErrorMessage;

  List<Person> get members => _team?.people ?? const [];
  int get membersPage => _team?.peoplePage ?? 1;
  int get membersLastPage => _team?.peopleLastPage ?? 1;
  int get membersTotal => _team?.peopleTotal ?? 0;
  bool get hasMembers => membersTotal > 0;

  Future<void> load() => runCatching(() async {
    _team = await _repository.getTeam(teamId, peoplePerPage: 10);
  });

  Future<void> searchMembers(String query) async {
    _membersQuery = query;
    await _reloadMembers(page: 1, useGlobalState: members.isEmpty);
  }

  Future<void> changeMembersPage(int requestedPage) async {
    final nextPage = requestedPage.clamp(1, membersLastPage).toInt();
    if (nextPage == membersPage || isChangingMembersPage) {
      return;
    }

    await _reloadMembers(page: nextPage, useGlobalState: false);
  }

  Future<void> _reloadMembers({
    required int page,
    required bool useGlobalState,
  }) async {
    membersErrorMessage = null;

    if (useGlobalState) {
      await runCatching(() async {
        _team = await _repository.getTeam(
          teamId,
          peoplePage: page,
          peoplePerPage: 10,
          peopleSearch: _membersQuery,
        );
      });
      return;
    }

    isChangingMembersPage = true;
    notifyListeners();

    try {
      _team = await _repository.getTeam(
        teamId,
        peoplePage: page,
        peoplePerPage: 10,
        peopleSearch: _membersQuery,
      );
    } on ApiException catch (e) {
      membersErrorMessage = e.userMessage;
    } catch (_) {
      membersErrorMessage = 'Algo deu errado. Tente novamente.';
    } finally {
      isChangingMembersPage = false;
      notifyListeners();
    }
  }
}
