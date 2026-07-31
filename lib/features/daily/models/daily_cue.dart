/// A gamification feedback moment during a live daily turn, consumed by
/// [DailySessionScreen] (never the ViewModel) to trigger sound + haptics.
enum DailyCue {
  turnStarted,
  aboutToBurn,
  burned,
  turnAdvanced,
  sessionFinished,
}
