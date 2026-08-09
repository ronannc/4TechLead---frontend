import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/daily/models/daily_entry_status.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting.dart';
import 'package:for_tech_lead/features/daily/models/daily_meeting_entry.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/viewmodels/daily_history_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

DailyMeetingEntry _entry({
  required int personId,
  required DailyEntryStatus status,
}) {
  return DailyMeetingEntry(
    id: personId,
    dailyMeetingId: 1,
    teamId: 1,
    personId: personId,
    speakingOrder: 0,
    allottedSeconds: 90,
    actualSeconds: 90,
    status: status,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

Person _person(int id, String name) {
  return Person(
    id: id,
    name: name,
    teamId: 1,
    birthDate: DateTime(1990, 5, 10),
    age: 35,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    admissionDate: DateTime(2020, 1, 15),
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  late _MockDailyMeetingRepository meetingRepository;
  late _MockPersonRepository personRepository;
  late DailyHistoryViewModel viewModel;

  setUp(() {
    meetingRepository = _MockDailyMeetingRepository();
    personRepository = _MockPersonRepository();
    viewModel = DailyHistoryViewModel(meetingRepository, personRepository, 1);
  });

  test(
    'load() exposes meetings, aggregated stats, and rankings by name',
    () async {
      when(() => meetingRepository.getAllEntries(teamId: 1)).thenAnswer(
        (_) async => [
          _entry(personId: 1, status: DailyEntryStatus.burned),
          _entry(personId: 2, status: DailyEntryStatus.onTime),
        ],
      );
      when(
        () => meetingRepository.getMeetings(teamId: 1, perPage: 100),
      ).thenAnswer(
        (_) async => [
          DailyMeeting(
            id: 1,
            teamId: 1,
            timeLimitSeconds: 90,
            startedAt: DateTime(2026),
            endedAt: DateTime(2026),
            entries: const [],
            annotations: const [],
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      );
      when(
        () => personRepository.getPeople(teamId: 1, perPage: 100),
      ).thenAnswer(
        (_) async => [_person(1, 'Ada Lovelace'), _person(2, 'Grace Hopper')],
      );

      await viewModel.load();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.meetings, hasLength(1));
      expect(viewModel.stats.entryCount, 2);
      expect(viewModel.rankingsByBurned.first.personId, 1);
      expect(viewModel.personName(1), 'Ada Lovelace');
      expect(viewModel.personName(999), '#999');
    },
  );
}
