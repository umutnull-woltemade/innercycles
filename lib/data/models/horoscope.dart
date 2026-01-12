import 'zodiac_sign.dart';

class DailyHoroscope {
  final ZodiacSign sign;
  final DateTime date;
  final String summary;
  final String loveAdvice;
  final String careerAdvice;
  final String healthAdvice;
  final int luckRating; // 1-5
  final String luckyNumber;
  final String luckyColor;
  final String mood;

  DailyHoroscope({
    required this.sign,
    required this.date,
    required this.summary,
    required this.loveAdvice,
    required this.careerAdvice,
    required this.healthAdvice,
    required this.luckRating,
    required this.luckyNumber,
    required this.luckyColor,
    required this.mood,
  });

  Map<String, dynamic> toJson() => {
        'sign': sign.index,
        'date': date.toIso8601String(),
        'summary': summary,
        'loveAdvice': loveAdvice,
        'careerAdvice': careerAdvice,
        'healthAdvice': healthAdvice,
        'luckRating': luckRating,
        'luckyNumber': luckyNumber,
        'luckyColor': luckyColor,
        'mood': mood,
      };

  factory DailyHoroscope.fromJson(Map<String, dynamic> json) => DailyHoroscope(
        sign: ZodiacSign.values[json['sign'] as int],
        date: DateTime.parse(json['date'] as String),
        summary: json['summary'] as String,
        loveAdvice: json['loveAdvice'] as String,
        careerAdvice: json['careerAdvice'] as String,
        healthAdvice: json['healthAdvice'] as String,
        luckRating: json['luckRating'] as int,
        luckyNumber: json['luckyNumber'] as String,
        luckyColor: json['luckyColor'] as String,
        mood: json['mood'] as String,
      );
}

class Compatibility {
  final ZodiacSign sign1;
  final ZodiacSign sign2;
  final int overallScore; // 0-100
  final int loveScore;
  final int friendshipScore;
  final int communicationScore;
  final String summary;
  final List<String> strengths;
  final List<String> challenges;

  Compatibility({
    required this.sign1,
    required this.sign2,
    required this.overallScore,
    required this.loveScore,
    required this.friendshipScore,
    required this.communicationScore,
    required this.summary,
    required this.strengths,
    required this.challenges,
  });
}
