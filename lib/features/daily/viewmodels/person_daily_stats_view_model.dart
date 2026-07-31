import '../../../core/viewmodels/base_view_model.dart';
import '../repositories/daily_meeting_repository.dart';
import '../utils/daily_stats.dart';

/// Backs the "Dailies" section appended to `PersonDetailBody` — this
/// person's own aggregated stats. Kept as its own ViewModel/state machine
/// (via `MultiProvider` on `PersonDetailScreen`) so a stats-fetch failure
/// never takes down the rest of the person's page.
class PersonDailyStatsViewModel extends BaseViewModel {
  PersonDailyStatsViewModel(this._repository, this.personId);

  final DailyMeetingRepository _repository;
  final int personId;

  DailyStatsSummary _stats = DailyStatsSummary.empty();
  DailyStatsSummary get stats => _stats;

  Future<void> load() => runCatching(() async {
    final entries = await _repository.getAllEntries(personId: personId);
    _stats = computeDailyStatsSummary(entries);
  });
}
