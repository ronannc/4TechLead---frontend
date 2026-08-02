import '../models/team.dart';
import '../services/team_service.dart';

/// Maps `TeamService`'s raw JSON into [Team] instances. Only Services and
/// ViewModels are allowed to depend on a Repository — Screens must not.
class TeamRepository {
  TeamRepository(this._service);

  final TeamService _service;

  Future<List<Team>> getTeams({int page = 1, int? perPage}) async {
    final json = await _service.index(page: page, perPage: perPage);
    final data = json['data'] as List<dynamic>;

    return [
      for (final item in data) Team.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<Team> getTeam(int id) async {
    final json = await _service.show(id);

    return Team.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Team> createTeam({required String name}) async {
    final json = await _service.store(name: name);

    return Team.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Team> updateTeam(int id, {required String name}) async {
    final json = await _service.update(id, name: name);

    return Team.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<void> deleteTeam(int id) => _service.destroy(id);
}
