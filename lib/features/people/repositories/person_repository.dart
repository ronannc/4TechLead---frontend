import '../models/contract_type.dart';
import '../models/person.dart';
import '../models/seniority_level.dart';
import '../services/person_service.dart';

/// Maps `PersonService`'s raw JSON into [Person] instances. Only Services
/// and ViewModels are allowed to depend on a Repository — Screens must not.
class PersonRepository {
  PersonRepository(this._service);

  final PersonService _service;

  Future<List<Person>> getPeople({
    int page = 1,
    int? teamId,
    String? search,
    int? perPage,
  }) async {
    final json = await _service.index(
      page: page,
      teamId: teamId,
      search: search,
      perPage: perPage,
    );
    final data = json['data'] as List<dynamic>;

    return [
      for (final item in data) Person.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<Person> getPerson(int id) async {
    final json = await _service.show(id);

    return Person.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Person> getMyPerson() async {
    final json = await _service.showMe();

    return Person.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Person> createPerson({
    required String name,
    required int teamId,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) async {
    final json = await _service.store(
      name: name,
      teamId: teamId,
      birthDate: birthDate,
      position: position,
      contractType: contractType,
      admissionDate: admissionDate,
      seniority: seniority,
      email: email,
      phone: phone,
    );

    return Person.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<Person> updatePerson({
    required int id,
    required String name,
    required int teamId,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) async {
    final json = await _service.update(
      id: id,
      name: name,
      teamId: teamId,
      birthDate: birthDate,
      position: position,
      contractType: contractType,
      admissionDate: admissionDate,
      seniority: seniority,
      email: email,
      phone: phone,
    );

    return Person.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<String> createInvitationToken(int personId) async {
    final json = await _service.createInvitation(personId);

    return json['token'] as String;
  }
}
