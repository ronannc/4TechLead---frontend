/// Mirrors the backend's `App\Enums\DailyEntryStatus`, computed server-side
/// from `actual_seconds` vs `allotted_seconds` — never recomputed client-side
/// for a saved entry, only used locally while a turn is still in progress
/// (see `daily_time_limit.dart`'s `DailyMeetingEntry.spokeTooLittleRatio`).
enum DailyEntryStatus {
  onTime('no_tempo', 'Falou bem'),
  burned('queimado', 'Queimou o tempo'),
  spokeTooLittle('pouco_tempo', 'Falou pouco');

  const DailyEntryStatus(this.apiValue, this.label);

  final String apiValue;
  final String label;

  factory DailyEntryStatus.fromApiValue(String value) {
    return DailyEntryStatus.values.firstWhere(
      (status) => status.apiValue == value,
    );
  }
}
