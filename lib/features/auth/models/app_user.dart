import 'package:equatable/equatable.dart';

/// Mirrors the backend's `UserResource` (`id, name, email, created_at`).
class AppUser extends Equatable {
  const AppUser({required this.id, required this.name, required this.email, required this.createdAt});

  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'created_at': createdAt.toIso8601String()};
  }

  @override
  List<Object?> get props => [id, name, email, createdAt];
}
