/// The smallest allowed per-meeting time limit, and the step between
/// consecutive values a tech lead can pick (60s, 90s, 120s, ...).
const int dailyTimeLimitMinSeconds = 60;
const int dailyTimeLimitStepSeconds = 30;

bool isValidDailyTimeLimit(int seconds) {
  return seconds >= dailyTimeLimitMinSeconds &&
      seconds % dailyTimeLimitStepSeconds == 0;
}

/// Formats a duration in seconds as `mm:ss`. Negative values (used to
/// represent overtime as a negative "remaining" count) are rendered with a
/// leading `-`, e.g. `-00:05`.
String formatDailyDuration(int totalSeconds) {
  final sign = totalSeconds < 0 ? '-' : '';
  final seconds = totalSeconds.abs();
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;

  return '$sign${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
