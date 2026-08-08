import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/network/api_exception.dart';
import 'package:for_tech_lead/features/teams/repositories/team_repository.dart';
import 'package:for_tech_lead/features/teams/services/team_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockTeamService extends Mock implements TeamService {}

void main() {
  late _MockTeamService service;
  late TeamRepository repository;

  setUp(() {
    service = _MockTeamService();
    repository = TeamRepository(service);
  });

  group('getTeams', () {
    test(
      'maps a paginated {data, links, meta} envelope into a List<Team>',
      () async {
        when(() => service.index(page: 1)).thenAnswer(
          (_) async => {
            'data': [
              {
                'id': 1,
                'name': 'Engineering',
                'created_at': '2026-01-01T10:00:00.000000Z',
                'updated_at': '2026-01-01T10:00:00.000000Z',
              },
              {
                'id': 2,
                'name': 'Sales',
                'created_at': '2026-01-02T10:00:00.000000Z',
                'updated_at': '2026-01-02T10:00:00.000000Z',
              },
            ],
            'links': {
              'first': '/teams?page=1',
              'last': '/teams?page=1',
              'prev': null,
              'next': null,
            },
            'meta': {'current_page': 1, 'last_page': 1, 'total': 2},
          },
        );

        final teams = await repository.getTeams();

        expect(teams, hasLength(2));
        expect(teams.first.id, 1);
        expect(teams.first.name, 'Engineering');
        expect(teams.last.name, 'Sales');
      },
    );

    test('propagates a NotFoundException thrown by the service', () async {
      when(() => service.index(page: 1)).thenThrow(const NotFoundException());

      expect(() => repository.getTeams(), throwsA(isA<NotFoundException>()));
    });
  });

  group('getTeam', () {
    test('maps a single {data} envelope into a Team', () async {
      when(() => service.show(1)).thenAnswer(
        (_) async => {
          'data': {
            'id': 1,
            'name': 'Engineering',
            'created_at': '2026-01-01T10:00:00.000000Z',
            'updated_at': '2026-01-01T10:00:00.000000Z',
          },
        },
      );

      final team = await repository.getTeam(1);

      expect(team.id, 1);
      expect(team.name, 'Engineering');
    });
  });
}
