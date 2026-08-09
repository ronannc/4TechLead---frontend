import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../people/models/person.dart';
import '../../people/repositories/person_repository.dart';
import '../../teams/models/team.dart';
import '../../teams/repositories/team_repository.dart';
import '../models/daily_blocker_draft.dart';
import '../models/daily_cue.dart';
import '../models/daily_note_category.dart';
import '../models/daily_session_phase.dart';
import '../models/daily_turn_draft.dart';
import '../repositories/daily_meeting_repository.dart';
import '../utils/daily_time_limit.dart';

enum _CueLevel { normal, aboutToBurn, burned }

/// Drives a full live Daily session: member loading, time-limit
/// configuration, the per-person countdown/overtime timer, and the final
/// save. `elapsedSeconds`/`cue` are exposed as [ValueNotifier]s (not
/// `notifyListeners()` on every tick) so only the timer display widget
/// rebuilds once a second — everything else in the tree stays still.
///
/// The countdown's source of truth is a monotonic clock read (`now()`,
/// injectable for tests), not an accumulating tick counter — a `Timer`
/// merely samples it, so a delayed/suspended tick never desyncs the
/// reported time from wall-clock reality.
class DailySessionViewModel extends BaseViewModel {
  DailySessionViewModel(
    this._personRepository,
    this._dailyMeetingRepository,
    this._teamRepository, {
    this.initialTeamId,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final PersonRepository _personRepository;
  final DailyMeetingRepository _dailyMeetingRepository;
  final TeamRepository _teamRepository;
  final int? initialTeamId;
  final DateTime Function() _now;

  bool _disposed = false;

  DailySessionPhase _phase = DailySessionPhase.configuring;
  DailySessionPhase get phase => _phase;

  List<Team> _teams = [];
  List<Team> get teams => List.unmodifiable(_teams);

  List<Person> _people = [];
  List<Person> get people => List.unmodifiable(_people);

  List<Person> _members = [];
  List<Person> get members => List.unmodifiable(_members);

  int _timeLimitSeconds = dailyTimeLimitMinSeconds;
  int get timeLimitSeconds => _timeLimitSeconds;

  final List<DailyTurnDraft> _turns = [];
  List<DailyTurnDraft> get turns => List.unmodifiable(_turns);

  final List<String> _topics = [];
  List<String> get topics => List.unmodifiable(_topics);

  final List<DailyBlockerDraft> _blockers = [];
  List<DailyBlockerDraft> get blockers => List.unmodifiable(_blockers);

  int _currentTurnIndex = 0;
  int get currentTurnIndex => _currentTurnIndex;

  DailyTurnDraft? get currentTurn =>
      _currentTurnIndex < _turns.length ? _turns[_currentTurnIndex] : null;

  DateTime? _turnStartedAt;
  DateTime? _pausedAt;
  DateTime? _meetingStartedAt;
  Timer? _ticker;
  _CueLevel _lastCueLevel = _CueLevel.normal;
  bool _isPaused = false;
  bool get isPaused => _isPaused;

  final ValueNotifier<int> elapsedSeconds = ValueNotifier(0);
  final ValueNotifier<DailyCue?> cue = ValueNotifier(null);

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _saveErrorMessage;
  String? get saveErrorMessage => _saveErrorMessage;

  Future<void> loadParticipants() => runCatching(() async {
    final results = await Future.wait([
      _teamRepository.getTeams(perPage: 100),
      _personRepository.getPeople(perPage: 100),
    ]);

    _teams = results[0] as List<Team>;
    _people = results[1] as List<Person>;
    _members = initialTeamId == null
        ? []
        : _people.where((person) => person.teamId == initialTeamId).toList();
  });

  bool isPersonSelected(Person person) {
    return _members.any((member) => member.id == person.id);
  }

  bool isTeamSelected(Team team) {
    final teamPeople = _people.where((person) => person.teamId == team.id);

    return teamPeople.isNotEmpty && teamPeople.every(isPersonSelected);
  }

  int selectedCountForTeam(Team team) {
    return _members.where((person) => person.teamId == team.id).length;
  }

  int totalCountForTeam(Team team) {
    return _people.where((person) => person.teamId == team.id).length;
  }

  String teamNameFor(int teamId) {
    for (final team in _teams) {
      if (team.id == teamId) {
        return team.name;
      }
    }

    return 'Time $teamId';
  }

  void toggleTeam(Team team) {
    final teamPeople = _people.where((person) => person.teamId == team.id);
    if (teamPeople.isEmpty) {
      return;
    }

    if (teamPeople.every(isPersonSelected)) {
      _members.removeWhere((person) => person.teamId == team.id);
    } else {
      final selectedIds = _members.map((person) => person.id).toSet();
      _members.addAll(
        teamPeople.where((person) => !selectedIds.contains(person.id)),
      );
    }

    notifyListeners();
  }

  void togglePerson(Person person) {
    if (isPersonSelected(person)) {
      _members.removeWhere((member) => member.id == person.id);
    } else {
      _members.add(person);
    }

    notifyListeners();
  }

  void selectAllPeople() {
    _members = List.of(_people);
    notifyListeners();
  }

  void clearSelection() {
    _members = [];
    notifyListeners();
  }

  void increaseTimeLimit() {
    _timeLimitSeconds += dailyTimeLimitStepSeconds;
    notifyListeners();
  }

  void decreaseTimeLimit() {
    if (_timeLimitSeconds - dailyTimeLimitStepSeconds >=
        dailyTimeLimitMinSeconds) {
      _timeLimitSeconds -= dailyTimeLimitStepSeconds;
      notifyListeners();
    }
  }

  /// Reorders the speaking queue while still in the configuration phase.
  void reorderMembers(int oldIndex, int newIndex) {
    if (_phase != DailySessionPhase.configuring || _members.isEmpty) {
      return;
    }

    if (oldIndex == newIndex ||
        oldIndex < 0 ||
        newIndex < 0 ||
        oldIndex >= _members.length ||
        newIndex >= _members.length) {
      return;
    }

    final member = _members.removeAt(oldIndex);
    _members.insert(newIndex, member);
    notifyListeners();
  }

  void reorderMemberByPersonId(int personId, int targetPersonId) {
    final oldIndex = _members.indexWhere((person) => person.id == personId);
    final newIndex = _members.indexWhere(
      (person) => person.id == targetPersonId,
    );

    reorderMembers(oldIndex, newIndex);
  }

  void start() {
    if (_members.isEmpty) return;

    _turns
      ..clear()
      ..addAll(
        _members.map(
          (person) =>
              DailyTurnDraft(person: person, allowedSeconds: _timeLimitSeconds),
        ),
      );
    _currentTurnIndex = 0;
    _meetingStartedAt = _now();
    _phase = DailySessionPhase.running;
    _beginCurrentTurn(initialCue: DailyCue.turnStarted);
    notifyListeners();
  }

  void _beginCurrentTurn({DailyCue? initialCue}) {
    _turnStartedAt = _now();
    _pausedAt = null;
    _isPaused = false;
    elapsedSeconds.value = 0;
    _lastCueLevel = _CueLevel.normal;
    if (initialCue != null) {
      cue.value = initialCue;
    }

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  void togglePause() {
    if (_phase != DailySessionPhase.running || currentTurn == null) {
      return;
    }

    if (_isPaused) {
      final pausedAt = _pausedAt;
      final startedAt = _turnStartedAt;
      if (pausedAt != null && startedAt != null) {
        _turnStartedAt = startedAt.add(_now().difference(pausedAt));
      }
      _pausedAt = null;
      _isPaused = false;
      _ticker?.cancel();
      _ticker = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _tick(),
      );
    } else {
      _tick();
      _pausedAt = _now();
      _isPaused = true;
      _ticker?.cancel();
    }

    notifyListeners();
  }

  /// Clears the currently emitted cue after the Screen consumes it.
  void clearCue() {
    cue.value = null;
  }

  void _tick() {
    final turn = currentTurn;
    if (_disposed || _isPaused || _turnStartedAt == null || turn == null) {
      return;
    }

    final elapsed = _now().difference(_turnStartedAt!).inSeconds;
    if (elapsed != elapsedSeconds.value) {
      elapsedSeconds.value = elapsed;
    }

    final remaining = turn.allowedSeconds - elapsed;
    final level = remaining <= 0
        ? _CueLevel.burned
        : (remaining <= 10 ? _CueLevel.aboutToBurn : _CueLevel.normal);

    if (level != _lastCueLevel) {
      _lastCueLevel = level;
      if (level == _CueLevel.aboutToBurn) {
        cue.value = DailyCue.aboutToBurn;
      } else if (level == _CueLevel.burned) {
        cue.value = DailyCue.burned;
      }
    }
  }

  void setCurrentNote({DailyNoteCategory? category, String? text}) {
    final turn = currentTurn;
    if (turn == null) {
      return;
    }

    turn.noteCategory = category;
    turn.noteText = text;
    notifyListeners();
  }

  void addTopic(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return;
    }

    _topics.add(normalized);
    notifyListeners();
  }

  void addBlocker(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return;
    }

    _blockers.add(DailyBlockerDraft(text: normalized));
    notifyListeners();
  }

