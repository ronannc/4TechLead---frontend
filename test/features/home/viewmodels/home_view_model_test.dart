import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/home/viewmodels/home_view_model.dart';
import 'package:for_tech_lead/features/people/models/contract_type.dart';
import 'package:for_tech_lead/features/people/models/person.dart';
import 'package:for_tech_lead/features/people/models/seniority_level.dart';
import 'package:for_tech_lead/features/people/repositories/person_repository.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockTeamRepository extends Mock implements TeamRepository {}

class _MockPersonRepository extends Mock implements PersonRepository {}

Person _personWithBirthday(String name, DateTime birthDate) {
  return Person(
    id: name.hashCode,
    name: name,
    teamId: 1,
    birthDate: birthDate,
    age: 30,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    admissionDate: DateTime(2020, 1, 15),
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

Person _personWithoutBirthday(String name) {
  return Person(
    id: name.hashCode,
    name: name,
    teamId: 1,
    position: 'Software Engineer',
    contractType: ContractType.clt,
    seniority: SeniorityLevel.senior,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
}

void main() {
  late _MockTeamRepository teamRepository;
  late _MockPersonRepository personRepository;
  late HomeViewModel viewModel;

  setUp(() {
    teamRepository = _MockTeamRepository();
    personRepository = _MockPersonRepository();
    viewModel = HomeViewModel(teamRepository, personRepository);
  });

  test(
    'load() exposes the team count and people sorted by soonest birthday',
    () async {
      when(() => teamRepository.getTeams()).thenAnswer(
        (_) async => [
          Team(
            id: 1,
            name: 'Engineering',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ],
      );

      // Built relative to today (not fixed calendar dates) so the expected
      // ordering below holds no matter what day the suite actually runs on.
      final today = DateTime.now();
      final soonBirthday = today.add(const Duration(days: 5));
      final laterBirthday = today.add(const Duration(days: 200));
      final soon = _personWithBirthday(
        'Soon',
        DateTime(1990, soonBirthday.month, soonBirthday.day),
      );
      final later = _personWithBirthday(
        'Later',
        DateTime(1990, laterBirthday.month, laterBirthday.day),
      );
      when(
        () => personRepository.getPeople(perPage: 100),
      ).thenAnswer((_) async => [later, soon]);

      await viewModel.load();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.teamsCount, 1);
      expect(viewModel.firstTeamId, 1);
      expect(viewModel.teamToday.map((p) => p.name), ['Later', 'Soon']);
      expect(viewModel.upcomingBirthdays.map((p) => p.name), ['Soon', 'Later']);
    },
  );

  test(
    'load() ignores people without birth dates in birthday ranking',
    () async {
      when(() => teamRepository.getTeams()).thenAnswer((_) async => []);

      final today = DateTime.now();
      final soonBirthday = today.add(const Duration(days: 5));
      final soon = _personWithBirthday(
        'Soon',
        DateTime(1990, soonBirthday.month, soonBirthday.day),
      );
      when(
        () => personRepository.getPeople(perPage: 100),
      ).thenAnswer((_) async => [_personWithoutBirthday('No birthday'), soon]);

      await viewModel.load();

      expect(viewModel.upcomingBirthdays.map((p) => p.name), ['Soon']);
      expect(viewModel.teamToday.map((p) => p.name), ['No birthday', 'Soon']);
    },
  );

  test('load() caps the upcoming birthdays list at 5 people', () async {
    when(() => teamRepository.getTeams()).thenAnswer((_) async => []);

    final people = [
      for (var day = 1; day <= 10; day++)
        _personWithBirthday('Person $day', DateTime(1990, 1, day)),
    ];
    when(
      () => personRepository.getPeople(perPage: 100),
    ).thenAnswer((_) async => people);

    await viewModel.load();

    expect(viewModel.upcomingBirthdays, hasLength(5));
  });
}
