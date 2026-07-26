/// Mirrors the backend's `App\Enums\SeniorityLevel` — `apiValue` is the wire
/// value exchanged with the API, `label` is the Portuguese display text.
enum SeniorityLevel {
  intern('estagiario', 'Estagiário'),
  junior('junior', 'Júnior'),
  mid('pleno', 'Pleno'),
  senior('senior', 'Sênior'),
  specialist('especialista', 'Especialista');

  const SeniorityLevel(this.apiValue, this.label);

  final String apiValue;
  final String label;

  factory SeniorityLevel.fromApiValue(String value) {
    return SeniorityLevel.values.firstWhere((level) => level.apiValue == value);
  }
}
