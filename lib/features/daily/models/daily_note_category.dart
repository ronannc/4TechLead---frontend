/// Mirrors the backend's `App\Enums\DailyNoteType` — `apiValue` is the wire
/// value exchanged with the API, `label` is the Portuguese display text.
enum DailyNoteCategory {
  impediment('impedimento', 'Impedimento'),
  alignment('alinhamento', 'Alinhamento'),
  event('acontecimento', 'Acontecimento');

  const DailyNoteCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;

  factory DailyNoteCategory.fromApiValue(String value) {
    return DailyNoteCategory.values.firstWhere(
      (category) => category.apiValue == value,
    );
  }
}
