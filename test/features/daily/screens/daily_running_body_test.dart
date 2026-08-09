import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_spacing.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/screens/daily_running_body.dart';
import 'package:for_tech_lead/features/daily/screens/daily_timer_ring.dart';
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
  testWidgets('keeps the timer ring inside a narrow content width', (
    tester,
  ) async {
    final elapsedSeconds = ValueNotifier<int>(12);
    addTearDown(elapsedSeconds.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 240 - (AppSpacing.md * 2),
              child: DailyTimerRing(
                allowedSeconds: 90,
                elapsedSeconds: elapsedSeconds,
              ),
            ),
          ),
        ),
      ),
    );

    final timerRect = tester.getRect(find.byType(DailyTimerRing));
    expect(timerRect.width, lessThanOrEqualTo(240 - (AppSpacing.md * 2)));
    expect(tester.takeException(), isNull);
  });

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
    expect(find.text('Anotações da daily'), findsOneWidget);
    expect(find.text('Tópico'), findsOneWidget);
    expect(find.text('Bloqueio'), findsOneWidget);
    expect(find.text('Tópico levantado'), findsOneWidget);
    expect(find.text('Nota'), findsNothing);

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

  testWidgets('uses one annotation composer for topics and blockers', (
    tester,
  ) async {
    final viewModel = await _runningViewModel();

    await tester.pumpWidget(
      ChangeNotifierProvider<DailySessionViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(body: DailyRunningBody()),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Anotações da daily'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Webhook validado');
    await tester.ensureVisible(find.byTooltip('Adicionar tópico'));
    await tester.pump();
    await tester.tap(find.byTooltip('Adicionar tópico'));
    await tester.pump();

    expect(viewModel.topics, ['Webhook validado']);
    expect(find.text('Webhook validado'), findsOneWidget);
    expect(find.text('Tópico levantado'), findsWidgets);

    await tester.tap(find.text('Bloqueio'));
    await tester.pump();
    expect(
      find.text(
        'Registre um impedimento que precisa sair da daily com responsável.',
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Credencial pendente');
    await tester.ensureVisible(find.byTooltip('Adicionar bloqueio'));
    await tester.pump();
    await tester.tap(find.byTooltip('Adicionar bloqueio'));
    await tester.pump();

    expect(viewModel.blockers.single.text, 'Credencial pendente');
    expect(find.text('Credencial pendente'), findsOneWidget);
    expect(find.text('Bloqueio'), findsWidgets);

    viewModel.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

Future<DailySessionViewModel> _runningViewModel() async {
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

  return viewModel;
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
