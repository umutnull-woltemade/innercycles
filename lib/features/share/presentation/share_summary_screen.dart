import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/theme/mystical_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';

class ShareSummaryScreen extends ConsumerStatefulWidget {
  const ShareSummaryScreen({super.key});

  @override
  ConsumerState<ShareSummaryScreen> createState() => _ShareSummaryScreenState();
}

class _ShareSummaryScreenState extends ConsumerState<ShareSummaryScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final horoscope = ref.watch(dailyHoroscopeProvider(sign));

    return Scaffold(
      backgroundColor: MysticalColors.bgDeepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: MysticalColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Paylaş',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: MysticalColors.textPrimary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instagram Story Card (9:16 aspect ratio)
            RepaintBoundary(
              key: _cardKey,
              child: _InstagramStoryCard(
                name: userProfile?.name ?? sign.nameTr,
                sign: sign,
                moonSign: userProfile?.moonSign,
                risingSign: userProfile?.risingSign,
                horoscope: horoscope,
                birthDate: userProfile?.birthDate,
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 32),

            // Share Button
            _ShareButton(
              isLoading: _isCapturing,
              onPressed: _captureAndShare,
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Hint
            Text(
              'Instagram hikayende paylaş!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MysticalColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    setState(() => _isCapturing = true);

    try {
      // Wait for next frame
      await Future.delayed(const Duration(milliseconds: 100));

      // Find RenderRepaintBoundary
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Capture image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/celestial_summary.png');
      await file.writeAsBytes(bytes);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Günlük burç yorumum! ✨ #celestial #astroloji',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paylaşım hatası: $e')),
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }
}

class _InstagramStoryCard extends StatelessWidget {
  final String name;
  final ZodiacSign sign;
  final ZodiacSign? moonSign;
  final ZodiacSign? risingSign;
  final dynamic horoscope;
  final DateTime? birthDate;

  const _InstagramStoryCard({
    required this.name,
    required this.sign,
    required this.moonSign,
    required this.risingSign,
    required this.horoscope,
    this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 40;
    // Instagram story aspect ratio approximately 9:16, but we'll make it fit nicely
    final cardHeight = screenWidth * 1.5;

    return Container(
      width: screenWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MysticalColors.bgCosmic,
            MysticalColors.cosmicPurple.withOpacity(0.8),
            MysticalColors.midnightBlue,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: MysticalColors.amethyst.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background stars pattern
          ..._buildStars(),

          // Glow effect behind zodiac symbol
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      sign.color.withOpacity(0.4),
                      sign.color.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Zodiac Symbol with glow
                _buildZodiacSymbol(),

                const SizedBox(height: 16),

                // Sign name
                Text(
                  sign.nameTr.toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MysticalColors.textPrimary,
                    letterSpacing: 6,
                    shadows: [
                      Shadow(
                        color: sign.color.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Date range
                Text(
                  sign.dateRange,
                  style: TextStyle(
                    fontSize: 14,
                    color: MysticalColors.textSecondary,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 24),

                // Name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MysticalColors.starGold.withOpacity(0.5),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MysticalColors.starGold,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Big Three (Sun, Moon, Rising)
                _buildBigThree(),

                const Spacer(),

                // Daily message
                _buildDailyMessage(),

                const SizedBox(height: 20),

                // Traits
                _buildTraits(),

                const SizedBox(height: 20),

                // Footer with app branding
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacSymbol() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: sign.color.withOpacity(0.5),
          width: 2,
        ),
        gradient: RadialGradient(
          colors: [
            sign.color.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Text(
          sign.symbol,
          style: TextStyle(
            fontSize: 56,
            color: sign.color,
            shadows: [
              Shadow(
                color: sign.color.withOpacity(0.8),
                blurRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigThree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BigThreeItem(
          label: 'GÜNEŞ',
          sign: sign,
          icon: '☀️',
        ),
        if (moonSign != null) ...[
          const SizedBox(width: 16),
          _BigThreeItem(
            label: 'AY',
            sign: moonSign!,
            icon: '🌙',
          ),
        ],
        if (risingSign != null) ...[
          const SizedBox(width: 16),
          _BigThreeItem(
            label: 'YÜKSELEN',
            sign: risingSign!,
            icon: '⬆️',
          ),
        ],
      ],
    );
  }

  Widget _buildDailyMessage() {
    final summary = horoscope?.summary ??
        'Bugün evren seninle uyum içinde. Enerjin yüksek ve fırsatlar kapında!';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MysticalColors.bgElevated.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MysticalColors.starGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'GÜNÜN MESAJI',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MysticalColors.starGold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('✨', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            summary,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: MysticalColors.textPrimary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraits() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: sign.traits.take(4).map((trait) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: sign.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: sign.color.withOpacity(0.3),
            ),
          ),
          child: Text(
            trait,
            style: TextStyle(
              fontSize: 11,
              color: sign.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    final now = DateTime.now();
    final dateStr = '${now.day}.${now.month}.${now.year}';

    return Column(
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                MysticalColors.starGold.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              'CELESTIAL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MysticalColors.starGold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 8),
            const Text('⭐', style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: TextStyle(
            fontSize: 10,
            color: MysticalColors.textMuted,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStars() {
    final List<Widget> stars = [];
    final starPositions = [
      const Offset(30, 50),
      const Offset(80, 120),
      const Offset(250, 80),
      const Offset(300, 150),
      const Offset(50, 300),
      const Offset(280, 350),
      const Offset(100, 450),
      const Offset(320, 500),
      const Offset(40, 550),
      const Offset(280, 600),
    ];

    for (var i = 0; i < starPositions.length; i++) {
      final pos = starPositions[i];
      final size = 2.0 + (i % 3) * 1.5;
      final opacity = 0.3 + (i % 4) * 0.15;

      stars.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(opacity * 0.5),
                  blurRadius: size * 2,
                  spreadRadius: size * 0.5,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return stars;
  }
}

class _BigThreeItem extends StatelessWidget {
  final String label;
  final ZodiacSign sign;
  final String icon;

  const _BigThreeItem({
    required this.label,
    required this.sign,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: MysticalColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: sign.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sign.symbol,
                style: TextStyle(fontSize: 14, color: sign.color),
              ),
              const SizedBox(width: 4),
              Text(
                sign.nameTr,
                style: TextStyle(
                  fontSize: 11,
                  color: sign.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _ShareButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MysticalColors.amethyst,
              MysticalColors.cosmicPurple,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: MysticalColors.amethyst.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else ...[
              const Icon(
                Icons.share_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'Instagram\'da Paylaş',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
