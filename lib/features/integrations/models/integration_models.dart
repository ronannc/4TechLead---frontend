import 'package:equatable/equatable.dart';

class IntegrationSystem extends Equatable {
  const IntegrationSystem({
    required this.id,
    required this.name,
    required this.provider,
    this.description,
    required this.tokenPrefix,
    this.webhookToken,
    required this.active,
    this.lastReceivedAt,
  });

  final int id;
  final String name;
  final String provider;
  final String? description;
  final String tokenPrefix;
  final String? webhookToken;
  final bool active;
  final DateTime? lastReceivedAt;

  factory IntegrationSystem.fromJson(Map<String, dynamic> json) {
    return IntegrationSystem(
      id: json['id'] as int,
      name: json['name'] as String,
      provider: json['provider'] as String,
      description: json['description'] as String?,
      tokenPrefix: json['token_prefix'] as String,
      webhookToken: json['webhook_token'] as String?,
      active: json['active'] as bool,
      lastReceivedAt: _date(json['last_received_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    provider,
    description,
    tokenPrefix,
    webhookToken,
    active,
    lastReceivedAt,
  ];
}

class PersonExternalIdentity extends Equatable {
  const PersonExternalIdentity({
    required this.id,
    required this.personId,
    required this.integrationSystemId,
    required this.externalCode,
    this.externalUsername,
    required this.active,
  });

  final int id;
  final int personId;
  final int integrationSystemId;
  final String externalCode;
  final String? externalUsername;
  final bool active;

  factory PersonExternalIdentity.fromJson(Map<String, dynamic> json) {
    return PersonExternalIdentity(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      integrationSystemId: json['integration_system_id'] as int,
      externalCode: json['external_code'] as String,
      externalUsername: json['external_username'] as String?,
      active: json['active'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    personId,
    integrationSystemId,
    externalCode,
    externalUsername,
    active,
  ];
}

class PersonDeliveryMetric extends Equatable {
  const PersonDeliveryMetric({
    required this.id,
    required this.personId,
    this.integrationSystemId,
    required this.metricType,
    required this.metricValue,
    this.unit,
    this.sourceRef,
    this.occurredAt,
  });

  final int id;
  final int personId;
  final int? integrationSystemId;
  final String metricType;
  final num metricValue;
  final String? unit;
  final String? sourceRef;
  final DateTime? occurredAt;

  factory PersonDeliveryMetric.fromJson(Map<String, dynamic> json) {
    return PersonDeliveryMetric(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      integrationSystemId: json['integration_system_id'] as int?,
      metricType: json['metric_type'] as String,
      metricValue: num.parse(json['metric_value'].toString()),
      unit: json['unit'] as String?,
      sourceRef: json['source_ref'] as String?,
      occurredAt: _date(json['occurred_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    personId,
    integrationSystemId,
    metricType,
    metricValue,
    unit,
    sourceRef,
    occurredAt,
  ];
}

DateTime? _date(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}
