import 'package:equatable/equatable.dart';

/// Mirrors the backend's `UserResource` (`id, name, email, created_at`).
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.personId,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final int? personId;
  final DateTime createdAt;

  bool get isTechLead => role == 'tech_lead';
  bool get isMember => role == 'member';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'member',
      personId: json['person_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'person_id': personId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, email, role, personId, createdAt];
}
