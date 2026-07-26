/// Mirrors the backend's `App\Enums\ContractType` — `apiValue` is the wire
/// value exchanged with the API, `label` is the Portuguese display text.
enum ContractType {
  clt('clt', 'CLT'),
  pj('pj', 'PJ'),
  hourly('horista', 'Horista'),
  cooperative('cooperado', 'Cooperado');

  const ContractType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  factory ContractType.fromApiValue(String value) {
    return ContractType.values.firstWhere((type) => type.apiValue == value);
  }
}
