import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/people/viewmodels/person_detail_view_model.dart';
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
  late PersonDetailViewModel viewModel;

  setUp(() {
    repository = _MockPersonRepository();
    viewModel = PersonDetailViewModel(repository, 1);
  });

  test(
    'load() sets state to loaded and exposes the person on success',
    () async {
      when(() => repository.getPerson(1)).thenAnswer((_) async => _person);

      await viewModel.load();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.person, _person);
    },
  );

  test(
    'load() sets state to error with the repository error message on failure',
    () async {
      when(() => repository.getPerson(1)).thenThrow(const NotFoundException());

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, const NotFoundException().userMessage);
    },
  );
}
