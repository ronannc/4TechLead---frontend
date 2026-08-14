import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';

/// Backs the "Dailies" section appended to `PersonDetailBody` — this
/// person's own aggregated stats. It now only adapts the summary already
/// returned by `/people/{id}` into the shared `BaseViewModel` state model.
class PersonDailyStatsViewModel extends BaseViewModel {
  PersonDailyStatsViewModel();

  PersonDailyStatsSummary _stats = const PersonDailyStatsSummary(
    entryCount: 0,
    averageActualSeconds: 0,
    onTimePercentage: 0,
    burnedPercentage: 0,
    spokeTooLittlePercentage: 0,
  );
  PersonDailyStatsSummary get stats => _stats;

  void setStats(PersonDailyStatsSummary? summary) {
    _stats =
        summary ??
        const PersonDailyStatsSummary(
          entryCount: 0,
          averageActualSeconds: 0,
          onTimePercentage: 0,
          burnedPercentage: 0,
          spokeTooLittlePercentage: 0,
        );
    setState(ViewState.loaded);
  }
}
