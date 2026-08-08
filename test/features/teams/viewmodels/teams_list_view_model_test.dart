import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/core/viewmodels/base_view_model.dart';
import 'package:for_tech_lead/features/teams/models/team.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:for_tech_lead/features/teams/viewmodels/teams_list_view_model.dart';
import 'package:mocktail/mocktail.dart';

class _MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late _MockTeamRepository repository;
  late TeamsListViewModel viewModel;

  final team = Team(
    id: 1,
    name: 'Engineering',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  setUp(() {
    repository = _MockTeamRepository();
    viewModel = TeamsListViewModel(repository);
  });

  test(
    'load() sets state to loaded and exposes the teams on success',
    () async {
      when(() => repository.getTeams()).thenAnswer((_) async => [team]);

      await viewModel.load();

      expect(viewModel.state, ViewState.loaded);
      expect(viewModel.teams, [team]);
    },
  );

  test(
    'load() sets state to error with the repository error message on failure',
    () async {
      when(() => repository.getTeams()).thenThrow(const NotFoundException());

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, const NotFoundException().userMessage);
    },
  );

  test('createTeam() prepends the new team to the existing list', () async {
    when(() => repository.getTeams()).thenAnswer((_) async => [team]);
    await viewModel.load();

    final newTeam = Team(
      id: 2,
      name: 'Sales',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    when(
      () => repository.createTeam(name: 'Sales'),
    ).thenAnswer((_) async => newTeam);

    await viewModel.createTeam('Sales');

    expect(viewModel.state, ViewState.loaded);
    expect(viewModel.teams, [newTeam, team]);
  });

  test(
    'search() filters the exposed teams by a case-insensitive name match',
    () async {
      final other = Team(
        id: 2,
        name: 'Sales',
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );
      when(() => repository.getTeams()).thenAnswer((_) async => [team, other]);
      await viewModel.load();

      viewModel.search('eng');

      expect(viewModel.teams, [team]);

      viewModel.search('');

      expect(viewModel.teams, [team, other]);
    },
  );

  test(
    'hasTeams reflects the unfiltered list, not the search result',
    () async {
      when(() => repository.getTeams()).thenAnswer((_) async => [team]);
      await viewModel.load();

      viewModel.search('no match');

      expect(viewModel.teams, isEmpty);
      expect(viewModel.hasTeams, isTrue);
    },
  );
}
