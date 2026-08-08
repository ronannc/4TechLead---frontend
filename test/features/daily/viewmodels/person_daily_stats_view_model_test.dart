import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/daily/models/daily_entry_status.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting_entry.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

DailyMeetingEntry _entry(DailyEntryStatus status) {
  return DailyMeetingEntry(
    id: 1,
    dailyMeetingId: 1,
    teamId: 1,
    personId: 5,
    speakingOrder: 0,
    allottedSeconds: 90,
    actualSeconds: 90,
    status: status,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  late _MockDailyMeetingRepository repository;
  late PersonDailyStatsViewModel viewModel;

  setUp(() {
    repository = _MockDailyMeetingRepository();
    viewModel = PersonDailyStatsViewModel(repository, 5);
  });

  test('load() exposes stats computed from this person\'s entries', () async {
    when(() => repository.getAllEntries(personId: 5)).thenAnswer(
      (_) async => [
        _entry(DailyEntryStatus.onTime),
        _entry(DailyEntryStatus.burned),
      ],
    );

    await viewModel.load();

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.stats.entryCount, 2);
    expect(viewModel.stats.burnedPercentage, 50);
  });

  test('load() sets state to error on failure', () async {
    when(
      () => repository.getAllEntries(personId: 5),
    ).thenThrow(Exception('boom'));

    await viewModel.load();

    expect(viewModel.state, ViewState.error);
  });
}
