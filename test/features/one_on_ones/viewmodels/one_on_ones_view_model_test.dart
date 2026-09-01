import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/one_on_ones/viewmodels/one_on_ones_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/person_growth_models.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_growth_repository.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonGrowthRepository extends Mock
    implements PersonGrowthRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

void main() {
  late _MockPersonGrowthRepository growthRepository;
  late _MockPersonRepository personRepository;
  late OneOnOnesViewModel viewModel;

  setUp(() {
    growthRepository = _MockPersonGrowthRepository();
    personRepository = _MockPersonRepository();
    viewModel = OneOnOnesViewModel(
      growthRepository,
      personRepository,
      canManageOneOnOnes: true,
    );

    when(
      () => personRepository.getPeople(perPage: 100),
    ).thenAnswer((_) async => [_person()]);
    when(growthRepository.getTemplates).thenAnswer(
      (_) async => [
        const OneOnOneTemplate(
          id: 2,
          title: 'Carreira',
          questions: ['O que quer evoluir?'],
        ),
      ],
    );
    when(
      () => growthRepository.getSessions(
        personId: null,
        status: 'completed',
        perPage: 50,
      ),
    ).thenAnswer((_) async => const []);
    when(
      () => growthRepository.getPersonOneOnOneNotes(
        personId: any(named: 'personId'),
        status: 'open',
      ),
    ).thenAnswer((_) async => const []);
  });

  test('loads people templates and one on one sections', () async {
    await viewModel.load(initialPersonId: 1);

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.selectedPersonId, 1);
    expect(viewModel.people.single.name, 'Ada Lovelace');
    expect(viewModel.templates.single.title, 'Carreira');
  });

  test('executes a one on one with selected person and document', () async {
    await viewModel.load(initialPersonId: 1);
    viewModel.selectTemplate(2);

    when(
      () => growthRepository.createSession(
        personId: 1,
        title: '1:1 Setembro',
        notes: 'Falar sobre carreira.',
        heldAt: any(named: 'heldAt'),
        templateId: 2,
        questions: ['O que quer evoluir?'],
        answers: {'O que quer evoluir?': 'Quero praticar mentoria.'},
        status: 'completed',
      ),
    ).thenAnswer(
      (invocation) async => OneOnOneSession(
        id: 10,
        personId: 1,
        title: '1:1 Setembro',
        status: 'completed',
        heldAt: invocation.namedArguments[#heldAt] as DateTime?,
      ),
    );

    await viewModel.executeSession(
      title: '1:1 Setembro',
      notes: 'Falar sobre carreira.',
      answers: {'O que quer evoluir?': 'Quero praticar mentoria.'},
    );

    verify(
      () => growthRepository.createSession(
        personId: 1,
        title: '1:1 Setembro',
        notes: 'Falar sobre carreira.',
        heldAt: any(named: 'heldAt'),
        templateId: 2,
        questions: ['O que quer evoluir?'],
        answers: {'O que quer evoluir?': 'Quero praticar mentoria.'},
        status: 'completed',
      ),
    ).called(1);
    expect(viewModel.actionErrorMessage, isNull);
  });

  test('can execute another one on one immediately after a save', () async {
    await viewModel.load(initialPersonId: 1);
    viewModel.selectTemplate(2);

    when(
      () => growthRepository.createSession(
        personId: 1,
        title: any(named: 'title'),
        notes: any(named: 'notes'),
        heldAt: any(named: 'heldAt'),
        templateId: 2,
        questions: ['O que quer evoluir?'],
        answers: any(named: 'answers'),
        status: 'completed',
      ),
    ).thenAnswer(
      (invocation) async => OneOnOneSession(
        id: 10,
        personId: 1,
        title: invocation.namedArguments[#title] as String,
        status: 'completed',
        heldAt: invocation.namedArguments[#heldAt] as DateTime?,
      ),
    );

    final firstSaved = await viewModel.executeSession(
      title: '1:1 Setembro',
      notes: 'Primeira conversa.',
      answers: {'O que quer evoluir?': 'Primeira conversa.'},
    );
    final secondSaved = await viewModel.executeSession(
      title: '1:1 Outubro',
      notes: 'Segunda conversa.',
      answers: {'O que quer evoluir?': 'Segunda conversa.'},
    );

    expect(firstSaved, isTrue);
    expect(secondSaved, isTrue);
    expect(viewModel.selectedPersonId, 1);
    expect(viewModel.selectedTemplateId, 2);
    verify(
      () => growthRepository.createSession(
        personId: 1,
        title: any(named: 'title'),
        notes: any(named: 'notes'),
        heldAt: any(named: 'heldAt'),
        templateId: 2,
        questions: ['O que quer evoluir?'],
        answers: any(named: 'answers'),
        status: 'completed',
      ),
    ).called(2);
  });

  test('creates a point for a person', () async {
    await viewModel.load(initialPersonId: 1);

    when(
      () => growthRepository.createPersonOneOnOneNote(
        personId: 1,
        title: 'Trazer feedback do PR',
        body: 'Comentário importante para conversar no próximo 1:1.',
        occurredAt: any(named: 'occurredAt'),
      ),
    ).thenAnswer(
      (_) async => const PersonOneOnOneNote(
        id: 3,
        personId: 1,
        title: 'Trazer feedback do PR',
        body: 'Comentário importante para conversar no próximo 1:1.',
        status: 'open',
      ),
    );

    await viewModel.createPersonNote(
      title: 'Trazer feedback do PR',
      body: 'Comentário importante para conversar no próximo 1:1.',
    );

    verify(
      () => growthRepository.createPersonOneOnOneNote(
        personId: 1,
        title: 'Trazer feedback do PR',
        body: 'Comentário importante para conversar no próximo 1:1.',
        occurredAt: any(named: 'occurredAt'),
      ),
    ).called(1);
  });
}

Person _person() {
  return Person(
    id: 1,
    name: 'Ada Lovelace',
    teamId: 1,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 1),
  );
}
