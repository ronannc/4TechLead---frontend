import 'package:equatable/equatable.dart';

/// Mirrors the backend's `TeamResource` (`id, name, created_at, updated_at`).
class Team extends Equatable {
  const Team({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];
}
