import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dream_journal_service.dart';
import 'dream_interpretation_service.dart';
import '../models/dream_interpretation_models.dart';

/// Supabase Dream Service - Cloud storage for dream data
/// Works alongside DreamJournalService (local) for offline-first architecture
class SupabaseDreamService {
  static SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static bool get isAvailable =>
      _supabase != null && _supabase!.auth.currentUser != null;

  /// Fetch all dreams from Supabase
  static Future<List<DreamEntry>> fetchDreams() async {
    if (!isAvailable) return [];

    try {
      final userId = _supabase!.auth.currentUser!.id;

      final response = await _supabase!
          .from('user_dreams')
          .select()
          .eq('user_id', userId)
          .order('dream_date', ascending: false);

      return (response as List).map((d) => _fromSupabase(d)).toList();
    } catch (e) {
      debugPrint('SupabaseDreamService.fetchDreams error: $e');
      return [];
    }
  }

  /// Save a dream to Supabase
  static Future<bool> saveDream(DreamEntry dream) async {
    if (!isAvailable) return false;

    try {
      final userId = _supabase!.auth.currentUser!.id;

      await _supabase!.from('user_dreams').upsert({
        'id': dream.id,
        'user_id': userId,
        'title': dream.title,
        'content': dream.content,
        'dream_date': dream.dreamDate.toIso8601String().split('T')[0],
        'recorded_at': dream.recordedAt.toIso8601String(),
        'detected_symbols': dream.detectedSymbols,
        'user_tags': dream.userTags,
        'dominant_emotion': dream.dominantEmotion.name,
        'emotional_intensity': dream.emotionalIntensity,
        'is_recurring': dream.isRecurring,
        'is_lucid': dream.isLucid,
        'is_nightmare': dream.isNightmare,
        'moon_phase': dream.moonPhase.name,
        'moon_sign': dream.moonSign,
        'interpretation': dream.interpretation?.toJson(),
        'metadata': dream.metadata,
        'updated_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      debugPrint('SupabaseDreamService.saveDream error: $e');
      return false;
    }
  }

  /// Delete a dream from Supabase
  static Future<bool> deleteDream(String id) async {
    if (!isAvailable) return false;

    try {
      await _supabase!.from('user_dreams').delete().eq('id', id);
      return true;
    } catch (e) {
      debugPrint('SupabaseDreamService.deleteDream error: $e');
      return false;
    }
  }

  /// Sync local dreams to Supabase
  static Future<int> syncToCloud(List<DreamEntry> localDreams) async {
    if (!isAvailable) return 0;

    int synced = 0;
    for (final dream in localDreams) {
      if (await saveDream(dream)) {
        synced++;
      }
    }
    return synced;
  }

  /// Get dreams updated after a specific timestamp
  static Future<List<DreamEntry>> fetchDreamsSince(DateTime since) async {
    if (!isAvailable) return [];

    try {
      final userId = _supabase!.auth.currentUser!.id;

      final response = await _supabase!
          .from('user_dreams')
          .select()
          .eq('user_id', userId)
          .gt('updated_at', since.toIso8601String())
          .order('updated_at', ascending: false);

      return (response as List).map((d) => _fromSupabase(d)).toList();
    } catch (e) {
      debugPrint('SupabaseDreamService.fetchDreamsSince error: $e');
      return [];
    }
  }

  /// Create a shared dream card
  static Future<String?> shareDream(String dreamId) async {
    if (!isAvailable) return null;

    try {
      final userId = _supabase!.auth.currentUser!.id;
      final shareCode = _generateShareCode();

      await _supabase!.from('shared_dreams').insert({
        'dream_id': dreamId,
        'user_id': userId,
        'share_code': shareCode,
        'is_public': true,
      });

      return shareCode;
    } catch (e) {
      debugPrint('SupabaseDreamService.shareDream error: $e');
      return null;
    }
  }

  /// Get a shared dream by code
  static Future<DreamEntry?> getSharedDream(String shareCode) async {
    try {
      final response = await _supabase!
          .from('shared_dreams')
          .select('*, user_dreams(*)')
          .eq('share_code', shareCode)
          .eq('is_public', true)
          .single();

      if (response['user_dreams'] == null) return null;

      // Increment view count
      await _supabase!
          .from('shared_dreams')
          .update({'view_count': (response['view_count'] ?? 0) + 1})
          .eq('share_code', shareCode);

      return _fromSupabase(response['user_dreams']);
    } catch (e) {
      debugPrint('SupabaseDreamService.getSharedDream error: $e');
      return null;
    }
  }

  /// Convert Supabase row to DreamEntry
  static DreamEntry _fromSupabase(Map<String, dynamic> data) {
    return DreamEntry(
      id: data['id'],
      dreamDate: DateTime.parse(data['dream_date']),
      recordedAt: data['recorded_at'] != null
          ? DateTime.parse(data['recorded_at'])
          : DateTime.now(),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      detectedSymbols: List<String>.from(data['detected_symbols'] ?? []),
      userTags: List<String>.from(data['user_tags'] ?? []),
      dominantEmotion: EmotionalTone.values.firstWhere(
        (e) => e.name == data['dominant_emotion'],
        orElse: () => EmotionalTone.merak,
      ),
      emotionalIntensity: data['emotional_intensity'] ?? 5,
      isRecurring: data['is_recurring'] ?? false,
      isLucid: data['is_lucid'] ?? false,
      isNightmare: data['is_nightmare'] ?? false,
      moonPhase: MoonPhase.values.firstWhere(
        (e) => e.name == data['moon_phase'],
        orElse: () => MoonPhaseCalculator.today,
      ),
      moonSign: data['moon_sign'],
      interpretation: data['interpretation'] != null
          ? FullDreamInterpretation.fromJson(data['interpretation'])
          : null,
      metadata: data['metadata'],
    );
  }

  /// Generate a unique share code
  static String _generateShareCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    for (var i = 0; i < 8; i++) {
      code += chars[(random + i * 7) % chars.length];
    }
    return code;
  }
}
