import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/theme/app_theme.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/screens/daily_config_body.dart';
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
      (_) async => [
        _person(id: 1, name: 'Ada Lovelace', teamId: 1),
        _person(id: 2, name: 'Grace Hopper', teamId: 1),
        _person(id: 3, name: 'Linus Torvalds', teamId: 2),
      ],
    );
    when(() => teamRepository.getTeams(perPage: 100)).thenAnswer(
      (_) async => [
        _team(id: 1, name: 'Engineering'),
        _team(id: 2, name: 'Platform'),
      ],
    );
  });

  testWidgets('uses one selectable list for participants and speaking order', (
    tester,
  ) async {
    _setMobileViewport(tester);

    final viewModel = DailySessionViewModel(
      personRepository,
      meetingRepository,
      teamRepository,
      initialTeamId: 1,
    );

    await viewModel.loadParticipants();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(_TestApp(viewModel: viewModel));

    expect(find.byType(ReorderableListView), findsOneWidget);
    expect(find.text('Ordem de fala'), findsNothing);
    expect(find.byKey(const ValueKey('daily-config-person-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-config-person-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-config-person-3')), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsNWidgets(2));

    await tester.ensureVisible(
      find.byKey(const ValueKey('daily-config-person-3')),
    );
    await tester.tap(find.byKey(const ValueKey('daily-config-person-3')));
    await tester.pumpAndSettle();

    expect(find.text('3 participantes selecionados'), findsOneWidget);
    expect(find.byIcon(Icons.drag_handle), findsNWidgets(3));
  });

  testWidgets('disables drag handles while filtering the participant list', (
    tester,
  ) async {
    _setMobileViewport(tester);

    final viewModel = DailySessionViewModel(
      personRepository,
      meetingRepository,
      teamRepository,
      initialTeamId: 1,
    );

    await viewModel.loadParticipants();
    expect(viewModel.state, ViewState.loaded);

    await tester.pumpWidget(_TestApp(viewModel: viewModel));

    await tester.enterText(find.byType(TextField), 'Ada');
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Toque para selecionar. Limpe a busca para reordenar a ordem de fala.',
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.drag_handle), findsNothing);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.viewModel});

  final DailySessionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DailySessionViewModel>.value(
      value: viewModel,
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(body: DailyConfigBody()),
      ),
    );
  }
}

Person _person({required int id, required String name, required int teamId}) {
  return Person(
    id: id,
    name: name,
    teamId: teamId,
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

Team _team({required int id, required String name}) {
  return Team(
    id: id,
    name: name,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(393, 852);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
