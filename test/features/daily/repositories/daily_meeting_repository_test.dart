import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/daily/repositories/daily_meeting_repository.dart';
import 'package:frontend/features/daily/services/daily_meeting_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockDailyMeetingService extends Mock implements DailyMeetingService {}

Map<String, dynamic> _meetingJson({int id = 1}) {
  return {
    'id': id,
    'team_id': 1,
    'time_limit_seconds': 90,
    'started_at': '2026-01-01T10:00:00.000000Z',
    'ended_at': '2026-01-01T10:15:00.000000Z',
    'entries': <dynamic>[],
    'created_at': '2026-01-01T10:15:00.000000Z',
    'updated_at': '2026-01-01T10:15:00.000000Z',
  };
}

Map<String, dynamic> _entryJson({int id = 1}) {
  return {
    'id': id,
    'daily_meeting_id': 1,
    'team_id': 1,
    'person_id': 1,
    'speaking_order': 0,
    'allotted_seconds': 90,
    'actual_seconds': 60,
    'status': 'no_tempo',
    'note_type': null,
    'note': null,
    'created_at': '2026-01-01T10:00:00.000000Z',
    'updated_at': '2026-01-01T10:00:00.000000Z',
  };
}

void main() {
  late _MockDailyMeetingService service;
  late DailyMeetingRepository repository;

  setUp(() {
    service = _MockDailyMeetingService();
    repository = DailyMeetingRepository(service);
  });

  test(
    'getMeetings maps a paginated {data} envelope into a List<DailyMeeting>',
    () async {
      when(() => service.index(teamId: 1, page: 1, perPage: 15)).thenAnswer(
        (_) async => {
          'data': [_meetingJson(), _meetingJson(id: 2)],
        },
      );

      final meetings = await repository.getMeetings(teamId: 1);

      expect(meetings, hasLength(2));
      expect(meetings.first.id, 1);
      expect(meetings.first.timeLimitSeconds, 90);
    },
  );

  test(
    'getMeeting maps a single {data} envelope into a DailyMeeting',
    () async {
      when(
        () => service.show(1),
      ).thenAnswer((_) async => {'data': _meetingJson()});

      final meeting = await repository.getMeeting(1);

      expect(meeting.id, 1);
    },
  );

  test(
    'createMeeting forwards the payload and maps the created {data} envelope',
    () async {
      when(
        () => service.store(
          teamId: 1,
          timeLimitSeconds: 90,
          startedAt: any(named: 'startedAt'),
          endedAt: any(named: 'endedAt'),
          entries: [
            {'person_id': 1, 'actual_seconds': 60},
          ],
        ),
      ).thenAnswer((_) async => {'data': _meetingJson()});

      final meeting = await repository.createMeeting(
        teamId: 1,
        timeLimitSeconds: 90,
        startedAt: DateTime(2026),
        endedAt: DateTime(2026),
        entries: [
          {'person_id': 1, 'actual_seconds': 60},
        ],
      );

      expect(meeting.id, 1);
    },
  );

  group('getAllEntries', () {
    test('follows meta.last_page across multiple pages', () async {
      when(
        () => service.indexEntries(
          teamId: any(named: 'teamId'),
          personId: any(named: 'personId'),
          dailyMeetingId: any(named: 'dailyMeetingId'),
          noteType: any(named: 'noteType'),
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((invocation) async {
        final page = invocation.namedArguments[#page] as int;

        return {
          'data': [_entryJson(id: page)],
          'meta': {'last_page': 2},
        };
      });

      final entries = await repository.getAllEntries(teamId: 1);

      expect(entries, hasLength(2));
      expect(entries.map((e) => e.id), [1, 2]);
    });

    test(
      'stops at the safety cap even if meta.last_page reports more',
      () async {
        when(
          () => service.indexEntries(
            teamId: any(named: 'teamId'),
            personId: any(named: 'personId'),
            dailyMeetingId: any(named: 'dailyMeetingId'),
            noteType: any(named: 'noteType'),
            page: any(named: 'page'),
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer((invocation) async {
          final page = invocation.namedArguments[#page] as int;

          return {
            'data': [_entryJson(id: page)],
            'meta': {'last_page': 100},
          };
        });

        final entries = await repository.getAllEntries(personId: 1);

        expect(entries, hasLength(10));
      },
    );
  });
}
