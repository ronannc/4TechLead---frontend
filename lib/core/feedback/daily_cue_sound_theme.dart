import '../../features/daily/models/daily_cue.dart';

class DailyCueSound {
  const DailyCueSound({required this.assetPath, required this.volume});

  final String assetPath;
  final double volume;
}

class DailyCueSoundTheme {
  const DailyCueSoundTheme._();

  static const ticking = DailyCueSound(
    assetPath: 'sounds/ticking_clock.wav',
    volume: 0.035,
  );

  static const byCue = <DailyCue, DailyCueSound>{
    DailyCue.turnStarted: DailyCueSound(
      assetPath: 'sounds/start_bell.wav',
      volume: 0.72,
    ),
    DailyCue.turnAdvanced: DailyCueSound(
      assetPath: 'sounds/turn_pass.wav',
      volume: 0.64,
    ),
    DailyCue.aboutToBurn: DailyCueSound(
      assetPath: 'sounds/attention_warning.wav',
      volume: 0.58,
    ),
    DailyCue.burned: DailyCueSound(
      assetPath: 'sounds/time_limit.wav',
      volume: 0.76,
    ),
    DailyCue.sessionFinished: DailyCueSound(
      assetPath: 'sounds/final_whistle.wav',
      volume: 0.74,
    ),
  };
}
