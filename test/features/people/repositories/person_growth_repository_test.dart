import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/people/repositories/person_growth_repository.dart';
import 'package:frontend/features/people/services/person_growth_service.dart';
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

Map<String, dynamic> _okrJson() {
  return {
    'id': 4,
    'person_id': 10,
    'development_plan_id': null,
    'objective': 'Aumentar autonomia técnica',
    'cycle': '2026-Q3',
    'status': 'active',
    'focus_area': 'Autonomia',
    'diagnosis': 'Precisa decidir com menos apoio.',
    'evidence_source': 'PRs e decisões',
    'baseline': null,
    'target': 'Conduzir entregas médias',
    'confidence': 50,
    'progress': 15,
    'key_results': [
      {
        'id': 5,
        'okr_id': 4,
        'title': 'Concluir ações do PDI',
        'metric_name': 'Ações',
        'initial_value': '0.00',
        'current_value': '1.00',
        'target_value': '4.00',
        'unit': 'itens',
        'confidence': 60,
        'status': 'doing',
        'due_date': null,
        'evidence': 'Itens fechados',
        'progress': 25,
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

  test('maps okrs with key results and numeric values', () async {
    when(() => service.getOkrs(10)).thenAnswer(
      (_) async => {
        'data': [_okrJson()],
      },
    );

    final okrs = await repository.getOkrs(10);

    expect(okrs.single.objective, 'Aumentar autonomia técnica');
    expect(okrs.single.keyResults.single.targetValue, 4);
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
          'okr_suggestions': [
            {'objective': 'Objetivo'},
          ],
        },
      },
    );

    final suggestions = await repository.getSuggestions(personId: 10);

    expect(suggestions.oneOnOneQuestions.single, 'Pergunta');
    expect(suggestions.pdiSuggestions.single['title'], 'Ação');
    expect(suggestions.okrSuggestions.single['objective'], 'Objetivo');
  });
}
