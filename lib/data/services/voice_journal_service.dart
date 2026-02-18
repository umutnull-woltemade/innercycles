// ════════════════════════════════════════════════════════════════════════════
// VOICE JOURNAL SERVICE - Speech-to-Text for Journal Entries
// ════════════════════════════════════════════════════════════════════════════
// Provides voice input capabilities for journal entries using the
// speech_to_text package. Follows the existing service pattern with
// static init() factory.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import '../providers/app_providers.dart';
import 'storage_service.dart';

/// Voice input service for journal entries.
/// Wraps the speech_to_text package with a clean API for the app.
class VoiceJournalService {
  final SpeechToText _speech;
  bool _isInitialized = false;
  bool _isListening = false;

  /// Stream controller for recognized text updates.
  final _textController = StreamController<String>.broadcast();

  /// Stream controller for listening state changes.
  final _listeningStateController = StreamController<bool>.broadcast();

  /// Stream controller for error events.
  final _errorController = StreamController<String>.broadcast();

  bool get _isEn => StorageService.loadLanguage() == AppLanguage.en;

  /// The most recent recognized text from the current listening session.
  String _lastRecognizedText = '';

  VoiceJournalService(this._speech);

  /// Initialize service - follows the static init() factory pattern.
  static Future<VoiceJournalService> init() async {
    final speech = SpeechToText();
    final service = VoiceJournalService(speech);
    await service._initialize();
    return service;
  }

  /// Internal initialization of the speech recognition engine.
  Future<void> _initialize() async {
    try {
      _isInitialized = await _speech.initialize(
        onError: _onError,
        onStatus: _onStatus,
      );
    } catch (e) {
      _isInitialized = false;
      _errorController.add(_isEn ? 'Failed to initialize voice input' : 'Sesli giriş başlatılamadı');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════

  /// Whether the speech recognition engine is available and initialized.
  bool get isAvailable => _isInitialized;

  /// Whether the service is currently listening for speech.
  bool get isListening => _isListening;

  /// Stream of recognized text as the user speaks.
  /// Emits partial and final results.
  Stream<String> get onTextRecognized => _textController.stream;

  /// Stream of listening state changes (true = listening, false = stopped).
  Stream<bool> get onListeningStateChanged => _listeningStateController.stream;

  /// Stream of error messages.
  Stream<String> get onError => _errorController.stream;

  /// The last recognized text from the most recent listening session.
  String get lastRecognizedText => _lastRecognizedText;

  /// Start listening for speech input.
  ///
  /// [localeId] - Optional locale for speech recognition (e.g. 'en_US', 'tr_TR').
  /// Returns true if listening started successfully.
  Future<bool> startListening({String? localeId}) async {
    if (!_isInitialized) {
      _errorController.add(_isEn ? 'Voice input is not available on this device.' : 'Bu cihazda sesli giriş kullanılamıyor.');
      return false;
    }

    if (_isListening) {
      return true; // Already listening
    }

    try {
      _lastRecognizedText = '';
      await _speech.listen(
        onResult: _onResult,
        localeId: localeId,
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        ),
      );
      _isListening = true;
      _listeningStateController.add(true);
      return true;
    } catch (e) {
      _errorController.add(_isEn ? 'Could not start listening' : 'Dinleme başlatılamadı');
      return false;
    }
  }

  /// Stop listening for speech input.
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _speech.stop();
    } catch (e) {
      _errorController.add(_isEn ? 'Error stopping voice input' : 'Sesli giriş durdurulurken hata oluştu');
    } finally {
      _isListening = false;
      _listeningStateController.add(false);
    }
  }

  /// Cancel listening without processing the result.
  Future<void> cancelListening() async {
    if (!_isListening) return;

    try {
      await _speech.cancel();
    } catch (e) {
      // Silently handle cancel errors
    } finally {
      _isListening = false;
      _lastRecognizedText = '';
      _listeningStateController.add(false);
    }
  }

  /// Get available locales for speech recognition.
  Future<List<LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) return [];
    try {
      return await _speech.locales();
    } catch (e) {
      return [];
    }
  }

  /// Check if a specific locale is available.
  Future<bool> isLocaleAvailable(String localeId) async {
    final locales = await getAvailableLocales();
    return locales.any((l) => l.localeId == localeId);
  }

  /// Dispose of resources. Call when the service is no longer needed.
  void dispose() {
    unawaited(stopListening());
    _textController.close();
    _listeningStateController.close();
    _errorController.close();
  }

  // ═══════════════════════════════════════════════════════════════
  // CALLBACKS
  // ═══════════════════════════════════════════════════════════════

  void _onResult(SpeechRecognitionResult result) {
    _lastRecognizedText = result.recognizedWords;
    _textController.add(result.recognizedWords);
  }

  void _onError(SpeechRecognitionError error) {
    _errorController.add(error.errorMsg);
    if (error.permanent) {
      _isListening = false;
      _listeningStateController.add(false);
    }
  }

  void _onStatus(String status) {
    // The speech_to_text package reports status as 'listening', 'notListening', 'done'
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
      _listeningStateController.add(false);
    }
  }
}
