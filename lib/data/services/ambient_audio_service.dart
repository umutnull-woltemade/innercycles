// ════════════════════════════════════════════════════════════════════════════
// AMBIENT AUDIO SERVICE - Procedural ambient sounds for breathing/meditation
// ════════════════════════════════════════════════════════════════════════════
// Generates loopable ambient audio (WAV) in pure Dart: drone, rain, binaural.
// Uses just_audio for playback with seamless looping.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/app_providers.dart';

enum AmbientSound {
  none,
  gentleDrone,
  softRain,
  binauralCalm;

  String nameEn() {
    switch (this) {
      case AmbientSound.none:
        return 'Off';
      case AmbientSound.gentleDrone:
        return 'Drone';
      case AmbientSound.softRain:
        return 'Rain';
      case AmbientSound.binauralCalm:
        return 'Binaural';
    }
  }

  String nameTr() {
    switch (this) {
      case AmbientSound.none:
        return 'Kapalı';
      case AmbientSound.gentleDrone:
        return 'Drone';
      case AmbientSound.softRain:
        return 'Yağmur';
      case AmbientSound.binauralCalm:
        return 'Binaural';
    }
  }

  String localizedName(AppLanguage language) =>
      language == AppLanguage.en ? nameEn() : nameTr();

  IconData get icon {
    switch (this) {
      case AmbientSound.none:
        return Icons.volume_off_rounded;
      case AmbientSound.gentleDrone:
        return Icons.music_note_rounded;
      case AmbientSound.softRain:
        return Icons.water_drop_rounded;
      case AmbientSound.binauralCalm:
        return Icons.headphones_rounded;
    }
  }
}

class AmbientAudioService {
  AmbientAudioService._();
  static final AmbientAudioService instance = AmbientAudioService._();

  AudioPlayer? _player;
  AmbientSound _currentSound = AmbientSound.none;
  double _volume = 0.3;

  AmbientSound get currentSound => _currentSound;
  double get volume => _volume;

  Future<void> play(AmbientSound sound) async {
    await stop();
    if (sound == AmbientSound.none) return;

    _currentSound = sound;
    _player = AudioPlayer();

    final bytes = _generateAudio(sound);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/ambient_${sound.name}.wav');
    await file.writeAsBytes(bytes);

    await _player!.setFilePath(file.path);
    await _player!.setLoopMode(LoopMode.one);
    await _player!.setVolume(_volume);
    await _player!.play();
  }

  Future<void> stop() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
    _currentSound = AmbientSound.none;
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    _player?.setVolume(_volume);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // AUDIO GENERATION
  // ══════════════════════════════════════════════════════════════════════════

  Uint8List _generateAudio(AmbientSound sound) {
    const sampleRate = 44100;
    const duration = 10; // seconds
    const numSamples = sampleRate * duration;

    // Stereo samples (interleaved L, R)
    final samples = Float64List(numSamples * 2);

    switch (sound) {
      case AmbientSound.gentleDrone:
        _generateDrone(samples, sampleRate, numSamples);
      case AmbientSound.softRain:
        _generateRain(samples, sampleRate, numSamples);
      case AmbientSound.binauralCalm:
        _generateBinaural(samples, sampleRate, numSamples);
      case AmbientSound.none:
        break;
    }

    return _encodeWav(samples, sampleRate, 2);
  }

