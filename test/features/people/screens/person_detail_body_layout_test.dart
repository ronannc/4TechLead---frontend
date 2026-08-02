import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/daily/repositories/daily_meeting_repository.dart';
import 'package:frontend/features/daily/viewmodels/person_daily_stats_view_model.dart';
import 'package:frontend/features/people/models/contract_type.dart';
import 'package:frontend/features/people/models/person.dart';
import 'package:frontend/features/people/models/person_growth_models.dart';
import 'package:frontend/features/people/models/seniority_level.dart';
import 'package:frontend/features/people/repositories/person_growth_repository.dart';
import 'package:frontend/features/people/repositories/person_repository.dart';
import 'package:frontend/features/people/screens/person_detail_body.dart';
import 'package:frontend/features/people/viewmodels/person_detail_view_model.dart';
import 'package:frontend/features/people/viewmodels/person_growth_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class _MockPersonRepository extends Mock implements PersonRepository {}

class _MockPersonGrowthRepository extends Mock
    implements PersonGrowthRepository {}

class _MockDailyMeetingRepository extends Mock
    implements DailyMeetingRepository {}

void main() {
  testWidgets(
    'renders without layout exceptions on mobile and desktop widths',
    (tester) async {
      await initializeDateFormatting('pt_BR');

      for (final size in [const Size(390, 900), const Size(900, 900)]) {
        await _pumpLoadedBody(tester, size);

        expect(find.text('Ada Lovelace'), findsOneWidget);
        expect(find.text('Registrar conversa'), findsOneWidget);
        expect(tester.takeException(), isNull);

        for (final view in ['Templates', 'Sugestões', 'Histórico']) {
          await _tapTab(tester, view);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        for (final tab in ['PDI', 'OKRs', 'Análises']) {
          await _tapTab(tester, tab);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      }
    },
  );

  testWidgets('fills one on one notes when selecting a template', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');
    await _pumpLoadedBody(tester, const Size(390, 900));

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Template').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Como foi o ciclo?'), findsOneWidget);
    expect(find.textContaining('Resposta:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpLoadedBody(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final personRepository = _MockPersonRepository();
  final growthRepository = _MockPersonGrowthRepository();
  final dailyRepository = _MockDailyMeetingRepository();

  when(() => personRepository.getPerson(1)).thenAnswer((_) async => _person());
  when(growthRepository.getTemplates).thenAnswer(
    (_) async => [
      const OneOnOneTemplate(
        id: 1,
        title: 'Template',
        questions: ['Como foi o ciclo?'],
      ),
    ],
  );
  when(
    () => growthRepository.getSessions(personId: 1, page: 1, search: null),
  ).thenAnswer(
    (_) async => [
      OneOnOneSession(
        id: 1,
        personId: 1,
        title: '1:1 semanal',
        status: 'completed',
        heldAt: DateTime(2026, 8, 2),
        notes: 'Falamos sobre evolução técnica.',
      ),
    ],
  );
  when(
    () => growthRepository.getDevelopmentPlans(1),
  ).thenAnswer((_) async => [_plan()]);
  when(() => growthRepository.getOkrs(1)).thenAnswer((_) async => [_okr()]);
  when(
    () => growthRepository.getSuggestions(
      personId: 1,
      focusArea: null,
      context: null,
    ),
  ).thenAnswer(
    (_) async => const GrowthSuggestions(
      oneOnOneQuestions: ['Qual apoio você precisa?'],
      pdiSuggestions: [
        {'title': 'Conduzir entrega', 'evidence': 'PR entregue'},
      ],
      okrSuggestions: [
        {'objective': 'Aumentar autonomia', 'diagnosis': 'Precisa evoluir'},
      ],
    ),
  );
  when(
    () => dailyRepository.getAllEntries(personId: 1),
  ).thenAnswer((_) async => []);

  final personViewModel = PersonDetailViewModel(personRepository, 1);
  final growthViewModel = PersonGrowthViewModel(growthRepository, 1);
  final dailyViewModel = PersonDailyStatsViewModel(dailyRepository, 1);

  await personViewModel.load();
  await growthViewModel.load();
  await dailyViewModel.load();

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PersonDetailViewModel>.value(
          value: personViewModel,
        ),
        ChangeNotifierProvider<PersonGrowthViewModel>.value(
          value: growthViewModel,
        ),
        ChangeNotifierProvider<PersonDailyStatsViewModel>.value(
          value: dailyViewModel,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PersonDetailBody(key: UniqueKey()),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapTab(WidgetTester tester, String label) async {
  final tab = find.text(label);
  final tabCenter = tester.getCenter(tab);

  if (tabCenter.dx > tester.view.physicalSize.width) {
    await tester.drag(
      find.byType(SingleChildScrollView).last,
      const Offset(-320, 0),
    );
    await tester.pumpAndSettle();
  }

  await tester.tap(tab);
}

Person _person() {
  return Person(
    id: 1,
    name: 'Ada Lovelace',
    teamId: 1,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026, 8, 2),
    updatedAt: DateTime(2026, 8, 2),
  );
}

DevelopmentPlan _plan() {
  return const DevelopmentPlan(
    id: 1,
    personId: 1,
    title: 'PDI autonomia',
    status: 'active',
    progress: 40,
    summary: 'Evoluir decisões técnicas.',
    items: [
      DevelopmentPlanItem(
        id: 1,
        developmentPlanId: 1,
        title: 'Conduzir desenho técnico',
        status: 'todo',
        progress: 0,
        competency: 'Arquitetura',
      ),
    ],
  );
}

PersonOkr _okr() {
  return const PersonOkr(
    id: 1,
    personId: 1,
    objective: 'Aumentar autonomia técnica',
    status: 'active',
    confidence: 50,
    progress: 20,
    diagnosis: 'Precisa decidir com menos apoio.',
    keyResults: [
      OkrKeyResult(
        id: 1,
        okrId: 1,
        title: 'Concluir ações do PDI',
        status: 'doing',
        progress: 25,
        metricName: 'Ações',
      ),
    ],
  );
}
