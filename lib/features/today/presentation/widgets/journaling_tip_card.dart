import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Shows a rotating daily journaling tip — practical micro-advice
/// that teaches users how to get more from their journaling practice.
/// Dismissable per-day, rotates deterministically by day of year.
class JournalingTipCard extends StatefulWidget {
  final bool isEn;
  final bool isDark;

  const JournalingTipCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  State<JournalingTipCard> createState() => _JournalingTipCardState();
}

class _JournalingTipCardState extends State<JournalingTipCard> {
  static const _dismissKeyPrefix = 'tip_dismissed_';
  bool _dismissed = false;
  bool _loaded = false;

  late final int _dayOfYear;
  late final String _dismissKey;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    _dismissKey = '$_dismissKeyPrefix${now.year}_$_dayOfYear';
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _dismissed = prefs.getBool(_dismissKey) == true;
        _loaded = true;
      });
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissKey, true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    final tip = _tips[_dayOfYear % _tips.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.amethyst.withValues(alpha: widget.isDark ? 0.07 : 0.05),
          border: Border.all(
            color: AppColors.amethyst.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: AppColors.amethyst.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEn ? 'Journaling Tip' : 'Günlük İpucu',
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.amethyst.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isEn ? tip.textEn : tip.textTr,
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: widget.isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _dismiss();
              },
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: widget.isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 450.ms, duration: 300.ms);
  }
}

class _Tip {
  final String textEn;
  final String textTr;
  const _Tip(this.textEn, this.textTr);
}

