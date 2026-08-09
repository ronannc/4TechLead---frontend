import '../../people/models/person.dart';

/// Local, mutable working state for one person's turn during a live
/// [DailySessionScreen] session — NOT the same as [DailyMeetingEntry], which
/// only exists once the meeting has been saved to the backend (a saved
/// entry has a real `id`; a draft never does).
class DailyTurnDraft {
  DailyTurnDraft({required this.person, required this.allowedSeconds});

  final Person person;
  final int allowedSeconds;

  /// Set once the turn ends (via "Próximo"/"Finalizar"); `null` while the
  /// person hasn't spoken yet.
  int? actualSeconds;

  bool get hasSpoken => actualSeconds != null;
}
