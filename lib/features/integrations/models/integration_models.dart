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

class IntegrationWebhookEvent extends Equatable {
  const IntegrationWebhookEvent({
    required this.id,
    required this.integrationSystemId,
    this.personId,
    required this.eventId,
    required this.eventType,
    this.externalActorCode,
    required this.status,
    this.failureReason,
    required this.payload,
    this.payloadHash,
    this.payloadSizeBytes,
    this.normalizedPayload,
    this.deliveryMetricsCount,
    this.deliveryMetrics = const [],
    this.receivedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int integrationSystemId;
  final int? personId;
  final String eventId;
  final String eventType;
  final String? externalActorCode;
  final String status;
  final String? failureReason;
  final Map<String, dynamic> payload;
  final String? payloadHash;
  final int? payloadSizeBytes;
  final Map<String, dynamic>? normalizedPayload;
  final int? deliveryMetricsCount;
  final List<PersonDeliveryMetric> deliveryMetrics;
  final DateTime? receivedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory IntegrationWebhookEvent.fromJson(Map<String, dynamic> json) {
    return IntegrationWebhookEvent(
      id: json['id'] as int,
      integrationSystemId: json['integration_system_id'] as int,
      personId: json['person_id'] as int?,
      eventId: json['event_id'] as String,
      eventType: json['event_type'] as String,
      externalActorCode: json['external_actor_code'] as String?,
      status: json['status'] as String,
      failureReason: json['failure_reason'] as String?,
      payload: (json['payload'] as Map<String, dynamic>?) ?? const {},
      payloadHash: json['payload_hash'] as String?,
      payloadSizeBytes: _int(json['payload_size_bytes']),
      normalizedPayload: json['normalized_payload'] as Map<String, dynamic>?,
      deliveryMetricsCount: _int(json['delivery_metrics_count']),
      deliveryMetrics: [
        for (final item in (json['delivery_metrics'] as List<dynamic>? ?? []))
          PersonDeliveryMetric.fromJson(item as Map<String, dynamic>),
      ],
      receivedAt: _date(json['received_at']),
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    integrationSystemId,
    personId,
    eventId,
    eventType,
    externalActorCode,
    status,
    failureReason,
    payload,
    payloadHash,
    payloadSizeBytes,
    normalizedPayload,
    deliveryMetricsCount,
    deliveryMetrics,
    receivedAt,
    createdAt,
    updatedAt,
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

class WebhookEventsPage extends Equatable {
  const WebhookEventsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<IntegrationWebhookEvent> items;
  final int currentPage;
  final int lastPage;
  final int total;

  factory WebhookEventsPage.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>?;

    return WebhookEventsPage(
      items: [
        for (final item in json['data'] as List<dynamic>)
          IntegrationWebhookEvent.fromJson(item as Map<String, dynamic>),
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
