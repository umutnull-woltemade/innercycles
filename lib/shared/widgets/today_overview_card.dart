import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/moon_service.dart';

/// Personalized "Your Day" summary card for home dashboard
/// Creates daily anchor for retention - competitive advantage vs Co-Star
class TodayOverviewCard extends StatelessWidget {
  final String userName;
  final String sunSign;
  final String? moonSign;
  final String? risingSign;
  final VoidCallback? onTap;
  final VoidCallback? onTransitsTap;
  final VoidCallback? onDreamTap;

  const TodayOverviewCard({
    super.key,
    required this.userName,
    required this.sunSign,
    this.moonSign,
    this.risingSign,
    this.onTap,
    this.onTransitsTap,
    this.onDreamTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moonPhase = MoonService.getCurrentPhase();
    final moonInSign = MoonService.getCurrentMoonSign(DateTime.now());
    final greeting = _getTimeBasedGreeting();
    final todayEnergy = _getTodayEnergy(moonPhase.name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F0F1A),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF8F9FC),
                    const Color(0xFFF0F2F8),
                  ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AppColors.starGold.withOpacity(0.3)
                : AppColors.lightStarGold.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withOpacity(isDark ? 0.15 : 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Greeting + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Today's Energy Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        todayEnergy.color.withOpacity(0.3),
                        todayEnergy.color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: todayEnergy.color.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        todayEnergy.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        todayEnergy.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: todayEnergy.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Moon Phase + Current Transit
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Moon Phase Visual
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.moonSilver,
                          AppColors.moonSilver.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.moonSilver.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        moonPhase.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ay $moonInSign Burcunda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          moonPhase.nameTr,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getMoonMessage(moonPhase.name, moonInSign.nameTr),
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Action Cards
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.auto_awesome,
                    label: 'Bugünün\nTransitleri',
                    color: AppColors.auroraStart,
                    onTap: onTransitsTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.nightlight_round,
                    label: 'Rüyanı\nKaydet',
                    color: AppColors.mystic,
                    onTap: onDreamTap,
                    showBadge: true,
                    badgeText: 'Yeni',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Today's Focus (Personalized)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.starGold.withOpacity(0.15),
                    AppColors.starGold.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.starGold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bugünün Odak Noktası',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getDailyFocus(sunSign, moonInSign.nameTr),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom CTA
            Center(
              child: Text(
                'Detaylı günlük yorumun için dokun',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'GECE YARISI';
    if (hour < 12) return 'GUNAYDIN';
    if (hour < 17) return 'IYI GUNLER';
    if (hour < 21) return 'IYI AKSAMLAR';
    return 'IYI GECELER';
  }

  _TodayEnergy _getTodayEnergy(String moonPhase) {
    switch (moonPhase.toLowerCase()) {
      case 'new moon':
        return _TodayEnergy(
          'Yeni Baslangiclarin Gunui',
          AppColors.mysticBlue,
          'seed',
        );
      case 'waxing crescent':
        return _TodayEnergy('Buyume Enerjisi', AppColors.success, 'sprout');
      case 'first quarter':
        return _TodayEnergy('Aksiyon Zamani', AppColors.fireElement, 'fire');
      case 'waxing gibbous':
        return _TodayEnergy('Gelistirme Gunui', AppColors.auroraStart, 'star');
      case 'full moon':
        return _TodayEnergy('Dolunay Gucui', AppColors.starGold, 'moon');
      case 'waning gibbous':
        return _TodayEnergy('Minnet Zamani', AppColors.venusColor, 'heart');
      case 'last quarter':
        return _TodayEnergy('Serbest Birakma', AppColors.waterElement, 'water');
      case 'waning crescent':
        return _TodayEnergy('Dinlenme Donemii', AppColors.moonSilver, 'rest');
      default:
        return _TodayEnergy('Kozmik Enerji', AppColors.cosmic, 'sparkle');
    }
  }

  String _getMoonMessage(String phase, String sign) {
    final messages = {
      'Koc': 'Cesur adimlar atmak icin ideal.',
      'Boga': 'Konfor ve istikrar arayin.',
      'Ikizler': 'Iletisim ve ogrenmee gunui.',
      'Yengec': 'Duygusal derinlik zamani.',
      'Aslan': 'Yaraticilik ve ifade gunui.',
      'Basak': 'Detaylara odaklanin.',
      'Terazi': 'Denge ve uyum arayin.',
      'Akrep': 'Donusum enerjisi yuksek.',
      'Yay': 'Macera ve keşif zamani.',
      'Oglak': 'Hedeflere odaklanin.',
      'Kova': 'Yenilikci fikirler icin acik olun.',
      'Balik': 'Sezgilerinize guvenin.',
    };
    return messages[sign] ?? 'Evrenin enerjisiyle uyum icinde kalin.';
  }

  String _getDailyFocus(String sunSign, String moonSign) {
    // Simplified personalized focus based on sun sign and current moon
    final focuses = {
      'aries':
          'Bugün enerjin yüksek. Ertelediğin bir projeyi başlatmak için mükemmel zaman.',
      'taurus':
          'Maddi konularda netlik günü. Bütçeni gözden geçir, küçük bir keyif al.',
      'gemini':
          'İletişim kanalların açık. Önemli bir konuşma için ideal atmosfer.',
      'cancer': 'Ev ve aile odaklı enerji. Yakınlarınla kaliteli zaman geçir.',
      'leo': 'Yaratıcılığın dorukta. Kendini ifade etmekten çekinme.',
      'virgo': 'Detaylara dikkat günü. Organize ol, listeler yap.',
      'libra': 'İlişkilerde denge ara. Bir uzlaşma noktası bul.',
      'scorpio': 'Derinlere dal. Bilinçaltından gelen mesajlara kulak ver.',
      'sagittarius': 'Öğrenme ve keşif enerjisi. Yeni bir şey öğren.',
      'capricorn': 'Kariyer odaklı gün. Uzun vadeli hedeflerine odaklan.',
      'aquarius': 'Sosyal bağlantılar güçlü. Topluluk aktivitelerine katıl.',
      'pisces': 'Sezgisel enerji yüksek. Meditasyon ve hayal kurma zamanı.',
    };
    return focuses[sunSign.toLowerCase()] ??
        'Bugün evrenin enerjisiyle uyum içinde kal.';
  }
}

class _TodayEnergy {
  final String label;
  final Color color;
  final String emoji;

  _TodayEnergy(this.label, this.color, String type) : emoji = _getEmoji(type);

  static String _getEmoji(String type) {
    switch (type) {
      case 'seed':
        return '🌱';
      case 'sprout':
        return '🌿';
      case 'fire':
        return '🔥';
      case 'star':
        return '⭐';
      case 'moon':
        return '🌕';
      case 'heart':
        return '💜';
      case 'water':
        return '💧';
      case 'rest':
        return '🌙';
      default:
        return '✨';
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool showBadge;
  final String? badgeText;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: color.withOpacity(0.7),
                ),
              ],
            ),
          ),
          if (showBadge && badgeText != null)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