  void toggleBlocker(int index) {
    if (index < 0 || index >= _blockers.length) {
      return;
    }

    _blockers[index] = _blockers[index].toggleResolved();
    notifyListeners();
  }

  /// Ends the current turn and advances to the next person, or moves to
  /// review if everyone has spoken.
  void nextTurn() => _endTurn(advance: true);

  /// Ends the current turn and jumps straight to review — any people who
  /// haven't spoken yet are simply left out of the saved meeting.
  void finishNow() => _endTurn(advance: false);

  void _endTurn({required bool advance}) {
    final turn = currentTurn;
    if (turn == null) {
      return;
    }

    turn.actualSeconds = elapsedSeconds.value;
    _ticker?.cancel();
    _pausedAt = null;
    _isPaused = false;

    if (advance && _currentTurnIndex < _turns.length - 1) {
      _currentTurnIndex++;
      _beginCurrentTurn(initialCue: DailyCue.turnAdvanced);
    } else {
      _phase = DailySessionPhase.reviewing;
    }

    notifyListeners();
  }

  /// Deliberately NOT `runCatching` — a failure here must never swap the
  /// whole screen for an `ErrorView`, which would erase the meeting the
  /// user just ran. Stays in `reviewing` with an inline error + retry, the
  /// drafts remain in memory untouched.
  Future<void> save() async {
    _isSaving = true;
    _saveErrorMessage = null;
    _safeNotify();

    try {
      final spokenTurns = _turns.where((turn) => turn.hasSpoken);

      await _dailyMeetingRepository.createMeeting(
        timeLimitSeconds: _timeLimitSeconds,
        startedAt: _meetingStartedAt ?? _now(),
        endedAt: _now(),
        entries: [
          for (final turn in spokenTurns)
            {
              'person_id': turn.person.id,
              'actual_seconds': turn.actualSeconds,
              if (turn.noteCategory != null)
                'note_type': turn.noteCategory!.apiValue,
              if (turn.noteText != null && turn.noteText!.isNotEmpty)
                'note': turn.noteText,
            },
        ],
      );

      _isSaving = false;
      _phase = DailySessionPhase.finished;
      cue.value = DailyCue.sessionFinished;
      _safeNotify();
    } on ApiException catch (e) {
      _isSaving = false;
      _saveErrorMessage = e.userMessage;
      _safeNotify();
    } catch (_) {
      _isSaving = false;
      _saveErrorMessage = 'Algo deu errado. Tente novamente.';
      _safeNotify();
    }
  }

  void _safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    elapsedSeconds.dispose();
    cue.dispose();
    super.dispose();
  }
}
