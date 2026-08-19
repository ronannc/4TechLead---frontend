import '../../../core/viewmodels/base_view_model.dart';
import '../models/contract_type.dart';
import '../models/person.dart';
import '../models/seniority_level.dart';
import '../repositories/person_repository.dart';

class PersonFormViewModel extends BaseViewModel {
  PersonFormViewModel(this._repository, this.teamId, {this.personId});

  final PersonRepository _repository;
  final int teamId;
  final int? personId;

  Person? _person;
  Person? get person => _person;
  bool get isEditing => personId != null;

  Future<void> load() => runCatching(() async {
    final id = personId;
    if (id == null) {
      return;
    }

    _person = await _repository.getPerson(id);
  });

  Future<void> createPerson({
    required String name,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) async => savePerson(
    name: name,
    birthDate: birthDate,
    position: position,
    contractType: contractType,
    admissionDate: admissionDate,
    seniority: seniority,
    email: email,
    phone: phone,
  );

  Future<void> savePerson({
    required String name,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) => runCatching(() async {
    final id = personId;
    if (id == null) {
      _person = await _repository.createPerson(
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
      return;
    }

    _person = await _repository.updatePerson(
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
  });
}
