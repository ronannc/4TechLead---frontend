import 'package:equatable/equatable.dart';

import '../../people/models/person.dart';

/// Mirrors the backend's `TeamResource` (`id, name, created_at, updated_at`).
class Team extends Equatable {
  const Team({
    required this.id,
    required this.name,
    this.people = const [],
    this.peoplePage = 1,
    this.peopleLastPage = 1,
    this.peoplePerPage = 15,
    this.peopleTotal = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final List<Person> people;
  final int peoplePage;
  final int peopleLastPage;
  final int peoplePerPage;
  final int peopleTotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Team.fromJson(Map<String, dynamic> json) {
    final peopleMeta = json['people_meta'] as Map<String, dynamic>?;

    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      people: json['people'] == null
          ? const []
          : [
              for (final item in json['people'] as List<dynamic>)
                Person.fromJson(item as Map<String, dynamic>),
            ],
      peoplePage: peopleMeta?['current_page'] as int? ?? 1,
      peopleLastPage: peopleMeta?['last_page'] as int? ?? 1,
      peoplePerPage: peopleMeta?['per_page'] as int? ?? 15,
      peopleTotal: peopleMeta?['total'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'people': [for (final person in people) person.toJson()],
      'people_meta': {
        'current_page': peoplePage,
        'last_page': peopleLastPage,
        'per_page': peoplePerPage,
        'total': peopleTotal,
      },
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    people,
    peoplePage,
    peopleLastPage,
    peoplePerPage,
    peopleTotal,
    createdAt,
    updatedAt,
  ];
}
