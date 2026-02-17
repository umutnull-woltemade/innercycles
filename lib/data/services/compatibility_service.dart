// ════════════════════════════════════════════════════════════════════════════
// COMPATIBILITY REFLECTION ENGINE - InnerCycles Relationship Self-Reflection
// ════════════════════════════════════════════════════════════════════════════
// Helps users reflect on their relationships through structured questions.
// Framed as a REFLECTION tool — how YOU experience this relationship.
// NEVER uses predictive or destined-partner language.
// USES: "Your reflections suggest", "You value", "Areas for growth together".
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ════════════════════════════════════════════════════════════════════════════
// ENUMS
// ════════════════════════════════════════════════════════════════════════════

enum RelationshipType {
  partner,
  friend,
  family,
  colleague;

  String get displayNameEn {
    switch (this) {
      case RelationshipType.partner:
        return 'Partner';
      case RelationshipType.friend:
        return 'Friend';
      case RelationshipType.family:
        return 'Family';
      case RelationshipType.colleague:
        return 'Colleague';
    }
  }

  String get displayNameTr {
    switch (this) {
      case RelationshipType.partner:
        return 'Partner';
      case RelationshipType.friend:
        return 'Arkadaş';
      case RelationshipType.family:
        return 'Aile';
      case RelationshipType.colleague:
        return 'İş Arkadaşı';
    }
  }

