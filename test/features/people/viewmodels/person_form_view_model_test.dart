import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/people/viewmodels/person_form_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonRepository extends Mock implements PersonRepository {}

final _person = Person(
  id: 1,
  name: 'Ada Lovelace',
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

void main() {
  late _MockPersonRepository repository;

  setUp(() {
    repository = _MockPersonRepository();
  });

  test('load() fetches the person when editing', () async {
    when(() => repository.getPerson(1)).thenAnswer((_) async => _person);

    final viewModel = PersonFormViewModel(repository, 1, personId: 1);
    await viewModel.load();

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.person, _person);
    expect(viewModel.isEditing, isTrue);
  });

  test(
    'savePerson() creates a person when no person id was provided',
    () async {
      when(
        () => repository.createPerson(
          name: 'Ada Lovelace',
          teamId: 1,
          birthDate: null,
          position: 'Software Engineer',
          contractType: ContractType.clt,
          admissionDate: null,
          seniority: SeniorityLevel.senior,
          email: null,
          phone: null,
        ),
      ).thenAnswer((_) async => _person);

      final viewModel = PersonFormViewModel(repository, 1);
      await viewModel.savePerson(
        name: 'Ada Lovelace',
        position: 'Software Engineer',
        contractType: ContractType.clt,
        seniority: SeniorityLevel.senior,
      );

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.person, _person);
      verify(
        () => repository.createPerson(
          name: 'Ada Lovelace',
          teamId: 1,
          birthDate: null,
          position: 'Software Engineer',
          contractType: ContractType.clt,
          admissionDate: null,
          seniority: SeniorityLevel.senior,
          email: null,
          phone: null,
        ),
      ).called(1);
    },
  );

  test('savePerson() updates a person when editing', () async {
    when(
      () => repository.updatePerson(
        id: 1,
        name: 'Ada Byron',
        teamId: 1,
        birthDate: null,
        position: 'Staff Engineer',
        contractType: ContractType.pj,
        admissionDate: null,
        seniority: SeniorityLevel.specialist,
        email: null,
        phone: null,
      ),
    ).thenAnswer(
      (_) async => Person(
        id: 1,
        name: 'Ada Byron',
        teamId: 1,
        position: 'Staff Engineer',
        contractType: ContractType.pj,
        seniority: SeniorityLevel.specialist,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026, 1, 2),
      ),
    );

    final viewModel = PersonFormViewModel(repository, 1, personId: 1);
    await viewModel.savePerson(
      name: 'Ada Byron',
      position: 'Staff Engineer',
      contractType: ContractType.pj,
      seniority: SeniorityLevel.specialist,
    );

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.person?.name, 'Ada Byron');
    verify(
      () => repository.updatePerson(
        id: 1,
        name: 'Ada Byron',
        teamId: 1,
        birthDate: null,
        position: 'Staff Engineer',
        contractType: ContractType.pj,
        admissionDate: null,
        seniority: SeniorityLevel.specialist,
        email: null,
        phone: null,
      ),
    ).called(1);
  });
}
