import 'package:equatable/equatable.dart';

import '../models/daily_entry_status.dart';
import '../models/daily_meeting_entry.dart';
import '../models/daily_note_category.dart';

/// Aggregate stats over a set of [DailyMeetingEntry] — used for both the
/// team-level history screen and a single person's stats section. Computed
/// entirely client-side from plain entry listings (no backend aggregation
/// endpoint), same approach as the Home "próximos aniversários" card.
class DailyStatsSummary extends Equatable {
  const DailyStatsSummary({
    required this.entryCount,
    required this.averageActualSeconds,
    required this.onTimePercentage,
    required this.burnedPercentage,
    required this.spokeTooLittlePercentage,
    required this.noteCounts,
  });

  factory DailyStatsSummary.empty() {
    return const DailyStatsSummary(
      entryCount: 0,
      averageActualSeconds: 0,
      onTimePercentage: 0,
      burnedPercentage: 0,
      spokeTooLittlePercentage: 0,
      noteCounts: {},
    );
  }

  final int entryCount;
  final double averageActualSeconds;
  final double onTimePercentage;
  final double burnedPercentage;
  final double spokeTooLittlePercentage;
  final Map<DailyNoteCategory, int> noteCounts;

  @override
  List<Object?> get props => [
    entryCount,
    averageActualSeconds,
    onTimePercentage,
    burnedPercentage,
    spokeTooLittlePercentage,
    noteCounts,
  ];
}

/// Mirrors the backend's `DailyMeetingEntry::SPOKE_TOO_LITTLE_RATIO` — used
/// to preview a draft turn's status client-side before it's ever saved (a
/// [DailyTurnDraft] has no server-computed `status` yet).
const double dailySpokeTooLittleRatio = 0.2;

DailyEntryStatus computeDraftStatus({
  required int allottedSeconds,
  required int actualSeconds,
}) {
  if (actualSeconds > allottedSeconds) {
    return DailyEntryStatus.burned;
  }

  if (actualSeconds < allottedSeconds * dailySpokeTooLittleRatio) {
    return DailyEntryStatus.spokeTooLittle;
  }

  return DailyEntryStatus.onTime;
}

DailyStatsSummary computeDailyStatsSummary(List<DailyMeetingEntry> entries) {
  if (entries.isEmpty) {
    return DailyStatsSummary.empty();
  }

  final total = entries.length;
  final totalActualSeconds = entries.fold<int>(
    0,
    (sum, entry) => sum + entry.actualSeconds,
  );

  int countWithStatus(DailyEntryStatus status) =>
      entries.where((entry) => entry.status == status).length;

  final noteCounts = <DailyNoteCategory, int>{};
  for (final entry in entries) {
    final category = entry.noteType;
    if (category != null) {
      noteCounts[category] = (noteCounts[category] ?? 0) + 1;
    }
  }

  return DailyStatsSummary(
    entryCount: total,
    averageActualSeconds: totalActualSeconds / total,
    onTimePercentage: countWithStatus(DailyEntryStatus.onTime) / total * 100,
    burnedPercentage: countWithStatus(DailyEntryStatus.burned) / total * 100,
    spokeTooLittlePercentage:
        countWithStatus(DailyEntryStatus.spokeTooLittle) / total * 100,
    noteCounts: noteCounts,
  );
}

/// Per-person ranking row for a team's daily history (who burns most/least,
/// who speaks too little most often).
class DailyPersonRanking extends Equatable {
  const DailyPersonRanking({
    required this.personId,
    required this.entryCount,
    required this.averageActualSeconds,
    required this.burnedPercentage,
    required this.spokeTooLittlePercentage,
  });

  final int personId;
  final int entryCount;
  final double averageActualSeconds;
  final double burnedPercentage;
  final double spokeTooLittlePercentage;

  @override
  List<Object?> get props => [
    personId,
    entryCount,
    averageActualSeconds,
    burnedPercentage,
    spokeTooLittlePercentage,
  ];
}

/// One ranking row per distinct `personId` present in [entries].
List<DailyPersonRanking> rankPeopleByEntries(List<DailyMeetingEntry> entries) {
  final byPerson = <int, List<DailyMeetingEntry>>{};
  for (final entry in entries) {
    byPerson.putIfAbsent(entry.personId, () => []).add(entry);
  }

  return byPerson.entries.map((group) {
    final personEntries = group.value;
    final summary = computeDailyStatsSummary(personEntries);

    return DailyPersonRanking(
      personId: group.key,
      entryCount: summary.entryCount,
      averageActualSeconds: summary.averageActualSeconds,
      burnedPercentage: summary.burnedPercentage,
      spokeTooLittlePercentage: summary.spokeTooLittlePercentage,
    );
  }).toList();
}
