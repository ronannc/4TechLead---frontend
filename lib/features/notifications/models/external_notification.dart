import 'package:equatable/equatable.dart';

class ExternalNotification extends Equatable {
  const ExternalNotification({
    required this.id,
    required this.integrationSystemId,
    this.integrationSystem,
    this.eventId,
    required this.title,
    required this.message,
    required this.source,
    this.type,
    required this.severity,
    this.sourceRef,
    this.payload,
    this.metadata,
    this.receivedAt,
    this.createdAt,
  });

  final int id;
  final int integrationSystemId;
  final NotificationIntegrationSystem? integrationSystem;
  final String? eventId;
  final String title;
  final String message;
  final String source;
  final String? type;
  final String severity;
  final String? sourceRef;
  final Map<String, dynamic>? payload;
  final Map<String, dynamic>? metadata;
  final DateTime? receivedAt;
  final DateTime? createdAt;

  factory ExternalNotification.fromJson(Map<String, dynamic> json) {
    final system = json['integration_system'];

    return ExternalNotification(
      id: _int(json['id']) ?? 0,
      integrationSystemId: _int(json['integration_system_id']) ?? 0,
      integrationSystem: system is Map<String, dynamic>
          ? NotificationIntegrationSystem.fromJson(system)
          : null,
      eventId: _text(json['event_id']),
      title: _text(json['title']) ?? 'Notificação externa',
      message: _text(json['message']) ?? '',
      source:
          _text(json['source']) ??
          _text(json['provider']) ??
          _nestedName(system) ??
          'Sistema externo',
      type: _text(json['type']),
      severity: _text(json['severity']) ?? 'info',
      sourceRef: _text(json['source_ref']),
      payload: _map(json['payload']),
      metadata: _map(json['metadata']),
      receivedAt: _date(json['received_at'] ?? json['created_at']),
      createdAt: _date(json['created_at']),
    );
  }

  Map<String, dynamic>? get detailsPayload => payload ?? metadata;

  DateTime? get displayDate => receivedAt ?? createdAt;

  @override
  List<Object?> get props => [
    id,
    integrationSystemId,
    integrationSystem,
    eventId,
    title,
    message,
    source,
    type,
    severity,
    sourceRef,
    payload,
    metadata,
    receivedAt,
    createdAt,
  ];
}

class NotificationIntegrationSystem extends Equatable {
  const NotificationIntegrationSystem({
    required this.id,
    required this.name,
    required this.provider,
  });

  final int id;
  final String name;
  final String provider;

  factory NotificationIntegrationSystem.fromJson(Map<String, dynamic> json) {
    return NotificationIntegrationSystem(
      id: _int(json['id']) ?? 0,
      name: _text(json['name']) ?? 'Integração',
      provider: _text(json['provider']) ?? 'custom',
    );
  }

  @override
  List<Object?> get props => [id, name, provider];
}

class NotificationsPage extends Equatable {
  const NotificationsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<ExternalNotification> items;
  final int currentPage;
  final int lastPage;
  final int total;

  factory NotificationsPage.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    final meta = json['meta'] as Map<String, dynamic>?;

    return NotificationsPage(
      items: [
        for (final item in data)
          ExternalNotification.fromJson(item as Map<String, dynamic>),
      ],
      currentPage: _int(meta?['current_page']) ?? 1,
      lastPage: _int(meta?['last_page']) ?? 1,
      total: _int(meta?['total']) ?? data.length,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}

DateTime? _date(Object? value) {
  final text = _text(value);
  return text == null ? null : DateTime.tryParse(text);
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

String? _text(Object? value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

String? _nestedName(Object? value) {
  if (value is Map<String, dynamic>) {
    return _text(value['name']);
  }

  return null;
}

Map<String, dynamic>? _map(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  return null;
}
