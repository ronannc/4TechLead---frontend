import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/daily/models/daily_entry_status.dart';
import 'package:frontend/features/daily/models/daily_meeting_entry.dart';
import 'package:frontend/features/daily/models/daily_note_category.dart';
import 'package:frontend/features/daily/utils/daily_stats.dart';

DailyMeetingEntry _entry({
  int id = 1,
  int personId = 1,
  int allottedSeconds = 100,
  int actualSeconds = 100,
  DailyEntryStatus status = DailyEntryStatus.onTime,
  DailyNoteCategory? noteType,
}) {
  return DailyMeetingEntry(
    id: id,
    dailyMeetingId: 1,
    teamId: 1,
    personId: personId,
    speakingOrder: 0,
    allottedSeconds: allottedSeconds,
    actualSeconds: actualSeconds,
    status: status,
    noteType: noteType,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  group('computeDraftStatus', () {
    test('is on_time within range', () {
      expect(
        computeDraftStatus(allottedSeconds: 100, actualSeconds: 100),
        DailyEntryStatus.onTime,
      );
    });

    test('is on_time exactly at the spoke-too-little boundary (strict <)', () {
      expect(
        computeDraftStatus(allottedSeconds: 100, actualSeconds: 20),
        DailyEntryStatus.onTime,
      );
    });

    test('is spoke_too_little just below the boundary', () {
      expect(
        computeDraftStatus(allottedSeconds: 100, actualSeconds: 19),
        DailyEntryStatus.spokeTooLittle,
      );
    });

    test('is burned above the allotted time', () {
      expect(
        computeDraftStatus(allottedSeconds: 100, actualSeconds: 101),
        DailyEntryStatus.burned,
      );
    });
  });

  group('computeDailyStatsSummary', () {
    test('returns the empty summary for no entries', () {
      final summary = computeDailyStatsSummary([]);

      expect(summary.entryCount, 0);
      expect(summary.averageActualSeconds, 0);
    });

    test('computes averages, percentages, and note counts', () {
      final entries = [
        _entry(
          actualSeconds: 100,
          status: DailyEntryStatus.onTime,
          noteType: DailyNoteCategory.impediment,
        ),
        _entry(actualSeconds: 150, status: DailyEntryStatus.burned),
        _entry(actualSeconds: 50, status: DailyEntryStatus.spokeTooLittle),
        _entry(actualSeconds: 100, status: DailyEntryStatus.onTime),
      ];

      final summary = computeDailyStatsSummary(entries);

      expect(summary.entryCount, 4);
      expect(summary.averageActualSeconds, 100);
      expect(summary.onTimePercentage, 50);
      expect(summary.burnedPercentage, 25);
      expect(summary.spokeTooLittlePercentage, 25);
      expect(summary.noteCounts[DailyNoteCategory.impediment], 1);
    });
  });

  group('rankPeopleByEntries', () {
    test('groups entries by personId', () {
      final entries = [
        _entry(
          personId: 1,
          actualSeconds: 150,
          status: DailyEntryStatus.burned,
        ),
        _entry(
          personId: 1,
          actualSeconds: 100,
          status: DailyEntryStatus.onTime,
        ),
        _entry(
          personId: 2,
          actualSeconds: 100,
          status: DailyEntryStatus.onTime,
        ),
      ];

      final rankings = rankPeopleByEntries(entries);

      expect(rankings, hasLength(2));
      final personOne = rankings.firstWhere((r) => r.personId == 1);
      expect(personOne.entryCount, 2);
      expect(personOne.burnedPercentage, 50);
    });
  });
}
