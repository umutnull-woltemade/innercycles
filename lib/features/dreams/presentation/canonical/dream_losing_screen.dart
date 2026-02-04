import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/entertainment_disclaimer.dart';

/// Rüyada Birini Kaybetmek Ne Demek? - AI-First Canonical Sayfa
class DreamLosingScreen extends ConsumerWidget {
  const DreamLosingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final color = const Color(0xFF7E57C2);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D0D1A), const Color(0xFF1A0A2E)]
                : [const Color(0xFFF8F5FF), const Color(0xFFF0E8FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white70 : AppColors.textDark)),
                const SizedBox(height: 24),
                Text('Rüyada birini kaybetmek ne demek?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textDark, height: 1.2)).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 8),
                _buildTag('Rüya İzi', color),
                const SizedBox(height: 32),
                _buildSection(isDark, 'Kısa Cevap', color, [
                  'Birini kaybetmek rüyası genellikle ayrılık korkusunu yansıtır.',
                  'Gerçek bir kayıp olmak zorunda değil, bağ kaybı hissidir.',
                  'O kişiyle ilgili çözülmemiş duygular olabilir.',
                ]),
                const SizedBox(height: 28),
                _buildSection(isDark, 'Kim Kayboldu?', color, [
                  'Sevdiğin biri: Ona olan bağlılığın ve kayıp korkun.',
                  'Tanımadığın biri: Kendinle bağlantın.',
                  'Çocuk: İçindeki masumiyet veya yeni başlangıçlar.',
                ]),
                const SizedBox(height: 28),
                _buildSection(isDark, 'Ne Anlama Gelir?', color, [
                  'Değişim korkusu yaşıyor olabilirsin.',
                  'Bir ilişkide mesafe hissediyorsun.',
                  'Geçmişte yaşanan bir ayrılığı işliyorsun.',
                ]),
                const SizedBox(height: 28),
                _buildSection(isDark, 'Tekrar Ediyorsa', color, [
                  'Kaybetme korkun derinleşmiş olabilir.',
                  'O kişiyle konuşman gereken bir şey var.',
                  'Bağımsızlık ve bağlılık arasında denge arıyorsun.',
                ]),
                const SizedBox(height: 32),
                _buildSuggestion(context, isDark, language, '🕳️', 'Rüyada karanlık yer ne anlama gelir?', Routes.dreamDarkness),
                const SizedBox(height: 40),
                const PageFooterWithDisclaimer(
                  brandText: 'Rüya İzi — Venus One',
                  disclaimerText: DisclaimerTexts.dreams,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
    child: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
  );

  Widget _buildSection(bool isDark, String title, Color color, List<String> bullets) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? color : color.withOpacity(0.8))),
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
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1))),
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
