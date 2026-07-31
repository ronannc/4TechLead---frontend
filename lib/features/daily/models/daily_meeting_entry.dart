import 'package:equatable/equatable.dart';

import '../../people/models/person.dart';
import 'daily_entry_status.dart';
import 'daily_note_category.dart';

/// Mirrors the backend's `DailyMeetingEntryResource` — one person's speaking
/// turn within a [DailyMeeting]. `status` is always server-computed, never
/// recomputed client-side for a saved entry.
class DailyMeetingEntry extends Equatable {
  const DailyMeetingEntry({
    required this.id,
    required this.dailyMeetingId,
    required this.teamId,
    required this.personId,
    required this.speakingOrder,
    required this.allottedSeconds,
    required this.actualSeconds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.person,
    this.noteType,
    this.note,
  });

  final int id;
  final int dailyMeetingId;
  final int teamId;
  final int personId;
  final Person? person;
  final int speakingOrder;
  final int allottedSeconds;
  final int actualSeconds;
  final DailyEntryStatus status;
  final DailyNoteCategory? noteType;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DailyMeetingEntry.fromJson(Map<String, dynamic> json) {
    final personJson = json['person'] as Map<String, dynamic>?;

    return DailyMeetingEntry(
      id: json['id'] as int,
      dailyMeetingId: json['daily_meeting_id'] as int,
      teamId: json['team_id'] as int,
      personId: json['person_id'] as int,
      person: personJson != null ? Person.fromJson(personJson) : null,
      speakingOrder: json['speaking_order'] as int,
      allottedSeconds: json['allotted_seconds'] as int,
      actualSeconds: json['actual_seconds'] as int,
      status: DailyEntryStatus.fromApiValue(json['status'] as String),
      noteType: json['note_type'] != null
          ? DailyNoteCategory.fromApiValue(json['note_type'] as String)
          : null,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    dailyMeetingId,
    teamId,
    personId,
    person,
    speakingOrder,
    allottedSeconds,
    actualSeconds,
    status,
    noteType,
    note,
    createdAt,
    updatedAt,
  ];
}
