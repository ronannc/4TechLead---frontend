import 'package:equatable/equatable.dart';

import 'contract_type.dart';
import 'seniority_level.dart';

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
    createdAt,
    updatedAt,
  ];
}
