import '../../../core/viewmodels/base_view_model.dart';
import '../models/contract_type.dart';
import '../models/person.dart';
import '../models/seniority_level.dart';
import '../repositories/person_repository.dart';

class PersonFormViewModel extends BaseViewModel {
  PersonFormViewModel(this._repository, this.teamId);

  final PersonRepository _repository;
  final int teamId;

  Person? _created;
  Person? get created => _created;

  Future<void> createPerson({
    required String name,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) => runCatching(() async {
    _created = await _repository.createPerson(
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
