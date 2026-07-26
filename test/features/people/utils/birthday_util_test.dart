import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/people/utils/birthday_util.dart';

void main() {
  group('daysUntilNextBirthday', () {
    test('returns 0 when the birthday is today', () {
      final now = DateTime(2026, 5, 10);
      final birthDate = DateTime(1990, 5, 10);

      expect(daysUntilNextBirthday(birthDate, now: now), 0);
    });

    test('returns 1 when the birthday is tomorrow', () {
      final now = DateTime(2026, 5, 9);
      final birthDate = DateTime(1990, 5, 10);

      expect(daysUntilNextBirthday(birthDate, now: now), 1);
    });

    test('rolls over to next year when the birthday already passed this year', () {
      final now = DateTime(2026, 5, 11);
      final birthDate = DateTime(1990, 5, 10);

      // 364, not 365 — no Feb 29 falls between 2026-05-11 and 2027-05-10.
      expect(daysUntilNextBirthday(birthDate, now: now), 364);
    });

    test('ignores the birth year and time-of-day, only month/day matter', () {
      final now = DateTime(2026, 1, 1, 23, 59);
      final birthDate = DateTime(2001, 1, 2, 3, 15);

      expect(daysUntilNextBirthday(birthDate, now: now), 1);
    });

    test('a Feb 29 birthday in a non-leap year rolls forward to Mar 1 (Dart DateTime behavior)', () {
      final now = DateTime(2027, 2, 1);
      final birthDate = DateTime(2000, 2, 29);

      // 2027 is not a leap year, so DateTime(2027, 2, 29) normalizes to Mar 1 —
      // this test documents that behavior rather than trying to correct it.
      expect(daysUntilNextBirthday(birthDate, now: now), 28);
    });
  });
}
