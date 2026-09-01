import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';
import '../../people/models/person_growth_models.dart';
import '../../people/repositories/person_growth_repository.dart';
import '../../people/repositories/person_repository.dart';

class OneOnOnesViewModel extends BaseViewModel {
  OneOnOnesViewModel(
    this._growthRepository,
    this._personRepository, {
    required this.canManageOneOnOnes,
    this.currentPersonId,
  });

  final PersonGrowthRepository _growthRepository;
  final PersonRepository _personRepository;
  final bool canManageOneOnOnes;
  final int? currentPersonId;

  List<Person> people = [];
  List<OneOnOneTemplate> templates = [];
  List<OneOnOneSession> completedSessions = [];
  List<PersonOneOnOneNote> personNotes = [];
  GrowthSuggestions? suggestions;

  String? actionErrorMessage;
  bool isMutating = false;
  int? selectedPersonId;
  int? selectedTemplateId;

  Future<void> load({int? initialPersonId}) => runCatching(() async {
    selectedPersonId = initialPersonId ?? currentPersonId ?? selectedPersonId;

    if (canManageOneOnOnes) {
      await Future.wait([
        _loadPeople(),
        _loadTemplates(),
        _loadCompletedSessions(),
        _loadPersonNotes(),
      ]);
      return;
    }

    await _loadCompletedSessions();
  });

  Person? personById(int? id) {
    if (id == null) {
      return null;
    }

    for (final person in people) {
      if (person.id == id) {
        return person;
      }
    }

    return null;
  }

  String personName(int personId) => personById(personId)?.name ?? 'Pessoa';

  OneOnOneTemplate? get selectedDocument => _selectedTemplate();

  void selectPerson(int? personId) {
    selectedPersonId = personId;
    suggestions = null;
    personNotes = [];
    notifyListeners();

    Future<void>(() async {
      await _runMutation(_loadPersonNotes);
    });
  }

  void selectTemplate(int? templateId) {
    selectedTemplateId = templateId;
    notifyListeners();
  }

  Future<void> createTemplate({
    required String title,
    required List<String> questions,
    String? description,
  }) => _runMutation(() async {
    await _growthRepository.createTemplate(
      title: title,
      questions: questions,
      description: description,
    );
    await _loadTemplates();
  });

  Future<bool> executeSession({
    required String title,
    String? notes,
    Map<String, dynamic>? answers,
    List<int> usedNoteIds = const [],
  }) => _runMutation(() async {
    final personId = selectedPersonId;
    if (personId == null) {
      actionErrorMessage = 'Escolha uma pessoa para executar o 1:1.';
      return;
    }

    final template = _selectedTemplate();
    await _growthRepository.createSession(
      personId: personId,
      title: title,
      notes: notes,
      heldAt: DateTime.now(),
      templateId: selectedTemplateId,
      questions: template?.questions,
      answers: answers,
      status: 'completed',
    );
    await Future.wait([
      for (final noteId in usedNoteIds)
        _growthRepository.updatePersonOneOnOneNote(id: noteId, status: 'used'),
      _loadCompletedSessions(),
      _loadPersonNotes(),
    ]);
  });

  Future<void> createPersonNote({required String title, String? body}) =>
      _runMutation(() async {
        final personId = selectedPersonId;
        if (personId == null) {
          actionErrorMessage = 'Escolha uma pessoa para anotar um ponto.';
          return;
        }

        await _growthRepository.createPersonOneOnOneNote(
          personId: personId,
          title: title,
          body: body,
          occurredAt: DateTime.now(),
        );
        await _loadPersonNotes();
      });

  Future<void> generateSuggestions({String? context}) => _runMutation(() async {
    final personId = selectedPersonId;
    if (personId == null) {
      actionErrorMessage = 'Escolha uma pessoa para gerar sugestões.';
      return;
    }

    suggestions = await _growthRepository.getSuggestions(
      personId: personId,
      context: context,
    );
  });

  void clearActionError() {
    actionErrorMessage = null;
    notifyListeners();
  }

  Future<void> _loadPeople() async {
    if (!canManageOneOnOnes) {
      return;
    }

    people = await _personRepository.getPeople(perPage: 100);
  }

  Future<void> _loadTemplates() async {
    if (!canManageOneOnOnes) {
      return;
    }

    templates = await _growthRepository.getTemplates();
  }

  Future<void> _loadCompletedSessions() async {
    completedSessions = await _growthRepository.getSessions(
      personId: canManageOneOnOnes ? null : currentPersonId,
      status: 'completed',
      perPage: 50,
    );
  }

  Future<void> _loadPersonNotes() async {
    if (!canManageOneOnOnes) {
      return;
    }

    personNotes = await _growthRepository.getPersonOneOnOneNotes(
      personId: selectedPersonId,
      status: 'open',
    );
  }

  OneOnOneTemplate? _selectedTemplate() {
    final templateId = selectedTemplateId;
    if (templateId == null) {
      return null;
    }

    for (final template in templates) {
      if (template.id == templateId) {
        return template;
      }
    }

    return null;
  }

  Future<bool> _runMutation(Future<void> Function() action) async {
    actionErrorMessage = null;
    isMutating = true;
    notifyListeners();

    try {
      await action();
      return actionErrorMessage == null;
    } on ApiException catch (e) {
      actionErrorMessage = e.userMessage;
    } catch (_) {
      actionErrorMessage = 'Algo deu errado. Tente novamente.';
    } finally {
      isMutating = false;
      notifyListeners();
    }

    return false;
  }
}
