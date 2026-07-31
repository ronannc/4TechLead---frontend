import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/daily/utils/daily_time_limit.dart';

void main() {
  group('isValidDailyTimeLimit', () {
    test('accepts the minimum (60s) and multiples of 30s above it', () {
      expect(isValidDailyTimeLimit(60), isTrue);
      expect(isValidDailyTimeLimit(90), isTrue);
      expect(isValidDailyTimeLimit(120), isTrue);
    });

    test('rejects values below the minimum', () {
      expect(isValidDailyTimeLimit(59), isFalse);
      expect(isValidDailyTimeLimit(0), isFalse);
    });

    test('rejects values that are not a multiple of 30', () {
      expect(isValidDailyTimeLimit(61), isFalse);
      expect(isValidDailyTimeLimit(100), isFalse);
    });
  });

  group('formatDailyDuration', () {
    test('formats whole minutes', () {
      expect(formatDailyDuration(60), '01:00');
      expect(formatDailyDuration(90), '01:30');
    });

    test('formats seconds under a minute', () {
      expect(formatDailyDuration(5), '00:05');
    });

    test('formats negative durations (overtime) with a leading -', () {
      expect(formatDailyDuration(-5), '-00:05');
    });
  });
}
