import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';
import '../../people/repositories/person_repository.dart';
import '../../people/utils/birthday_util.dart';
import '../../teams/models/team.dart';
import '../../teams/repositories/team_repository.dart';

/// How many upcoming birthdays the Dashboard shows at once.
const _upcomingBirthdaysLimit = 5;

/// Drives the Home dashboard's summary cards. Loads whatever cross-feature
/// data is cheap to fetch on entry — team count and the soonest upcoming
/// birthdays (across all teams, not just one) — extend with more Repository
/// calls as more features exist.
class HomeViewModel extends BaseViewModel {
  HomeViewModel(this._teamRepository, this._personRepository);

  final TeamRepository _teamRepository;
  final PersonRepository _personRepository;

  int _teamsCount = 0;
  int get teamsCount => _teamsCount;

  List<Team> _teams = [];
  List<Team> get teams => List.unmodifiable(_teams);

  List<Person> _upcomingBirthdays = [];
  List<Person> get upcomingBirthdays => List.unmodifiable(_upcomingBirthdays);

  List<Person> _teamToday = [];
  List<Person> get teamToday => List.unmodifiable(_teamToday);

  int? get firstTeamId => _teams.isEmpty ? null : _teams.first.id;

  Future<void> load() => runCatching(() async {
    _teams = await _teamRepository.getTeams();
    _teamsCount = _teams.length;

    // per_page=100 is the API's validated ceiling (IndexPersonRequest) —
    // enough for the birthday widget at the team sizes this app targets;
    // revisit if a real org ever needs more than that across all teams.
    final people = await _personRepository.getPeople(perPage: 100);
    _teamToday = people.take(4).toList();
    final sorted = [...people]
      ..sort(
        (a, b) => daysUntilNextBirthday(
          a.birthDate,
        ).compareTo(daysUntilNextBirthday(b.birthDate)),
      );
    _upcomingBirthdays = sorted.take(_upcomingBirthdaysLimit).toList();
  });
}
