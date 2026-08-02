import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/people/models/contract_type.dart';
import 'package:frontend/features/people/models/seniority_level.dart';
import 'package:frontend/features/people/repositories/person_repository.dart';
import 'package:frontend/features/people/services/person_service.dart';
import 'package:mocktail/mocktail.dart';

class _MockPersonService extends Mock implements PersonService {}

Map<String, dynamic> _personJson({int id = 1, String name = 'Ada Lovelace'}) {
  return {
    'id': id,
    'name': name,
    'team_id': 1,
    'birth_date': '1990-05-10',
    'age': 35,
    'position': 'Software Engineer',
    'contract_type': 'clt',
    'email': 'ada@example.com',
    'phone': '+55 11 99999-0000',
    'admission_date': '2020-01-15',
    'seniority': 'senior',
    'created_at': '2026-01-01T10:00:00.000000Z',
    'updated_at': '2026-01-01T10:00:00.000000Z',
  };
}

Map<String, dynamic> _personWithoutDatesJson() {
  return {
    ..._personJson(),
    'birth_date': null,
    'age': null,
    'admission_date': null,
  };
}

void main() {
  late _MockPersonService service;
  late PersonRepository repository;

  setUp(() {
    service = _MockPersonService();
    repository = PersonRepository(service);
  });

  group('getPeople', () {
    test('maps a paginated {data} envelope into a List<Person>', () async {
      when(
        () => service.index(page: 1, teamId: null, search: null, perPage: null),
      ).thenAnswer(
        (_) async => {
          'data': [_personJson(), _personJson(id: 2, name: 'Grace Hopper')],
        },
      );

      final people = await repository.getPeople();

      expect(people, hasLength(2));
      expect(people.first.name, 'Ada Lovelace');
      expect(people.first.contractType, ContractType.clt);
      expect(people.first.seniority, SeniorityLevel.senior);
      expect(people.last.name, 'Grace Hopper');
    });

    test('propagates a NotFoundException thrown by the service', () async {
      when(
        () => service.index(page: 1, teamId: null, search: null, perPage: null),
      ).thenThrow(const NotFoundException());

      expect(() => repository.getPeople(), throwsA(isA<NotFoundException>()));
    });
  });

  group('getPerson', () {
    test('maps a single {data} envelope into a Person', () async {
      when(
        () => service.show(1),
      ).thenAnswer((_) async => {'data': _personJson()});

      final person = await repository.getPerson(1);

      expect(person.id, 1);
      expect(person.name, 'Ada Lovelace');
      expect(person.age, 35);
    });

    test('maps nullable birth and admission dates', () async {
      when(
        () => service.show(1),
      ).thenAnswer((_) async => {'data': _personWithoutDatesJson()});

      final person = await repository.getPerson(1);

      expect(person.birthDate, isNull);
      expect(person.age, isNull);
      expect(person.admissionDate, isNull);
    });
  });

  group('createPerson', () {
    test('maps the created {data} envelope into a Person', () async {
      when(
        () => service.store(
          name: 'Ada Lovelace',
          teamId: 1,
          birthDate: DateTime(1990, 5, 10),
          position: 'Software Engineer',
          contractType: ContractType.clt,
          admissionDate: DateTime(2020, 1, 15),
          seniority: SeniorityLevel.senior,
          email: 'ada@example.com',
          phone: null,
        ),
      ).thenAnswer((_) async => {'data': _personJson()});

      final person = await repository.createPerson(
        name: 'Ada Lovelace',
        teamId: 1,
        birthDate: DateTime(1990, 5, 10),
        position: 'Software Engineer',
        contractType: ContractType.clt,
        admissionDate: DateTime(2020, 1, 15),
        seniority: SeniorityLevel.senior,
        email: 'ada@example.com',
      );

      expect(person.name, 'Ada Lovelace');
    });

    test('forwards null dates when they are not provided', () async {
      when(
        () => service.store(
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
      ).thenAnswer((_) async => {'data': _personWithoutDatesJson()});

      final person = await repository.createPerson(
        name: 'Ada Lovelace',
        teamId: 1,
        position: 'Software Engineer',
        contractType: ContractType.clt,
        seniority: SeniorityLevel.senior,
      );

      expect(person.birthDate, isNull);
      expect(person.admissionDate, isNull);
    });
  });
}
