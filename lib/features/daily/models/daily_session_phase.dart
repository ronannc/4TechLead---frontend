/// UI-only phase of a live [DailySessionScreen] flow — deliberately does NOT
/// include a "saving"/"saved" phase, since that's exactly what the session
/// ViewModel's own `isSaving`/save-result state already covers. Overlapping
/// this with a second state machine is the most likely source of bugs here.
enum DailySessionPhase { configuring, running, reviewing, finished }
