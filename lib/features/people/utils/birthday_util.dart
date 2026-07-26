/// Days remaining until [birthDate]'s next anniversary, relative to [now]
/// (defaults to `DateTime.now()`). `0` means the birthday is today.
///
/// A Feb 29 birthday in a non-leap `now.year` rolls forward to Mar 1 —
/// `DateTime` doesn't throw on that construction, it just normalizes the
/// date, so no special-casing is done here.
int daysUntilNextBirthday(DateTime birthDate, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());

  var next = DateTime(today.year, birthDate.month, birthDate.day);
  if (next.isBefore(today)) {
    next = DateTime(today.year + 1, birthDate.month, birthDate.day);
  }

  return next.difference(today).inDays;
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
