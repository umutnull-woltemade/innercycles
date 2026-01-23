import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ai_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Dream Interpretation Screen with AI-like Chatbot
/// Provides mystical dream interpretations based on user's zodiac sign
class DreamInterpretationScreen extends ConsumerStatefulWidget {
  const DreamInterpretationScreen({super.key});

  @override
  ConsumerState<DreamInterpretationScreen> createState() =>
      _DreamInterpretationScreenState();
}

class _DreamInterpretationScreenState
    extends ConsumerState<DreamInterpretationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _dreamController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _pulseController;

  // APEX Dream Intelligence Engine State
  DreamInterpretationSession? _currentSession;
  int _currentQuestionIndex = 0;
  final Map<String, String> _contextAnswers = {};
  bool _awaitingAnswer = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Add welcome message
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _dreamController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;

    setState(() {
      _messages.add(ChatMessage(
        text:
            'Merhaba, ben Ruya Yorumcusu. ${sign.nameTr} burcunun kozmik enerjisiyle ruyalarini yorumlamak icin buradayim.\n\n'
            'Gordugün ruyayi detayli bir sekilde anlat. Ne gordun? Neler hissettin? '
            'Ruyandaki semboller, renkler ve duygular hakkinda ne kadar cok bilgi verirsen, '
            'yorumum o kadar derin olacak.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage() async {
    final text = _dreamController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _dreamController.clear();
    _scrollToBottom();

    // Check if we're awaiting an answer to a context question
    if (_awaitingAnswer && _currentSession != null) {
      await _handleContextAnswer(text);
    } else {
      // Start new dream interpretation with APEX approach
      await _startApexInterpretation(text);
    }
  }

  /// APEX Step 1: Acknowledge symbol and ask context questions
  Future<void> _startApexInterpretation(String dreamText) async {
    final userProfile = ref.read(userProfileProvider);
    final aiService = ref.read(aiContentServiceProvider);

    try {
      // Start session
      final session = await aiService.startDreamInterpretation(
        dreamDescription: dreamText,
        userSign: userProfile?.sunSign,
      );

      _currentSession = session;
      _currentQuestionIndex = 0;
      _contextAnswers.clear();

      // Add acknowledgment message
      final acknowledgment = aiService.getDreamAcknowledgment(session.dreamSymbol);

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: acknowledgment,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();

      // Ask first context question after delay
      if (session.contextQuestions.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          _messages.add(ChatMessage(
            text: session.contextQuestions[0],
            isUser: false,
            timestamp: DateTime.now(),
            isQuestion: true,
          ));
          _awaitingAnswer = true;
        });
        _scrollToBottom();
      } else {
        // No questions, generate interpretation directly
        await _generateApexInterpretation();
      }
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: 'Bir sorun olustu. Lutfen tekrar dene.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  /// APEX Step 2: Handle context answers
  Future<void> _handleContextAnswer(String answer) async {
    if (_currentSession == null) return;

    final question = _currentSession!.contextQuestions[_currentQuestionIndex];
    _contextAnswers[question] = answer;

    // Check if more questions
    if (_currentQuestionIndex < _currentSession!.contextQuestions.length - 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isTyping = false;
        _currentQuestionIndex++;
        _messages.add(ChatMessage(
          text: _currentSession!.contextQuestions[_currentQuestionIndex],
          isUser: false,
          timestamp: DateTime.now(),
          isQuestion: true,
        ));
      });
      _scrollToBottom();
    } else {
      // All questions answered, generate interpretation
      setState(() {
        _awaitingAnswer = false;
      });
      await _generateApexInterpretation();
    }
  }

  /// APEX Step 3 & 4: Generate conditional interpretation
  Future<void> _generateApexInterpretation() async {
    if (_currentSession == null) return;

    final userProfile = ref.read(userProfileProvider);
    final aiService = ref.read(aiContentServiceProvider);

    setState(() {
      _isTyping = true;
    });

    try {
      final interpretedSession = await aiService.interpretDream(
        session: _currentSession!,
        contextAnswers: _contextAnswers,
        userSign: userProfile?.sunSign,
      );

      _currentSession = interpretedSession;

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: interpretedSession.interpretation ?? 'Yorum olusturulamadi.',
          isUser: false,
          timestamp: DateTime.now(),
          isInterpretation: true,
        ));
      });
      _scrollToBottom();

      // Add follow-up message
      await Future.delayed(const Duration(milliseconds: 1500));
      setState(() {
        _messages.add(ChatMessage(
          text: 'Baska bir ruya paylasmak istersen, dinlemeye hazirim.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();

    } catch (e) {
      // Fallback to local interpretation
      _generateInterpretation(_currentSession!.dreamSymbol);
    }
  }

  // Keep the original method as fallback
  void _sendMessageLegacy() {
    final text = _dreamController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _dreamController.clear();
    _scrollToBottom();

    // Simulate AI thinking time
    Future.delayed(const Duration(milliseconds: 1500), () {
      _generateInterpretation(text);
    });
  }

  void _generateInterpretation(String dreamText) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;

    // Generate interpretation based on dream content and zodiac
    final interpretation = _interpretDream(dreamText, sign);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: interpretation,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();
  }

  String _interpretDream(String dreamText, zodiac.ZodiacSign sign) {
    final lowerDream = dreamText.toLowerCase();

    // Analyze dream themes
    final themes = <String, String>{};

    // Water themes
    if (lowerDream.contains('su') ||
        lowerDream.contains('deniz') ||
        lowerDream.contains('okyanus') ||
        lowerDream.contains('nehir') ||
        lowerDream.contains('yagmur')) {
      themes['water'] = _getWaterInterpretation(sign);
    }

    // Flying themes
    if (lowerDream.contains('ucmak') ||
        lowerDream.contains('uctum') ||
        lowerDream.contains('ucuyordum') ||
        lowerDream.contains('havada')) {
      themes['flying'] = _getFlyingInterpretation(sign);
    }

    // Falling themes
    if (lowerDream.contains('dusmek') ||
        lowerDream.contains('dustum') ||
        lowerDream.contains('dusuyordum') ||
        lowerDream.contains('ucurum')) {
      themes['falling'] = _getFallingInterpretation(sign);
    }

    // Death/Transformation themes
    if (lowerDream.contains('olum') ||
        lowerDream.contains('oldum') ||
        lowerDream.contains('oldu') ||
        lowerDream.contains('cenaze')) {
      themes['death'] = _getDeathInterpretation(sign);
    }

    // Chase themes
    if (lowerDream.contains('kovalamak') ||
        lowerDream.contains('kacmak') ||
        lowerDream.contains('takip') ||
        lowerDream.contains('kaciyordum')) {
      themes['chase'] = _getChaseInterpretation(sign);
    }

    // Animal themes
    if (lowerDream.contains('yilan') ||
        lowerDream.contains('kopek') ||
        lowerDream.contains('kedi') ||
        lowerDream.contains('hayvan') ||
        lowerDream.contains('kus')) {
      themes['animal'] = _getAnimalInterpretation(sign);
    }

    // House/Building themes
    if (lowerDream.contains('ev') ||
        lowerDream.contains('bina') ||
        lowerDream.contains('oda') ||
        lowerDream.contains('kapi')) {
      themes['house'] = _getHouseInterpretation(sign);
    }

    // Love/Relationship themes
    if (lowerDream.contains('ask') ||
        lowerDream.contains('sevgili') ||
        lowerDream.contains('opusmek') ||
        lowerDream.contains('iliski')) {
      themes['love'] = _getLoveInterpretation(sign);
    }

    // Money/Wealth themes
    if (lowerDream.contains('para') ||
        lowerDream.contains('altin') ||
        lowerDream.contains('zengin') ||
        lowerDream.contains('hazine')) {
      themes['money'] = _getMoneyInterpretation(sign);
    }

    // Build final interpretation
    final buffer = StringBuffer();

    if (themes.isEmpty) {
      // Generic interpretation based on zodiac
      buffer.writeln(_getGenericInterpretation(sign, dreamText));
    } else {
      buffer.writeln('${sign.symbol} ${sign.nameTr} burcunun kozmik perspektifinden ruya yorumun:\n');

      for (final entry in themes.entries) {
        buffer.writeln(entry.value);
        buffer.writeln();
      }

      buffer.writeln(_getZodiacAdvice(sign));
    }

    return buffer.toString().trim();
  }

  String _getWaterInterpretation(zodiac.ZodiacSign sign) {
    final interpretations = {
      zodiac.ZodiacSign.aries:
          'Su, ates burcun icin duygusal derinliklere inmeye cagri. Bilincdisi enerjilerin yuzeyе cikmak istiyor. Sabir ve dinlenme zamani.',
      zodiac.ZodiacSign.taurus:
          'Su, toprak burcun icin bereket ve bollugun sembolü. Maddi ve duygusal akis hayatina giriyor. Dogal ritmine güven.',
      zodiac.ZodiacSign.gemini:
          'Su, hava burcun icin duyguların mantıkla bulusmasi. Ic sesin sana ne söylediğine kulak ver. Iletisimde daha derin ol.',
      zodiac.ZodiacSign.cancer:
          'Su senin elementi - bu ruya cok güclü! Ev, aile ve köklerİnle derin bir baglantiyi isaret ediyor. Içsel huzuru bul.',
      zodiac.ZodiacSign.leo:
          'Su, ates burcun icin yaratici enerjilerin akisi. Duygusal ifade ve sanatsal yeteneklerin one cikiyor.',
      zodiac.ZodiacSign.virgo:
          'Su, toprak burcun icin arınma ve iyilesme. Detaylara takılmak yerine akisa bırak. Bedensel sagliga dikkat.',
      zodiac.ZodiacSign.libra:
          'Su, hava burcun icin iliskilerde denge arayisi. Duygusal dengeyi bulmak icin partnerlİklerine odaklan.',
      zodiac.ZodiacSign.scorpio:
          'Su senin elementi - bu ruya transformasyonu isaret ediyor! Derin donusum süreci basliyor. Yenilenme zamani.',
      zodiac.ZodiacSign.sagittarius:
          'Su, ates burcun icin ruhsal yolculuk. Felsefi derinlikler ve manevi arayis seni bekliyor.',
      zodiac.ZodiacSign.capricorn:
          'Su, toprak burcun icin duygusal engellerin erİmesi. Sert kabuğunu yumusatma zamani. Savunmasizlik güctür.',
      zodiac.ZodiacSign.aquarius:
          'Su, hava burcun icin kollektif bilinc baglantisi. Insanliga hizmet ve duygusal zeka gelistirme zamani.',
      zodiac.ZodiacSign.pisces:
          'Su senin elementi - spiritüel alemlerle baglanti cok güclü! Sezgilerine tamamen güvenebilirsin. Yaratici ilham akiyor.',
    };
    return interpretations[sign] ?? interpretations[zodiac.ZodiacSign.aries]!;
  }

  String _getFlyingInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Ucmak, özgürlük ve sınırları asma arzusunu temsil eder. '
        '${sign.nameTr} enerjinle, bu ruya sana hayatında yeni zirveler fethetme potansiyelini gösteriyor. '
        'Kendini sınırlayan inanclardan kurtulma zamanı geldi.';
  }

  String _getFallingInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Düsmek, kontrolü kaybetme korkusunu ya da hayatındaki bir alanda güvensizligi yansıtır. '
        '${sign.nameTr} olarak, temellendirme calismalarına odaklan. '
        'Bu ruya, sana "yere sag basmalısın" mesajı veriyor olabilir.';
  }

  String _getDeathInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Ruyalarda ölum, transformasyonun ve yeni baslangiclarin sembolüdür - korkulacak bir sey degil! '
        '${sign.nameTr} icin bu, eski kaliplarin ölmesi ve yeni benligin dogması anlamına gelir. '
        'Hayatında neyi bırakman gerektigini düsün.';
  }

  String _getChaseInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Kovalanmak, hayatinda kactIgIn bir konuyla yüzlesme cagrisI. '
        '${sign.nameTr} enerjinle, cesaretle dön ve neyin pesinde oldugunu sor. '
        'Genellikle kaçtığımız sey, en cok ihtiyacımız olan derslerdir.';
  }

  String _getAnimalInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Hayvanlar, icgüdüsel dogamızı ve bastırılmıs enerjileri temsil eder. '
        '${sign.nameTr} icin bu ruya, dogal iç güdülerinle yeniden bağlanma cagrisi. '
        'Hangi hayvan gördüysen, onun totem enerjisini arastir.';
  }

  String _getHouseInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Ev ve binalar, ruhsal yapını ve iç dünyanı sembolize eder. '
        'Odalr, benliginin farklI yönlerini temsil eder. '
        '${sign.nameTr} olarak, hangi "oda"ya girmekten kacIndIgInI düsün.';
  }

  String _getLoveInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Ask temalı ruyalar, iliski dinamiklerini ve duygusal ihtiyacları yansıtır. '
        '${sign.nameTr} icin bu, ask hayatında yeni bir dönemin habercisi olabilir. '
        'Kendinle olan iliskim nasıl sorusunu sor.';
  }

  String _getMoneyInterpretation(zodiac.ZodiacSign sign) {
    return '${sign.symbol} Para ve zenginlik ruyaları, özdeğer ve bolluk bilincini temsil eder. '
        '${sign.nameTr} icin bu ruya, maddi dünyayla iliskini sorgulamaya davet. '
        'Gerçek zenginlik içsel huzur ve minnettarlıktır.';
  }

  String _getGenericInterpretation(zodiac.ZodiacSign sign, String dreamText) {
    return '${sign.symbol} ${sign.nameTr} burcunun kozmik perspektifinden:\n\n'
        'Anlattıgın ruya, bilincaltinin sana önemli mesajlar ilettigini gösteriyor. '
        '${sign.element.nameTr} elementinin enerjisiyle, bu ruyanin temel mesaji '
        '${_getElementMessage(sign)} ile ilgili görünüyor.\n\n'
        'Ruyandaki duygulara odaklan - korku, mutluluk, saskinlik... '
        'Bu duygular, uyanik hayatinda hangi alanlarla resonans yapiyor?\n\n'
        '${_getZodiacAdvice(sign)}';
  }

  String _getElementMessage(zodiac.ZodiacSign sign) {
    switch (sign.element) {
      case zodiac.Element.fire:
        return 'tutku, aksiyon ve yaratici güc';
      case zodiac.Element.earth:
        return 'güvenlik, maddi dünya ve pratik adimlar';
      case zodiac.Element.air:
        return 'iletisim, fikirler ve sosyal baglantilar';
      case zodiac.Element.water:
        return 'duygular, sezgi ve ruhsal derinlik';
    }
  }

  String _getZodiacAdvice(zodiac.ZodiacSign sign) {
    final advice = {
      zodiac.ZodiacSign.aries:
          'Tavsiyem: Sabah uyandığında ilk düsüncelerini not al. Ates enerjin, bilinçaltı mesajları hızla unutturabilir.',
      zodiac.ZodiacSign.taurus:
          'Tavsiyem: Ruyalarını bir ruya defterine yaz. Toprak enerjin, somut kayıtlarla daha iyi çalısır.',
      zodiac.ZodiacSign.gemini:
          'Tavsiyem: Rüyanı birine anlat. Hava enerjin, sözel ifadeyle anlam bulmayı sever.',
      zodiac.ZodiacSign.cancer:
          'Tavsiyem: Ay fazlarına dikkat et. Dolunay ve yeniay zamanları ruyaların daha güçlü olacak.',
      zodiac.ZodiacSign.leo:
          'Tavsiyem: Rüyalarını yaratıcı bir sekilde ifade et - çiz, yaz, paylas. Ates enerjin ifadeyi sever.',
      zodiac.ZodiacSign.virgo:
          'Tavsiyem: Ruya sembolleri listesi tut. Toprak enerjin, sistematik analizi takdir eder.',
      zodiac.ZodiacSign.libra:
          'Tavsiyem: Rüyalarındaki iliskilere odaklan. Hava enerjin, sosyal dinamiklerden ders çıkarır.',
      zodiac.ZodiacSign.scorpio:
          'Tavsiyem: Derin meditasyon yap. Su enerjin, bilincalti derinliklerine dalmak icin cok güclü.',
      zodiac.ZodiacSign.sagittarius:
          'Tavsiyem: Rüyalarını felsefi açıdan yorumla. Ates enerjin, büyük resmi görmeyi sever.',
      zodiac.ZodiacSign.capricorn:
          'Tavsiyem: Ruyalarini pratik yaşama nasıl uygularsın düsün. Toprak enerjin, somut sonuclar ister.',
      zodiac.ZodiacSign.aquarius:
          'Tavsiyem: Ruya toplulukarina katıl. Hava enerjin, kolektif bilgelikten beslenİr.',
      zodiac.ZodiacSign.pisces:
          'Tavsiyem: Uyumadan önce niyet koy. Su enerjin, spiritüel rehberlikle doğrudan bağlanabilir.',
    };
    return advice[sign] ?? advice[zodiac.ZodiacSign.aries]!;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildChatArea(),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.mystic.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          // Animated dream icon
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.mystic.withOpacity(0.5 + _pulseController.value * 0.3),
                      AppColors.nebulaPurple.withOpacity(0.3),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mystic.withOpacity(0.4 * _pulseController.value),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  '\u{1F319}', // Crescent moon emoji
                  style: TextStyle(fontSize: 24),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruya Yorumcusu',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Ruyalarinin gizemini coz',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          // Quick symbols button
          IconButton(
            onPressed: () => _showDreamSymbolsSheet(context),
            icon: const Icon(Icons.auto_stories, color: AppColors.starGold),
            tooltip: 'Ruya Sembolleri',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index], index);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic.withOpacity(0.5),
                    AppColors.nebulaPurple.withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Text('\u{1F319}', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isUser
                      ? [
                          AppColors.cosmicPurple.withOpacity(0.4),
                          AppColors.nebulaPurple.withOpacity(0.3),
                        ]
                      : [
                          AppColors.mystic.withOpacity(0.2),
                          const Color(0xFF1A1A2E).withOpacity(0.8),
                        ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: isUser
                      ? AppColors.cosmicPurple.withOpacity(0.3)
                      : AppColors.mystic.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? AppColors.cosmicPurple : AppColors.mystic)
                        .withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isInterpretation) ...[
                    Row(
                      children: [
                        const Text('\u{2728}', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          'RUYA YORUMU',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (message.isQuestion) ...[
                    Row(
                      children: [
                        const Text('\u{2753}', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          'SORU',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.mystic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms).slideX(
          begin: isUser ? 0.2 : -0.2,
          end: 0,
          duration: 300.ms,
          delay: (50 * index).ms,
        );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mystic.withOpacity(0.5),
                  AppColors.nebulaPurple.withOpacity(0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('\u{1F319}', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.mystic.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.mystic.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: const Text('\u{2728}', style: TextStyle(fontSize: 14)),
                )
                    .animate(
                      onComplete: (controller) => controller.repeat(),
                    )
                    .fadeIn(duration: 400.ms, delay: (200 * index).ms)
                    .then()
                    .fadeOut(duration: 400.ms, delay: 400.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.nebulaPurple.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick answer buttons when awaiting context answer
          if (_awaitingAnswer && _currentSession != null) _buildQuickAnswers(),
          Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic.withOpacity(0.15),
                    const Color(0xFF1A1A2E).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.mystic.withOpacity(0.3),
                ),
              ),
              child: TextField(
                controller: _dreamController,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Ruyani anlat...',
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mystic,
                    AppColors.cosmicPurple,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mystic.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          )
              .animate(
                onComplete: (controller) => controller.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 1500.ms,
              ),
        ],
      ),
        ],
      ),
    );
  }

  /// Quick answer buttons for context questions
  Widget _buildQuickAnswers() {
    if (_currentSession == null || _currentQuestionIndex >= _currentSession!.contextQuestions.length) {
      return const SizedBox.shrink();
    }

    final currentQuestion = _currentSession!.contextQuestions[_currentQuestionIndex].toLowerCase();
    List<String> quickAnswers = [];

    // Generate contextual quick answers based on question
    if (currentQuestion.contains('korku') ||
        currentQuestion.contains('duygu') ||
        currentQuestion.contains('hissett')) {
      quickAnswers = ['Korku hissettim', 'Huzur hissettim', 'Merak duydum', 'Belirsiz bir his'];
    } else if (currentQuestion.contains('ortam') ||
               currentQuestion.contains('nerede') ||
               currentQuestion.contains('gorunuyordu')) {
      quickAnswers = ['Evde', 'Dogada', 'Tanimadik bir yer', 'Karanlik bir ortam'];
    } else if (currentQuestion.contains('kim') ||
               currentQuestion.contains('baska')) {
      quickAnswers = ['Yalnizdim', 'Tanidik biri vardi', 'Yabancilar vardi', 'Hatirlamiyorum'];
    } else if (currentQuestion.contains('dogru') ||
               currentQuestion.contains('sana')) {
      quickAnswers = ['Evet', 'Hayir', 'Emin degilim'];
    } else {
      quickAnswers = ['Evet', 'Hayir', 'Emin degilim', 'Hatirlamiyorum'];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: quickAnswers.map((answer) => InkWell(
          onTap: () {
            _dreamController.text = answer;
            _sendMessage();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cosmicPurple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.cosmicPurple.withOpacity(0.5),
              ),
            ),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  void _showDreamSymbolsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _DreamSymbolsSheet(),
    );
  }
}

/// Chat message model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isQuestion;
  final bool isInterpretation;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isQuestion = false,
    this.isInterpretation = false,
  });
}

