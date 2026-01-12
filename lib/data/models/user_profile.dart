import 'zodiac_sign.dart';

class UserProfile {
  final String? name;
  final DateTime birthDate;
  final String? birthTime;
  final String? birthPlace;
  final double? birthLatitude;
  final double? birthLongitude;
  final ZodiacSign sunSign;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;

  UserProfile({
    this.name,
    required this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.birthLatitude,
    this.birthLongitude,
    ZodiacSign? sunSign,
    this.moonSign,
    this.risingSign,
  }) : sunSign = sunSign ?? ZodiacSignExtension.fromDate(birthDate);

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'birthTime': birthTime,
        'birthPlace': birthPlace,
        'birthLatitude': birthLatitude,
        'birthLongitude': birthLongitude,
        'sunSign': sunSign.index,
        'moonSign': moonSign?.index,
        'risingSign': risingSign?.index,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String?,
        birthDate: DateTime.parse(json['birthDate'] as String),
        birthTime: json['birthTime'] as String?,
        birthPlace: json['birthPlace'] as String?,
        birthLatitude: json['birthLatitude'] as double?,
        birthLongitude: json['birthLongitude'] as double?,
        sunSign: ZodiacSign.values[json['sunSign'] as int],
        moonSign: json['moonSign'] != null
            ? ZodiacSign.values[json['moonSign'] as int]
            : null,
        risingSign: json['risingSign'] != null
            ? ZodiacSign.values[json['risingSign'] as int]
            : null,
      );

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? birthTime,
    String? birthPlace,
    double? birthLatitude,
    double? birthLongitude,
    ZodiacSign? sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? risingSign,
  }) =>
      UserProfile(
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        birthTime: birthTime ?? this.birthTime,
        birthPlace: birthPlace ?? this.birthPlace,
        birthLatitude: birthLatitude ?? this.birthLatitude,
        birthLongitude: birthLongitude ?? this.birthLongitude,
        sunSign: sunSign ?? this.sunSign,
        moonSign: moonSign ?? this.moonSign,
        risingSign: risingSign ?? this.risingSign,
      );
}
