import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/entertainment_disclaimer.dart';

/// Kader Sayısı Nedir? - AI-First Canonical Sayfa
class DestinyNumberScreen extends ConsumerWidget {
  const DestinyNumberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final color = const Color(0xFFE91E63);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D0D1A), const Color(0xFF1A0A15)]
                : [const Color(0xFFFFF5F8), const Color(0xFFFFE8EF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white70 : AppColors.textDark),
                ),
                const SizedBox(height: 24),
                Text(
                  'Kader sayısı nedir?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textDark, height: 1.2),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                _buildTag('Numeroloji', color),
                const SizedBox(height: 32),

                _buildSection(isDark, 'Kısa Cevap', color, [
                  'Kader sayısı, tam adından hesaplanan numerolojik değerdir.',
                  'Bu hayatta neyi başarmak için geldiğini gösterir.',
                  'İfade sayısı olarak da bilinir.',
                ]),
                const SizedBox(height: 28),

                _buildSection(isDark, 'Nasıl Hesaplanır?', color, [
                  'Tam adının her harfine bir sayı karşılığı atanır.',
                  'A=1, B=2, C=3... şeklinde devam eder.',
                  'Tüm harflerin sayıları toplanır ve tek haneye indirgenir.',
                ]),
                const SizedBox(height: 28),

                _buildNumberChart(isDark),
                const SizedBox(height: 28),

                _buildSection(isDark, 'Ne Anlatır?', color, [
                  'Bu hayatta ifade etmen gereken enerjiyi.',
                  'Potansiyelini en iyi nasıl kullanacağını.',
                  'Dünyaya ne katmak için geldiğini.',
                  'Doğal yeteneklerinin yönünü.',
                ]),
                const SizedBox(height: 28),

                _buildSection(isDark, 'Yaşam Yolundan Farkı', color, [
                  'Yaşam yolu: Yürüdüğün yol.',
                  'Kader sayısı: Ulaşmak istediğin hedef.',
                  'İkisi birlikte tam resmi oluşturur.',
                ]),
                const SizedBox(height: 32),

                _buildSuggestion(context, isDark, language, '🔢', 'Yaşam yolu sayısı nedir?', Routes.numerology),
                const SizedBox(height: 40),

                const PageFooterWithDisclaimer(
                  brandText: 'Numeroloji — Venus One',
                  disclaimerText: DisclaimerTexts.numerology,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberChart(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harf-Sayı Tablosu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLetterChip('A,J,S', '1', isDark),
              _buildLetterChip('B,K,T', '2', isDark),
              _buildLetterChip('C,L,U', '3', isDark),
              _buildLetterChip('D,M,V', '4', isDark),
              _buildLetterChip('E,N,W', '5', isDark),
              _buildLetterChip('F,O,X', '6', isDark),
              _buildLetterChip('G,P,Y', '7', isDark),
              _buildLetterChip('H,Q,Z', '8', isDark),
              _buildLetterChip('I,R', '9', isDark),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  Widget _buildLetterChip(String letters, String number, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            letters,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : AppColors.textDark,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '= $number',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE91E63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
  );

  Widget _buildSection(bool isDark, String title, Color color, List<String> bullets) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? color : color.withValues(alpha: 0.85))),
      const SizedBox(height: 12),
      ...bullets.map((b) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('•', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : AppColors.textLight)),
          const SizedBox(width: 8),
          Expanded(child: Text(b, style: TextStyle(fontSize: 15, height: 1.5, color: isDark ? Colors.white70 : AppColors.textDark))),
        ]),
      )),
    ],
  ).animate().fadeIn(duration: 400.ms);

  Widget _buildSuggestion(BuildContext context, bool isDark, AppLanguage language, String emoji, String text, String route) => GestureDetector(
    onTap: () => context.push(route),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1)),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(L10nService.get('common.also_discover', language), style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.textLight)),
          const SizedBox(height: 2),
          Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : AppColors.textDark)),
        ])),
        Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white38 : AppColors.textLight),
      ]),
    ),
  ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
}
