// ignore_for_file: avoid_print
//
// Generates the WAV cues used by the Daily feature. The sounds are synthesized
// locally, so there are no external audio assets or licensing concerns.
//
// Run with: dart run tool/generate_daily_sounds.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const int _sampleRate = 44100;

void main() {
  final outDir = Directory('assets/sounds')..createSync(recursive: true);

  _writeWav(
    '${outDir.path}/start_bell.wav',
    _normalize(
      _mix([
        _decayTone(frequencyHz: 740, durationSeconds: 0.78, decay: 4.2),
        _decayTone(
          frequencyHz: 1110,
          durationSeconds: 0.78,
          decay: 5.4,
          gain: 0.58,
        ),
        _decayTone(
          frequencyHz: 1480,
          durationSeconds: 0.52,
          decay: 7.0,
          gain: 0.34,
        ),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/ticking_clock.wav',
    _concat([
      _tick(frequencyHz: 1900, durationSeconds: 0.035),
      _silence(0.465),
      _tick(frequencyHz: 1320, durationSeconds: 0.042, gain: 0.78),
      _silence(0.458),
    ]),
  );

  _writeWav(
    '${outDir.path}/attention_warning.wav',
    _concat([
      _beep(frequencyHz: 880, durationSeconds: 0.12),
      _silence(0.06),
      _beep(frequencyHz: 1040, durationSeconds: 0.12),
      _silence(0.06),
      _beep(frequencyHz: 880, durationSeconds: 0.12),
    ]),
  );

  _writeWav(
    '${outDir.path}/time_limit.wav',
    _normalize(
      _concat([
        _beep(frequencyHz: 360, durationSeconds: 0.16, gain: 0.82),
        _silence(0.045),
        _beep(frequencyHz: 300, durationSeconds: 0.22, gain: 0.96),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/final_whistle.wav',
    _normalize(
      _concat([
        _whistle(frequencyHz: 1680, durationSeconds: 0.28),
        _silence(0.05),
        _whistle(frequencyHz: 1480, durationSeconds: 0.38, gain: 0.86),
      ]),
    ),
  );

  print('Generated Daily sound cues in ${outDir.path}');
}

Int16List _beep({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.72,
}) {
  return _tone(
    frequencyHz: frequencyHz,
    durationSeconds: durationSeconds,
    gain: gain,
    attackSeconds: 0.006,
    releaseSeconds: 0.025,
  );
}

Int16List _tick({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.62,
}) {
  final tone = _tone(
    frequencyHz: frequencyHz,
    durationSeconds: durationSeconds,
    gain: gain,
    attackSeconds: 0.0015,
    releaseSeconds: durationSeconds * 0.82,
  );
  final click = _noise(durationSeconds: 0.01, gain: gain * 0.32);

  return _mix([tone, click]);
}

Int16List _whistle({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.78,
}) {
  final base = _tone(
    frequencyHz: frequencyHz,
    durationSeconds: durationSeconds,
    gain: gain,
    attackSeconds: 0.018,
    releaseSeconds: 0.08,
    vibratoHz: 7.0,
    vibratoDepthHz: 16.0,
  );
  final harmonic = _tone(
    frequencyHz: frequencyHz * 2.0,
    durationSeconds: durationSeconds,
    gain: gain * 0.18,
    attackSeconds: 0.018,
    releaseSeconds: 0.08,
    vibratoHz: 7.0,
    vibratoDepthHz: 20.0,
  );

  return _mix([base, harmonic]);
}

Int16List _decayTone({
  required double frequencyHz,
  required double durationSeconds,
  required double decay,
  double gain = 0.72,
}) {
  final sampleCount = (_sampleRate * durationSeconds).round();
  final samples = Int16List(sampleCount);

  for (var i = 0; i < sampleCount; i++) {
    final t = i / _sampleRate;
    final attack = (t / 0.012).clamp(0.0, 1.0);
    final amp = math.exp(-decay * t) * attack;
    final value = math.sin(2 * math.pi * frequencyHz * t) * amp * gain;
    samples[i] = (value * 32767).round().clamp(-32768, 32767);
  }

  return samples;
}

Int16List _tone({
  required double frequencyHz,
  required double durationSeconds,
  required double gain,
  required double attackSeconds,
  required double releaseSeconds,
  double vibratoHz = 0,
  double vibratoDepthHz = 0,
}) {
  final sampleCount = (_sampleRate * durationSeconds).round();
  final samples = Int16List(sampleCount);
  var phase = 0.0;

  for (var i = 0; i < sampleCount; i++) {
    final t = i / _sampleRate;
    final attack = attackSeconds <= 0
        ? 1.0
        : (t / attackSeconds).clamp(0.0, 1.0);
    final releaseStart = durationSeconds - releaseSeconds;
    final release = releaseSeconds <= 0 || t < releaseStart
        ? 1.0
        : ((durationSeconds - t) / releaseSeconds).clamp(0.0, 1.0);
    final vibrato = vibratoDepthHz == 0
        ? 0.0
        : math.sin(2 * math.pi * vibratoHz * t) * vibratoDepthHz;

    phase += 2 * math.pi * (frequencyHz + vibrato) / _sampleRate;
    final value = math.sin(phase) * attack * release * gain;
    samples[i] = (value * 32767).round().clamp(-32768, 32767);
  }

  return samples;
}

Int16List _noise({required double durationSeconds, required double gain}) {
  final sampleCount = (_sampleRate * durationSeconds).round();
  final samples = Int16List(sampleCount);
  var seed = 123456789;

  for (var i = 0; i < sampleCount; i++) {
    seed = (1103515245 * seed + 12345) & 0x7fffffff;
    final t = i / _sampleRate;
    final envelope = ((durationSeconds - t) / durationSeconds).clamp(0.0, 1.0);
    final random = (seed / 0x7fffffff) * 2 - 1;
    samples[i] = (random * envelope * gain * 32767).round().clamp(
      -32768,
      32767,
    );
  }

  return samples;
}

Int16List _silence(double durationSeconds) =>
    Int16List((_sampleRate * durationSeconds).round());

Int16List _concat(List<Int16List> parts) {
  final total = parts.fold<int>(0, (sum, part) => sum + part.length);
  final result = Int16List(total);
  var offset = 0;

  for (final part in parts) {
    result.setRange(offset, offset + part.length, part);
    offset += part.length;
  }

  return result;
}

Int16List _mix(List<Int16List> parts) {
  final length = parts.fold<int>(0, (max, part) => math.max(max, part.length));
  final mixed = Float64List(length);

  for (final part in parts) {
    for (var i = 0; i < part.length; i++) {
      mixed[i] += part[i] / 32767;
    }
  }

  final result = Int16List(length);
  for (var i = 0; i < length; i++) {
    result[i] = (mixed[i].clamp(-1.0, 1.0) * 32767).round();
  }

  return result;
}

Int16List _normalize(Int16List samples) {
  var peak = 1;
  for (final sample in samples) {
    peak = math.max(peak, sample.abs());
  }

  final gain = 32767 / peak * 0.92;
  final result = Int16List(samples.length);
  for (var i = 0; i < samples.length; i++) {
    result[i] = (samples[i] * gain).round().clamp(-32768, 32767);
  }

  return result;
}

void _writeWav(String path, Int16List samples) {
  const channels = 1;
  const bitsPerSample = 16;
  final byteRate = _sampleRate * channels * bitsPerSample ~/ 8;
  final blockAlign = channels * bitsPerSample ~/ 8;
  final dataSize = samples.lengthInBytes;

  final header = BytesBuilder()
    ..add('RIFF'.codeUnits)
    ..add(_uint32(36 + dataSize))
    ..add('WAVE'.codeUnits)
    ..add('fmt '.codeUnits)
    ..add(_uint32(16))
    ..add(_uint16(1))
    ..add(_uint16(channels))
    ..add(_uint32(_sampleRate))
    ..add(_uint32(byteRate))
    ..add(_uint16(blockAlign))
    ..add(_uint16(bitsPerSample))
    ..add('data'.codeUnits)
    ..add(_uint32(dataSize));

  File(path).openSync(mode: FileMode.write)
    ..writeFromSync(header.toBytes())
    ..writeFromSync(samples.buffer.asUint8List())
    ..closeSync();
}

Uint8List _uint32(int value) =>
    Uint8List(4)..buffer.asByteData().setUint32(0, value, Endian.little);

Uint8List _uint16(int value) =>
    Uint8List(2)..buffer.asByteData().setUint16(0, value, Endian.little);
