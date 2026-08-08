import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/bootstrap.dart';
import 'package:for_tech_lead/core/responsive/adaptive_scaffold.dart';
import 'package:for_tech_lead/features/daily/repositories/daily_meeting_repository.dart';
import 'package:for_tech_lead/features/daily/viewmodels/person_daily_stats_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/person_growth_models.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_growth_repository.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/people/screens/person_detail_body.dart';
import 'package:for_tech_lead/features/people/screens/person_detail_screen.dart';
import 'package:for_tech_lead/features/people/viewmodels/person_detail_view_model.dart';
import 'package:for_tech_lead/features/people/viewmodels/person_growth_view_model.dart';
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
    'renders the complete person detail screen without layout errors',
    (tester) async {
      await initializeDateFormatting('pt_BR');
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(getIt.reset);

      final personRepository = _MockPersonRepository();
      final growthRepository = _MockPersonGrowthRepository();
      final dailyRepository = _MockDailyMeetingRepository();
      _stubRepositories(
        personRepository: personRepository,
        growthRepository: growthRepository,
        dailyRepository: dailyRepository,
      );

      getIt.registerSingleton<PersonRepository>(personRepository);
      getIt.registerSingleton<PersonGrowthRepository>(growthRepository);
      getIt.registerSingleton<DailyMeetingRepository>(dailyRepository);

      await tester.pumpWidget(
        const MaterialApp(home: PersonDetailScreen(personId: '1')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Informações gerais'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('renders inside the adaptive app shell without layout errors', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');
    addTearDown(getIt.reset);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final personRepository = _MockPersonRepository();
    final growthRepository = _MockPersonGrowthRepository();
    final dailyRepository = _MockDailyMeetingRepository();
    _stubRepositories(
      personRepository: personRepository,
      growthRepository: growthRepository,
      dailyRepository: dailyRepository,
    );

    getIt.registerSingleton<PersonRepository>(personRepository);
    getIt.registerSingleton<PersonGrowthRepository>(growthRepository);
    getIt.registerSingleton<DailyMeetingRepository>(dailyRepository);

    for (final size in [const Size(390, 900), const Size(1280, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: AdaptiveScaffold(
            destinations: const [
              AppNavDestination(
                label: 'Início',
                icon: Icons.home_outlined,
                path: '/inicio',
              ),
              AppNavDestination(
                label: 'Times',
                icon: Icons.groups_outlined,
                path: '/times',
              ),
            ],
            selectedIndex: 1,
            onDestinationSelected: (_) {},
            child: const PersonDetailScreen(personId: '1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ada Lovelace'), findsOneWidget);
      expect(find.text('Informações gerais'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'renders without layout exceptions on mobile and desktop widths',
    (tester) async {
      await initializeDateFormatting('pt_BR');

      for (final size in [const Size(390, 900), const Size(1280, 900)]) {
        await _pumpLoadedBody(tester, size);

        expect(find.text('Ada Lovelace'), findsOneWidget);
        expect(find.text('Informações gerais'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await _tapTab(tester, '1:1');
        await tester.pumpAndSettle();
        expect(find.text('Histórico de 1:1'), findsOneWidget);
        expect(find.text('Novo 1:1'), findsOneWidget);
        expect(tester.takeException(), isNull);

        for (final view in ['Templates', 'Sugestões', 'Histórico']) {
          await _tapContextualTab(tester, view);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        await tester.tap(find.text('Novo 1:1'));
        await tester.pumpAndSettle();
        expect(find.text('Novo 1:1'), findsOneWidget);
        expect(find.text('Histórico de 1:1'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        for (final tab in ['PDI', 'OKRs', 'Análises']) {
          await _tapTab(tester, tab);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          if (tab == 'PDI') {
            for (final view in ['Sugestões', 'Planos']) {
              await _tapContextualTab(tester, view);
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
            }

            await tester.tap(find.text('Novo PDI'));
            await tester.pumpAndSettle();
            expect(find.text('Novo PDI'), findsOneWidget);
            expect(tester.takeException(), isNull);
            await tester.tap(find.byIcon(Icons.arrow_back));
            await tester.pumpAndSettle();

            await _tapVisible(tester, find.text('Adicionar ação'));
            expect(find.text('Nova ação do PDI'), findsOneWidget);
            expect(tester.takeException(), isNull);
            await tester.tap(find.text('Cancelar'));
            await tester.pumpAndSettle();
          }

          if (tab == 'OKRs') {
            for (final view in ['Sugestões', 'OKRs']) {
              await _tapContextualTab(tester, view);
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
            }

            await tester.tap(find.text('Novo OKR'));
            await tester.pumpAndSettle();
            expect(find.text('Novo OKR'), findsOneWidget);
            expect(tester.takeException(), isNull);
            await tester.tap(find.byIcon(Icons.arrow_back));
            await tester.pumpAndSettle();

            await _tapVisible(tester, find.text('Adicionar métrica'));
            expect(find.text('Nova métrica'), findsOneWidget);
            expect(tester.takeException(), isNull);
            await tester.tap(find.text('Cancelar'));
            await tester.pumpAndSettle();
          }
        }
      }
    },
  );

  testWidgets('fills one on one notes when selecting a template', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');
    await _pumpLoadedBody(tester, const Size(390, 900));

    await _tapTab(tester, '1:1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Novo 1:1'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Template').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Como foi o ciclo?'), findsOneWidget);
    expect(find.textContaining('Resposta:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders when its parent has an unbounded height', (
    tester,
  ) async {
    await initializeDateFormatting('pt_BR');
    await _pumpLoadedBody(tester, const Size(390, 900), unboundedHeight: true);

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Informações gerais'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpLoadedBody(
  WidgetTester tester,
  Size size, {
  bool unboundedHeight = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final personRepository = _MockPersonRepository();
  final growthRepository = _MockPersonGrowthRepository();
  final dailyRepository = _MockDailyMeetingRepository();

  _stubRepositories(
    personRepository: personRepository,
    growthRepository: growthRepository,
    dailyRepository: dailyRepository,
  );

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
            child: unboundedHeight
                ? SingleChildScrollView(
                    child: PersonDetailBody(key: UniqueKey()),
                  )
                : PersonDetailBody(key: UniqueKey()),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _stubRepositories({
  required PersonRepository personRepository,
  required PersonGrowthRepository growthRepository,
  required DailyMeetingRepository dailyRepository,
}) {
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
}

Future<void> _tapTab(WidgetTester tester, String label) async {
  final tab = find.text(label);
  await tester.ensureVisible(tab);
  await tester.pumpAndSettle();
  await tester.tap(tab);
}

Future<void> _tapContextualTab(WidgetTester tester, String label) async {
  final tab = find.text(label).last;
  await tester.ensureVisible(tab);
  await tester.pumpAndSettle();
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
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
