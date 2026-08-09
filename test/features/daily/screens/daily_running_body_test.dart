import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/screens/daily_running_body.dart';
import 'package:for_tech_lead/features/daily/viewmodels/daily_session_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockPersonRepository extends Mock implements PersonRepository {}

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

class _MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  testWidgets('shows clear pause and resume states while a turn is running', (
    tester,
  ) async {
    final personRepository = _MockPersonRepository();
    final meetingRepository = _MockDailyMeetingRepository();
    final teamRepository = _MockTeamRepository();

    when(
      () => personRepository.getPeople(teamId: null, perPage: 100),
    ).thenAnswer((_) async => [_person(1, 'Ada Lovelace')]);
    when(
      () => teamRepository.getTeams(perPage: 100),
    ).thenAnswer((_) async => [_team(1, 'Engineering')]);

    final viewModel = DailySessionViewModel(
      personRepository,
      meetingRepository,
      teamRepository,
      initialTeamId: 1,
    );
    await viewModel.loadParticipants();
    viewModel.start();

    await tester.pumpWidget(
      ChangeNotifierProvider<DailySessionViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(body: DailyRunningBody()),
        ),
      ),
    );

    expect(find.text('Pausar timer'), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-running-hint')), findsOneWidget);

    await tester.tap(find.text('Pausar timer'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(viewModel.isPaused, isTrue);
    expect(find.text('Retomar timer'), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-paused-banner')), findsOneWidget);
    expect(
      find.text('Timer pausado. Retome quando quiser continuar este turno.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retomar timer'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(viewModel.isPaused, isFalse);
    expect(find.text('Pausar timer'), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-running-hint')), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-paused-banner')), findsNothing);

    viewModel.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
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

Team _team(int id, String name) {
  return Team(
    id: id,
    name: name,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}
