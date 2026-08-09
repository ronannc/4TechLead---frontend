import 'package:equatable/equatable.dart';

import '../../people/models/person.dart';
import 'daily_annotation_type.dart';

class DailyMeetingAnnotation extends Equatable {
  const DailyMeetingAnnotation({
    required this.id,
    required this.dailyMeetingId,
    required this.type,
    required this.text,
    required this.resolved,
    required this.createdAt,
    required this.updatedAt,
    this.personId,
    this.person,
  });

  final int id;
  final int dailyMeetingId;
  final int? personId;
  final Person? person;
  final DailyAnnotationType type;
  final String text;
  final bool resolved;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DailyMeetingAnnotation.fromJson(Map<String, dynamic> json) {
    final personJson = json['person'] as Map<String, dynamic>?;

    return DailyMeetingAnnotation(
      id: json['id'] as int,
      dailyMeetingId: json['daily_meeting_id'] as int,
      personId: json['person_id'] as int?,
      person: personJson != null ? Person.fromJson(personJson) : null,
      type: DailyAnnotationType.fromApiValue(json['type'] as String),
      text: json['text'] as String,
      resolved: json['resolved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    dailyMeetingId,
    personId,
    person,
    type,
    text,
    resolved,
    createdAt,
    updatedAt,
  ];
}