/// Dream symbols reference sheet
class _DreamSymbolsSheet extends StatelessWidget {
  const _DreamSymbolsSheet();

  @override
  Widget build(BuildContext context) {
    final symbols = [
      {'emoji': '\u{1F40D}', 'name': 'Yilan', 'meaning': 'Donusum, iyilesme, gizli korkular'},
      {'emoji': '\u{1F30A}', 'name': 'Su', 'meaning': 'Duygular, bilincalti, arinma'},
      {'emoji': '\u{1F525}', 'name': 'Ates', 'meaning': 'Tutku, ofke, donusum'},
      {'emoji': '\u{1F3E0}', 'name': 'Ev', 'meaning': 'Benlik, guvenlik, aile'},
      {'emoji': '\u{2708}', 'name': 'Ucmak', 'meaning': 'Ozgurluk, yukselis, kacis'},
      {'emoji': '\u{1F319}', 'name': 'Ay', 'meaning': 'Sezgi, kadinsi enerji, donguler'},
      {'emoji': '\u{2600}', 'name': 'Gunes', 'meaning': 'Bilinc, basari, erkeksi enerji'},
      {'emoji': '\u{1F480}', 'name': 'Olum', 'meaning': 'Transformasyon, son, yeni baslangic'},
      {'emoji': '\u{1F436}', 'name': 'Kopek', 'meaning': 'Sadakat, koruma, dostluk'},
      {'emoji': '\u{1F431}', 'name': 'Kedi', 'meaning': 'Bagimsizlik, sezgi, gizemlilik'},
      {'emoji': '\u{1F4B0}', 'name': 'Para', 'meaning': 'Ozdeger, bolluk, guvenlik'},
      {'emoji': '\u{2764}', 'name': 'Ask', 'meaning': 'Baglanma, arzu, kabul'},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.nebulaPurple,
            const Color(0xFF0D0D1A),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('\u{1F52E}', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Text(
                  'Ruya Sembolleri Rehberi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Symbols grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: symbols.length,
              itemBuilder: (context, index) {
                final symbol = symbols[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.mystic.withOpacity(0.2),
                        const Color(0xFF1A1A2E).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.mystic.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        symbol['emoji']!,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              symbol['name']!,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              symbol['meaning']!,
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.8),
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
