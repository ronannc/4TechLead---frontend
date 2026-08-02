import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/viewmodels/base_view_model.dart';
import 'package:frontend/features/daily/models/daily_cue.dart';
import 'package:frontend/features/daily/models/daily_meeting.dart';
import 'package:frontend/features/daily/models/daily_session_phase.dart';
import 'package:frontend/features/daily/repositories/daily_meeting_repository.dart';
import 'package:frontend/features/daily/viewmodels/daily_session_view_model.dart';
import 'package:frontend/features/people/models/contract_type.dart';
import 'package:frontend/features/people/models/person.dart';
import 'package:frontend/features/people/models/seniority_level.dart';
import 'package:frontend/features/people/repositories/person_repository.dart';
import 'package:frontend/features/teams/models/team.dart';
import 'package:frontend/features/teams/repositories/team_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonRepository extends Mock implements PersonRepository {}

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

class _MockTeamRepository extends Mock implements TeamRepository {}

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

Team _team(int id, String name) {
  return Team(
    id: id,
    name: name,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

DailyMeeting _savedMeeting() {
  return DailyMeeting(
    id: 1,
    teamId: 1,
    timeLimitSeconds: 60,
    startedAt: DateTime(2026),
    endedAt: DateTime(2026),
    entries: const [],
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  late _MockPersonRepository personRepository;
  late _MockDailyMeetingRepository meetingRepository;
  late _MockTeamRepository teamRepository;

  setUp(() {
    personRepository = _MockPersonRepository();
    meetingRepository = _MockDailyMeetingRepository();
    teamRepository = _MockTeamRepository();
    when(
      () => personRepository.getPeople(teamId: null, perPage: 100),
    ).thenAnswer(
      (_) async => [_person(1, 'Ada Lovelace'), _person(2, 'Grace Hopper')],
    );
    when(
      () => teamRepository.getTeams(perPage: 100),
    ).thenAnswer((_) async => [_team(1, 'Engineering')]);
  });

  test('countdown reaches burned and emits the expected cue sequence', () {
    fakeAsync((async) {
      final start = DateTime(2026);
      final viewModel = DailySessionViewModel(
        personRepository,
        meetingRepository,
        teamRepository,
        initialTeamId: 1,
        now: () => start.add(async.elapsed),
      );
      final cues = <DailyCue>[];
      viewModel.cue.addListener(() {
        final cue = viewModel.cue.value;
        if (cue != null) cues.add(cue);
      });

      viewModel.loadParticipants();
      async.flushMicrotasks();
      expect(viewModel.state, ViewState.loaded);

      viewModel.start();
      expect(viewModel.phase, DailySessionPhase.running);

      async.elapse(const Duration(seconds: 65));

      expect(viewModel.elapsedSeconds.value, 65);
      expect(cues, [
        DailyCue.turnStarted,
        DailyCue.aboutToBurn,
        DailyCue.burned,
      ]);

      viewModel.dispose();
    });
  });

  test('nextTurn records actualSeconds and advances to the next person', () {
    fakeAsync((async) {
      final start = DateTime(2026);
      final viewModel = DailySessionViewModel(
        personRepository,
        meetingRepository,
        teamRepository,
        initialTeamId: 1,
        now: () => start.add(async.elapsed),
      );

      viewModel.loadParticipants();
      async.flushMicrotasks();
      viewModel.start();

      async.elapse(const Duration(seconds: 30));
      viewModel.nextTurn();

      expect(viewModel.turns.first.actualSeconds, 30);
      expect(viewModel.currentTurnIndex, 1);
      expect(viewModel.phase, DailySessionPhase.running);

      async.elapse(const Duration(seconds: 10));
      viewModel.finishNow();

      expect(viewModel.turns.last.actualSeconds, 10);
      expect(viewModel.phase, DailySessionPhase.reviewing);

      viewModel.dispose();
    });
  });

  test('reorderMembers updates speaking order used at start', () {
    fakeAsync((async) {
      final start = DateTime(2026);
      final viewModel = DailySessionViewModel(
        personRepository,
        meetingRepository,
        teamRepository,
        initialTeamId: 1,
        now: () => start.add(async.elapsed),
      );

      viewModel.loadParticipants();
      async.flushMicrotasks();
      expect(viewModel.members.map((person) => person.name), [
        'Ada Lovelace',
        'Grace Hopper',
      ]);

      viewModel.reorderMembers(0, 1);
      expect(viewModel.members.map((person) => person.name), [
        'Grace Hopper',
        'Ada Lovelace',
      ]);

      viewModel.start();
      expect(viewModel.turns.first.person.name, 'Grace Hopper');
      expect(viewModel.turns.last.person.name, 'Ada Lovelace');

      viewModel.dispose();
    });
  });

  test('addTopic and addBlocker keep local facilitation notes', () {
    final viewModel = DailySessionViewModel(
      personRepository,
      meetingRepository,
      teamRepository,
    );

    viewModel.addTopic('  Webhook de frota validado  ');
    viewModel.addTopic(' ');
    viewModel.addBlocker('Credencial de staging pendente');
    viewModel.toggleBlocker(0);

    expect(viewModel.topics, ['Webhook de frota validado']);
    expect(viewModel.blockers, hasLength(1));
    expect(viewModel.blockers.single.text, 'Credencial de staging pendente');
    expect(viewModel.blockers.single.resolved, isTrue);

    viewModel.dispose();
  });

  test('dispose cancels the ticker — no error after further elapsed time', () {
    fakeAsync((async) {
      final start = DateTime(2026);
      final viewModel = DailySessionViewModel(
        personRepository,
        meetingRepository,
        teamRepository,
        initialTeamId: 1,
        now: () => start.add(async.elapsed),
      );

      viewModel.loadParticipants();
      async.flushMicrotasks();
      viewModel.start();
      async.elapse(const Duration(seconds: 5));

      viewModel.dispose();

      expect(() => async.elapse(const Duration(seconds: 30)), returnsNormally);
    });
  });

  test('save() preserves drafts and allows retry after a failure', () {
    fakeAsync((async) {
      final start = DateTime(2026);
      final viewModel = DailySessionViewModel(
        personRepository,
        meetingRepository,
        teamRepository,
        initialTeamId: 1,
        now: () => start.add(async.elapsed),
      );

      viewModel.loadParticipants();
      async.flushMicrotasks();
      viewModel.start();
      async.elapse(const Duration(seconds: 20));
      viewModel.finishNow();

      when(
        () => meetingRepository.createMeeting(
          timeLimitSeconds: any(named: 'timeLimitSeconds'),
          startedAt: any(named: 'startedAt'),
          endedAt: any(named: 'endedAt'),
          entries: any(named: 'entries'),
        ),
      ).thenThrow(const NotFoundException());

      viewModel.save();
      async.flushMicrotasks();

      expect(viewModel.isSaving, isFalse);
      expect(viewModel.saveErrorMessage, isNotNull);
      expect(viewModel.phase, DailySessionPhase.reviewing);
      expect(viewModel.turns.first.actualSeconds, 20);

      when(
        () => meetingRepository.createMeeting(
          timeLimitSeconds: any(named: 'timeLimitSeconds'),
          startedAt: any(named: 'startedAt'),
          endedAt: any(named: 'endedAt'),
          entries: any(named: 'entries'),
        ),
      ).thenAnswer((_) async => _savedMeeting());

      viewModel.save();
      async.flushMicrotasks();

      expect(viewModel.phase, DailySessionPhase.finished);
      expect(viewModel.saveErrorMessage, isNull);
      expect(viewModel.cue.value, DailyCue.sessionFinished);

      viewModel.dispose();
    });
  });
}