  String get icon {
    switch (this) {
      case RelationshipType.partner:
        return 'favorite';
      case RelationshipType.friend:
        return 'people';
      case RelationshipType.family:
        return 'home';
      case RelationshipType.colleague:
        return 'work';
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════════════

/// A single reflection question with bilingual text and answer options
class ReflectionQuestion {
  final int index;
  final String questionEn;
  final String questionTr;
  final String dimension; // Communication, Emotional, Values, Growth, Trust
  final List<ReflectionOption> options;

  const ReflectionQuestion({
    required this.index,
    required this.questionEn,
    required this.questionTr,
    required this.dimension,
    required this.options,
  });
}

/// An option for a reflection question (scored 1-5)
class ReflectionOption {
  final String textEn;
  final String textTr;
  final int score; // 1 = low alignment, 5 = high alignment

  const ReflectionOption({
    required this.textEn,
    required this.textTr,
    required this.score,
  });
}

/// A scored dimension with insight text
class CompatibilityDimension {
  final String name;
  final double score; // 0-100
  final String insightEn;
  final String insightTr;

  const CompatibilityDimension({
    required this.name,
    required this.score,
    required this.insightEn,
    required this.insightTr,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'insightEn': insightEn,
        'insightTr': insightTr,
      };

  factory CompatibilityDimension.fromJson(Map<String, dynamic> json) =>
      CompatibilityDimension(
        name: json['name'] as String,
        score: (json['score'] as num).toDouble(),
        insightEn: json['insightEn'] as String,
        insightTr: json['insightTr'] as String,
      );
}

/// The full result of a compatibility reflection
class CompatibilityResult {
  final List<CompatibilityDimension> dimensions;
  final double overallScore;
  final String summaryEn;
  final String summaryTr;

  const CompatibilityResult({
    required this.dimensions,
    required this.overallScore,
    required this.summaryEn,
    required this.summaryTr,
  });

  Map<String, dynamic> toJson() => {
        'dimensions': dimensions.map((d) => d.toJson()).toList(),
        'overallScore': overallScore,
        'summaryEn': summaryEn,
        'summaryTr': summaryTr,
      };

  factory CompatibilityResult.fromJson(Map<String, dynamic> json) =>
      CompatibilityResult(
        dimensions: (json['dimensions'] as List)
            .map((d) => CompatibilityDimension.fromJson(d))
            .toList(),
        overallScore: (json['overallScore'] as num).toDouble(),
        summaryEn: json['summaryEn'] as String,
        summaryTr: json['summaryTr'] as String,
      );
}

/// A saved relationship reflection profile
class CompatibilityProfile {
  final String id;
  final String name;
  final RelationshipType relationshipType;
  final List<int> answers; // answer index per question (0-based)
  final CompatibilityResult? result;
  final DateTime createdAt;

  const CompatibilityProfile({
    required this.id,
    required this.name,
    required this.relationshipType,
    required this.answers,
    this.result,
    required this.createdAt,
  });

  double get overallScore => result?.overallScore ?? 0;

  bool get isComplete => answers.length == 10;

  CompatibilityProfile copyWith({
    String? id,
    String? name,
    RelationshipType? relationshipType,
    List<int>? answers,
    CompatibilityResult? result,
    DateTime? createdAt,
  }) =>
      CompatibilityProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        relationshipType: relationshipType ?? this.relationshipType,
        answers: answers ?? this.answers,
        result: result ?? this.result,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'relationshipType': relationshipType.name,
        'answers': answers,
        'result': result?.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory CompatibilityProfile.fromJson(Map<String, dynamic> json) =>
      CompatibilityProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        relationshipType: RelationshipType.values.firstWhere(
          (e) => e.name == json['relationshipType'],
          orElse: () => RelationshipType.friend,
        ),
        answers: List<int>.from(json['answers'] ?? []),
        result: json['result'] != null
            ? CompatibilityResult.fromJson(json['result'])
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// COMPATIBILITY SERVICE
// ════════════════════════════════════════════════════════════════════════════

class CompatibilityService {
  static const String _profilesKey = 'compatibility_profiles';

  final SharedPreferences _prefs;

  CompatibilityService(this._prefs);

  /// Initialize service with SharedPreferences
  static Future<CompatibilityService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return CompatibilityService(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REFLECTION QUESTIONS (10 total, 2 per dimension)
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns all 10 reflection questions
  static List<ReflectionQuestion> getReflectionQuestions() => _questions;

  static const List<ReflectionQuestion> _questions = [
    // ─── COMMUNICATION (Q1, Q2) ─────────────────────────────────
    ReflectionQuestion(
      index: 0,
      questionEn:
          'When you need to share something difficult with this person, how do you usually feel?',
      questionTr:
          'Bu kişiyle zor bir şeyi paylaşmanız gerektiğinde genellikle nasıl hissediyorsunuz?',
      dimension: 'Communication',
      options: [
        ReflectionOption(
          textEn: 'I feel safe and heard — they listen without judgment',
          textTr:
              'Güvende ve duyulmuş hissediyorum — yargılamadan dinliyorlar',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Mostly comfortable, though some topics feel harder',
          textTr: 'Çoğunlukla rahat, ama bazı konular daha zor geliyor',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'I tend to hold back — I am not sure how they will react',
          textTr:
              'Kendimi tutma eğilimindeyim — nasıl tepki vereceklerinden emin değilim',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'I often avoid it — conversations tend to escalate',
          textTr:
              'Genellikle kaçınırım — konuşmalar genellikle tırmanır',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'I rarely bring things up — it does not feel worth the effort',
          textTr:
              'Nadiren gündeme getiririm — çabaya değmez gibi geliyor',
          score: 1,
        ),
      ],
    ),
    ReflectionQuestion(
      index: 1,
      questionEn:
          'How well do you feel this person understands your communication style?',
      questionTr:
          'Bu kişinin iletişim tarzınızı ne kadar iyi anladığını hissediyorsunuz?',
      dimension: 'Communication',
      options: [
        ReflectionOption(
          textEn:
              'Very well — they adapt and we find common ground easily',
          textTr:
              'Çok iyi — uyum sağlıyorlar ve ortak noktayı kolayca buluyoruz',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Fairly well — we have learned each other over time',
          textTr:
              'Oldukça iyi — zamanla birbirimizi öğrendik',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'Sometimes — there are misunderstandings but we work through them',
          textTr:
              'Bazen — yanlış anlamalar oluyor ama üstesinden geliyoruz',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Not really — we often talk past each other',
          textTr:
              'Pek değil — genellikle birbirimizi anlayamıyoruz',
          score: 2,
        ),
        ReflectionOption(
          textEn: 'Poorly — our styles clash and it creates friction',
          textTr:
              'Kötü — tarzlarımız çatışıyor ve sürtüşmeler yaratıyoruz',
          score: 1,
        ),
      ],
    ),

    // ─── EMOTIONAL NEEDS (Q3, Q4) ───────────────────────────────
    ReflectionQuestion(
      index: 2,
      questionEn:
          'When you are going through a hard time, how does this person typically respond?',
      questionTr:
          'Zor bir dönemden geçerken, bu kişi genellikle nasıl karşılık verir?',
      dimension: 'Emotional',
      options: [
        ReflectionOption(
          textEn:
              'They show up — emotionally present and supportive',
          textTr:
              'Yanında olurlar — duygusal olarak mevcut ve destekçi',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'They try their best, even if their way differs from mine',
          textTr:
              'Ellerinden gelenin en iyisini yaparlar, tarzı benimkinden farklı olsa bile',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'It depends on the situation — sometimes present, sometimes not',
          textTr:
              'Duruma bağlı — bazen mevcut, bazen değil',
          score: 3,
        ),
        ReflectionOption(
          textEn:
              'They tend to withdraw or minimize my feelings',
          textTr:
              'Geri çekilme veya duygularımı küçümseme eğilimindeler',
          score: 2,
        ),
        ReflectionOption(
          textEn: 'I usually do not turn to them during hard times',
          textTr:
              'Zor zamanlarda genellikle onlara yönelmiyorum',
          score: 1,
        ),
      ],
    ),
    ReflectionQuestion(
      index: 3,
      questionEn:
          'How balanced do you feel the emotional effort is in this relationship?',
      questionTr:
          'Bu ilişkideki duygusal çabanın ne kadar dengeli olduğunu hissediyorsunuz?',
      dimension: 'Emotional',
      options: [
        ReflectionOption(
          textEn: 'Very balanced — we both give and receive equally',
          textTr:
              'Çok dengeli — ikimiz de eşit olarak veriyoruz ve alıyoruz',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Mostly balanced — small imbalances are normal',
          textTr:
              'Çoğunlukla dengeli — küçük dengesizlikler normal',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'Somewhat uneven — I notice one of us gives more',
          textTr:
              'Biraz eşitsiz — birimizin daha fazla verdiğini fark ediyorum',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Quite unbalanced — I feel drained at times',
          textTr:
              'Oldukça dengesiz — bazen tükendiğimi hissediyorum',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'One-sided — the effort mostly comes from one direction',
          textTr:
              'Tek taraflı — çaba çoğunlukla bir yönden geliyor',
          score: 1,
        ),
      ],
    ),

    // ─── VALUES (Q5, Q6) ────────────────────────────────────────
    ReflectionQuestion(
      index: 4,
      questionEn:
          'How aligned do you feel your core values are with this person?',
      questionTr:
          'Temel değerlerinizin bu kişiyle ne kadar uyumlu olduğunu hissediyorsunuz?',
      dimension: 'Values',
      options: [
        ReflectionOption(
          textEn:
              'Strongly aligned — we share the same priorities in life',
          textTr:
              'Güçlü bir uyum — hayatta aynı öncelikleri paylaşıyoruz',
          score: 5,
        ),
        ReflectionOption(
          textEn:
              'Mostly aligned — differences are enriching, not divisive',
          textTr:
              'Çoğunlukla uyumlu — farklılıklar bölücü değil zenginleştiricidir',
          score: 4,
        ),
        ReflectionOption(
          textEn:
              'Some overlap — but there are areas where we diverge clearly',
          textTr:
              'Biraz örtüşme var — ama açıkça ayrıştığımız alanlar var',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Limited alignment — we see the world quite differently',
          textTr:
              'Sınırlı uyum — dünyayı oldukça farklı görüyoruz',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'Fundamentally different — our values often clash',
          textTr:
              'Temelden farklı — değerlerimiz sıklıkla çatışıyor',
          score: 1,
        ),
      ],
    ),
    ReflectionQuestion(
      index: 5,
      questionEn:
          'When you think about how you each spend time and energy, how aligned does it feel?',
      questionTr:
          'Her birinizin zamanını ve enerjisini nasıl harcadığını düşündüğünde, ne kadar uyumlu hissediyorsun?',
      dimension: 'Values',
      options: [
        ReflectionOption(
          textEn:
              'Very aligned — we invest in similar things that matter to us',
          textTr:
              'Çok uyumlu — ikimiz için önemli olan benzer şeylere yatırım yapıyoruz',
          score: 5,
        ),
        ReflectionOption(
          textEn:
              'Mostly — we respect each other\'s priorities even when different',
          textTr:
              'Çoğunlukla — farklı olsa da birbirimizin önceliklerine saygı duyuyoruz',
          score: 4,
        ),
        ReflectionOption(
          textEn:
              'Partially — we sometimes struggle to find shared interests',
          textTr:
              'Kısmen — bazen ortak ilgi alanları bulmakta zorlanıyoruz',
          score: 3,
        ),
        ReflectionOption(
          textEn:
              'Rarely — our priorities feel like they pull us apart',
          textTr:
              'Nadiren — önceliklerimiz bizi ayırıyormuş gibi hissediyorum',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'Not at all — we live in very separate worlds',
          textTr:
              'Hiç değil — çok ayrı dünyalarda yaşıyoruz',
          score: 1,
        ),
      ],
    ),

    // ─── GROWTH (Q7, Q8) ────────────────────────────────────────
    ReflectionQuestion(
      index: 6,
      questionEn:
          'Does this relationship encourage your personal growth?',
      questionTr:
          'Bu ilişki kişisel gelişiminizi teşvik ediyor mu?',
      dimension: 'Growth',
      options: [
        ReflectionOption(
          textEn:
              'Absolutely — I feel inspired and challenged in healthy ways',
          textTr:
              'Kesinlikle — sağlıklı yollarla ilham ve meydan okunmuş hissediyorum',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Yes — they support my goals and celebrate wins with me',
          textTr:
              'Evet — hedeflerimi destekliyorlar ve başarıları benimle kutluyorlar',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'Sometimes — growth happens but it is not a focus of ours',
          textTr:
              'Bazen — gelişim oluyor ama odağımız bu değil',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Rarely — I feel stuck or held back in this dynamic',
          textTr:
              'Nadiren — bu dinamikte takılı kalmış veya geri tutulmuş hissediyorum',
          score: 2,
        ),
        ReflectionOption(
          textEn: 'No — this relationship limits who I can become',
          textTr:
              'Hayır — bu ilişki olabileceğim kişiyi sınırlıyor',
          score: 1,
        ),
      ],
    ),
    ReflectionQuestion(
      index: 7,
      questionEn:
          'How do you and this person handle change and new challenges together?',
      questionTr:
          'Siz ve bu kişi değişiklikleri ve yeni zorlukları birlikte nasıl ele alıyorsunuz?',
      dimension: 'Growth',
      options: [
        ReflectionOption(
          textEn:
              'We adapt together — change brings us closer',
          textTr:
              'Birlikte uyum sağlıyoruz — değişim bizi yakınlaştırıyor',
          score: 5,
        ),
        ReflectionOption(
          textEn:
              'We manage — it takes effort but we get through it',
          textTr:
              'İdare ediyoruz — çaba gerektiriyor ama üstesinden geliyoruz',
          score: 4,
        ),
        ReflectionOption(
          textEn:
              'Mixed — sometimes we grow together, sometimes we drift',
          textTr:
              'Karışık — bazen birlikte büyüyoruz, bazen uzaklaşıyoruz',
          score: 3,
        ),
        ReflectionOption(
          textEn:
              'Difficult — change tends to create conflict between us',
          textTr:
              'Zor — değişim aramızda çatışma yaratma eğiliminde',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'Poorly — we resist change and avoid hard conversations',
          textTr:
              'Kötü — değişime direnç gösteriyoruz ve zor konuşmalardan kaçınıyoruz',
          score: 1,
        ),
      ],
    ),

    // ─── TRUST (Q9, Q10) ────────────────────────────────────────
    ReflectionQuestion(
      index: 8,
      questionEn:
          'How much do you trust this person with your vulnerabilities?',
      questionTr:
          'Kırılganlıklarınız konusunda bu kişiye ne kadar güveniyorsunuz?',
      dimension: 'Trust',
      options: [
        ReflectionOption(
          textEn:
              'Completely — I can be my fullest self without masks',
          textTr:
              'Tamamen — maskeler olmadan en öz halimle olabiliyorum',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Mostly — I share deeply but keep some walls',
          textTr:
              'Çoğunlukla — derinden paylaşıyorum ama bazı duvarlarım var',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'Somewhat — I am selective about what I reveal',
          textTr:
              'Biraz — neyi açığa vuracağım konusunda seçiciyim',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Not much — past experiences have made me cautious',
          textTr:
              'Çok değil — geçmiş deneyimler beni temkinli kıldı',
          score: 2,
        ),
        ReflectionOption(
          textEn: 'Very little — I guard myself carefully around them',
          textTr:
              'Çok az — yanlarında kendimi dikkatle koruyorum',
          score: 1,
        ),
      ],
    ),
    ReflectionQuestion(
      index: 9,
      questionEn:
          'When conflicts arise, do you trust that this person has good intentions toward you?',
      questionTr:
          'Çatışmalar ortaya çıktığında, bu kişinin size karşı iyi niyetli olduğuna güveniyor musunuz?',
      dimension: 'Trust',
      options: [
        ReflectionOption(
          textEn:
              'Always — even in disagreement, I know they care about us',
          textTr:
              'Her zaman — anlaşamadığımızda bile, bize değer verdiklerini biliyorum',
          score: 5,
        ),
        ReflectionOption(
          textEn: 'Usually — though heated moments can shake that briefly',
          textTr:
              'Genellikle — gergin anlar bunu kısa süreliğine sarsabilse de',
          score: 4,
        ),
        ReflectionOption(
          textEn: 'Sometimes — it depends on the nature of the conflict',
          textTr:
              'Bazen — çatışmanın niteliklerine bağlı',
          score: 3,
        ),
        ReflectionOption(
          textEn: 'Rarely — conflicts often feel personal or attacking',
          textTr:
              'Nadiren — çatışmalar genellikle kişisel veya saldırgan hissettiriyor',
          score: 2,
        ),
        ReflectionOption(
          textEn:
              'No — I question their motives during disagreements',
          textTr:
              'Hayır — anlaşmazlıklar sırasında niyetlerini sorguluyorum',
          score: 1,
        ),
      ],
    ),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// Create a new reflection profile
  Future<CompatibilityProfile> createProfile(
    String name,
    RelationshipType type,
  ) async {
    final profile = CompatibilityProfile(
      id: const Uuid().v4(),
      name: name,
      relationshipType: type,
      answers: [],
      createdAt: DateTime.now(),
    );

    final profiles = await getProfiles();
    profiles.add(profile);
    await _saveProfiles(profiles);
    return profile;
  }

  /// Answer a question for a specific profile
  Future<CompatibilityProfile> answerQuestion(
    String profileId,
    int questionIndex,
    int answerIndex,
  ) async {
    final profiles = await getProfiles();
    final index = profiles.indexWhere((p) => p.id == profileId);
    if (index < 0) throw Exception('Profile not found');

    final profile = profiles[index];
    final answers = List<int>.from(profile.answers);

    // Extend or update
    if (questionIndex < answers.length) {
      answers[questionIndex] = answerIndex;
    } else {
      // Fill gaps if needed
      while (answers.length < questionIndex) {
        answers.add(0);
      }
      answers.add(answerIndex);
    }

    final updated = profile.copyWith(answers: answers);
    profiles[index] = updated;
    await _saveProfiles(profiles);
    return updated;
  }

  /// Calculate scores for a completed profile
  Future<CompatibilityResult> calculateScores(String profileId) async {
    final profiles = await getProfiles();
    final index = profiles.indexWhere((p) => p.id == profileId);
    if (index < 0) throw Exception('Profile not found');

    final profile = profiles[index];
    if (profile.answers.length < 10) {
      throw Exception('All 10 questions must be answered');
    }

    final result = _computeResult(profile);

    // Save result to profile
    final updated = profile.copyWith(result: result);
    profiles[index] = updated;
    await _saveProfiles(profiles);

    return result;
  }

  /// Get all saved profiles
  Future<List<CompatibilityProfile>> getProfiles() async {
    final json = _prefs.getString(_profilesKey);
    if (json == null) return [];

    final List<dynamic> decoded = jsonDecode(json);
    return decoded
        .map((d) => CompatibilityProfile.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  /// Delete a profile by ID
  Future<void> deleteProfile(String id) async {
    final profiles = await getProfiles();
    profiles.removeWhere((p) => p.id == id);
    await _saveProfiles(profiles);
  }

  /// Clear all compatibility data
  Future<void> clearAllData() async {
    await _prefs.remove(_profilesKey);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SCORE CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  CompatibilityResult _computeResult(CompatibilityProfile profile) {
    final answers = profile.answers;

    // Dimension index mapping: 2 questions each
    // Communication: Q0, Q1
    // Emotional:     Q2, Q3
    // Values:        Q4, Q5
    // Growth:        Q6, Q7
    // Trust:         Q8, Q9

    final commScore = _dimensionScore(0, answers[0], 1, answers[1]);
    final emotionalScore = _dimensionScore(2, answers[2], 3, answers[3]);
    final valuesScore = _dimensionScore(4, answers[4], 5, answers[5]);
    final growthScore = _dimensionScore(6, answers[6], 7, answers[7]);
    final trustScore = _dimensionScore(8, answers[8], 9, answers[9]);

    final dimensions = [
      CompatibilityDimension(
        name: 'Communication',
        score: commScore,
        insightEn: _communicationInsightEn(commScore),
        insightTr: _communicationInsightTr(commScore),
      ),
      CompatibilityDimension(
        name: 'Emotional',
        score: emotionalScore,
        insightEn: _emotionalInsightEn(emotionalScore),
        insightTr: _emotionalInsightTr(emotionalScore),
      ),
      CompatibilityDimension(
        name: 'Values',
        score: valuesScore,
        insightEn: _valuesInsightEn(valuesScore),
        insightTr: _valuesInsightTr(valuesScore),
      ),
      CompatibilityDimension(
        name: 'Growth',
        score: growthScore,
        insightEn: _growthInsightEn(growthScore),
        insightTr: _growthInsightTr(growthScore),
      ),
      CompatibilityDimension(
        name: 'Trust',
        score: trustScore,
        insightEn: _trustInsightEn(trustScore),
        insightTr: _trustInsightTr(trustScore),
      ),
    ];

    // Weighted average: Trust 25%, Communication 20%, Emotional 20%, Values 20%, Growth 15%
    final overall = (trustScore * 0.25) +
        (commScore * 0.20) +
        (emotionalScore * 0.20) +
        (valuesScore * 0.20) +
        (growthScore * 0.15);

    return CompatibilityResult(
      dimensions: dimensions,
      overallScore: overall,
      summaryEn: _overallSummaryEn(overall, profile.name),
      summaryTr: _overallSummaryTr(overall, profile.name),
    );
  }

  /// Convert two answer indices (0-based, pointing into options scored 1-5) to 0-100
  double _dimensionScore(
    int questionIdx1,
    int answerIdx1,
    int questionIdx2,
    int answerIdx2,
  ) {
    final q1Options = _questions[questionIdx1].options;
    final q2Options = _questions[questionIdx2].options;

    final q1Score =
        answerIdx1 < q1Options.length ? q1Options[answerIdx1].score : 3;
    final q2Score =
        answerIdx2 < q2Options.length ? q2Options[answerIdx2].score : 3;

    // Each question score 1-5, total 2-10, map to 0-100
    final raw = (q1Score + q2Score); // 2..10
    return ((raw - 2) / 8) * 100;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INSIGHT GENERATION — REFLECTION-BASED, NEVER PREDICTIVE
  // ══════════════════════════════════════════════════════════════════════════

  // ─── Communication ────────────────────────────────────────────
  String _communicationInsightEn(double score) {
    if (score >= 75) {
      return 'Your reflections suggest strong communication alignment. You seem to feel heard and understood in this relationship.';
    } else if (score >= 50) {
      return 'Your entries suggest a solid foundation in communication, with some areas that could benefit from deeper dialogue.';
    } else if (score >= 25) {
      return 'You may notice some friction in communication. Exploring different ways to express needs could be a meaningful growth area.';
    }
    return 'Your reflections point to communication as a significant area for growth together. Small steps toward openness can make a difference.';
  }

  String _communicationInsightTr(double score) {
    if (score >= 75) {
      return 'Yansımalarınız güçlü bir iletişim uyumu olduğunu gösteriyor. Bu ilişkide duyulduğunuzu ve anlaşıldığınızı hissediyor görünüyorsunuz.';
    } else if (score >= 50) {
      return 'Girdiğiniz yanıtlar iletişimde sağlam bir temel olduğunu, ancak daha derin diyalogdan fayda görebilecek alanlar olduğunu gösteriyor.';
    } else if (score >= 25) {
      return 'İletişimde bazı sürtünmeler fark edebilirsiniz. İhtiyaçları ifade etmenin farklı yollarını keşfetmek anlamlı bir gelişim alanı olabilir.';
    }
    return 'Yansımalarınız iletişimin birlikte büyümek için önemli bir alan olduğuna işaret ediyor. Açıklığa doğru küçük adımlar fark yaratabilir.';
  }

  // ─── Emotional ────────────────────────────────────────────────
  String _emotionalInsightEn(double score) {
    if (score >= 75) {
      return 'You value the emotional presence in this relationship. Your reflections suggest a nurturing and balanced emotional connection.';
    } else if (score >= 50) {
      return 'There seems to be a caring foundation here, though emotional balance may shift depending on circumstances.';
    } else if (score >= 25) {
      return 'You may notice uneven emotional investment at times. Reflecting on what you need emotionally could help bring clarity.';
    }
    return 'Your reflections suggest emotional connection is an area calling for attention. Understanding each other\'s emotional language could be a starting point.';
  }

  String _emotionalInsightTr(double score) {
    if (score >= 75) {
      return 'Bu ilişkideki duygusal varlığı değerli buluyorsunuz. Yansımalarınız besleyici ve dengeli bir duygusal bağlantı olduğunu gösteriyor.';
    } else if (score >= 50) {
      return 'Burada ilgili bir temel var gibi görünüyor, ancak duygusal denge koşullara bağlı olarak değişebilir.';
    } else if (score >= 25) {
      return 'Zaman zaman eşit olmayan duygusal yatırım fark edebilirsiniz. Duygusal olarak neye ihtiyacınız olduğunu yansıtmak netlik kazanmanıza yardımcı olabilir.';
    }
    return 'Yansımalarınız duygusal bağlantıyı dikkat gerektiren bir alan olduğunu gösteriyor. Birbirinizin duygusal dilini anlamak bir başlangıç noktası olabilir.';
  }

  // ─── Values ───────────────────────────────────────────────────
  String _valuesInsightEn(double score) {
    if (score >= 75) {
      return 'Your reflections show deep alignment in what matters most to you both. Shared values can be a strong anchor.';
    } else if (score >= 50) {
      return 'You share meaningful overlap in values, with room for appreciating your differences as sources of growth.';
    } else if (score >= 25) {
      return 'Your values may differ in some important areas. Exploring where you connect and where you diverge can bring understanding.';
    }
    return 'Your reflections highlight a values gap that may feel significant. Open curiosity about each other\'s worldview could be valuable.';
  }

  String _valuesInsightTr(double score) {
    if (score >= 75) {
      return 'Yansımalarınız ikiniz için de en önemli konularda derin bir uyum gösteriyor. Paylaşılan değerler güçlü bir çapa olabilir.';
    } else if (score >= 50) {
      return 'Değerlerde anlamlı bir örtüşme paylaşıyorsunuz, farklılıklarınızı büyüme kaynakları olarak takdir etmeye yer var.';
    } else if (score >= 25) {
      return 'Değerleriniz bazı önemli alanlarda farklılık gösterebilir. Nerede bağlandığınızı ve nerede ayrıştığınızı keşfetmek anlayış getirebilir.';
    }
    return 'Yansımalarınız önemli hissedilebilecek bir değer farklılığı vurguluyor. Birbirinizin dünya görüşüne açık merak değerli olabilir.';
  }

  // ─── Growth ───────────────────────────────────────────────────
  String _growthInsightEn(double score) {
    if (score >= 75) {
      return 'You experience this relationship as a catalyst for growth. Your entries suggest mutual inspiration and healthy challenge.';
    } else if (score >= 50) {
      return 'Growth is happening in this relationship, though it may not always feel intentional. Being more deliberate could amplify it.';
    } else if (score >= 25) {
      return 'You may notice that growth feels limited in this dynamic. Reflecting on what would help you both evolve could open new paths.';
    }
    return 'Your reflections suggest this relationship may feel stagnant at times. Introducing shared goals or new experiences could help.';
  }

  String _growthInsightTr(double score) {
    if (score >= 75) {
      return 'Bu ilişkiyi büyüme için bir katalizör olarak deneyimliyorsunuz. Yanıtlarınız karşılıklı ilham ve sağlıklı meydan okumayı gösteriyor.';
    } else if (score >= 50) {
      return 'Bu ilişkide büyüme yaşanıyor, ancak her zaman kasıtlı hissetmeyebilir. Daha kasıtlı olmak bunu güçlendirebilir.';
    } else if (score >= 25) {
      return 'Bu dinamikte büyümenin sınırlı olduğunu fark edebilirsiniz. İkinizin de gelişmesine neyin yardımcı olacağını yansıtmak yeni yollar açabilir.';
    }
    return 'Yansımalarınız bu ilişkinin zaman zaman durgun hissedilebileceğini gösteriyor. Ortak hedefler veya yeni deneyimler tanımak yardımcı olabilir.';
  }

  // ─── Trust ────────────────────────────────────────────────────
  String _trustInsightEn(double score) {
    if (score >= 75) {
      return 'Your reflections suggest a deep sense of trust and safety. You feel free to be vulnerable and authentic.';
    } else if (score >= 50) {
      return 'There is a reasonable level of trust here. Continuing to show up authentically can deepen it over time.';
    } else if (score >= 25) {
      return 'Trust seems to be an area with room for growth. Small, consistent acts of reliability can help rebuild or strengthen it.';
    }
    return 'Your reflections suggest trust is a core area calling for attention. Honest conversations about needs and boundaries may help.';
  }

  String _trustInsightTr(double score) {
    if (score >= 75) {
      return 'Yansımalarınız derin bir güven ve güvenlik duygusu olduğunu gösteriyor. Kırılgan ve özgün olmakta kendinizi özgür hissediyorsunuz.';
    } else if (score >= 50) {
      return 'Burada makul bir güven seviyesi var. Özgün bir şekilde var olmaya devam etmek bunu zamanla derinleştirebilir.';
    } else if (score >= 25) {
      return 'Güven büyüme için yer olan bir alan gibi görünüyor. Küçük, tutarlı güvenilirlik eylemleri yeniden inşa etmeye veya güçlendirmeye yardımcı olabilir.';
    }
    return 'Yansımalarınız güvenin dikkat gerektiren temel bir alan olduğunu gösteriyor. İhtiyaçlar ve sınırlar hakkında dürüstçe konuşmalar yardımcı olabilir.';
  }

  // ─── Overall Summary ─────────────────────────────────────────
  String _overallSummaryEn(double score, String name) {
    if (score >= 75) {
      return 'Your reflections about $name paint a picture of a deeply fulfilling relationship. You value connection, trust, and mutual growth.';
    } else if (score >= 50) {
      return 'Your reflections about $name suggest a meaningful relationship with strong foundations and clear areas for deeper connection.';
    } else if (score >= 25) {
      return 'Your reflections about $name reveal a relationship with both strengths and areas that may benefit from intentional attention.';
    }
    return 'Your reflections about $name highlight significant areas for growth together. Every relationship has potential when both people are willing to invest.';
  }

  String _overallSummaryTr(double score, String name) {
    if (score >= 75) {
      return '$name hakkındaki yansımalarınız derinden tatmin edici bir ilişki resmini çiziyor. Bağlantı, güven ve karşılıklı büyümeye değer veriyorsunuz.';
    } else if (score >= 50) {
      return '$name hakkındaki yansımalarınız güçlü temellere ve daha derin bağlantı için açık alanlara sahip anlamlı bir ilişki olduğunu gösteriyor.';
    } else if (score >= 25) {
      return '$name hakkındaki yansımalarınız hem güçlü yanları hem de kasıtlı ilgiden fayda görebilecek alanları olan bir ilişkiyi ortaya koyuyor.';
    }
    return '$name hakkındaki yansımalarınız birlikte büyüme için önemli alanları vurguluyor. Her iki kişi de yatırım yapmaya istekli olduğunda her ilişkinin potansiyeli vardır.';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _saveProfiles(List<CompatibilityProfile> profiles) async {
    await _prefs.setString(
      _profilesKey,
      jsonEncode(profiles.map((p) => p.toJson()).toList()),
    );
  }
}
