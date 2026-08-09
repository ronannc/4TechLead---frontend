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
    required this.active,
  });

  final int id;
  final int personId;
  final int integrationSystemId;
  final String externalCode;
  final bool active;

  factory PersonExternalIdentity.fromJson(Map<String, dynamic> json) {
    return PersonExternalIdentity(
      id: json['id'] as int,
      personId: json['person_id'] as int,
      integrationSystemId: json['integration_system_id'] as int,
      externalCode: json['external_code'] as String,
      active: json['active'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    personId,
    integrationSystemId,
    externalCode,
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
    this.metadata,
  });

  final int id;
  final int personId;
  final int? integrationSystemId;
  final String metricType;
  final num metricValue;
  final String? unit;
  final String? sourceRef;
  final DateTime? occurredAt;
  final Map<String, dynamic>? metadata;

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
      metadata: json['metadata'] as Map<String, dynamic>?,
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
    metadata,
  ];
}

class DeliveryMetricsPage extends Equatable {
  const DeliveryMetricsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<PersonDeliveryMetric> items;
  final int currentPage;
  final int lastPage;
  final int total;

  factory DeliveryMetricsPage.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>?;

    return DeliveryMetricsPage(
      items: [
        for (final item in json['data'] as List<dynamic>)
          PersonDeliveryMetric.fromJson(item as Map<String, dynamic>),
      ],
      currentPage: _int(meta?['current_page']) ?? 1,
      lastPage: _int(meta?['last_page']) ?? 1,
      total: _int(meta?['total']) ?? (json['data'] as List<dynamic>).length,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}

DateTime? _date(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}

int? _int(Object? value) {
  if (value is int) {
    return value;
  }

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}
