import 'package:equatable/equatable.dart';

import 'daily_meeting_entry.dart';

/// Mirrors the backend's `DailyMeetingResource`. `entries` defaults to an
/// empty list when the API response didn't include them (e.g. a list
/// endpoint that only needs meeting-level metadata).
class DailyMeeting extends Equatable {
  const DailyMeeting({
    required this.id,
    required this.teamId,
    required this.timeLimitSeconds,
    required this.startedAt,
    required this.endedAt,
    required this.entries,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int teamId;
  final int timeLimitSeconds;
  final DateTime startedAt;
  final DateTime endedAt;
  final List<DailyMeetingEntry> entries;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DailyMeeting.fromJson(Map<String, dynamic> json) {
    final entriesJson = json['entries'] as List<dynamic>?;

    return DailyMeeting(
      id: json['id'] as int,
      teamId: json['team_id'] as int,
      timeLimitSeconds: json['time_limit_seconds'] as int,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: DateTime.parse(json['ended_at'] as String),
      entries: entriesJson == null
          ? const []
          : entriesJson
                .map(
                  (entry) =>
                      DailyMeetingEntry.fromJson(entry as Map<String, dynamic>),
                )
                .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    teamId,
    timeLimitSeconds,
    startedAt,
    endedAt,
    entries,
    createdAt,
    updatedAt,
  ];
}