  /// Warm pad: A2 root + E3 fifth + A3 octave with gentle vibrato
  void _generateDrone(Float64List samples, int sr, int n) {
    const baseFreq = 110.0; // A2
    for (int i = 0; i < n; i++) {
      final t = i / sr;
      final vibrato = sin(2 * pi * 0.3 * t) * 0.5;
      final s1 = sin(2 * pi * (baseFreq + vibrato) * t) * 0.25;
      final s2 = sin(2 * pi * (baseFreq * 1.5 + vibrato * 0.7) * t) * 0.18;
      final s3 = sin(2 * pi * (baseFreq * 2.0 + vibrato * 0.3) * t) * 0.12;
      final s4 = sin(2 * pi * (baseFreq * 3.0) * t) * 0.04;

      // Crossfade envelope for seamless loop
      double env = 1.0;
      const fadeLen = 0.5;
      if (t < fadeLen) env = t / fadeLen;
      if (t > (n / sr) - fadeLen) env = ((n / sr) - t) / fadeLen;

      final sample = (s1 + s2 + s3 + s4) * env;
      samples[i * 2] = sample;
      samples[i * 2 + 1] = sample;
    }
  }

  /// Brown noise with gentle amplitude variation (sounds like soft rain/wind)
  void _generateRain(Float64List samples, int sr, int n) {
    final rng = Random(42);
    double prev = 0;
    for (int i = 0; i < n; i++) {
      final t = i / sr;
      final raw = rng.nextDouble() * 2.0 - 1.0;
      prev = (prev + raw * 0.02) * 0.98;

      // Slow amplitude variation for organic feel
      final ampMod = 0.8 + 0.2 * sin(2 * pi * 0.15 * t);
      final sample = prev * 0.4 * ampMod;

      // Crossfade envelope
      double env = 1.0;
      const fadeSamples = 22050; // 0.5s
      if (i < fadeSamples) env = i / fadeSamples;
      if (i > n - fadeSamples) env = (n - i) / fadeSamples;

      samples[i * 2] = sample * env;
      samples[i * 2 + 1] = sample * env;
    }
  }

  /// Binaural beats: 200 Hz left, 210 Hz right = 10 Hz alpha wave
  void _generateBinaural(Float64List samples, int sr, int n) {
    for (int i = 0; i < n; i++) {
      final t = i / sr;
      final left = sin(2 * pi * 200.0 * t) * 0.25;
      final right = sin(2 * pi * 210.0 * t) * 0.25;

      double env = 1.0;
      const fadeLen = 0.5;
      if (t < fadeLen) env = t / fadeLen;
      if (t > (n / sr) - fadeLen) env = ((n / sr) - t) / fadeLen;

      samples[i * 2] = left * env;
      samples[i * 2 + 1] = right * env;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WAV ENCODER
  // ══════════════════════════════════════════════════════════════════════════

  Uint8List _encodeWav(Float64List samples, int sampleRate, int channels) {
    final numFrames = samples.length ~/ channels;
    final dataSize = numFrames * channels * 2; // 16-bit PCM
    final fileSize = 44 + dataSize;

    final bytes = ByteData(fileSize);
    var o = 0;

    // RIFF header
    void writeStr(String s) {
      for (var c in s.codeUnits) {
        bytes.setUint8(o++, c);
      }
    }

    writeStr('RIFF');
    bytes.setUint32(o, fileSize - 8, Endian.little);
    o += 4;
    writeStr('WAVE');

    // fmt chunk
    writeStr('fmt ');
    bytes.setUint32(o, 16, Endian.little);
    o += 4;
    bytes.setUint16(o, 1, Endian.little);
    o += 2; // PCM
    bytes.setUint16(o, channels, Endian.little);
    o += 2;
    bytes.setUint32(o, sampleRate, Endian.little);
    o += 4;
    bytes.setUint32(o, sampleRate * channels * 2, Endian.little);
    o += 4;
    bytes.setUint16(o, channels * 2, Endian.little);
    o += 2;
    bytes.setUint16(o, 16, Endian.little);
    o += 2;

    // data chunk
    writeStr('data');
    bytes.setUint32(o, dataSize, Endian.little);
    o += 4;

    // Write samples
    for (int i = 0; i < samples.length; i++) {
      final clamped = samples[i].clamp(-1.0, 1.0);
      bytes.setInt16(o, (clamped * 32767).toInt(), Endian.little);
      o += 2;
    }

    return bytes.buffer.asUint8List();
  }
}
