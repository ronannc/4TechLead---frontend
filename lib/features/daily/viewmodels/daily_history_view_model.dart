import '../../../core/viewmodels/base_view_model.dart';
import '../../people/repositories/person_repository.dart';
import '../models/daily_meeting.dart';
import '../repositories/daily_meeting_repository.dart';
import '../utils/daily_stats.dart';

/// Backs `DailyHistoryScreen` — a team's past daily meetings plus aggregated
/// stats computed client-side from the (paginated, capped) entry listing.
class DailyHistoryViewModel extends BaseViewModel {
  DailyHistoryViewModel(this._repository, this._personRepository, this.teamId);

  final DailyMeetingRepository _repository;
  final PersonRepository _personRepository;
  final int teamId;

  final Map<int, String> _namesByPersonId = {};

  /// Falls back to the raw id if the person is no longer on the team's
  /// current roster (e.g. removed since the meeting happened).
  String personName(int personId) => _namesByPersonId[personId] ?? '#$personId';

  List<DailyMeeting> _meetings = [];
  List<DailyMeeting> get meetings => List.unmodifiable(_meetings);

  DailyStatsSummary _stats = DailyStatsSummary.empty();
  DailyStatsSummary get stats => _stats;

  List<DailyPersonRanking> _rankings = [];

  /// Sorted by burned percentage descending — first entry burns the most
  /// often, last entry burns the least.
  List<DailyPersonRanking> get rankingsByBurned =>
      List<DailyPersonRanking>.of(_rankings)
        ..sort((a, b) => b.burnedPercentage.compareTo(a.burnedPercentage));

  /// Sorted by "spoke too little" percentage descending.
  List<DailyPersonRanking> get rankingsBySpokeTooLittle =>
      List<DailyPersonRanking>.of(_rankings)..sort(
        (a, b) =>
            b.spokeTooLittlePercentage.compareTo(a.spokeTooLittlePercentage),
      );

  Future<void> load() => runCatching(() async {
    final entries = await _repository.getAllEntries(teamId: teamId);
    _meetings = await _repository.getMeetings(teamId: teamId, perPage: 100);
    _stats = computeDailyStatsSummary(entries);
    _rankings = rankPeopleByEntries(entries);

    final members = await _personRepository.getPeople(
      teamId: teamId,
      perPage: 100,
    );
    _namesByPersonId
      ..clear()
      ..addEntries(members.map((person) => MapEntry(person.id, person.name)));
  });
}
