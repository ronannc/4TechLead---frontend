import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/people/viewmodels/people_list_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonRepository extends Mock implements PersonRepository {}

Person _person({int id = 1, String name = 'Ada Lovelace'}) {
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

void main() {
  late _MockPersonRepository repository;
  late PeopleListViewModel viewModel;

  setUp(() {
    repository = _MockPersonRepository();
    viewModel = PeopleListViewModel(repository, 1);
  });

  test(
    'load() sets state to loaded and exposes the people on success',
    () async {
      when(
        () => repository.getPeople(teamId: 1, perPage: 100),
      ).thenAnswer((_) async => [_person()]);

      await viewModel.load();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.people, [_person()]);
    },
  );

  test(
    'load() sets state to error with the repository error message on failure',
    () async {
      when(
        () => repository.getPeople(teamId: 1, perPage: 100),
      ).thenThrow(const NotFoundException());

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, const NotFoundException().userMessage);
    },
  );

  test(
    'search() filters the exposed people by a case-insensitive name match',
    () async {
      final other = _person(id: 2, name: 'Grace Hopper');
      when(
        () => repository.getPeople(teamId: 1, perPage: 100),
      ).thenAnswer((_) async => [_person(), other]);
      await viewModel.load();

      viewModel.search('ada');

      expect(viewModel.people, [_person()]);

      viewModel.search('');

      expect(viewModel.people, [_person(), other]);
    },
  );

  test(
    'hasPeople reflects the unfiltered list, not the search result',
    () async {
      when(
        () => repository.getPeople(teamId: 1, perPage: 100),
      ).thenAnswer((_) async => [_person()]);
      await viewModel.load();

      viewModel.search('no match');

      expect(viewModel.people, isEmpty);
      expect(viewModel.hasPeople, isTrue);
    },
  );
}
