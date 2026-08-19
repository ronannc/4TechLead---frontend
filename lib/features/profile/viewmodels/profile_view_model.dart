import '../../../core/viewmodels/base_view_model.dart';
import '../../auth/models/app_user.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../people/models/person.dart';
import '../../people/repositories/person_repository.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(this._authRepository, this._personRepository);

  final AuthRepository _authRepository;
  final PersonRepository _personRepository;

  AppUser? _user;
  AppUser? get user => _user;
  Person? _person;
  Person? get person => _person;

  Future<void> load() => runCatching(() async {
    _user = await _authRepository.me();
    _person = await _loadLinkedPerson(_user!);
  });

  Future<void> signOut() => _authRepository.logout();

  Future<Person?> _loadLinkedPerson(AppUser user) async {
    if (user.isMember) {
      return _personRepository.getMyPerson();
    }

    final personId = user.personId;
    if (personId != null) {
      return _personRepository.getPerson(personId);
    }

    if (!user.isTechLead) {
      return null;
    }

    final people = await _personRepository.getPeople(
      search: user.email,
      perPage: 100,
    );
    final normalizedEmail = user.email.toLowerCase().trim();

    for (final person in people) {
      if (person.email?.toLowerCase().trim() == normalizedEmail) {
        return person;
      }
    }

    return null;
  }
}
