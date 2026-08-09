enum DailyAnnotationType {
  topic('topico', 'Tópico levantado'),
  blocker('bloqueio', 'Bloqueio');

  const DailyAnnotationType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  factory DailyAnnotationType.fromApiValue(String value) {
    return DailyAnnotationType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => throw ArgumentError.value(value, 'value'),
    );
  }
}
