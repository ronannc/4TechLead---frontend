import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/daily/models/daily_cue.dart';
import 'daily_cue_sound_theme.dart';

/// Plays the sound + haptic feedback for a [DailyCue] during a live Daily
/// session. Cross-cutting infrastructure (same tier as `AuthSession`/
/// `DioClient`), not a `services/` HTTP client — consumed by the Screen,
/// never injected into a ViewModel, so the ViewModel stays testable without
/// an audio plugin.
///
/// Failures (missing platform support, no audio backend on a bare test
/// environment, etc.) are swallowed — a broken sound/haptic must never
/// crash or block the live session, since the visual countdown is always
/// the primary feedback channel.
class DailyCuePlayer {
  DailyCuePlayer() : _cuePlayer = AudioPlayer(), _tickPlayer = AudioPlayer();

  final AudioPlayer _cuePlayer;
  final AudioPlayer _tickPlayer;
  bool _isTicking = false;

  static const _hapticByCue = {
    DailyCue.turnStarted: HapticFeedback.lightImpact,
    DailyCue.turnAdvanced: HapticFeedback.lightImpact,
    DailyCue.aboutToBurn: HapticFeedback.mediumImpact,
    DailyCue.burned: HapticFeedback.heavyImpact,
    DailyCue.sessionFinished: HapticFeedback.heavyImpact,
  };

  Future<void> startTicking() async {
    if (_isTicking) {
      return;
    }

    _isTicking = true;

    try {
      await _tickPlayer.setReleaseMode(ReleaseMode.loop);
      await _tickPlayer.play(
        AssetSource(DailyCueSoundTheme.ticking.assetPath),
        volume: DailyCueSoundTheme.ticking.volume,
      );
    } catch (error) {
      _isTicking = false;
      if (kDebugMode) {
        debugPrint('[DailyCuePlayer] Falha no tic-tac da daily: $error');
      }
    }
  }

  Future<void> stopTicking() async {
    if (!_isTicking) {
      return;
    }

    _isTicking = false;

    try {
      await _tickPlayer.stop();
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[DailyCuePlayer] Falha ao parar tic-tac da daily: $error');
      }
    }
  }

  Future<void> play(DailyCue cue) async {
    final sound = DailyCueSoundTheme.byCue[cue];
    if (sound == null) {
      return;
    }

    try {
      await _hapticByCue[cue]?.call();
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[DailyCuePlayer] Falha no feedback tátil para $cue: $error',
        );
      }
      // Haptics unsupported on this platform — ignore.
    }

    try {
      await _cuePlayer.play(AssetSource(sound.assetPath), volume: sound.volume);
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[DailyCuePlayer] Falha no áudio para $cue (${sound.assetPath}): $error',
        );
      }
      // Audio backend unavailable (e.g. missing GStreamer on Linux, no
      // audio device in a test/CI environment) — visual feedback carries on.
    }
  }

  Future<void> dispose() async {
    await _tickPlayer.dispose();
    await _cuePlayer.dispose();
  }
}
