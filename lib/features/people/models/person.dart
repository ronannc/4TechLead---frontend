import 'package:equatable/equatable.dart';

import 'contract_type.dart';
import 'seniority_level.dart';

class PersonDailyStatsSummary extends Equatable {
  const PersonDailyStatsSummary({
    required this.entryCount,
    required this.averageActualSeconds,
    required this.onTimePercentage,
    required this.burnedPercentage,
    required this.spokeTooLittlePercentage,
  });

  factory PersonDailyStatsSummary.fromJson(Map<String, dynamic> json) {
    return PersonDailyStatsSummary(
      entryCount: json['entry_count'] as int? ?? 0,
      averageActualSeconds:
          (json['average_actual_seconds'] as num?)?.toDouble() ?? 0,
      onTimePercentage: (json['on_time_percentage'] as num?)?.toDouble() ?? 0,
      burnedPercentage: (json['burned_percentage'] as num?)?.toDouble() ?? 0,
      spokeTooLittlePercentage:
          (json['spoke_too_little_percentage'] as num?)?.toDouble() ?? 0,
    );
  }

  final int entryCount;
  final double averageActualSeconds;
  final double onTimePercentage;
  final double burnedPercentage;
  final double spokeTooLittlePercentage;

  @override
  List<Object?> get props => [
    entryCount,
    averageActualSeconds,
    onTimePercentage,
    burnedPercentage,
    spokeTooLittlePercentage,
  ];
}

/// Mirrors the backend's `PersonResource`. `age` is always server-computed
/// from `birthDate` — never recomputed client-side, so there's a single
/// source of truth for "today" in that calculation.
class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.teamId,
    this.birthDate,
    this.age,
    required this.position,
    required this.contractType,
    this.admissionDate,
    required this.seniority,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.phone,
    this.dailyStatsSummary,
  });

  final int id;
  final String name;
  final int teamId;
  final DateTime? birthDate;
  final int? age;
  final String position;
  final ContractType contractType;
  final String? email;
  final String? phone;
  final DateTime? admissionDate;
  final SeniorityLevel seniority;
  final PersonDailyStatsSummary? dailyStatsSummary;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      name: json['name'] as String,
      teamId: json['team_id'] as int,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      age: json['age'] as int?,
      position: json['position'] as String,
      contractType: ContractType.fromApiValue(json['contract_type'] as String),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      admissionDate: json['admission_date'] == null
          ? null
          : DateTime.parse(json['admission_date'] as String),
      seniority: SeniorityLevel.fromApiValue(json['seniority'] as String),
      dailyStatsSummary: json['daily_stats_summary'] == null
          ? null
          : PersonDailyStatsSummary.fromJson(
              json['daily_stats_summary'] as Map<String, dynamic>,
            ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    teamId,
    birthDate,
    age,
    position,
    contractType,
    email,
    phone,
    admissionDate,
    seniority,
    dailyStatsSummary,
    createdAt,
    updatedAt,
  ];
}
