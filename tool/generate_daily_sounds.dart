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
      _concat([
        _ceramicChime(frequencyHz: 660, durationSeconds: 0.42, gain: 0.82),
        _silence(0.035),
        _ceramicChime(frequencyHz: 990, durationSeconds: 0.56, gain: 0.58),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/ticking_clock.wav',
    _concat([
      _tick(frequencyHz: 1480, durationSeconds: 0.02, gain: 0.28),
      _silence(0.48),
      _tick(frequencyHz: 1080, durationSeconds: 0.024, gain: 0.22),
      _silence(0.476),
    ]),
  );

  _writeWav(
    '${outDir.path}/turn_pass.wav',
    _normalize(
      _concat([
        _woodTap(frequencyHz: 460, durationSeconds: 0.07, gain: 0.74),
        _silence(0.055),
        _woodTap(frequencyHz: 620, durationSeconds: 0.065, gain: 0.56),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/attention_warning.wav',
    _normalize(
      _concat([
        _woodTap(frequencyHz: 700, durationSeconds: 0.05, gain: 0.5),
        _silence(0.07),
        _woodTap(frequencyHz: 860, durationSeconds: 0.05, gain: 0.58),
        _silence(0.07),
        _woodTap(frequencyHz: 1020, durationSeconds: 0.055, gain: 0.66),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/time_limit.wav',
    _normalize(
      _concat([
        _bowlStrike(frequencyHz: 320, durationSeconds: 0.28, gain: 0.88),
        _silence(0.06),
        _bowlStrike(frequencyHz: 240, durationSeconds: 0.42, gain: 0.98),
      ]),
    ),
  );

  _writeWav(
    '${outDir.path}/final_whistle.wav',
    _normalize(
      _concat([
        _ceramicChime(frequencyHz: 880, durationSeconds: 0.46, gain: 0.78),
        _silence(0.05),
        _ceramicChime(frequencyHz: 660, durationSeconds: 0.74, gain: 0.92),
      ]),
    ),
  );

  print('Generated Daily sound cues in ${outDir.path}');
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

Int16List _woodTap({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.7,
}) {
  final body = _decayTone(
    frequencyHz: frequencyHz,
    durationSeconds: durationSeconds,
    decay: 34,
    gain: gain,
  );
  final overtone = _decayTone(
    frequencyHz: frequencyHz * 1.8,
    durationSeconds: durationSeconds * 0.72,
    decay: 42,
    gain: gain * 0.34,
  );
  final transient = _noise(durationSeconds: 0.008, gain: gain * 0.18);

  return _mix([body, overtone, transient]);
}

Int16List _ceramicChime({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.78,
}) {
  return _mix([
    _decayTone(
      frequencyHz: frequencyHz,
      durationSeconds: durationSeconds,
      decay: 5.0,
      gain: gain,
    ),
    _decayTone(
      frequencyHz: frequencyHz * 1.5,
      durationSeconds: durationSeconds * 0.88,
      decay: 6.4,
      gain: gain * 0.42,
    ),
    _decayTone(
      frequencyHz: frequencyHz * 2.08,
      durationSeconds: durationSeconds * 0.68,
      decay: 8.2,
      gain: gain * 0.22,
    ),
  ]);
}

Int16List _bowlStrike({
  required double frequencyHz,
  required double durationSeconds,
  double gain = 0.86,
}) {
  final fundamental = _decayTone(
    frequencyHz: frequencyHz,
    durationSeconds: durationSeconds,
    decay: 4.8,
    gain: gain,
  );
  final harmonic = _decayTone(
    frequencyHz: frequencyHz * 2.4,
    durationSeconds: durationSeconds * 0.78,
    decay: 6.0,
    gain: gain * 0.22,
  );
  final breath = _noise(durationSeconds: 0.012, gain: gain * 0.08);

  return _mix([fundamental, harmonic, breath]);
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
