import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/auth/models/app_user.dart';
import 'package:for_tech_lead/features/auth/repositories/auth_repository.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/profile/viewmodels/profile_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

AppUser _user({
  String role = 'member',
  int? personId = 10,
  String email = 'ada@example.com',
}) {
  return AppUser(
    id: 1,
    name: 'Ada Lovelace',
    email: email,
    role: role,
    personId: personId,
    createdAt: DateTime(2026),
  );
}

Person _person({int id = 10, String email = 'ada@example.com'}) {
  return Person(
    id: id,
    name: 'Ada Lovelace',
    teamId: 2,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.senior,
    email: email,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  late _MockAuthRepository authRepository;
  late _MockPersonRepository personRepository;

  setUp(() {
    authRepository = _MockAuthRepository();
    personRepository = _MockPersonRepository();
  });

  test('loads member profile through the me person endpoint', () async {
    when(() => authRepository.me()).thenAnswer((_) async => _user());
    when(
      () => personRepository.getMyPerson(),
    ).thenAnswer((_) async => _person());

    final viewModel = ProfileViewModel(authRepository, personRepository);

    await viewModel.load();

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.person?.id, 10);
    verify(() => personRepository.getMyPerson()).called(1);
    verifyNever(() => personRepository.getPerson(any()));
  });

  test('loads linked tech lead person through person id', () async {
    when(
      () => authRepository.me(),
    ).thenAnswer((_) async => _user(role: 'tech_lead', personId: 12));
    when(
      () => personRepository.getPerson(12),
    ).thenAnswer((_) async => _person(id: 12));

    final viewModel = ProfileViewModel(authRepository, personRepository);

    await viewModel.load();

    expect(viewModel.person?.id, 12);
    verify(() => personRepository.getPerson(12)).called(1);
    verifyNever(
      () => personRepository.getPeople(
        page: any(named: 'page'),
        teamId: any(named: 'teamId'),
        search: any(named: 'search'),
        perPage: any(named: 'perPage'),
      ),
    );
  });

  test(
    'matches a tech lead person by login email when not linked yet',
    () async {
      when(
        () => authRepository.me(),
      ).thenAnswer((_) async => _user(role: 'tech_lead', personId: null));
      when(
        () =>
            personRepository.getPeople(search: 'ada@example.com', perPage: 100),
      ).thenAnswer(
        (_) async => [
          _person(id: 9, email: 'other@example.com'),
          _person(id: 10),
        ],
      );

      final viewModel = ProfileViewModel(authRepository, personRepository);

      await viewModel.load();

      expect(viewModel.person?.id, 10);
      verify(
        () =>
            personRepository.getPeople(search: 'ada@example.com', perPage: 100),
      ).called(1);
    },
  );
}
