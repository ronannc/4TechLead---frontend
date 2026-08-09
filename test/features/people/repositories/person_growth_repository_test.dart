import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/features/people/repositories/person_growth_repository.dart';
import 'package:for_tech_lead/features/people/services/person_growth_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonGrowthService extends Mock implements PersonGrowthService {}

Map<String, dynamic> _sessionJson() {
  return {
    'id': 1,
    'person_id': 10,
    'one_on_one_template_id': null,
    'scheduled_for': null,
    'held_at': '2026-08-02',
    'title': '1:1 autonomia',
    'status': 'completed',
    'sentiment': 'positive',
    'questions': ['Como foi a entrega?'],
    'answers': <String, dynamic>{},
    'notes': 'Falamos sobre decisões técnicas.',
    'action_items': <Map<String, dynamic>>[
      {'title': 'Registrar decisões', 'done': false},
    ],
  };
}

Map<String, dynamic> _planJson() {
  return {
    'id': 2,
    'person_id': 10,
    'title': 'PDI autonomia',
    'summary': 'Evoluir decisões técnicas.',
    'status': 'active',
    'start_date': null,
    'end_date': null,
    'target_role': 'Tech Lead',
    'target_seniority': 'senior',
    'progress': 30,
    'items': [
      {
        'id': 3,
        'development_plan_id': 2,
        'title': 'Conduzir desenho técnico',
        'description': null,
        'competency': 'Arquitetura',
        'evidence': 'RFC curto',
        'status': 'todo',
        'due_date': null,
        'completed_at': null,
        'progress': 0,
      },
    ],
  };
}

void main() {
  late _MockPersonGrowthService service;
  late PersonGrowthRepository repository;

  setUp(() {
    service = _MockPersonGrowthService();
    repository = PersonGrowthRepository(service);
  });

  test('maps one on one sessions', () async {
    when(
      () => service.getSessions(personId: 10, page: 1, search: null),
    ).thenAnswer(
      (_) async => {
        'data': [_sessionJson()],
      },
    );

    final sessions = await repository.getSessions(personId: 10);

    expect(sessions.single.title, '1:1 autonomia');
    expect(sessions.single.heldAt, DateTime(2026, 8, 2));
    expect(sessions.single.actionItems.single['title'], 'Registrar decisões');
  });

  test('maps development plans with items', () async {
    when(() => service.getDevelopmentPlans(10)).thenAnswer(
      (_) async => {
        'data': [_planJson()],
      },
    );

    final plans = await repository.getDevelopmentPlans(10);

    expect(plans.single.title, 'PDI autonomia');
    expect(plans.single.items.single.competency, 'Arquitetura');
  });

  test('maps growth suggestions', () async {
    when(
      () =>
          service.getSuggestions(personId: 10, focusArea: null, context: null),
    ).thenAnswer(
      (_) async => {
        'data': {
          'one_on_one_questions': ['Pergunta'],
          'pdi_suggestions': [
            {'title': 'Ação'},
          ],
          'kpi_suggestions': [
            {'title': 'Indicador'},
          ],
        },
      },
    );

    final suggestions = await repository.getSuggestions(personId: 10);

    expect(suggestions.oneOnOneQuestions.single, 'Pergunta');
    expect(suggestions.pdiSuggestions.single['title'], 'Ação');
    expect(suggestions.kpiSuggestions.single['title'], 'Indicador');
  });
}
