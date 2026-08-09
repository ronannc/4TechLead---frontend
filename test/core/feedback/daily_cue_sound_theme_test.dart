import 'package:flutter_test/flutter_test.dart';
import 'package:for_tech_lead/core/feedback/daily_cue_sound_theme.dart';
import 'package:for_tech_lead/features/daily/models/daily_cue.dart';

void main() {
  test('defines one sound profile per daily cue', () {
    expect(DailyCueSoundTheme.byCue.keys, containsAll(DailyCue.values));
    expect(DailyCueSoundTheme.byCue.length, DailyCue.values.length);
  });

  test('uses a distinct cue for advancing to the next speaker', () {
    final startSound = DailyCueSoundTheme.byCue[DailyCue.turnStarted];
    final advancedSound = DailyCueSoundTheme.byCue[DailyCue.turnAdvanced];

    expect(startSound, isNotNull);
    expect(advancedSound, isNotNull);
    expect(advancedSound!.assetPath, isNot(startSound!.assetPath));
  });

  test('keeps the ticking layer much quieter than the main cues', () {
    expect(DailyCueSoundTheme.ticking.volume, lessThan(0.05));

    for (final sound in DailyCueSoundTheme.byCue.values) {
      expect(sound.volume, inInclusiveRange(0.0, 1.0));
      expect(sound.volume, greaterThan(DailyCueSoundTheme.ticking.volume));
    }
  });
}
