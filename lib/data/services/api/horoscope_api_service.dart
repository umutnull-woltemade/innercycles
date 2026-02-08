import 'api_client.dart';

/// API service for horoscope-related endpoints
class HoroscopeApiService {
  final ApiClient _client;

  HoroscopeApiService(this._client);

  /// Get daily horoscope for a specific sign
  Future<ApiResponse<HoroscopeDto>> getDailyHoroscope(
    String sign, {
    String? language,
  }) async {
    return _client.get<HoroscopeDto>(
      '/horoscopes/daily/${sign.toLowerCase()}',
      queryParams: language != null ? {'language': language} : null,
      fromJson: (json) => HoroscopeDto.fromJson(json),
    );
  }

  /// Get weekly horoscope for a specific sign
  Future<ApiResponse<HoroscopeDto>> getWeeklyHoroscope(
    String sign, {
    String? language,
  }) async {
    return _client.get<HoroscopeDto>(
      '/horoscopes/weekly/${sign.toLowerCase()}',
      queryParams: language != null ? {'language': language} : null,
      fromJson: (json) => HoroscopeDto.fromJson(json),
    );
  }

  /// Get monthly horoscope for a specific sign
  Future<ApiResponse<HoroscopeDto>> getMonthlyHoroscope(
    String sign, {
    String? language,
  }) async {
    return _client.get<HoroscopeDto>(
      '/horoscopes/monthly/${sign.toLowerCase()}',
      queryParams: language != null ? {'language': language} : null,
      fromJson: (json) => HoroscopeDto.fromJson(json),
    );
  }

  /// Get all daily horoscopes for all signs
  Future<ApiResponse<List<HoroscopeDto>>> getAllDailyHoroscopes({
    String? language,
  }) async {
    return _client.get<List<HoroscopeDto>>(
      '/horoscopes/daily',
      queryParams: language != null ? {'language': language} : null,
      fromJson: (json) =>
          (json as List).map((h) => HoroscopeDto.fromJson(h)).toList(),
    );
  }

  /// Get horoscope by parameters
  Future<ApiResponse<HoroscopeDto>> getHoroscope({
    required String sign,
    String? type,
    String? category,
    DateTime? date,
    String? language,
  }) async {
    return _client.get<HoroscopeDto>(
      '/horoscopes',
      queryParams: {
        'sign': sign.toLowerCase(),
        'type': ?type,
        'category': ?category,
        if (date != null) 'date': date.toIso8601String(),
        'language': ?language,
      },
      fromJson: (json) => HoroscopeDto.fromJson(json),
    );
  }
}

class HoroscopeDto {
  final String id;
  final String sign;
  final String type;
  final String? category;
  final String content;
  final Map<String, dynamic>? ratings;
  final String? luckyNumber;
  final String? luckyColor;
  final String? compatibility;
  final String? mood;
  final DateTime validFrom;
  final DateTime validTo;
  final String language;

  HoroscopeDto({
    required this.id,
    required this.sign,
    required this.type,
    this.category,
    required this.content,
    this.ratings,
    this.luckyNumber,
    this.luckyColor,
    this.compatibility,
    this.mood,
    required this.validFrom,
    required this.validTo,
    required this.language,
  });

  factory HoroscopeDto.fromJson(Map<String, dynamic> json) {
    return HoroscopeDto(
      id: json['id'] as String,
      sign: json['sign'] as String,
      type: json['type'] as String,
      category: json['category'] as String?,
      content: json['content'] as String,
      ratings: json['ratings'] as Map<String, dynamic>?,
      luckyNumber: json['luckyNumber']?.toString(),
      luckyColor: json['luckyColor'] as String?,
      compatibility: json['compatibility'] as String?,
      mood: json['mood'] as String?,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validTo: DateTime.parse(json['validTo'] as String),
      language: json['language'] as String? ?? 'en',
    );
  }

  /// Get love rating (0-5)
  double get loveRating => (ratings?['love'] as num?)?.toDouble() ?? 3.0;

  /// Get career rating (0-5)
  double get careerRating => (ratings?['career'] as num?)?.toDouble() ?? 3.0;

  /// Get health rating (0-5)
  double get healthRating => (ratings?['health'] as num?)?.toDouble() ?? 3.0;

  /// Get overall rating (0-5)
  double get overallRating => (ratings?['overall'] as num?)?.toDouble() ?? 3.0;
}