const _tips = [
  _Tip(
    'Write without editing. Let your thoughts flow freely for the first few minutes.',
    'Düzenlemeden yaz. İlk birkaç dakika düşüncelerinin serbestçe akmasına izin ver.',
  ),
  _Tip(
    'Try naming your emotion with a specific word instead of "good" or "bad".',
    '"İyi" veya "kötü" yerine duyguna özel bir isim vermeyi dene.',
  ),
  _Tip(
    'Start with "Right now I feel..." when you don\'t know what to write.',
    'Ne yazacağını bilmediğinde "Şu an hissediyorum ki..." ile başla.',
  ),
  _Tip(
    'Notice physical sensations. Where in your body do you feel today\'s emotion?',
    'Bedensel hislere dikkat et. Bugünkü duygunu vücudunun neresinde hissediyorsun?',
  ),
  _Tip(
    'Write about one moment from today that stands out, no matter how small.',
    'Bugünden öne çıkan tek bir an hakkında yaz, ne kadar küçük olursa olsun.',
  ),
  _Tip(
    'Ask yourself: "What would I tell a friend who felt this way?"',
    'Kendine sor: "Bu şekilde hisseden bir arkadaşıma ne söylerdim?"',
  ),
  _Tip(
    'Try writing from a third-person perspective about your day.',
    'Gününü üçüncü şahıs bakış açısından yazmayı dene.',
  ),
  _Tip(
    'End your entry with one thing you\'re looking forward to tomorrow.',
    'Kaydını yarın için sabırsızlandığın bir şeyle bitir.',
  ),
  _Tip(
    'Describe what you see, hear, and smell right now. Ground yourself in the present.',
    'Şu an gördüklerini, duyduklarını ve kokladıklarını tanımla. Kendini şimdiki zamanda topla.',
  ),
  _Tip(
    'Rate your energy, not just your mood. They often tell different stories.',
    'Sadece ruh halini değil, enerjini de değerlendir. Çoğu zaman farklı hikayeler anlatırlar.',
  ),
  _Tip(
    'Write a letter to your future self about how you feel today.',
    'Bugün nasıl hissettiğin hakkında gelecekteki kendine bir mektup yaz.',
  ),
  _Tip(
    'When you notice a pattern repeating, pause and ask: "What need is driving this?"',
    'Bir kalıbın tekrarlandığını fark ettiğinde dur ve sor: "Bunu hangi ihtiyaç tetikliyor?"',
  ),
  _Tip(
    'Write about a decision you\'re avoiding. Sometimes clarity comes from putting it on paper.',
    'Ertelediğin bir karar hakkında yaz. Bazen netlik kağıda dökmekle gelir.',
  ),
  _Tip(
    'Instead of "I had a bad day," try listing three specific things that happened.',
    '"Kötü bir gün geçirdim" yerine, olan üç belirli şeyi listelemeyi dene.',
  ),
  _Tip(
    'Gratitude journaling works best when you write *why* something mattered, not just what.',
    'Şükür günlüğü en iyi neyin değil, *neden* önemli olduğunu yazdığında işe yarar.',
  ),
  _Tip(
    'Try journaling at the same time each day. Consistency builds deeper reflection.',
    'Her gün aynı saatte yazmayı dene. Tutarlılık daha derin yansıma oluşturur.',
  ),
  _Tip(
    'Write about what surprised you today. Surprises reveal what you expected.',
    'Bugün seni neyin şaşırttığını yaz. Sürprizler beklentilerini ortaya koyar.',
  ),
  _Tip(
    'If you\'re stuck, describe your current surroundings in detail for 2 minutes.',
    'Takıldıysan, 2 dakika boyunca mevcut çevreni ayrıntılı olarak tanımla.',
  ),
  _Tip(
    'Track your sleep alongside mood. Small connections become visible over time.',
    'Ruh halinin yanında uykunu da takip et. Küçük bağlantılar zamanla görünür hale gelir.',
  ),
  _Tip(
    'Re-read an old entry. You\'ll be surprised how much you\'ve changed.',
    'Eski bir kaydı tekrar oku. Ne kadar değiştiğine şaşıracaksın.',
  ),
  _Tip(
    'Write about what you\'re resisting right now. Resistance often points to growth.',
    'Şu an neye direndiğini yaz. Direnç genellikle büyümeye işaret eder.',
  ),
  _Tip(
    'Use "I notice..." statements to observe your thoughts without judgment.',
    'Düşüncelerini yargılamadan gözlemlemek için "Fark ediyorum ki..." ifadelerini kullan.',
  ),
  _Tip(
    'Your journal is private. Write the thing you wouldn\'t say out loud.',
    'Günlüğün özel. Yüksek sesle söylemeyeceğin şeyi yaz.',
  ),
  _Tip(
    'After a hard day, write three things that went well, even if they were tiny.',
    'Zor bir günün ardından, küçük de olsa iyi giden üç şey yaz.',
  ),
  _Tip(
    'Describe your ideal day in vivid detail. What would change from today?',
    'İdeal gününü canlı detaylarla tanımla. Bugünden ne değişirdi?',
  ),
  _Tip(
    'Notice your inner critic. Write its words, then write a kind response.',
    'İç eleştirmenini fark et. Onun sözlerini yaz, sonra nazik bir yanıt yaz.',
  ),
  _Tip(
    'Focus on one small win today. Progress matters more than perfection.',
    'Bugünkü küçük bir kazanıma odaklan. İlerleme mükemmellikten daha önemlidir.',
  ),
  _Tip(
    'Write about someone who influenced your mood today. Relationships shape our inner world.',
    'Bugün ruh halini etkileyen biri hakkında yaz. İlişkiler iç dünyamızı şekillendirir.',
  ),
  _Tip(
    'Before bed, write one sentence about what you\'ll release and one about what you\'ll carry.',
    'Yatmadan önce, bırakacağın bir şey ve taşıyacağın bir şey hakkında birer cümle yaz.',
  ),
  _Tip(
    'Your patterns page unlocks after a week of entries. Consistency reveals insights.',
    'Örüntüler sayfası bir haftalık kayıttan sonra açılır. Tutarlılık içgörüleri ortaya çıkarır.',
  ),
];
