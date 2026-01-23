import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/models/house.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/ai_content_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    // Guard: Redirect to onboarding if no valid profile
    if (userProfile == null || userProfile.name == null || userProfile.name!.isEmpty) {
      // Use addPostFrameCallback to navigate after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(Routes.onboarding);
        }
      });
      // Show loading while redirecting
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    final sign = userProfile.sunSign;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, userProfile?.name, sign),
                const SizedBox(height: AppConstants.spacingLg),
                // ════════════════════════════════════════════════════════════
                // KOZMOZ USTASI - Ana sayfanın yıldızı, AI destekli asistan
                // ════════════════════════════════════════════════════════════
                const _KozmozMasterSection(),
                const SizedBox(height: AppConstants.spacingLg),
                // Mercury Retrograde Alert
                if (MoonService.isPlanetRetrograde('mercury'))
                  _buildMercuryRetrogradeAlert(context),
                const SizedBox(height: AppConstants.spacingMd),
                // Moon Phase & Sign Widget
                _buildMoonWidget(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildQuickActions(context),
                const SizedBox(height: AppConstants.spacingXl),
                // Kozmik Keşif - Yeni Araçlar Bölümü
                _buildKozmikKesif(context),
                const SizedBox(height: AppConstants.spacingXxl),
                // ═══════════════════════════════════════════════════════════════
                // RUHSAL & WELLNESS - Meditasyon, ritüeller, chakra
                // ═══════════════════════════════════════════════════════════════
                _buildSpiritualSection(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildAllSigns(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String? name, ZodiacSign sign) {
    final greeting = _getGreeting(ref);
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language selector and settings at top
        Row(
          children: [
            _LanguageSelectorButton(
              currentLanguage: language,
              onLanguageChanged: (lang) => ref.read(languageProvider.notifier).state = lang,
            ),
            const Spacer(),
            // Rüya Tabiri Butonu - Kozmoz'un solunda
            _DreamButton(
              onTap: () => context.push(Routes.dreamInterpretation),
            ),
            const SizedBox(width: 8),
            // KOZMOZ Butonu - Her zaman parlayan özel buton
            _KozmozButton(
              onTap: () => context.push(Routes.kozmoz),
            ),
            const SizedBox(width: 8),
            // Arama Butonu - Büyük ve animasyonlu
            _AnimatedHeaderButton(
              icon: Icons.search_rounded,
              label: 'Ara',
              color: AppColors.mysticBlue,
              onTap: () => _showSearchDialog(context, ref),
            ),
            const SizedBox(width: 8),
            // Profil Ekle Butonu
            _AnimatedHeaderButton(
              icon: Icons.person_add_rounded,
              label: 'Profil',
              color: AppColors.starGold,
              onTap: () => _showAddProfileDialog(context, ref),
            ),
            const SizedBox(width: 8),
            // Ayarlar Butonu
            _AnimatedHeaderButton(
              icon: Icons.settings_rounded,
              label: 'Ayar',
              color: AppColors.cosmicPurple,
              onTap: () => context.push(Routes.settings),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // Günlük yorum kartı header'da
        _buildCompactDailyCard(context, ref, name, sign),
      ],
    );
  }

  // Kompakt günlük yorum kartı - header'a entegre
  Widget _buildCompactDailyCard(BuildContext context, WidgetRef ref, String? name, ZodiacSign sign) {
    final horoscope = ref.watch(dailyHoroscopeProvider(sign));
    final userProfile = ref.watch(userProfileProvider);
    final greeting = _getGreeting(ref);

    // Doğum bilgileri
    final birthDate = userProfile?.birthDate;
    final birthTime = userProfile?.birthTime;
    final birthPlace = userProfile?.birthPlace;

    return GestureDetector(
      onTap: () => context.push('${Routes.horoscope}/${sign.name.toLowerCase()}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              sign.color.withOpacity(0.25),
              sign.color.withOpacity(0.1),
              const Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sign.color.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: sign.color.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ════════════════════════════════════════════════════════════
            // ÜST KISIM: İsim, Burç ve Doğum Bilgileri
            // ════════════════════════════════════════════════════════════
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: Tantrik logo
                const _TantricLogoSmall(),
                const SizedBox(width: 12),
                // Orta: Burç sembolü
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        sign.color.withOpacity(0.5),
                        sign.color.withOpacity(0.15),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: sign.color.withOpacity(0.7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: sign.color.withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(sign.symbol, style: TextStyle(fontSize: 24, color: sign.color)),
                ),
                const SizedBox(width: 14),
                // Sağ: İsim, Burç ve Doğum Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // İsim ve Burç
                      Row(
                        children: [
                          if (name != null && name.isNotEmpty) ...[
                            Flexible(
                              child: Text(
                                name,
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('•', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            sign.nameTr,
                            style: TextStyle(
                              color: sign.color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Doğum Tarihi ve Saati
                      if (birthDate != null)
                        Row(
                          children: [
                            Icon(Icons.cake_outlined, size: 14, color: Colors.white.withOpacity(0.6)),
                            const SizedBox(width: 6),
                            Text(
                              _formatBirthDate(birthDate),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                            if (birthTime != null && birthTime.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Icon(Icons.access_time, size: 14, color: Colors.white.withOpacity(0.6)),
                              const SizedBox(width: 4),
                              Text(
                                birthTime,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      // Doğum Yeri
                      if (birthPlace != null && birthPlace.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.white.withOpacity(0.6)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                birthPlace,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Şans yıldızları
                Column(
                  children: [
                    _buildLuckStars(horoscope.luckRating),
                    const SizedBox(height: 2),
                    Text(
                      'Şans',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniChip(icon: Icons.mood, label: horoscope.mood, color: sign.color),
                const SizedBox(width: 8),
                _MiniChip(icon: Icons.palette, label: horoscope.luckyColor, color: sign.color),
                const SizedBox(width: 8),
                _MiniChip(icon: Icons.tag, label: horoscope.luckyNumber, color: sign.color),
              ],
            ),
            const SizedBox(height: 12),
            // Kozmik mesaj
            if (horoscope.cosmicMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.starGold.withOpacity(0.2),
                      sign.color.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.starGold.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.starGold, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        horoscope.cosmicMessage,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            // Detaylı yorum butonu
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [sign.color.withOpacity(0.4), sign.color.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sign.color.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Detaylı Yorum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  // Küçük kozmik mesaj widget'ı - Yazı kadar kutu (artık kullanılmıyor ama yedek)
  Widget _buildMiniCosmicMessage(BuildContext context, WidgetRef ref, ZodiacSign sign) {
    final cosmicMessages = {
      ZodiacSign.aries: ['Cesaretini göster! 🔥', 'Liderlik zamanı! 🔥', 'Harekete geç! 🔥', 'Zafer senin! 🔥', 'Korkusuzca ilerle! 🔥'],
      ZodiacSign.taurus: ['Sabır meyvesini verir 🌿', 'Bolluk kapıda 🌿', 'Kendini ödüllendir 🌿', 'Huzuru bul 🌿', 'Değerini bil 🌿'],
      ZodiacSign.gemini: ['Kelimelerin sihirli ✨', 'İletişim dorukta ✨', 'Zekân parlıyor ✨', 'Fikirlerini paylaş ✨', 'Merakını takip et ✨'],
      ZodiacSign.cancer: ['Sezgilerine güven 🌙', 'Duygusal zekân güçlü 🌙', 'Ailenle bağlan 🌙', 'Şefkat göster 🌙', 'İç sesin doğru 🌙'],
      ZodiacSign.leo: ['Sahneyi al! 👑', 'Işığın parlıyor 👑', 'Kraliyet enerjisi 👑', 'Yaratıcılığın coşuyor 👑', 'Parlamanın zamanı 👑'],
      ZodiacSign.virgo: ['Detaylar fark yaratır 💫', 'Mükemmelsin 💫', 'Çözüm seninle 💫', 'Düzeni sağla 💫', 'Analiz gücün 💫'],
      ZodiacSign.libra: ['Denge ve uyum ⚖️', 'Aşk kapıda ⚖️', 'Diplomasi zamanı ⚖️', 'Güzelliği gör ⚖️', 'Kalbini dinle ⚖️'],
      ZodiacSign.scorpio: ['Dönüşüm zamanı 🦂', 'Güç seninle 🦂', 'Derinlere dal 🦂', 'Sezgilerin keskin 🦂', 'Tutkunu kullan 🦂'],
      ZodiacSign.sagittarius: ['Macera çağırıyor 🏹', 'Büyük düşün 🏹', 'Özgürlük ruhu 🏹', 'İyimser kal 🏹', 'Hayallerinin peşinde 🏹'],
      ZodiacSign.capricorn: ['Hedefe yakınsın 🏔️', 'Disiplin ödüllendirir 🏔️', 'Zirve yakın 🏔️', 'Kararlılık gücü 🏔️', 'Başarı senin 🏔️'],
      ZodiacSign.aquarius: ['Farklı ol! ⚡', 'Devrimci düşün ⚡', 'Özgün kal ⚡', 'Geleceği şekillendir ⚡', 'Vizyonun güçlü ⚡'],
      ZodiacSign.pisces: ['Rüyaların mesaj 🐟', 'Sezgisel güç 🐟', 'Empatin süper güç 🐟', 'Evrenle bir ol 🐟', 'Hayal gücün sınırsız 🐟'],
    };

    final messages = cosmicMessages[sign] ?? ['Evren seninle ✨'];
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final message = messages[dayOfYear % messages.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            sign.color.withOpacity(0.35),
            sign.color.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sign.color.withOpacity(0.5)),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white.withOpacity(0.95),
          fontStyle: FontStyle.italic,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getGreeting(WidgetRef ref) {
    final hour = DateTime.now().hour;
    final language = ref.watch(languageProvider);

    String key;
    if (hour < 6) {
      key = 'greeting_night';
    } else if (hour < 12) {
      key = 'greeting_morning';
    } else if (hour < 17) {
      key = 'greeting_afternoon';
    } else if (hour < 21) {
      key = 'greeting_evening';
    } else {
      key = 'greeting_late_night';
    }

    return L10n.get(key, language);
  }

  Widget _buildMercuryRetrogradeAlert(BuildContext context) {
    final retroEnd = MoonService.getCurrentMercuryRetrogradeEnd();
    final daysLeft = retroEnd != null
        ? retroEnd.difference(DateTime.now()).inDays
        : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withAlpha(40),
            Colors.red.withAlpha(30),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.orange.withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Merkür Retrosu',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Rx',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  daysLeft > 0
                      ? 'Iletisimde dikkatli ol! $daysLeft gun kaldi.'
                      : 'Iletisim ve teknolojide dikkatli ol!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // Evrenin Mesajı - Büyük ve dikkat çekici bölüm
  Widget _buildCosmicMessage(BuildContext context, WidgetRef ref, ZodiacSign sign) {
    // Burca özel kozmik mesajlar - Her burç için 5+ mesaj
    final cosmicMessagesMap = {
      ZodiacSign.aries: [
        'Bugün cesaretini gösterme zamanı. Evren, yeni başlangıçlar için sana güç veriyor. Korkusuzca ilerle! 🔥',
        'Ateş enerjin bugün dorukta! Önüne çıkan engelleri aşacak güce sahipsin. Harekete geç! 🔥',
        'Liderlik ruhun bugün parlıyor. İnsanları peşinden sürükleyecek karizman var, kullan! 🔥',
        'Evren sana "şimdi zamanı" diyor. Ertelediğin o adımı bugün at, pişman olmayacaksın! 🔥',
        'Tutkun ve enerjin bugün bulaşıcı. Etrafındakilere ilham kaynağı olacaksın! 🔥',
        'Mars enerjin güçlü! Rekabetten korkma, kazanmak için doğdun. Zafer senin! 🔥',
      ],
      ZodiacSign.taurus: [
        'Sabır ve kararlılığın bugün meyvelerini verecek. Güvendiğin yolda devam et, evren seninle. 🌿',
        'Venüs sana bolluk enerjisi gönderiyor. Maddi ve manevi zenginlik kapıda! 🌿',
        'Bugün konfor alanını genişlet. Kendine güzel bir şey hediye etmeyi hak ediyorsun! 🌿',
        'Sadakatin ve güvenilirliğin bugün takdir görecek. Değerini bilenler yanına gelecek! 🌿',
        'Doğayla bağlantın güçlü. Toprakla temas et, enerji al, huzur bul! 🌿',
        'Evren diyor ki: Acele etme, doğru zamanda doğru şeyler gelecek. Sabret! 🌿',
      ],
      ZodiacSign.gemini: [
        'İletişim enerjin dorukta. Bugün söylediklerin kalplere dokunacak. Kelimelerin sihirli! ✨',
        'Zekân ve esprin bugün çevreni büyüleyecek. Sosyal enerjin tavanda! ✨',
        'Merkür sana mesaj gönderiyor: Öğrenmeye açık ol, yeni bilgiler hayatını değiştirecek! ✨',
        'Çift taraflı doğan bugün avantajlı. Farklı bakış açıların fark yaratacak! ✨',
        'Merakın seni güzel yerlere götürecek. Sorularının peşinden git! ✨',
        'Evren diyor ki: Fikirlerini paylaş, dünyayı değiştirecek potansiyelin var! ✨',
      ],
      ZodiacSign.cancer: [
        'Sezgilerin seni yönlendiriyor. İç sesin her zamankinden güçlü, ona güven. 🌙',
        'Ay enerjin bugün çok güçlü. Duygusal zekân seni doğru kararlara götürecek! 🌙',
        'Ailenle bağın bugün önem kazanıyor. Sevdiklerinle vakit geçir, şifa bulacaksın! 🌙',
        'Koruyucu enerjin bugün hissedilecek. Yakınların sana minnettar! 🌙',
        'Evren diyor ki: Duygularından korkma, onlar senin süper gücün! 🌙',
        'Bugün kendine şefkat göster. Başkalarına verdiğin sevgiyi kendine de ver! 🌙',
      ],
      ZodiacSign.leo: [
        'Işığın bugün herkesi aydınlatacak. Liderlik enerjin dorukta, sahneyi al! 👑',
        'Güneş sana özel parlıyor! Bugün dikkat çekecek, başarı senin! 👑',
        'Kraliyet enerjin dorukta. Hak ettiğin ilgiyi ve saygıyı talep et! 👑',
        'Yaratıcılığın bugün coşkuyla akıyor. Sanatsal ruhunu ifade et! 👑',
        'Evren diyor ki: Mütevazılığı bırak, parlamanın zamanı geldi! 👑',
        'Cömertliğin bugün karşılık bulacak. Verdiğin sevgi katlanarak dönecek! 👑',
      ],
      ZodiacSign.virgo: [
        'Detaylara olan hakimiyetin bugün fark yaratacak. Mükemmeliyetin ilham veriyor. 💫',
        'Analitik zekân bugün problemleri çözecek. Kimsenin göremediğini sen görüyorsun! 💫',
        'Merkür sana pratik çözümler fısıldıyor. Dinle ve uygula! 💫',
        'Düzen ve organizasyon enerjin dorukta. Hayatını düzene sok, rahatlayacaksın! 💫',
        'Evren diyor ki: Mükemmel olmak zorunda değilsin, yeterlisin! 💫',
        'Sağlık ve wellness enerjin güçlü. Bedenine iyi bak, o sana iyi bakacak! 💫',
      ],
      ZodiacSign.libra: [
        'Denge ve uyum enerjin bugün çok güçlü. İlişkilerinde mucizeler bekle. ⚖️',
        'Venüs sana aşk ve güzellik enerjisi gönderiyor. Kalbin açık, aşk kapıda! ⚖️',
        'Diplomasi yeteneğin bugün parlıyor. Anlaşmazlıkları çözecek tek kişi sensin! ⚖️',
        'Estetik anlayışın dorukta. Güzelliği her yerde görüyorsun, paylaş! ⚖️',
        'Evren diyor ki: Karar verme zamanı geldi, kalbini dinle! ⚖️',
        'Adalet duygun güçlü. Doğru olanı savunmaktan çekinme! ⚖️',
      ],
      ZodiacSign.scorpio: [
        'Dönüşüm enerjin zirve yapıyor. Eskiyi bırak, yeniye yer aç. Güç seninle! 🦂',
        'Plüton sana yeniden doğuş enerjisi veriyor. Küllerinden yüksel! 🦂',
        'Sezgilerin ve içgüdülerin bugün çok keskin. Kimse seni kandıramaz! 🦂',
        'Gizemli çekiciliğin bugün dorukta. İnsanlar sana mıknatıs gibi çekilecek! 🦂',
        'Evren diyor ki: Derinlere dal, orada hazineler var! 🦂',
        'Tutkun ve yoğunluğun bugün seni hedefe götürecek. Vazgeçme! 🦂',
      ],
      ZodiacSign.sagittarius: [
        'Macera ruhu bugün seni çağırıyor. Yeni ufuklar keşfetme zamanı! 🏹',
        'Jüpiter sana şans ve genişleme enerjisi gönderiyor. Büyük düşün! 🏹',
        'Özgürlük ruhun kanat çırpıyor. Sınırları aş, dünyayı keşfet! 🏹',
        'İyimserliğin bugün bulaşıcı. Gülümsemen insanların gününü aydınlatacak! 🏹',
        'Evren diyor ki: Hayallerinin peşinden koş, evren seni destekliyor! 🏹',
        'Felsefi bakış açın bugün derinleşiyor. Hayatın anlamını sorgula! 🏹',
      ],
      ZodiacSign.capricorn: [
        'Hedeflerine her zamankinden yakınsın. Disiplin ve kararlılığın ödüllendirilecek. 🏔️',
        'Satürn sana dayanıklılık ve sabır veriyor. Zirveye ulaşacaksın! 🏔️',
        'Profesyonel imajın bugün parlıyor. Kariyer fırsatları kapıda! 🏔️',
        'Sorumluluk bilincing takdir görecek. Güvenilirliğin altın değerinde! 🏔️',
        'Evren diyor ki: Adım adım ilerliyorsun, zirve yakın! 🏔️',
        'Pratik zekân bugün seni öne çıkaracak. Çözüm odaklı ol! 🏔️',
      ],
      ZodiacSign.aquarius: [
        'Yaratıcı enerjin bugün dorukta. Farklı düşüncelerinden korkma, devrimci ol! ⚡',
        'Uranüs sana yenilik ve özgünlük enerjisi gönderiyor. Sıradanı reddet! ⚡',
        'İnsanlık için vizyonun bugün önem kazanıyor. Dünyayı değiştir! ⚡',
        'Bağımsızlık ruhun güçlü. Kendi yolunu çiz, takipçiler gelecek! ⚡',
        'Evren diyor ki: Farklı olmak güç, bu gücü kullan! ⚡',
        'Teknoloji ve yenilik enerjin dorukta. Geleceği bugünden şekillendir! ⚡',
      ],
      ZodiacSign.pisces: [
        'Spiritüel bağlantın çok güçlü. Rüyaların mesaj taşıyor, evrenle bir ol. 🐟',
        'Neptün sana ilham ve hayal gücü veriyor. Sanatsal ruhun akıyor! 🐟',
        'Empatin bugün süper güç. Başkalarının hislerini anlıyorsun, şifa veriyorsun! 🐟',
        'Sezgisel yeteneklerin dorukta. Evren seninle konuşuyor, dinle! 🐟',
        'Evren diyor ki: Hayallerinin gücünü hafife alma, gerçek olabilirler! 🐟',
        'Şefkat ve merhamet enerjin bugün dünyaya ışık saçıyor! 🐟',
      ],
    };

    // Günün mesajını seç (gün bazlı değişecek)
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final messages = cosmicMessagesMap[sign] ?? ['Evren bugün seninle. Her adımında kozmik rehberlik yanında. ✨'];
    final message = messages[dayOfYear % messages.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a0a2e).withOpacity(0.95),
            const Color(0xFF2d1b4e).withOpacity(0.9),
            const Color(0xFF1a0a2e).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D4EDD).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF6B9D), Color(0xFF9D4EDD)],
                ).createShader(bounds),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFF6B9D)],
                ).createShader(bounds),
                child: Text(
                  'Evrenin Mesajı',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF9D4EDD), Color(0xFFFF6B9D), Color(0xFFFFD700)],
                ).createShader(bounds),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mesaj
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          // Alt bilgi
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sign.symbol,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                sign.nameTr,
                style: TextStyle(
                  color: sign.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Bugün için',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(delay: 200.ms, duration: 500.ms)
      .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 500.ms);
  }

  Widget _buildMoonWidget(BuildContext context) {
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final illumination = MoonService.getIllumination();
    final retrogrades = MoonService.getRetrogradePlanets();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.moonSilver.withAlpha(30),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.moonSilver.withAlpha(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Moon phase visual
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.moonSilver,
                      AppColors.moonSilver.withAlpha(100),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.moonSilver.withAlpha(80),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    moonPhase.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              // Moon info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simdi Gokyuzunde',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moonPhase.nameTr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.moonSilver,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Ay ${moonSign.nameTr} burcunda',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          moonSign.symbol,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Illumination
              Column(
                children: [
                  Text(
                    '${illumination.round()}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.moonSilver,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Aydinlik',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Moon phase meaning
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.moonSilver.withAlpha(15),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              moonPhase.meaning,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
            ),
          ),
          // Retrograde planets
          if (retrogrades.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: Colors.orange.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.replay, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Retro: ',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: retrogrades.map((planet) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getPlanetNameTr(planet),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.orange,
                                  fontSize: 10,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Void of Course Moon indicator
          if (vocStatus.isVoid) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withAlpha(30),
                    Colors.indigo.withAlpha(20),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: Colors.purple.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.do_not_disturb_on, color: Colors.purple, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ay Bos Seyir',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.withAlpha(40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'VOC',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.purple,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vocStatus.timeRemainingFormatted != null
                              ? 'Onemli kararlar ertelensin. ${vocStatus.timeRemainingFormatted} kaldi.'
                              : 'Onemli kararlar ve baslangiclari erteleyiniz.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (vocStatus.nextSign != null) ...[
                    Column(
                      children: [
                        Text(
                          vocStatus.nextSign!.symbol,
                          style: TextStyle(fontSize: 18, color: Colors.purple.withAlpha(180)),
                        ),
                        Text(
                          'Sonraki',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  String _getPlanetNameTr(String planet) {
    switch (planet.toLowerCase()) {
      case 'mercury': return 'Merkur';
      case 'venus': return 'Venus';
      case 'mars': return 'Mars';
      case 'jupiter': return 'Jupiter';
      case 'saturn': return 'Saturn';
      case 'uranus': return 'Uranus';
      case 'neptune': return 'Neptun';
      case 'pluto': return 'Pluton';
      default: return planet;
    }
  }

  Widget _buildTodayCard(BuildContext context, WidgetRef ref, ZodiacSign sign) {
    final horoscope = ref.watch(dailyHoroscopeProvider(sign));

    return GestureDetector(
      onTap: () => context.push('${Routes.horoscope}/${sign.name.toLowerCase()}'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              sign.color.withValues(alpha: 0.25),
              const Color(0xFF1A1A2E),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: sign.color.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: sign.color.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Üst kısım: Tantrik Logo + Burç bilgisi yan yana
            Row(
              children: [
                // Sol: Tantrik Logo (küçültülmüş)
                const _TantricLogoSmall(),
                const SizedBox(width: 12),
                // Orta: Burç sembolü ve ismi
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              sign.color.withValues(alpha: 0.4),
                              sign.color.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: sign.color.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          sign.symbol,
                          style: TextStyle(fontSize: 20, color: sign.color),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sign.nameTr,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: sign.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              _formatTodayDate(DateTime.now()),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Sağ: Şans yıldızları
                Column(
                  children: [
                    _buildLuckStars(horoscope.luckRating),
                    Text(
                      'Şans',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 8,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Info chips - tek satırda kompakt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniChip(icon: Icons.mood, label: horoscope.mood, color: sign.color),
                const SizedBox(width: 6),
                _MiniChip(icon: Icons.palette, label: horoscope.luckyColor, color: sign.color),
                const SizedBox(width: 6),
                _MiniChip(icon: Icons.tag, label: horoscope.luckyNumber, color: sign.color),
              ],
            ),
            const SizedBox(height: 10),
            // Evrenin Mesajı - Kısa
            if (horoscope.cosmicMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.starGold.withValues(alpha: 0.15),
                      sign.color.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
                ),
                child: Text(
                  horoscope.cosmicMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                        fontSize: 12,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 8),
            // Detay butonu - daha kompakt
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [sign.color.withValues(alpha: 0.3), sign.color.withValues(alpha: 0.15)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Detaylı Yorum',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildCosmicSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String content,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.8,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  String _formatTodayDate(DateTime date) {
    final days = ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'];
    final months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatBirthDate(DateTime date) {
    final months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildLuckStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: AppColors.starGold,
        );
      }),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ═══════════════════════════════════════════════════════════════
        // ÖZEL ÇÖZÜMLEMELERİMİZ - Profil tabanlı, kişiye özel analizler
        // ═══════════════════════════════════════════════════════════════
        _buildSectionHeader(context, '✨ Özel Çözümlemelerimiz', 'Doğum bilgilerinize özel analizler'),
        const SizedBox(height: AppConstants.spacingMd),
        // Doğum Haritası & Uyum
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: 'Doğum Haritası',
                color: AppColors.starGold,
                tooltip: 'Natal haritanız: Gezegen pozisyonları, evler ve açılar',
                onTap: () => context.push(Routes.birthChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite,
                label: 'Uyum',
                color: AppColors.fireElement,
                tooltip: 'İki burç arasındaki romantik ve duygusal uyumu keşfedin',
                onTap: () => context.push(Routes.compatibility),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Sinastri & Kompozit
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people_alt,
                label: 'Sinastri',
                color: Colors.pink,
                tooltip: 'İki kişinin haritalarını karşılaştırarak ilişki dinamiklerini analiz edin',
                onTap: () => context.push(Routes.synastry),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.compare_arrows,
                label: 'Kompozit',
                color: AppColors.sunriseStart,
                tooltip: 'İki haritanın birleşiminden oluşan ilişki haritası',
                onTap: () => context.push(Routes.compositeChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Transitler & Transit Takvimi
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.public,
                label: 'Transitler',
                color: AppColors.sunriseEnd,
                tooltip: 'Gökyüzündeki gezegenlerin natal haritanıza etkileri',
                onTap: () => context.push(Routes.transits),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.event_note,
                label: 'Transit Takvimi',
                color: AppColors.auroraStart,
                tooltip: 'Önemli transit tarihleri ve kozmik olaylar takvimi',
                onTap: () => context.push(Routes.transitCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Progresyon & Saturn Dönüşü
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_graph,
                label: 'Progresyon',
                color: AppColors.twilightStart,
                tooltip: 'Haritanızın zaman içinde nasıl evrildiğini görün',
                onTap: () => context.push(Routes.progressions),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.refresh,
                label: 'Saturn Dönüşü',
                color: AppColors.saturnColor,
                tooltip: '~29 yılda bir gerçekleşen önemli yaşam dönüm noktası',
                onTap: () => context.push(Routes.saturnReturn),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 550.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Solar Return & Yıl Öngörüsü
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.cake,
                label: 'Solar Return',
                color: AppColors.starGold,
                tooltip: 'Doğum gününüz etrafındaki yıllık kozmik haritanız',
                onTap: () => context.push(Routes.solarReturn),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_month,
                label: 'Yıl Öngörüsü',
                color: AppColors.celestialGold,
                tooltip: 'Önümüzdeki 12 ay için astrolojik öngörüler',
                onTap: () => context.push(Routes.yearAhead),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Vedik & Drakonik
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.brightness_3,
                label: 'Vedik',
                color: AppColors.celestialGold,
                tooltip: 'Hint astrolojisine göre haritanız (Sidereal)',
                onTap: () => context.push(Routes.vedicChart),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.psychology,
                label: 'Drakonik',
                color: AppColors.mystic,
                tooltip: 'Ruhsal amacınızı ve karmik yolculuğunuzu keşfedin',
                onTap: () => context.push(Routes.draconicChart),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 650.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Asteroidler & Astro Harita
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.star_outline,
                label: 'Asteroidler',
                color: AppColors.stardust,
                tooltip: 'Chiron, Juno, Ceres ve diğer asteroitlerin konumları',
                onTap: () => context.push(Routes.asteroids),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.map,
                label: 'Astro Harita',
                color: AppColors.auroraStart,
                tooltip: 'Dünya üzerinde enerjilerin en güçlü olduğu yerler',
                onTap: () => context.push(Routes.astroCartography),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Yerel Uzay & Elektif
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.explore,
                label: 'Yerel Uzay',
                color: Colors.teal,
                tooltip: 'Bulunduğunuz konuma özel astrolojik harita',
                onTap: () => context.push(Routes.localSpace),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.schedule,
                label: 'Elektif',
                color: AppColors.twilightEnd,
                tooltip: 'Önemli kararlar için en uygun zamanı seçin',
                onTap: () => context.push(Routes.electional),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Zamanlama & Numeroloji
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.access_time,
                label: 'Zamanlama',
                color: AppColors.auroraEnd,
                tooltip: 'Kozmik enerjilere göre en uygun zamanları keşfedin',
                onTap: () => context.push(Routes.timing),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.numbers,
                label: 'Numeroloji',
                color: AppColors.auroraEnd,
                tooltip: 'Sayıların gizli anlamları ve yaşam yolu sayınız',
                onTap: () => context.push(Routes.numerology),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Share Summary Button
        _ShareSummaryButton(
          onTap: () => context.push(Routes.shareSummary),
        ).animate().fadeIn(delay: 850.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingXxl),
        // ═══════════════════════════════════════════════════════════════
        // 12 ASTROLOJİK EV - Kompakt görünüm
        // ═══════════════════════════════════════════════════════════════
        _buildCompactHousesSection(context),
        const SizedBox(height: AppConstants.spacingXxl),
        // ═══════════════════════════════════════════════════════════════
        // KALAN ÇÖZÜMLEMELERİMİZ - Genel araçlar
        // ═══════════════════════════════════════════════════════════════
        _buildOtherTools(context),
      ],
    );
  }

  Widget _buildCompactHousesSection(BuildContext context) {
    // 12 ev sistemi - büyük pencere görünümü
    final houses = [
      {'num': 1, 'name': 'Benlik', 'icon': Icons.person, 'color': Colors.red, 'desc': 'Kim olduğun'},
      {'num': 2, 'name': 'Para', 'icon': Icons.attach_money, 'color': Colors.green, 'desc': 'Değerlerin'},
      {'num': 3, 'name': 'İletişim', 'icon': Icons.chat_bubble, 'color': Colors.orange, 'desc': 'Nasıl düşünürsün'},
      {'num': 4, 'name': 'Aile', 'icon': Icons.home, 'color': Colors.blue, 'desc': 'Köklerin'},
      {'num': 5, 'name': 'Yaratıcılık', 'icon': Icons.palette, 'color': Colors.purple, 'desc': 'İfade tarzın'},
      {'num': 6, 'name': 'Sağlık', 'icon': Icons.favorite, 'color': Colors.teal, 'desc': 'Günlük rutinin'},
      {'num': 7, 'name': 'İlişki', 'icon': Icons.people, 'color': Colors.pink, 'desc': 'Ortaklıkların'},
      {'num': 8, 'name': 'Dönüşüm', 'icon': Icons.autorenew, 'color': Colors.deepPurple, 'desc': 'Gizli güçlerin'},
      {'num': 9, 'name': 'Felsefe', 'icon': Icons.school, 'color': Colors.indigo, 'desc': 'Arayışların'},
      {'num': 10, 'name': 'Kariyer', 'icon': Icons.work, 'color': Colors.amber, 'desc': 'Hedeflerin'},
      {'num': 11, 'name': 'Arkadaş', 'icon': Icons.groups, 'color': Colors.cyan, 'desc': 'Toplulukların'},
      {'num': 12, 'name': 'Bilinçaltı', 'icon': Icons.psychology, 'color': Colors.deepOrange, 'desc': 'İç dünyan'},
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cosmicPurple.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Pencere başlığı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cosmicPurple.withValues(alpha: 0.4),
                  AppColors.mysticBlue.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.cosmicPurple, AppColors.mysticBlue],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏠 12 Astrolojik Ev',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Hayatınızın farklı alanlarını keşfedin',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push(Routes.birthChart),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Detay',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 12 Ev - Tek satırda yatay scroll, büyük boyut
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 12,
              itemBuilder: (context, index) {
                final house = houses[index];
                final houseColor = house['color'] as Color;
                final houseIcon = house['icon'] as IconData;

                return Padding(
                  padding: EdgeInsets.only(right: index < 11 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => _showHouseDetail(context, house),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            houseColor.withValues(alpha: 0.5),
                            houseColor.withValues(alpha: 0.2),
                          ],
                        ),
                        border: Border.all(
                          color: houseColor.withValues(alpha: 0.7),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: houseColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            houseIcon,
                            color: houseColor,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            house['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
  }

  IconData _getHouseIcon(int houseNum) {
    switch (houseNum) {
      case 1: return Icons.person;
      case 2: return Icons.attach_money;
      case 3: return Icons.chat_bubble;
      case 4: return Icons.home;
      case 5: return Icons.palette;
      case 6: return Icons.favorite;
      case 7: return Icons.people;
      case 8: return Icons.autorenew;
      case 9: return Icons.school;
      case 10: return Icons.work;
      case 11: return Icons.groups;
      case 12: return Icons.psychology;
      default: return Icons.circle;
    }
  }

  void _showHouseDetail(BuildContext context, Map<String, dynamic> house) {
    final houseNum = house['num'] as int;
    final houseName = house['name'] as String;
    final houseColor = house['color'] as Color;
    final houseIcon = house['icon'] as IconData;

    // Ev detay bilgileri
    final houseDetails = {
      1: {
        'title': '1. Ev - Benlik Evi',
        'keywords': 'Kimlik • Görünüş • Başlangıçlar',
        'description': 'Kişiliğinizi, fiziksel görünümünüzü ve dünyaya nasıl sunulduğunuzu temsil eder. Yükselen burç bu evi yönetir.',
        'areas': ['Kişisel imaj', 'Fiziksel sağlık', 'İlk izlenimler', 'Yeni başlangıçlar'],
      },
      2: {
        'title': '2. Ev - Para ve Değerler Evi',
        'keywords': 'Para • Değerler • Güvenlik',
        'description': 'Maddi değerlerinizi, para kazanma yeteneğinizi ve öz değerinizi temsil eder.',
        'areas': ['Gelir kaynakları', 'Maddi güvenlik', 'Öz değer', 'Yetenekler'],
      },
      3: {
        'title': '3. Ev - İletişim Evi',
        'keywords': 'İletişim • Öğrenme • Kardeşler',
        'description': 'Düşünce tarzınızı, iletişim becerilerinizi ve yakın çevrenizle ilişkilerinizi temsil eder.',
        'areas': ['Konuşma ve yazma', 'Kısa yolculuklar', 'Kardeş ilişkileri', 'Temel eğitim'],
      },
      4: {
        'title': '4. Ev - Aile ve Kökler Evi',
        'keywords': 'Ev • Aile • Kökler',
        'description': 'Ailenizi, yuvanızı, duygusal temelerinizi ve yaşamınızın son dönemini temsil eder.',
        'areas': ['Aile bağları', 'Ev ortamı', 'Duygusal güvenlik', 'Anne figürü'],
      },
      5: {
        'title': '5. Ev - Yaratıcılık ve Aşk Evi',
        'keywords': 'Aşk • Yaratıcılık • Eğlence',
        'description': 'Yaratıcı ifadenizi, romantizmi, çocukları ve eğlence anlayışınızı temsil eder.',
        'areas': ['Romantik ilişkiler', 'Çocuklar', 'Sanatsal ifade', 'Hobiler'],
      },
      6: {
        'title': '6. Ev - Sağlık ve Hizmet Evi',
        'keywords': 'Sağlık • Günlük İş • Rutin',
        'description': 'Günlük rutinlerinizi, iş alışkanlıklarınızı ve fiziksel sağlığınızı temsil eder.',
        'areas': ['Sağlık alışkanlıkları', 'İş ortamı', 'Günlük rutinler', 'Hizmet'],
      },
      7: {
        'title': '7. Ev - Evlilik ve Ortaklık Evi',
        'keywords': 'Partner • Evlilik • Ortaklık',
        'description': 'Ciddi ilişkilerinizi, evliliği ve her türlü ortaklığı temsil eder.',
        'areas': ['Evlilik', 'İş ortaklıkları', 'Sözleşmeler', 'Açık düşmanlar'],
      },
      8: {
        'title': '8. Ev - Dönüşüm Evi',
        'keywords': 'Cinsellik • Dönüşüm • Miras',
        'description': 'Derin dönüşümü, ortak kaynakları, cinselliği ve ruhsal yeniden doğuşu temsil eder.',
        'areas': ['Cinsel enerji', 'Miras', 'Borçlar', 'Psikolojik derinlik'],
      },
      9: {
        'title': '9. Ev - Felsefe ve Yolculuk Evi',
        'keywords': 'Felsefe • Yolculuk • İnanç',
        'description': 'Yüksek öğrenimi, uzun yolculukları, felsefeyi ve spiritüel arayışı temsil eder.',
        'areas': ['Yüksek eğitim', 'Uzak yolculuklar', 'Felsefe ve din', 'Yayıncılık'],
      },
      10: {
        'title': '10. Ev - Kariyer ve Statü Evi',
        'keywords': 'Kariyer • Statü • Başarı',
        'description': 'Kariyerinizi, toplumsal statünüzü, hedeflerinizi ve başarılarınızı temsil eder.',
        'areas': ['Kariyer hedefleri', 'Toplumsal konum', 'Baba figürü', 'Otorite'],
      },
      11: {
        'title': '11. Ev - Arkadaşlık ve İdealler Evi',
        'keywords': 'Arkadaş • Topluluk • Hayaller',
        'description': 'Arkadaşlıklarınızı, sosyal grupları, gelecek umutlarınızı ve ideallerinizi temsil eder.',
        'areas': ['Arkadaşlıklar', 'Sosyal gruplar', 'Geleceğe dair umutlar', 'İnsani idealler'],
      },
      12: {
        'title': '12. Ev - Bilinçaltı ve Gizlilik Evi',
        'keywords': 'Bilinçaltı • Spiritüel • Karma',
        'description': 'Bilinçaltınızı, gizli düşmanları, spiritüel yolculuğu ve karmik dersleri temsil eder.',
        'areas': ['Bilinçaltı dürtüler', 'Yalnızlık zamanları', 'Spiritüel gelişim', 'Karma'],
      },
    };

    final detail = houseDetails[houseNum]!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: houseColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(houseIcon, color: houseColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: houseColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        detail['keywords'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // Description
            Text(
              detail['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            // Areas
            Text(
              'Bu Evin Yönettiği Alanlar:',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: houseColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (detail['areas'] as List<String>).map((area) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: houseColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: houseColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    area,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: houseColor,
                        ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(Routes.birthChart);
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Haritamda Bu Evi Gör'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: houseColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starGold.withValues(alpha: 0.15),
            AppColors.auroraStart.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildOtherTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.moonSilver.withValues(alpha: 0.15),
                AppColors.waterElement.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.moonSilver.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔮 Kalan Çözümlemelerimiz',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.moonSilver,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Genel astroloji araçları ve burç yorumları',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Tüm Burçlar & Günlük
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.auto_awesome,
                label: 'Tüm Burçlar',
                color: AppColors.waterElement,
                tooltip: '12 burç için günlük yorumlar ve öngörüler',
                onTap: () => context.push(Routes.horoscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_view_week,
                label: 'Haftalık',
                color: AppColors.earthElement,
                tooltip: 'Bu haftanın kozmik enerjileri ve tavsiyeleri',
                onTap: () => context.push(Routes.weeklyHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 950.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aylık & Yıllık
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_month,
                label: 'Aylık',
                color: AppColors.waterElement,
                tooltip: 'Bu ayın astrolojik temaları ve fırsatları',
                onTap: () => context.push(Routes.monthlyHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_today,
                label: 'Yıllık',
                color: AppColors.fireElement,
                tooltip: 'Yılın genel akışı ve büyük döngüler',
                onTap: () => context.push(Routes.yearlyHoroscope),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aşk & Tutulma
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.favorite_border,
                label: 'Aşk',
                color: Colors.pink,
                tooltip: 'Romantik yaşamınız için günlük öngörüler',
                onTap: () => context.push(Routes.loveHoroscope),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.dark_mode,
                label: 'Tutulma',
                color: AppColors.moonSilver,
                tooltip: 'Güneş ve Ay tutulmalarının takvimi ve etkileri',
                onTap: () => context.push(Routes.eclipseCalendar),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1050.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Kabala & Tarot
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.account_tree,
                label: 'Kabala',
                color: AppColors.moonSilver,
                tooltip: 'Hayat Ağacı ve mistik Yahudi bilgeliği',
                onTap: () => context.push(Routes.kabbalah),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.style,
                label: 'Tarot',
                color: AppColors.auroraStart,
                tooltip: 'Günlük kart çekimi ve tarot okumları',
                onTap: () => context.push(Routes.tarot),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Aura & Bahçe Ayı
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.blur_on,
                label: 'Aura Analizi',
                color: AppColors.airElement,
                tooltip: 'Enerji alanınızın renkleri ve anlamları',
                onTap: () => context.push(Routes.aura),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.eco,
                label: 'Bahçe Ayı',
                color: AppColors.earthElement,
                tooltip: 'Ay fazlarına göre bahçecilik ve ekim takvimi',
                onTap: () => context.push(Routes.gardeningMoon),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1150.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Ünlüler & Makaleler
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.people,
                label: 'Ünlüler',
                color: AppColors.starGold,
                tooltip: 'Ünlü kişilerin doğum haritaları ve analizleri',
                onTap: () => context.push(Routes.celebrities),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.article,
                label: 'Makaleler',
                color: AppColors.airElement,
                tooltip: 'Astroloji hakkında derinlemesine yazılar',
                onTap: () => context.push(Routes.articles),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Sözlük
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.menu_book,
                label: 'Sözlük',
                color: AppColors.textSecondary,
                tooltip: 'Astroloji terimleri ve kavramları sözlüğü',
                onTap: () => context.push(Routes.glossary),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            const Expanded(child: SizedBox()),
          ],
        ).animate().fadeIn(delay: 1250.ms, duration: 400.ms),
        // Ruhsal & Wellness section moved after Kozmik Keşif
      ],
    );
  }

  Widget _buildSpiritualSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cosmicPurple.withValues(alpha: 0.2),
                AppColors.mysticBlue.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.cosmicPurple.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruhsal & Wellness',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.cosmicPurple,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Meditasyon, ritüeller ve enerji dengeleme',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1300.ms, duration: 400.ms),
        const SizedBox(height: AppConstants.spacingMd),
        // Günlük Ritüeller & Chakra
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.self_improvement,
                label: 'Günlük Ritüel',
                color: AppColors.cosmicPurple,
                onTap: () => context.push(Routes.dailyRituals),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.blur_circular,
                label: 'Chakra',
                color: AppColors.mysticBlue,
                onTap: () => context.push(Routes.chakraAnalysis),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 1350.ms, duration: 400.ms),
      ],
    );
  }

  // Kozmik Keşif - Instagram'da paylaşılabilir viral içerikler
  Widget _buildKozmikKesif(BuildContext context) {
    // Instagram'da viral olacak paylaşılabilir içerikler
    // Her biri 1080x1080 veya 1080x1350 Instagram formatına uygun
    final kesifItems = [
      // ════ GÜNLÜK ÖZET & YORUMLAR ════
      {'icon': '⭐', 'name': 'Bugünün\nÖzeti', 'color': Color(0xFFFFD700), 'route': Routes.dailySummary, 'badge': 'Günlük'},
      {'icon': '🌙', 'name': 'Ay\nEnerjisi', 'color': Color(0xFF607D8B), 'route': Routes.moonEnergy, 'badge': null},
      {'icon': '💕', 'name': 'Aşk\nEnerjisi', 'color': Color(0xFFE91E63), 'route': Routes.loveEnergy, 'badge': 'Hot'},
      {'icon': '💰', 'name': 'Bolluk\nEnerjisi', 'color': Color(0xFF4CAF50), 'route': Routes.abundanceEnergy, 'badge': null},

      // ════ FELSEFİ & VİRAL İÇERİKLER ════
      {'icon': '🦋', 'name': 'Ruhsal\nDönüşüm', 'color': Color(0xFF9C27B0), 'route': Routes.spiritualTransformation, 'badge': 'Derin'},
      {'icon': '🌟', 'name': 'Hayat\nAmacın', 'color': Color(0xFFFFD700), 'route': Routes.lifePurpose, 'badge': null},
      {'icon': '🧠', 'name': 'Bilinçaltı\nKalıpların', 'color': Color(0xFF3F51B5), 'route': Routes.subconsciousPatterns, 'badge': null},
      {'icon': '💫', 'name': 'Karma\nDerslerin', 'color': Color(0xFF673AB7), 'route': Routes.karmaLessons, 'badge': 'Derin'},
      {'icon': '🌀', 'name': 'Ruh\nSözleşmen', 'color': Color(0xFF00BCD4), 'route': Routes.soulContract, 'badge': null},
      {'icon': '✨', 'name': 'İçsel\nGücün', 'color': Color(0xFFFF9800), 'route': Routes.innerPower, 'badge': null},

      // ════ KİŞİLİK ANALİZLERİ ════
      {'icon': '😈', 'name': 'Gölge\nBenliğin', 'color': Color(0xFF880E4F), 'route': Routes.shadowSelf, 'badge': 'Viral'},
      {'icon': '👑', 'name': 'Liderlik\nStili', 'color': Color(0xFFFFAB00), 'route': Routes.leadershipStyle, 'badge': null},
      {'icon': '💔', 'name': 'Kalp\nYaran', 'color': Color(0xFF6A1B9A), 'route': Routes.heartbreak, 'badge': null},
      {'icon': '🔥', 'name': 'Red\nFlag\'lerin', 'color': Color(0xFFFF1744), 'route': Routes.redFlags, 'badge': 'Trend'},
      {'icon': '💚', 'name': 'Green\nFlag\'lerin', 'color': Color(0xFF00C853), 'route': Routes.greenFlags, 'badge': null},
      {'icon': '💋', 'name': 'Flört\nStili', 'color': Color(0xFFD81B60), 'route': Routes.flirtStyle, 'badge': null},

      // ════ MİSTİK ARAÇLAR ════
      {'icon': '🔮', 'name': 'Tarot\nKartın', 'color': Color(0xFF9C27B0), 'route': Routes.tarotCard, 'badge': 'Yeni'},
      {'icon': '🌈', 'name': 'Aura\nRengin', 'color': Color(0xFFAB47BC), 'route': Routes.auraColor, 'badge': null},
      {'icon': '🧘', 'name': 'Çakra\nDengen', 'color': Color(0xFFFF5722), 'route': Routes.chakraBalance, 'badge': null},
      {'icon': '🔢', 'name': 'Yaşam\nSayın', 'color': Color(0xFF7986CB), 'route': Routes.lifeNumber, 'badge': null},
      {'icon': '🌳', 'name': 'Kabala\nYolun', 'color': Color(0xFF66BB6A), 'route': Routes.kabbalaPath, 'badge': null},

      // ════ ZAMAN & DÖNGÜLER ════
      {'icon': '🪐', 'name': 'Saturn\nDersleri', 'color': Color(0xFF455A64), 'route': Routes.saturnLessons, 'badge': null},
      {'icon': '☀️', 'name': 'Doğum Günü\nEnerjin', 'color': Color(0xFFFF9800), 'route': Routes.birthdayEnergy, 'badge': null},
      {'icon': '🌑', 'name': 'Tutulma\nEtkisi', 'color': Color(0xFF37474F), 'route': Routes.eclipseEffect, 'badge': null},
      {'icon': '🔄', 'name': 'Transit\nAkışı', 'color': Color(0xFF4CAF50), 'route': Routes.transitFlow, 'badge': null},

      // ════ İLİŞKİ ANALİZLERİ ════
      {'icon': '💕', 'name': 'Uyum\nAnalizi', 'color': Color(0xFFE91E63), 'route': Routes.compatibilityAnalysis, 'badge': 'Hot'},
      {'icon': '👥', 'name': 'Ruh\nEşin', 'color': Color(0xFFE91E63), 'route': Routes.soulMate, 'badge': null},
      {'icon': '💫', 'name': 'İlişki\nKarman', 'color': Color(0xFFFF4081), 'route': Routes.relationshipKarma, 'badge': null},

      // ════ KEŞFET ════
      {'icon': '⭐', 'name': 'Ünlü\nİkizin', 'color': Color(0xFFFFB74D), 'route': Routes.celebrityTwin, 'badge': 'Fun'},
      {'icon': '🌌', 'name': 'Kozmoz\nDünyası', 'color': Color(0xFF6A1B9A), 'route': Routes.kozmoz, 'badge': 'Yeni'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF6B9D), Color(0xFF9D4EDD)],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Kozmik Keşif',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFFF5722)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PAYLAŞ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // 2 satırlık yatay scroll grid (daha fazla içerik için)
        SizedBox(
          height: 160, // 2 satır için yükseklik (her biri 72px + 8px gap + padding)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (kesifItems.length / 2).ceil(),
            itemBuilder: (context, colIndex) {
              return Padding(
                padding: EdgeInsets.only(right: colIndex < (kesifItems.length / 2).ceil() - 1 ? 8 : 0),
                child: Column(
                  children: [
                    // Üst satır
                    if (colIndex * 2 < kesifItems.length)
                      _buildKesifItem(context, kesifItems[colIndex * 2]),
                    const SizedBox(height: 8),
                    // Alt satır
                    if (colIndex * 2 + 1 < kesifItems.length)
                      _buildKesifItem(context, kesifItems[colIndex * 2 + 1]),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildKesifItem(BuildContext context, Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final emoji = item['icon'] as String;
    final name = item['name'] as String;
    final route = item['route'] as String;
    final badge = item['badge'] as String?;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.5),
              color.withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // İçerik
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            // Badge
            if (badge != null)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: badge == 'Viral' || badge == 'Hot' || badge == 'Trend'
                          ? [Color(0xFFFF1744), Color(0xFFFF6D00)]
                          : badge == 'Yeni'
                              ? [Color(0xFF00E676), Color(0xFF00BFA5)]
                              : badge == 'Fun'
                                  ? [Color(0xFFFFD700), Color(0xFFFF9800)]
                                  : [Color(0xFF2196F3), Color(0xFF00BCD4)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllSigns(BuildContext context) {
    // Burç tarihleri
    final signDates = {
      ZodiacSign.aries: '21 Mar - 19 Nis',
      ZodiacSign.taurus: '20 Nis - 20 May',
      ZodiacSign.gemini: '21 May - 20 Haz',
      ZodiacSign.cancer: '21 Haz - 22 Tem',
      ZodiacSign.leo: '23 Tem - 22 Ağu',
      ZodiacSign.virgo: '23 Ağu - 22 Eyl',
      ZodiacSign.libra: '23 Eyl - 22 Eki',
      ZodiacSign.scorpio: '23 Eki - 21 Kas',
      ZodiacSign.sagittarius: '22 Kas - 21 Ara',
      ZodiacSign.capricorn: '22 Ara - 19 Oca',
      ZodiacSign.aquarius: '20 Oca - 18 Şub',
      ZodiacSign.pisces: '19 Şub - 20 Mar',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ Burçlar',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        // Tüm burçlar tek satırda - scroll ile, BÜYÜK boyut
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ZodiacSign.values.length,
            itemBuilder: (context, index) {
              final sign = ZodiacSign.values[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < 11 ? 10 : 0,
                ),
                child: GestureDetector(
                  onTap: () => context
                      .push('${Routes.horoscope}/${sign.name.toLowerCase()}'),
                  child: Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          sign.color.withValues(alpha: 0.4),
                          sign.color.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: sign.color.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: sign.color.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Parlak burç sembolü
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              sign.color,
                              Colors.white,
                              sign.color,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            sign.symbol,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: sign.color,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sign.nameTr,
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          signDates[sign] ?? '',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white60,
                                fontSize: 7,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAllZodiacSigns(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0D0D1A),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              '✨ Tüm Burçlar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // 2 satırda 6'şar burç
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 0.85,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final sign = ZodiacSign.values[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.push('${Routes.horoscope}/${sign.name.toLowerCase()}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          sign.color.withValues(alpha: 0.3),
                          sign.color.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: sign.color.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sign.symbol,
                          style: TextStyle(
                            fontSize: 20,
                            color: sign.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sign.nameTr,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _SearchBottomSheet(),
    );
  }

  void _showAddProfileDialog(BuildContext context, WidgetRef ref) {
    context.push(Routes.savedProfiles);
  }
}

class _SearchBottomSheet extends StatefulWidget {
  const _SearchBottomSheet();

  @override
  State<_SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<_SearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // All available features with categories
  static final List<_SearchItem> _allFeatures = [
    // Keşfet (Explore) - Main features
    _SearchItem('Günlük Burç', 'Günlük burç yorumları', Icons.wb_sunny, Routes.horoscope, _SearchCategory.explore, ['günlük', 'burç', 'yorum', 'daily']),
    _SearchItem('Haftalık Burç', 'Haftalık burç yorumları', Icons.calendar_view_week, Routes.weeklyHoroscope, _SearchCategory.explore, ['haftalık', 'weekly']),
    _SearchItem('Aylık Burç', 'Aylık burç yorumları', Icons.calendar_month, Routes.monthlyHoroscope, _SearchCategory.explore, ['aylık', 'monthly']),
    _SearchItem('Yıllık Burç', 'Yıllık burç yorumları', Icons.calendar_today, Routes.yearlyHoroscope, _SearchCategory.explore, ['yıllık', 'yearly']),
    _SearchItem('Aşk Burcu', 'Aşk ve ilişki yorumları', Icons.favorite, Routes.loveHoroscope, _SearchCategory.explore, ['aşk', 'love', 'ilişki']),
    _SearchItem('Doğum Haritası', 'Natal chart analizi', Icons.auto_awesome, Routes.birthChart, _SearchCategory.explore, ['doğum', 'natal', 'harita', 'chart']),
    _SearchItem('Uyumluluk', 'Burç uyumluluk analizi', Icons.people, Routes.compatibility, _SearchCategory.explore, ['uyumluluk', 'compatibility']),
    _SearchItem('Transitler', 'Güncel gezegen transitler', Icons.public, Routes.transits, _SearchCategory.explore, ['transit', 'gezegen']),
    _SearchItem('Numeroloji', 'Sayıların gizemi', Icons.pin, Routes.numerology, _SearchCategory.explore, ['numeroloji', 'sayı', 'number']),
    _SearchItem('Kabala', 'Kabalistik analiz', Icons.account_tree, Routes.kabbalah, _SearchCategory.explore, ['kabala', 'kabbalah']),
    _SearchItem('Tarot', 'Tarot kartları', Icons.style, Routes.tarot, _SearchCategory.explore, ['tarot', 'kart', 'fal']),
    _SearchItem('Aura', 'Aura renkleri', Icons.blur_circular, Routes.aura, _SearchCategory.explore, ['aura', 'enerji']),

    // Daha Fazla Araç (More Tools) - Advanced features
    _SearchItem('Transit Takvimi', 'Aylık transit takvimi', Icons.event_note, Routes.transitCalendar, _SearchCategory.moreTools, ['transit', 'takvim', 'calendar']),
    _SearchItem('Tutulma Takvimi', 'Güneş ve Ay tutulmaları', Icons.dark_mode, Routes.eclipseCalendar, _SearchCategory.moreTools, ['tutulma', 'eclipse', 'güneş', 'ay']),
    _SearchItem('Sinastri', 'İlişki analizi', Icons.people_alt, Routes.synastry, _SearchCategory.moreTools, ['sinastri', 'synastry', 'ilişki']),
    _SearchItem('Kompozit', 'Kompozit harita', Icons.compare_arrows, Routes.compositeChart, _SearchCategory.moreTools, ['kompozit', 'composite']),
    _SearchItem('Progresyon', 'Secondary progressions', Icons.auto_graph, Routes.progressions, _SearchCategory.moreTools, ['progresyon', 'progression']),
    _SearchItem('Saturn Dönüşü', 'Saturn Return analizi', Icons.refresh, Routes.saturnReturn, _SearchCategory.moreTools, ['saturn', 'dönüş', 'return']),
    _SearchItem('Solar Return', 'Güneş dönüşü', Icons.wb_sunny_outlined, Routes.solarReturn, _SearchCategory.moreTools, ['solar', 'güneş', 'dönüş']),
    _SearchItem('Yıl Önü', 'Yıl öngörüsü', Icons.upcoming, Routes.yearAhead, _SearchCategory.moreTools, ['yıl', 'öngörü', 'year']),
    _SearchItem('Zamanlama', 'En uygun zamanlar', Icons.access_time, Routes.timing, _SearchCategory.moreTools, ['zaman', 'timing']),
    _SearchItem('Vedik', 'Vedik astroloji', Icons.brightness_3, Routes.vedicChart, _SearchCategory.moreTools, ['vedik', 'vedic', 'hint']),
    _SearchItem('Astro Harita', 'Astrocartography', Icons.map, Routes.astroCartography, _SearchCategory.moreTools, ['astro', 'harita', 'cartography']),
    _SearchItem('Yerel Uzay', 'Local space astroloji', Icons.explore, Routes.localSpace, _SearchCategory.moreTools, ['yerel', 'local', 'space']),
    _SearchItem('Elektif', 'En iyi zamanlar', Icons.schedule, Routes.electional, _SearchCategory.moreTools, ['elektif', 'electional']),
    _SearchItem('Drakonik', 'Drakonik harita', Icons.psychology, Routes.draconicChart, _SearchCategory.moreTools, ['drakonik', 'draconic']),
    _SearchItem('Asteroidler', 'Asteroid konumları', Icons.star_outline, Routes.asteroids, _SearchCategory.moreTools, ['asteroid', 'yıldız']),
    _SearchItem('Bahçe Ayı', 'Aya göre bahçecilik', Icons.eco, Routes.gardeningMoon, _SearchCategory.moreTools, ['bahçe', 'garden', 'ay', 'moon']),
    _SearchItem('Ünlüler', 'Ünlü haritaları', Icons.people, Routes.celebrities, _SearchCategory.moreTools, ['ünlü', 'celebrity']),
    _SearchItem('Makaleler', 'Astroloji yazıları', Icons.article, Routes.articles, _SearchCategory.moreTools, ['makale', 'article', 'yazı']),
    _SearchItem('Sözlük', 'Astroloji terimleri', Icons.menu_book, Routes.glossary, _SearchCategory.moreTools, ['sözlük', 'glossary', 'terim']),
    _SearchItem('Profil', 'Profil ayarları', Icons.person, Routes.profile, _SearchCategory.moreTools, ['profil', 'profile']),
    _SearchItem('Kayıtlı Profiller', 'Kaydedilmiş profiller', Icons.people_outline, Routes.savedProfiles, _SearchCategory.moreTools, ['kayıtlı', 'profil', 'saved']),
    _SearchItem('Karşılaştırma', 'Profil karşılaştırma', Icons.compare, Routes.comparison, _SearchCategory.moreTools, ['karşılaştır', 'compare']),
    _SearchItem('Ayarlar', 'Uygulama ayarları', Icons.settings, Routes.settings, _SearchCategory.moreTools, ['ayar', 'settings']),
    _SearchItem('Premium', 'Premium özellikler', Icons.workspace_premium, Routes.premium, _SearchCategory.moreTools, ['premium', 'pro']),
    // Spiritual & Wellness
    _SearchItem('Günlük Ritüel', 'Sabah ve akşam ritüelleri', Icons.self_improvement, Routes.dailyRituals, _SearchCategory.explore, ['ritüel', 'ritual', 'meditasyon', 'sabah', 'akşam']),
    _SearchItem('Chakra Analizi', 'Enerji merkezleri', Icons.blur_circular, Routes.chakraAnalysis, _SearchCategory.explore, ['chakra', 'çakra', 'enerji', 'denge']),
  ];

  List<_SearchItem> get _filteredFeatures {
    if (_searchQuery.isEmpty) return _allFeatures;
    final query = _searchQuery.toLowerCase();
    return _allFeatures.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.keywords.any((k) => k.toLowerCase().contains(query));
    }).toList();
  }

  List<_SearchItem> get _exploreFeatures =>
      _filteredFeatures.where((f) => f.category == _SearchCategory.explore).toList();

  List<_SearchItem> get _moreToolsFeatures =>
      _filteredFeatures.where((f) => f.category == _SearchCategory.moreTools).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Ara... (örn: burç, tarot, saturn)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.withAlpha(30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: 16),
              // Results
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (_exploreFeatures.isNotEmpty) ...[
                      _buildCategoryHeader('Keşfet', Icons.explore),
                      const SizedBox(height: 8),
                      ..._exploreFeatures.map((f) => _buildSearchResultItem(f)),
                      const SizedBox(height: 24),
                    ],
                    if (_moreToolsFeatures.isNotEmpty) ...[
                      _buildCategoryHeader('Daha Fazla Araç', Icons.build),
                      const SizedBox(height: 8),
                      ..._moreToolsFeatures.map((f) => _buildSearchResultItem(f)),
                    ],
                    if (_filteredFeatures.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 48, color: Colors.grey.withAlpha(100)),
                              const SizedBox(height: 16),
                              Text(
                                'Sonuç bulunamadı',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.starGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.starGold,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(_SearchItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.auroraStart.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: AppColors.auroraStart),
        ),
        title: Text(item.title),
        subtitle: Text(
          item.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pop(context);
          context.push(item.route);
        },
      ),
    );
  }
}

enum _SearchCategory { explore, moreTools }

class _SearchItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final _SearchCategory category;
  final List<String> keywords;

  const _SearchItem(this.title, this.description, this.icon, this.route, this.category, this.keywords);
}

// Animasyonlu Tantrik Logo Widget
// Küçük Tantrik Logo - Kompakt görünüm için
class _TantricLogoSmall extends StatefulWidget {
  const _TantricLogoSmall();

  @override
  State<_TantricLogoSmall> createState() => _TantricLogoSmallState();
}

class _TantricLogoSmallState extends State<_TantricLogoSmall> {
  @override
  Widget build(BuildContext context) {
    // Static version - no animation to prevent scroll issues
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 3,
          ),
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dış halka - statik
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.auroraStart.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          // İç halka
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          // Merkez sembol
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.starGold,
                AppColors.auroraStart,
                AppColors.cosmicPurple,
              ],
            ).createShader(bounds),
            child: const Text(
              '☸',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TantricLogo extends StatelessWidget {
  const _TantricLogo();

  @override
  Widget build(BuildContext context) {
    // Static version - no animation to prevent scroll issues
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.5),
            blurRadius: 25,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.3),
            blurRadius: 35,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dış halka - statik
          CustomPaint(
            size: const Size(70, 70),
            painter: _SacredGeometryPainter(
              color: AppColors.auroraStart,
              progress: 0,
            ),
          ),
          // İç halka
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
          // Merkez - Om sembolü / Lotus
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.starGold,
                AppColors.auroraStart,
                AppColors.cosmicPurple,
              ],
            ).createShader(bounds),
            child: const Text(
              '☸',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sacred Geometry Painter
class _SacredGeometryPainter extends CustomPainter {
  final Color color;
  final double progress;

  _SacredGeometryPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Dış çember
    canvas.drawCircle(center, radius, paint);

    // Altı köşeli yıldız (hexagram)
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * 3.14159 / 180;
      final x = center.dx + radius * 0.8 * (angle).abs() % 1 * (i % 2 == 0 ? 1 : 0.7);
      final y = center.dy + radius * 0.8 * (angle).abs() % 1 * (i % 2 == 0 ? 0.7 : 1);

      final pointAngle = (i * 60 - 90) * 3.14159 / 180;
      final px = center.dx + radius * 0.85 * math.cos(pointAngle);
      final py = center.dy + radius * 0.85 * math.sin(pointAngle);

      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint..color = color.withValues(alpha: 0.4));

    // İç üçgen
    final innerPath = Path();
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120 - 90) * 3.14159 / 180;
      final px = center.dx + radius * 0.5 * math.cos(angle);
      final py = center.dy + radius * 0.5 * math.sin(angle);

      if (i == 0) {
        innerPath.moveTo(px, py);
      } else {
        innerPath.lineTo(px, py);
      }
    }
    innerPath.close();
    canvas.drawPath(innerPath, paint..color = AppColors.starGold.withValues(alpha: 0.5));
  }

  @override
  bool shouldRepaint(covariant _SacredGeometryPainter oldDelegate) {
    return false; // Static - no repaints needed
  }
}

// Mini Chip - Kompakt bilgi gösterici
class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cardContent = GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color.withValues(alpha: _isPressed ? 0.3 : 0.2),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: widget.color.withValues(alpha: _isPressed ? 0.5 : 0.3),
              width: _isPressed ? 1.5 : 1.0,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: widget.color.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: _isPressed ? 0.3 : 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: cardContent,
      );
    }
    return cardContent;
  }
}

class _LanguageSelectorButton extends StatelessWidget {
  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const _LanguageSelectorButton({
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showLanguageSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLanguage.flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              size: 16,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.language,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    L10n.get('language', currentLanguage),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AppLanguage.values.map((lang) {
                  final isSelected = lang == currentLanguage;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () {
                        onLanguageChanged(lang);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary.withOpacity(0.2)
                              : (isDark
                                  ? AppColors.surfaceLight.withOpacity(0.3)
                                  : AppColors.lightSurfaceVariant),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _ShareSummaryButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ShareSummaryButton({required this.onTap});

  @override
  State<_ShareSummaryButton> createState() => _ShareSummaryButtonState();
}

// ════════════════════════════════════════════════════════════════════════════
// KOZMOZ USTASI - Premium AI Asistan Widget
// Ana sayfanın en önemli özelliği, kullanıcının ilk göreceği interaktif element
// ════════════════════════════════════════════════════════════════════════════

class _KozmozMasterSection extends ConsumerStatefulWidget {
  const _KozmozMasterSection();

  @override
  ConsumerState<_KozmozMasterSection> createState() => _KozmozMasterSectionState();
}

class _KozmozMasterSectionState extends ConsumerState<_KozmozMasterSection> {
  final _questionController = TextEditingController();
  bool _isLoading = false;
  bool _isExpanded = false;
  final List<Map<String, String>> _chatHistory = [];

  // Featured questions - en viral ve ilgi çekici sorular
  static const List<Map<String, dynamic>> _featuredQuestions = [
    {'text': '💕 Ruh eşimi ne zaman bulacağım?', 'category': 'love', 'gradient': [Color(0xFFE91E63), Color(0xFFFF5722)]},
    {'text': '💰 Bu yıl zengin olur muyum?', 'category': 'money', 'gradient': [Color(0xFF4CAF50), Color(0xFF8BC34A)]},
    {'text': '🔮 Geleceğim nasıl görünüyor?', 'category': 'future', 'gradient': [Color(0xFF9C27B0), Color(0xFF673AB7)]},
    {'text': '⭐ Bugün şansım nasıl?', 'category': 'daily', 'gradient': [Color(0xFFFFD700), Color(0xFFFF9800)]},
    {'text': '😈 En karanlık sırrım ne?', 'category': 'shadow', 'gradient': [Color(0xFF424242), Color(0xFF880E4F)]},
    {'text': '💋 Aşk hayatım ne zaman düzelir?', 'category': 'love', 'gradient': [Color(0xFFE91E63), Color(0xFFAD1457)]},
  ];

  // Extended questions list
  static const List<Map<String, dynamic>> _allQuestions = [
    // Burç Uyumu & Dedikodu
    {'text': '♈ Koç erkeğiyle anlaşabilir miyim?', 'category': 'compatibility'},
    {'text': '♏ Akrep kadınları neden bu kadar gizemli?', 'category': 'compatibility'},
    {'text': '♌ Aslan burcu neden hep ilgi bekler?', 'category': 'compatibility'},
    {'text': '♊ İkizler neden karar veremez?', 'category': 'compatibility'},
    {'text': '🔥 Ateş grubuyla su grubu uyumlu mu?', 'category': 'compatibility'},
    {'text': '💫 En sadık burç hangisi?', 'category': 'compatibility'},
    {'text': '😈 En kıskanç burç hangisi?', 'category': 'compatibility'},
    {'text': '💋 Yatakta en ateşli burç hangisi?', 'category': 'compatibility'},
    // Aşk & İlişki
    {'text': '💕 Bugün aşkta şansım nasıl?', 'category': 'love'},
    {'text': '💔 Eski sevgilim geri döner mi?', 'category': 'love'},
    {'text': '🤫 Beni aldatır mı?', 'category': 'love'},
    {'text': '💍 Evlilik teklifi ne zaman gelir?', 'category': 'love'},
    {'text': '😍 O benden hoşlanıyor mu?', 'category': 'love'},
    {'text': '💬 Neden mesaj atmıyor?', 'category': 'love'},
    // Kariyer & Para
    {'text': '💼 Terfi alacak mıyım?', 'category': 'career'},
    {'text': '📈 İş değişikliği yapmalı mıyım?', 'category': 'career'},
    {'text': '🎰 Şans oyunları oynamalı mıyım?', 'category': 'career'},
    // Spiritüel
    {'text': '✨ Şans yıldızım ne zaman parlayacak?', 'category': 'spiritual'},
    {'text': '🌙 Merkür retrosu beni nasıl etkiler?', 'category': 'spiritual'},
    {'text': '🦋 Hayatımda büyük değişim ne zaman?', 'category': 'general'},
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion([String? predefinedQuestion]) async {
    final question = predefinedQuestion ?? _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _isExpanded = true;
      _chatHistory.add({'role': 'user', 'content': question});
    });

    _questionController.clear();

    try {
      final userProfile = ref.read(userProfileProvider);
      final sign = userProfile?.sunSign ?? ZodiacSign.aries;
      final aiService = AiContentService();

      String response;
      if (aiService.isAiAvailable) {
        response = await aiService.generatePersonalizedAdvice(
          sign: sign,
          area: _determineAdviceArea(question),
          context: question,
        );
      } else {
        response = _generateSmartLocalResponse(question, sign);
      }

      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': 'Kozmik bağlantı geçici olarak kesildi. Lütfen tekrar deneyin. 🌟'});
        _isLoading = false;
      });
    }
  }

  AdviceArea _determineAdviceArea(String question) {
    final lowerQuestion = question.toLowerCase();
    if (lowerQuestion.contains('aşk') || lowerQuestion.contains('ilişki') || lowerQuestion.contains('partner') ||
        lowerQuestion.contains('sevgili') || lowerQuestion.contains('evlilik') || lowerQuestion.contains('ruh eşi')) {
      return AdviceArea.love;
    } else if (lowerQuestion.contains('kariyer') || lowerQuestion.contains('iş') || lowerQuestion.contains('para') ||
        lowerQuestion.contains('maaş') || lowerQuestion.contains('terfi') || lowerQuestion.contains('zengin')) {
      return AdviceArea.career;
    } else if (lowerQuestion.contains('sağlık') || lowerQuestion.contains('enerji') || lowerQuestion.contains('stres')) {
      return AdviceArea.health;
    } else if (lowerQuestion.contains('ruhsal') || lowerQuestion.contains('spiritüel') || lowerQuestion.contains('karma')) {
      return AdviceArea.spiritual;
    }
    return AdviceArea.spiritual;
  }

  String _generateSmartLocalResponse(String question, ZodiacSign sign) {
    final lowerQuestion = question.toLowerCase();

    // Burç uyumu ve dedikodu soruları
    if (lowerQuestion.contains('koç') && (lowerQuestion.contains('erkek') || lowerQuestion.contains('kadın') || lowerQuestion.contains('anlaş'))) {
      return '♈ Koç erkeği/kadınıyla ilişki mi düşünüyorsun? ${sign.nameTr} burcu olarak şunu bilmelisin:\n\n🔥 Koç burçları ateşli, tutkulu ve sabırsızdır. İlk adımı onlar atmak ister!\n\n💕 Seninle uyumu: ${_getCompatibilityWithAries(sign)}\n\n⚠️ Dikkat: Koçlar çabuk sıkılabilir, heyecanı canlı tut. Meydan okumayı severler ama ego çatışmalarından kaçın.\n\n💡 İpucu: Bağımsızlıklarına saygı göster, maceraya ortak ol!';
    }

    if (lowerQuestion.contains('akrep') && (lowerQuestion.contains('kadın') || lowerQuestion.contains('erkek') || lowerQuestion.contains('gizemli'))) {
      return '♏ Akrep burçları yüzyılın en gizemli ve yoğun aşıklarıdır!\n\n🔮 Neden gizemli? Pluto\'nun çocukları olarak derinliklerde yaşarlar. Duygularını kolay açmazlar ama bir kez bağlandılar mı ölümüne sadıktırlar.\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithScorpio(sign)}\n\n⚠️ Dikkat: Kıskançlık ve sahiplenme güçlü olabilir. Güven inşa et, sırlarını paylaş.\n\n💋 Bonus: Yatakta en tutkulu burçlardan biri... 🔥';
    }

    if (lowerQuestion.contains('aslan') && (lowerQuestion.contains('ilgi') || lowerQuestion.contains('bekler') || lowerQuestion.contains('ego'))) {
      return '♌ Aslan burçları neden sürekli ilgi bekler?\n\n👑 Güneş\'in çocukları olarak doğuştan "star" olarak doğdular! İlgi ve takdir onların oksijeni.\n\n🎭 Gerçek: Aslında çok cömert ve sıcak kalplidirler. İlgi istedikleri kadar sevgi de verirler.\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithLeo(sign)}\n\n💡 İpucu: Onları öv, takdir et, sahneyi paylaş. Karşılığında en sadık ve koruyucu partnere sahip olursun!';
    }

    if (lowerQuestion.contains('ikizler') && (lowerQuestion.contains('karar') || lowerQuestion.contains('veremez') || lowerQuestion.contains('değişken'))) {
      return '♊ İkizler neden karar veremez?\n\n🌀 Merkür\'ün çocukları olarak çift taraflı düşünürler - her şeyin iki yüzünü görürler!\n\n💬 Gerçek: Aslında karar verememe değil, tüm seçenekleri değerlendirme ihtiyacı. Çok zekiler!\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithGemini(sign)}\n\n⚠️ Dikkat: Sıkılabilirler, entelektüel uyarılma şart. Konuşma, tartışma, fikir alışverişi anahtar!\n\n😜 Bonus: İkizlerle asla sıkılmazsın - her gün farklı bir insan gibidirler!';
    }

    if (lowerQuestion.contains('ateş') && lowerQuestion.contains('su')) {
      return '🔥💧 Ateş ve Su grupları uyumlu mu?\n\n⚡ Zorlu ama mümkün! Ateş (Koç, Aslan, Yay) tutku ve enerji getirir. Su (Yengeç, Akrep, Balık) duygusal derinlik katar.\n\n✅ Artıları:\n• Tutku + Duygusallık = Yoğun romantizm\n• Birbirlerini dengeleyebilirler\n• Çekim gücü yüksek\n\n❌ Eksileri:\n• Ateş çok hızlı, Su çok hassas\n• İletişim kopuklukları yaşanabilir\n• Ateş suyu buharlaştırabilir, Su ateşi söndürebilir\n\n💡 Çözüm: Sabır, anlayış ve orta yol bulmak şart!';
    }

    if (lowerQuestion.contains('sadık') || lowerQuestion.contains('en sadık')) {
      return '💫 En sadık burçlar sıralaması:\n\n🥇 1. AKREP - Bir kez bağlandı mı ölümüne sadık! Ama ihanet edersen unutmaz.\n\n🥈 2. BOĞA - Toprak elementi, güvenilir ve sadık. Değişimi sevmez.\n\n🥉 3. YENGEÇ - Aile odaklı, koruyucu ve sadık. Duygusal bağ güçlü.\n\n4. OĞLAK - Sorumlu ve bağlı. Evliliği ciddiye alır.\n\n5. ASLAN - Sadık ama ilgi ister. İlgi alırsa sadık kalır.\n\n⚠️ En az sadık: İkizler (değişken), Yay (özgürlükçü), Kova (bağımsız)';
    }

    if (lowerQuestion.contains('kıskanç') || lowerQuestion.contains('kıskançlık')) {
      return '😈 En kıskanç burçlar:\n\n🔥 1. AKREP - Kıskançlık kralı/kraliçesi! Sahiplenme yoğun, güven sorunu var.\n\n2. ASLAN - Ego meselesi. "Benim olan başkasının olamaz" zihniyeti.\n\n3. BOĞA - Sahiplenme güdüsü güçlü. Yavaş güvenir ama kıskançlık patlamaları olabilir.\n\n4. YENGEÇ - Duygusal kıskançlık. Güvensizlik hissederse kapanır.\n\n5. KOÇ - Ani öfke patlamaları olabilir ama çabuk geçer.\n\n😎 En az kıskanç: Yay, Kova, İkizler - özgürlüğe değer verirler!';
    }

    if (lowerQuestion.contains('yatakta') || lowerQuestion.contains('ateşli') || lowerQuestion.contains('cinsel')) {
      return '💋 Yatakta en ateşli burçlar:\n\n🔥 1. AKREP - Tartışmasız şampiyon! Tutku, yoğunluk, derinlik... Seksi bir sanat formuna dönüştürürler.\n\n2. KOÇ - Ateşli ve enerjik. Spontan ve maceraperest.\n\n3. ASLAN - Dramatik ve gösterişli. Performans önemli!\n\n4. BOĞA - Duyusal zevklerin ustası. Yavaş ama etkili.\n\n5. BALIK - Romantik ve hayalperest. Duygusal bağ + fiziksel = mükemmel!\n\n😌 En az: Başak (aşırı analitik), Oğlak (iş odaklı), Kova (kafası başka yerde)';
    }

    // Zenginlik soruları
    if (lowerQuestion.contains('zengin') || lowerQuestion.contains('para') || lowerQuestion.contains('bolluk')) {
      return '💰 ${sign.nameTr} burcu olarak finansal geleceğin parlak görünüyor!\n\n✨ Jüpiter\'in bereketli enerjisi bu yıl mali fırsatlar getiriyor. Özellikle ${_getLuckyMonths(sign)} aylarında yeni gelir kaynakları belirleyebilir.\n\n💎 Güçlü yönlerin: ${_getFinancialStrength(sign)}\n\n🎯 Tavsiyem: Sabırlı ol, fırsatları değerlendir, bilinçli harca. Evren sana bolluk gönderiyor! 🌟';
    }

    // Ruh eşi soruları
    if (lowerQuestion.contains('ruh eşi') || lowerQuestion.contains('kader') || lowerQuestion.contains('büyük aşk')) {
      return '💕 ${sign.nameTr} için ruh eşi yorumu:\n\n🌟 Kuzey Düğüm sinyalleri seninle konuşuyor. Ruh eşin beklenmedik bir şekilde karşına çıkabilir.\n\n🔮 Dikkat etmen gereken burçlar: ${_getSoulMateCompatibility(sign)}\n\n⏰ Zamanlama: Venüs transitlerini takip et. Özellikle Venüs retrosundan sonra yeni başlangıçlar mümkün.\n\n💫 İpucu: Ruh eşini bulmak için önce kendini bul. İç dünyan ne kadar huzurlu olursa, doğru kişi o kadar çabuk belirir!';
    }

    // Aşk soruları
    if (lowerQuestion.contains('aşk') || lowerQuestion.contains('ilişki') || lowerQuestion.contains('sevgili') || lowerQuestion.contains('evlilik')) {
      return '💕 ${sign.nameTr} için aşk yorumu:\n\n🌹 Venüs şu an ${sign.element == 'Ateş' ? 'tutkunu artırıyor' : sign.element == 'Su' ? 'duygusal derinliğini güçlendiriyor' : sign.element == 'Toprak' ? 'sadakatini ödüllendiriyor' : 'iletişimini destekliyor'}.\n\n✨ Yakın dönemde romantik sürprizler olabilir. Kalbini aç, evren seninle iletişim kurmaya çalışıyor.\n\n💫 Tavsiye: ${_getLoveAdvice(sign)}';
    }

    // Genel/Spiritüel sorular
    return '✨ Sevgili ${sign.nameTr}, evren bugün seninle konuşuyor!\n\n🔮 ${_getDailyMessage(sign)}\n\n💫 Bugünün enerjisi: ${_getDailyEnergy(sign)}\n\n🌟 Tavsiye: İç sesini dinle, sezgilerine güven. Cevaplar kalbinde saklı.';
  }

  String _getLuckyMonths(ZodiacSign sign) {
    final months = {
      ZodiacSign.aries: 'Mart, Temmuz, Kasım',
      ZodiacSign.taurus: 'Nisan, Ağustos, Aralık',
      ZodiacSign.gemini: 'Mayıs, Eylül, Ocak',
      ZodiacSign.cancer: 'Haziran, Ekim, Şubat',
      ZodiacSign.leo: 'Temmuz, Kasım, Mart',
      ZodiacSign.virgo: 'Ağustos, Aralık, Nisan',
      ZodiacSign.libra: 'Eylül, Ocak, Mayıs',
      ZodiacSign.scorpio: 'Ekim, Şubat, Haziran',
      ZodiacSign.sagittarius: 'Kasım, Mart, Temmuz',
      ZodiacSign.capricorn: 'Aralık, Nisan, Ağustos',
      ZodiacSign.aquarius: 'Ocak, Mayıs, Eylül',
      ZodiacSign.pisces: 'Şubat, Haziran, Ekim',
    };
    return months[sign] ?? 'bahar ayları';
  }

  String _getFinancialStrength(ZodiacSign sign) {
    final strengths = {
      ZodiacSign.aries: 'Girişimcilik ve cesaret. Yeni projeler başlatmak senin işin!',
      ZodiacSign.taurus: 'Sabır ve istikrar. Yatırımlar seninle güvende.',
      ZodiacSign.gemini: 'İletişim ve çok yönlülük. Birden fazla gelir kaynağı yaratabilirsin.',
      ZodiacSign.cancer: 'Sezgi ve koruyuculuk. Aile işleri ve gayrimenkul avantajlı.',
      ZodiacSign.leo: 'Liderlik ve yaratıcılık. Gösterime dayalı işler parlıyor.',
      ZodiacSign.virgo: 'Detaycılık ve analiz. Finans ve muhasebe alanları güçlü.',
      ZodiacSign.libra: 'Diplomasi ve ortaklıklar. İş birlikleri bereketli.',
      ZodiacSign.scorpio: 'Derinlik ve dönüşüm. Yatırım ve araştırma alanları parlıyor.',
      ZodiacSign.sagittarius: 'Vizyon ve genişleme. Uluslararası fırsatlar seni bekliyor.',
      ZodiacSign.capricorn: 'Disiplin ve hırs. Uzun vadeli planlar meyvesini verecek.',
      ZodiacSign.aquarius: 'Yenilikçilik ve teknoloji. Dijital alanda fırsatlar var.',
      ZodiacSign.pisces: 'Yaratıcılık ve sezgi. Sanat ve spiritüel alanlar bereketli.',
    };
    return strengths[sign] ?? 'Yeteneklerini kullanmak';
  }

  String _getSoulMateCompatibility(ZodiacSign sign) {
    final soulmates = {
      ZodiacSign.aries: 'Aslan, Yay, İkizler - ateşli ve maceraperest ruhlar',
      ZodiacSign.taurus: 'Başak, Oğlak, Yengeç - güvenilir ve sadık kalpler',
      ZodiacSign.gemini: 'Terazi, Kova, Koç - entelektüel ve özgür ruhlar',
      ZodiacSign.cancer: 'Akrep, Balık, Boğa - duygusal ve koruyucu kalpler',
      ZodiacSign.leo: 'Yay, Koç, Terazi - parlak ve cömert ruhlar',
      ZodiacSign.virgo: 'Oğlak, Boğa, Akrep - detaycı ve sadık kalpler',
      ZodiacSign.libra: 'Kova, İkizler, Aslan - uyumlu ve estetik ruhlar',
      ZodiacSign.scorpio: 'Balık, Yengeç, Başak - derin ve tutkulu kalpler',
      ZodiacSign.sagittarius: 'Koç, Aslan, Kova - maceraperest ve özgür ruhlar',
      ZodiacSign.capricorn: 'Boğa, Başak, Balık - kararlı ve sadık kalpler',
      ZodiacSign.aquarius: 'İkizler, Terazi, Yay - yenilikçi ve bağımsız ruhlar',
      ZodiacSign.pisces: 'Yengeç, Akrep, Oğlak - romantik ve şefkatli kalpler',
    };
    return soulmates[sign] ?? 'tüm burçlarla uyum potansiyeli var';
  }

  String _getLoveAdvice(ZodiacSign sign) {
    final advices = {
      ZodiacSign.aries: 'Sabırlı ol, ani kararlar verme. Doğru kişi seni bekletmeye değer.',
      ZodiacSign.taurus: 'Değişime açık ol. Bazen konfor alanından çıkmak gerekir.',
      ZodiacSign.gemini: 'Bir ilişkiye odaklan. Çok seçenek bazen kafa karıştırır.',
      ZodiacSign.cancer: 'Kalbin kabuğunu aç. Korunmak için herkesi uzak tutma.',
      ZodiacSign.leo: 'Bazen arka planda dur. İlişki iki kişiliktir.',
      ZodiacSign.virgo: 'Mükemmeliyetçiliği bırak. Kusursuz aşk diye bir şey yok.',
      ZodiacSign.libra: 'Kendi sesini dinle. Herkesi memnun etmeye çalışma.',
      ZodiacSign.scorpio: 'Güvenmeyi öğren. Herkes seni incitmeye çalışmıyor.',
      ZodiacSign.sagittarius: 'Özgürlüğünü korurken bağlanmayı da öğren.',
      ZodiacSign.capricorn: 'İşi bir kenara bırak, duygularına yer aç.',
      ZodiacSign.aquarius: 'Duygusal mesafeyi azalt. Yakınlık zayıflık değil.',
      ZodiacSign.pisces: 'Gerçekçi ol. Hayallerdeki aşk yerine gerçek olanı gör.',
    };
    return advices[sign] ?? 'Kalbini aç, sevgiye izin ver.';
  }

  String _getDailyMessage(ZodiacSign sign) {
    final messages = {
      ZodiacSign.aries: 'Bugün cesaretin ödüllendirilecek. Korkularını yenmeye hazır ol!',
      ZodiacSign.taurus: 'Bugün hak ettiğini alacaksın. Sabır meyvesini veriyor.',
      ZodiacSign.gemini: 'Bugün iletişim gücün dorukta. Fikirlerini paylaş!',
      ZodiacSign.cancer: 'Bugün sezgilerin seni doğru yöne götürecek. Güven!',
      ZodiacSign.leo: 'Bugün parlama zamanı. Sahne senin, ışığını göster!',
      ZodiacSign.virgo: 'Bugün detaylar önemli. Dikkatli ol, fırsatlar gizli.',
      ZodiacSign.libra: 'Bugün denge günü. Uyum kur, güzellik yarat.',
      ZodiacSign.scorpio: 'Bugün dönüşüm zamanı. Eskiyi bırak, yeniye hazır ol.',
      ZodiacSign.sagittarius: 'Bugün macera günü. Yeni deneyimlere açık ol!',
      ZodiacSign.capricorn: 'Bugün başarı günü. Hedeflerine bir adım daha yaklaş.',
      ZodiacSign.aquarius: 'Bugün yenilik günü. Farklı ol, fark yarat!',
      ZodiacSign.pisces: 'Bugün yaratıcılık günü. Hayal gücünü kullan!',
    };
    return messages[sign] ?? 'Bugün senin günün!';
  }

  String _getDailyEnergy(ZodiacSign sign) {
    final energies = ['Pozitif', 'Güçlü', 'Yaratıcı', 'Tutkulu', 'Dengeli', 'Huzurlu', 'Enerjik', 'Sezgisel'];
    final index = (DateTime.now().day + sign.index) % energies.length;
    return energies[index];
  }

  // Burç uyumu hesaplama fonksiyonları
  String _getCompatibilityWithAries(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🔥🔥🔥 Mükemmel! İki ateş bir arada.',
      ZodiacSign.taurus: '⚠️ Zorlu. Sabır gerekli.',
      ZodiacSign.gemini: '✨ Harika! Maceraperest ikili.',
      ZodiacSign.cancer: '💔 Zor. Anlayış şart.',
      ZodiacSign.leo: '🔥🔥 Süper! Tutku patlaması.',
      ZodiacSign.virgo: '😐 Orta. Denge bulunmalı.',
      ZodiacSign.libra: '💕 İyi! Zıt ama çekici.',
      ZodiacSign.scorpio: '🌋 Yoğun! Ya harika ya felaket.',
      ZodiacSign.sagittarius: '🎯 Mükemmel! En uyumlu çift.',
      ZodiacSign.capricorn: '😅 Zorlu ama güçlü olabilir.',
      ZodiacSign.aquarius: '💫 İyi! Bağımsız ruhlar.',
      ZodiacSign.pisces: '🌊 Karışık. Nazik ol.',
    };
    return compatibilities[userSign] ?? 'Analiz ediliyor...';
  }

  String _getCompatibilityWithScorpio(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🌋 Yoğun! Tutku dolu.',
      ZodiacSign.taurus: '💕💕 Harika! Mükemmel çekim.',
      ZodiacSign.gemini: '😰 Zor. Derinlik farkı.',
      ZodiacSign.cancer: '🌊💕 Mükemmel! Su uyumu.',
      ZodiacSign.leo: '🔥⚡ Güç savaşı!',
      ZodiacSign.virgo: '✨ İyi! Güven inşa edilirse.',
      ZodiacSign.libra: '😐 Orta. Derinlik farkı.',
      ZodiacSign.scorpio: '🦂🦂 Yoğun! Ya ruh eşi ya düşman.',
      ZodiacSign.sagittarius: '⚠️ Zorlu. Güven sorunu.',
      ZodiacSign.capricorn: '💪 Güçlü! Güç çifti.',
      ZodiacSign.aquarius: '❄️ Çok zor. Zıt kutuplar.',
      ZodiacSign.pisces: '💕💕💕 EN İYİ! Ruhsal bağ.',
    };
    return compatibilities[userSign] ?? 'Analiz ediliyor...';
  }

  String _getCompatibilityWithLeo(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🔥🔥 Süper! Ateş uyumu.',
      ZodiacSign.taurus: '😤 Zorlu. İkisi de inatçı.',
      ZodiacSign.gemini: '🎭 İyi! Eğlenceli çift.',
      ZodiacSign.cancer: '🏠 Aile odaklı olabilir.',
      ZodiacSign.leo: '👑👑 Harika veya felaket.',
      ZodiacSign.virgo: '😐 Orta. Denge zor.',
      ZodiacSign.libra: '💕 Mükemmel! Romantik çift.',
      ZodiacSign.scorpio: '⚡ Güç savaşı!',
      ZodiacSign.sagittarius: '🔥🎯 Harika! Macera dolu.',
      ZodiacSign.capricorn: '🏆 Güç çifti olabilir.',
      ZodiacSign.aquarius: '💫 Zıt ama çekici.',
      ZodiacSign.pisces: '🌊 Romantik. Hayran olur.',
    };
    return compatibilities[userSign] ?? 'Analiz ediliyor...';
  }

  String _getCompatibilityWithGemini(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '✨ Harika! Enerjik.',
      ZodiacSign.taurus: '😅 Zorlu. Hız farkı.',
      ZodiacSign.gemini: '💬💬 İlginç! Eğlenceli.',
      ZodiacSign.cancer: '🌙 Duygusal zorluklar.',
      ZodiacSign.leo: '🎭 İyi! Sosyal çift.',
      ZodiacSign.virgo: '🧠 Zihinsel uyum.',
      ZodiacSign.libra: '💕💕 Mükemmel! Hava uyumu.',
      ZodiacSign.scorpio: '😰 Çok zor. Derinlik farkı.',
      ZodiacSign.sagittarius: '🎯✈️ Harika! Macera.',
      ZodiacSign.capricorn: '📊 Zorlu. Ciddiyet farkı.',
      ZodiacSign.aquarius: '💫💫 Süper! Entelektüel.',
      ZodiacSign.pisces: '🌊 Karışık. Köprü kurun.',
    };
    return compatibilities[userSign] ?? 'Analiz ediliyor...';
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F0F23),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFFE91E63).withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ════════════════════════════════════════════════════════════
              // HEADER - Premium görünüm
              // ════════════════════════════════════════════════════════════
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0).withValues(alpha: 0.4),
                      const Color(0xFFE91E63).withValues(alpha: 0.3),
                      const Color(0xFF673AB7).withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  children: [
                    // Animated Icon Container
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF9C27B0),
                            const Color(0xFFE91E63),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withValues(alpha: 0.6),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFD700)],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Colors.white, Color(0xFFFFD700), Colors.white],
                                ).createShader(bounds),
                                child: Text(
                                  '🔮 Kozmoz Ustası',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFF9800)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'AI',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${sign.nameTr} burcu için kişiselleştirilmiş kozmik rehberlik',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ════════════════════════════════════════════════════════════
              // FEATURED QUESTIONS - Hızlı erişim butonları
              // ════════════════════════════════════════════════════════════
              if (!_isExpanded && _chatHistory.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.amber, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'En Popüler Sorular',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Featured questions grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _featuredQuestions.map((q) {
                      final gradientColors = q['gradient'] as List<Color>;
                      return GestureDetector(
                        onTap: () => _askQuestion(q['text'] as String),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                gradientColors[0].withValues(alpha: 0.3),
                                gradientColors[1].withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: gradientColors[0].withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors[0].withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            q['text'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ════════════════════════════════════════════════════════════
              // CHAT HISTORY - Sohbet geçmişi
              // ════════════════════════════════════════════════════════════
              if (_chatHistory.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    minHeight: 120,
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.3)),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _chatHistory.map((message) {
                        final isUser = message['role'] == 'user';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isUser
                                        ? [const Color(0xFFFFD700), Colors.orange]
                                        : [const Color(0xFF9C27B0), const Color(0xFFE91E63)],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isUser ? const Color(0xFFFFD700) : const Color(0xFF9C27B0)).withValues(alpha: 0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isUser ? Icons.person : Icons.auto_awesome,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                                        : const Color(0xFF9C27B0).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isUser
                                          ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                                          : const Color(0xFF9C27B0).withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    message['content'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // ════════════════════════════════════════════════════════════
              // INPUT FIELD - Soru sorma alanı
              // ════════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF9C27B0).withValues(alpha: 0.1),
                              const Color(0xFFE91E63).withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _questionController,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Yıldızlara sormak istediğin her şey...',
                            hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                            prefixIcon: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                              ).createShader(bounds),
                              child: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                            ),
                            filled: false,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          onSubmitted: (_) => _askQuestion(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isLoading ? null : () => _askQuestion(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isLoading
                                ? [Colors.grey, Colors.grey.shade600]
                                : [const Color(0xFF9C27B0), const Color(0xFFE91E63)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isLoading ? [] : [
                            BoxShadow(
                              color: const Color(0xFF9C27B0).withValues(alpha: 0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),

              // ════════════════════════════════════════════════════════════
              // MORE QUESTIONS - Daha fazla soru
              // ════════════════════════════════════════════════════════════
              if (_chatHistory.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Başka sorular',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _allQuestions.length,
                          itemBuilder: (context, index) {
                            final question = _allQuestions[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => _askQuestion(question['text'] as String),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF9C27B0).withValues(alpha: 0.2),
                                        const Color(0xFFE91E63).withValues(alpha: 0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    question['text'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ESKİ _AiChatSection - Kullanılmıyor, referans için tutuldu
// ════════════════════════════════════════════════════════════════════════════

class _AiChatSection extends ConsumerStatefulWidget {
  const _AiChatSection();

  @override
  ConsumerState<_AiChatSection> createState() => _AiChatSectionState();
}

class _AiChatSectionState extends ConsumerState<_AiChatSection> {
  final _questionController = TextEditingController();
  bool _isLoading = false;
  final List<Map<String, String>> _chatHistory = [];

  // Hazır sorular - MASTER seviye genişletilmiş liste
  static const List<Map<String, dynamic>> _suggestedQuestions = [
    // Burç Uyumu & Dedikodu
    {'text': '♈ Koç erkeğiyle anlaşabilir miyim?', 'category': 'compatibility', 'icon': '♈'},
    {'text': '♏ Akrep kadınları neden bu kadar gizemli?', 'category': 'compatibility', 'icon': '♏'},
    {'text': '♌ Aslan burcu neden hep ilgi bekler?', 'category': 'compatibility', 'icon': '♌'},
    {'text': '♊ İkizler neden karar veremez?', 'category': 'compatibility', 'icon': '♊'},
    {'text': '🔥 Ateş grubuyla su grubu uyumlu mu?', 'category': 'compatibility', 'icon': '🔥'},
    {'text': '💫 En sadık burç hangisi?', 'category': 'compatibility', 'icon': '💫'},
    {'text': '😈 En kıskanç burç hangisi?', 'category': 'compatibility', 'icon': '😈'},
    {'text': '💋 Yatakta en ateşli burç hangisi?', 'category': 'compatibility', 'icon': '💋'},
    // Aşk & İlişki Dedikodu
    {'text': '💕 Bugün aşkta şansım nasıl?', 'category': 'love', 'icon': '💕'},
    {'text': '💑 Ruh eşimi ne zaman bulacağım?', 'category': 'love', 'icon': '💑'},
    {'text': '💔 Eski sevgilim geri döner mi?', 'category': 'love', 'icon': '💔'},
    {'text': '🤫 Beni aldatır mı?', 'category': 'love', 'icon': '🤫'},
    {'text': '💍 Evlilik teklifi ne zaman gelir?', 'category': 'love', 'icon': '💍'},
    {'text': '😍 O benden hoşlanıyor mu?', 'category': 'love', 'icon': '😍'},
    {'text': '💬 Neden mesaj atmıyor?', 'category': 'love', 'icon': '💬'},
    {'text': '🔮 Gelecek aşkım nasıl biri?', 'category': 'love', 'icon': '🔮'},
    // Kariyer & Para
    {'text': '💼 Terfi alacak mıyım?', 'category': 'career', 'icon': '💼'},
    {'text': '💰 Zengin olacak mıyım?', 'category': 'career', 'icon': '💰'},
    {'text': '📈 İş değişikliği yapmalı mıyım?', 'category': 'career', 'icon': '📈'},
    {'text': '🎰 Şans oyunları oynamalı mıyım?', 'category': 'career', 'icon': '🎰'},
    // Spiritüel & Genel
    {'text': '✨ Şans yıldızım ne zaman parlayacak?', 'category': 'spiritual', 'icon': '✨'},
    {'text': '🌙 Merkür retrosu beni nasıl etkiler?', 'category': 'spiritual', 'icon': '🌙'},
    {'text': '🦋 Hayatımda büyük değişim ne zaman?', 'category': 'general', 'icon': '🦋'},
    {'text': '🎭 Bu hafta dikkat etmem gereken ne?', 'category': 'general', 'icon': '🎭'},
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion([String? predefinedQuestion]) async {
    final question = predefinedQuestion ?? _questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _isLoading = true;
      _chatHistory.add({'role': 'user', 'content': question});
    });

    _questionController.clear();

    try {
      final userProfile = ref.read(userProfileProvider);
      final sign = userProfile?.sunSign ?? ZodiacSign.aries;
      final aiService = AiContentService();

      String response;
      if (aiService.isAiAvailable) {
        response = await aiService.generatePersonalizedAdvice(
          sign: sign,
          area: _determineAdviceArea(question),
          context: question,
        );
      } else {
        response = _generateSmartLocalResponse(question, sign);
      }

      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _chatHistory.add({'role': 'assistant', 'content': 'Kozmik bağlantı geçici olarak kesildi. Lütfen tekrar deneyin. 🌟'});
        _isLoading = false;
      });
    }
  }

  AdviceArea _determineAdviceArea(String question) {
    final lowerQuestion = question.toLowerCase();
    if (lowerQuestion.contains('aşk') || lowerQuestion.contains('ilişki') || lowerQuestion.contains('partner') ||
        lowerQuestion.contains('sevgili') || lowerQuestion.contains('evlilik') || lowerQuestion.contains('ruh eşi')) {
      return AdviceArea.love;
    } else if (lowerQuestion.contains('kariyer') || lowerQuestion.contains('iş') || lowerQuestion.contains('para') ||
        lowerQuestion.contains('maaş') || lowerQuestion.contains('terfi')) {
      return AdviceArea.career;
    } else if (lowerQuestion.contains('sağlık') || lowerQuestion.contains('enerji') || lowerQuestion.contains('stres') ||
        lowerQuestion.contains('uyku')) {
      return AdviceArea.health;
    } else if (lowerQuestion.contains('ruhsal') || lowerQuestion.contains('spiritüel') || lowerQuestion.contains('meditasyon') ||
        lowerQuestion.contains('karma') || lowerQuestion.contains('evren')) {
      return AdviceArea.spiritual;
    }
    return AdviceArea.spiritual;
  }

  String _generateSmartLocalResponse(String question, ZodiacSign sign) {
    final lowerQuestion = question.toLowerCase();

    // Burç uyumu ve dedikodu soruları
    if (lowerQuestion.contains('koç') && (lowerQuestion.contains('erkek') || lowerQuestion.contains('kadın') || lowerQuestion.contains('anlaş'))) {
      return '♈ Koç erkeği/kadınıyla ilişki mi düşünüyorsun? ${sign.nameTr} burcu olarak şunu bilmelisin:\n\n🔥 Koç burçları ateşli, tutkulu ve sabırsızdır. İlk adımı onlar atmak ister!\n\n💕 Seninle uyumu: ${_getCompatibilityWithAries(sign)}\n\n⚠️ Dikkat: Koçlar çabuk sıkılabilir, heyecanı canlı tut. Meydan okumayı severler ama ego çatışmalarından kaçın.\n\n💡 İpucu: Bağımsızlıklarına saygı göster, maceraya ortak ol!';
    }

    if (lowerQuestion.contains('akrep') && (lowerQuestion.contains('kadın') || lowerQuestion.contains('erkek') || lowerQuestion.contains('gizemli'))) {
      return '♏ Akrep burçları yüzyılın en gizemli ve yoğun aşıklarıdır!\n\n🔮 Neden gizemli? Pluto\'nun çocukları olarak derinliklerde yaşarlar. Duygularını kolay açmazlar ama bir kez bağlandılar mı ölümüne sadıktırlar.\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithScorpio(sign)}\n\n⚠️ Dikkat: Kıskançlık ve sahiplenme güçlü olabilir. Güven inşa et, sırlarını paylaş.\n\n💋 Bonus: Yatakta en tutkulu burçlardan biri... 🔥';
    }

    if (lowerQuestion.contains('aslan') && (lowerQuestion.contains('ilgi') || lowerQuestion.contains('bekler') || lowerQuestion.contains('ego'))) {
      return '♌ Aslan burçları neden sürekli ilgi bekler?\n\n👑 Güneş\'in çocukları olarak doğuştan "star" olarak doğdular! İlgi ve takdir onların oksijeni.\n\n🎭 Gerçek: Aslında çok cömert ve sıcak kalplidirler. İlgi istedikleri kadar sevgi de verirler.\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithLeo(sign)}\n\n💡 İpucu: Onları öv, takdir et, sahneyi paylaş. Karşılığında en sadık ve koruyucu partnere sahip olursun!';
    }

    if (lowerQuestion.contains('ikizler') && (lowerQuestion.contains('karar') || lowerQuestion.contains('veremez') || lowerQuestion.contains('değişken'))) {
      return '♊ İkizler neden karar veremez?\n\n🌀 Merkür\'ün çocukları olarak çift taraflı düşünürler - her şeyin iki yüzünü görürler!\n\n💬 Gerçek: Aslında karar verememe değil, tüm seçenekleri değerlendirme ihtiyacı. Çok zekiler!\n\n${sign.nameTr} burcu olarak seninle uyumu: ${_getCompatibilityWithGemini(sign)}\n\n⚠️ Dikkat: Sıkılabilirler, entelektüel uyarılma şart. Konuşma, tartışma, fikir alışverişi anahtar!\n\n😜 Bonus: İkizlerle asla sıkılmazsın - her gün farklı bir insan gibidirler!';
    }

    if (lowerQuestion.contains('ateş') && lowerQuestion.contains('su')) {
      return '🔥💧 Ateş ve Su grupları uyumlu mu?\n\n⚡ Zorlu ama mümkün! Ateş (Koç, Aslan, Yay) tutku ve enerji getirir. Su (Yengeç, Akrep, Balık) duygusal derinlik katar.\n\n✅ Artıları:\n• Tutku + Duygusallık = Yoğun romantizm\n• Birbirlerini dengeleyebilirler\n• Çekim gücü yüksek\n\n❌ Eksileri:\n• Ateş çok hızlı, Su çok hassas\n• İletişim kopuklukları yaşanabilir\n• Ateş suyu buharlaştırabilir, Su ateşi söndürebilir\n\n💡 Çözüm: Sabır, anlayış ve orta yol bulmak şart!';
    }

    if (lowerQuestion.contains('sadık') || lowerQuestion.contains('en sadık')) {
      return '💫 En sadık burçlar sıralaması:\n\n🥇 1. AKREP - Bir kez bağlandı mı ölümüne sadık! Ama ihanet edersen unutmaz.\n\n🥈 2. BOĞA - Toprak elementi, güvenilir ve sadık. Değişimi sevmez.\n\n🥉 3. YENGEÇ - Aile odaklı, koruyucu ve sadık. Duygusal bağ güçlü.\n\n4. OĞLAK - Sorumlu ve bağlı. Evliliği ciddiye alır.\n\n5. ASLAN - Sadık ama ilgi ister. İlgi alırsa sadık kalır.\n\n⚠️ En az sadık: İkizler (değişken), Yay (özgürlükçü), Kova (bağımsız)';
    }

    if (lowerQuestion.contains('kıskanç') || lowerQuestion.contains('kıskançlık')) {
      return '😈 En kıskanç burçlar:\n\n🔥 1. AKREP - Kıskançlık kralı/kraliçesi! Sahiplenme yoğun, güven sorunu var.\n\n2. ASLAN - Ego meselesi. "Benim olan başkasının olamaz" zihniyeti.\n\n3. BOĞA - Sahiplenme güdüsü güçlü. Yavaş güvenir ama kıskançlık patlamaları olabilir.\n\n4. YENGEÇ - Duygusal kıskançlık. Güvensizlik hissederse kapanır.\n\n5. KOÇ - Ani öfke patlamaları olabilir ama çabuk geçer.\n\n😎 En az kıskanç: Yay, Kova, İkizler - özgürlüğe değer verirler!';
    }

    if (lowerQuestion.contains('yatakta') || lowerQuestion.contains('ateşli') || lowerQuestion.contains('cinsel')) {
      return '💋 Yatakta en ateşli burçlar:\n\n🔥 1. AKREP - Tartışmasız şampiyon! Tutku, yoğunluk, derinlik... Seksi bir sanat formuna dönüştürürler.\n\n2. KOÇ - Ateşli ve enerjik. Spontan ve maceraperest.\n\n3. ASLAN - Dramatik ve gösterişli. Performans önemli!\n\n4. BOĞA - Duyusal zevklerin ustası. Yavaş ama etkili.\n\n5. BALIK - Romantik ve hayalperest. Duygusal bağ + fiziksel = mükemmel!\n\n😌 En az: Başak (aşırı analitik), Oğlak (iş odaklı), Kova (kafası başka yerde)';
    }

    // Aşk soruları
    if (lowerQuestion.contains('aşk') || lowerQuestion.contains('ilişki') || lowerQuestion.contains('sevgili') ||
        lowerQuestion.contains('ruh eşi') || lowerQuestion.contains('evlilik')) {
      final responses = {
        ZodiacSign.aries: '🔥 Koç burcu olarak tutkunuz ve enerjiniz aşkta sizi öne çıkarıyor. Venüs bugün cesaretli adımları destekliyor. Kalbinizin sesini dinleyin, duygularınızı açıkça ifade edin. Yeni bir romantik döngü başlıyor olabilir.',
        ZodiacSign.taurus: '🌹 Boğa burcu olarak sadakatiniz ve duyusal yaklaşımınız ilişkilerde güç kaynağınız. Venüs sizin yönetici gezegeniniz olarak güven ve romantizmi artırıyor. Sabırla bekleyin, doğru kişi yolda.',
        ZodiacSign.gemini: '💬 İkizler burcu olarak iletişim gücünüz aşkta sizi öne çıkarıyor. Merkür derin sohbetleri destekliyor. Merakınızı partnerinize yönlendirin, zihinsel bağ duygusal bağı güçlendirir.',
        ZodiacSign.cancer: '🌙 Yengeç burcu olarak duygusal derinliğiniz ilişkilerde büyük avantaj. Ay enerjisi sezgilerinizi keskinleştiriyor. Koruyucu içgüdülerinizi kullanın ama aşırı hassas olmaktan kaçının.',
        ZodiacSign.leo: '👑 Aslan burcu olarak cömertliğiniz ve sıcaklığınız aşkta mıknatıs gibi çekiyor. Güneş parlamanızı destekliyor. Romantik jestler yapın, ama partnerinize de sahne verin.',
        ZodiacSign.virgo: '💎 Başak burcu olarak küçük detaylara verdiğiniz önem ilişkilerde fark yaratıyor. Merkür analitik yaklaşımınızı güçlendiriyor. Mükemmeliyetçiliği bırakın, sevgiyi olduğu gibi kabul edin.',
        ZodiacSign.libra: '⚖️ Terazi burcu olarak uyum arayışınız ilişkilerde denge sağlıyor. Venüs romantik atmosferleri destekliyor. Adalet duygusunu aşkta da kullanın, karşılıklı saygı şart.',
        ZodiacSign.scorpio: '🦂 Akrep burcu olarak tutkunuz ve yoğunluğunuz aşkta güçlü bağlar kuruyor. Pluto derin dönüşümü destekliyor. Güven inşa etmeye odaklanın, kıskançlığı yönetin.',
        ZodiacSign.sagittarius: '🏹 Yay burcu olarak özgürlük aşkınız ve maceracı ruhunuz ilişkilere heyecan katıyor. Jüpiter genişlemeyi destekliyor. Partner ile birlikte keşfedin, büyüyün.',
        ZodiacSign.capricorn: '🏔️ Oğlak burcu olarak ciddiyetiniz ve bağlılığınız uzun vadeli ilişkiler için ideal. Satürn sadakati ödüllendiriyor. Duygularınızı ifade etmekten çekinmeyin.',
        ZodiacSign.aquarius: '🌊 Kova burcu olarak özgünlüğünüz ve entelektüel yaklaşımınız ilişkilere farklı bir boyut katıyor. Uranüs sürprizler getiriyor. Arkadaşlık temelli aşk sizin için ideal.',
        ZodiacSign.pisces: '🐟 Balık burcu olarak romantizminiz ve empati gücünüz aşkta derin bağlar kurmanızı sağlıyor. Neptün ruhsal bağları güçlendiriyor. Hayalleriniz gerçeğe dönüşüyor.',
      };
      return responses[sign] ?? '💕 Aşk hayatınızda pozitif enerjiler hissediyorum. Kalbinizi açın, evren sizi destekliyor.';
    }

    // Kariyer & Para soruları
    if (lowerQuestion.contains('kariyer') || lowerQuestion.contains('iş') || lowerQuestion.contains('para') ||
        lowerQuestion.contains('maaş') || lowerQuestion.contains('terfi')) {
      final responses = {
        ZodiacSign.aries: '🚀 Koç burcu olarak liderlik yetenekleriniz kariyerde öne çıkıyor. Mars cesaret veriyor, yeni projeler başlatmak için ideal zaman. Girişimci ruhunuzu kullanın!',
        ZodiacSign.taurus: '💎 Boğa burcu olarak sabırlı ve istikrarlı yaklaşımınız finansal güvenlik getiriyor. Venüs bolluk kapılarını açıyor. Yatırımlar için dikkatli ama kararlı olun.',
        ZodiacSign.gemini: '🌐 İkizler burcu olarak iletişim yetenekleriniz kariyerde avantaj. Merkür network fırsatları sunuyor. Çok yönlülüğünüzü kullanın, farklı alanlarda parlamak mümkün.',
        ZodiacSign.cancer: '🏠 Yengeç burcu olarak sezgisel yaklaşımınız iş kararlarında rehber. Ay enerjisi ev tabanlı işleri destekliyor. Güvendiğiniz insanlarla çalışın.',
        ZodiacSign.leo: '👑 Aslan burcu olarak yaratıcılığınız ve liderliğiniz kariyerde parlamanızı sağlıyor. Güneş sahne önü rolleri aydınlatıyor. Kendinizi gösterin!',
        ZodiacSign.virgo: '📊 Başak burcu olarak analitik yetenekleriniz ve detay odaklılığınız kariyerde değerli. Merkür organizasyon projelerini destekliyor. Sistemler kurun.',
        ZodiacSign.libra: '🤝 Terazi burcu olarak diplomasi yeteneğiniz iş hayatında köprüler kuruyor. Venüs ortaklıkları kutsuyor. İş birlikleri ve ortaklıklar faydalı.',
        ZodiacSign.scorpio: '🔍 Akrep burcu olarak araştırma yetenekleriniz ve derinlemesine analiz gücünüz kariyerde avantaj. Pluto gizli fırsatları ortaya çıkarıyor.',
        ZodiacSign.sagittarius: '🌍 Yay burcu olarak vizyoner bakış açınız ve genişleme arzunuz kariyerde yeni ufuklar açıyor. Jüpiter uluslararası fırsatları destekliyor.',
        ZodiacSign.capricorn: '🏆 Oğlak burcu olarak disiplininiz ve hırsınız kariyer zirvesine taşıyor. Satürn uzun vadeli başarıyı ödüllendiriyor. Hedeflerinize odaklanın.',
        ZodiacSign.aquarius: '💡 Kova burcu olarak yenilikçi fikirleriniz ve bağımsız ruhunuz kariyerde fark yaratıyor. Uranüs teknoloji alanlarını aydınlatıyor.',
        ZodiacSign.pisces: '🎨 Balık burcu olarak yaratıcılığınız ve sezgisel yaklaşımınız kariyerde benzersiz değer katıyor. Neptün sanatsal alanları kutsuyor.',
      };
      return responses[sign] ?? '💼 Kariyer yolculuğunuzda pozitif gelişmeler görüyorum. Yeteneklerinize güvenin, fırsatlar kapıda.';
    }

    // Sağlık & Enerji soruları
    if (lowerQuestion.contains('sağlık') || lowerQuestion.contains('enerji') || lowerQuestion.contains('stres') ||
        lowerQuestion.contains('uyku') || lowerQuestion.contains('yorgun')) {
      final responses = {
        ZodiacSign.aries: '🔥 Koç burcu olarak yüksek enerjinizi yönetmek önemli. Mars fiziksel aktiviteyi destekliyor. Yoğun sporlar ve açık hava egzersizleri size iyi gelecek.',
        ZodiacSign.taurus: '🌿 Boğa burcu olarak duyusal keyifler ruhunuzu besliyor. Venüs spa ve masajı destekliyor. Doğal yiyecekler ve topraklanma egzersizleri önerilir.',
        ZodiacSign.gemini: '🧠 İkizler burcu olarak zihinsel detoks önemli. Merkür bilgi bombardımanından uzaklaşmayı öneriyor. Hafif yürüyüşler ve meditasyon faydalı.',
        ZodiacSign.cancer: '💧 Yengeç burcu olarak su elementi şifa veriyor. Ay duygusal arınmayı destekliyor. Deniz tuzu banyoları ve su terapisi önerilir.',
        ZodiacSign.leo: '❤️ Aslan burcu olarak kalp sağlığına dikkat önemli. Güneş kardiyovasküler egzersizleri destekliyor. Dans ve yaratıcı ifade enerjinizi dengeler.',
        ZodiacSign.virgo: '🌱 Başak burcu olarak detoks ve arınma ritüelleri şifa verir. Merkür sağlıklı rutinleri destekliyor. Mükemmeliyetçiliği bırakın, dinlenin.',
        ZodiacSign.libra: '⚖️ Terazi burcu olarak denge çalışmaları önemli. Venüs yoga ve pilates destekliyor. Güzellik ritüelleri ruhunuzu besliyor.',
        ZodiacSign.scorpio: '🦋 Akrep burcu olarak derin dönüşüm ve şifa çalışmaları faydalı. Pluto gölge çalışmasını destekliyor. Meditasyon gücünüzü artırır.',
        ZodiacSign.sagittarius: '🏃 Yay burcu olarak hareket ve macera şart! Jüpiter doğada vakit geçirmeyi destekliyor. Stretching ve kalça egzersizleri önemli.',
        ZodiacSign.capricorn: '🦴 Oğlak burcu olarak kemik ve eklem sağlığına dikkat önemli. Satürn dinlenmeyi ve rejenerasyonu destekliyor. Aşırı çalışmaktan kaçının.',
        ZodiacSign.aquarius: '⚡ Kova burcu olarak sinir sistemi dengelemesi gerekli. Uranüs teknolojiden uzaklaşmayı öneriyor. Sosyal aktiviteler ruh sağlığını destekler.',
        ZodiacSign.pisces: '🌊 Balık burcu olarak su elementleriyle şifa bulursunuz. Neptün yüzme ve banyo ritüellerini destekliyor. Uyku kalitesine dikkat edin.',
      };
      return responses[sign] ?? '⚡ Enerjinizi dengelemek için doğayla bağlantı kurun, meditasyon yapın ve bedeninizi dinleyin.';
    }

    // Genel/Spiritüel sorular
    final generalResponses = {
      ZodiacSign.aries: '🔥 Sevgili ${sign.nameTr}, ateş enerjiniz bugün doruklarda. Mars gücünüzü destekliyor, cesaretinizle yeni kapılar açacaksınız. Evren "harekete geç" diyor. Kalbinizin sesini dinleyin, başarı kaçınılmaz.',
      ZodiacSign.taurus: '🌹 Sevgili ${sign.nameTr}, toprak enerjisi sizi besliyor. Venüs güzelliğinizi ve bolluğunuzu artırıyor. Sabırla bekleyin, zamanı gelince en tatlı meyveler sizin olacak. Bugün kendinizi şımartın.',
      ZodiacSign.gemini: '💬 Sevgili ${sign.nameTr}, zihinsel çevikliğiniz bugün süper güç. Merkür düşüncelerinizi keskinleştiriyor. İletişim yeteneğinizi kullanın, fikirleriniz dünyayı değiştirebilir.',
      ZodiacSign.cancer: '🌙 Sevgili ${sign.nameTr}, Ay ışığı ruhunuzu aydınlatıyor. Sezgileriniz çok güçlü, onları dinleyin. Duygusal zekânız rehberiniz olsun, şefkatiniz şifa verir.',
      ZodiacSign.leo: '👑 Sevgili ${sign.nameTr}, Güneş enerjiniz maksimumda. Yaratıcılığınız ve liderliğiniz parlıyor. Sahneye çıkın, ilgi odağı olun. Cömertliğiniz bereketinizi artırır.',
      ZodiacSign.virgo: '💎 Sevgili ${sign.nameTr}, analitik zekânız bugün lazer gibi. Detaylarda sihir gizli. Organizasyon yeteneğinizi kullanın, şifalı ellerinizle fark yaratın.',
      ZodiacSign.libra: '⚖️ Sevgili ${sign.nameTr}, denge ve uyum enerjisi güçlü. Venüs diplomasi yeteneğinizi artırıyor. Güzellik yaratın, güzellik çekin. İlişkilerde harmoni zamanı.',
      ZodiacSign.scorpio: '🦂 Sevgili ${sign.nameTr}, dönüşüm enerjisi yoğun. Sezgileriniz keskin, gizli gerçekler ortaya çıkıyor. Tutku ve güç sizinle. Derinliklerde hazineler bekliyor.',
      ZodiacSign.sagittarius: '🏹 Sevgili ${sign.nameTr}, macera ruhu uyanıyor. Jüpiter şansınızı genişletiyor. Yeni ufuklar, yeni deneyimler sizi bekliyor. Bilgelik arayışınız ödüllendirilecek.',
      ZodiacSign.capricorn: '🏔️ Sevgili ${sign.nameTr}, Satürn disiplin ve yapı veriyor. Hedeflerinize kararlılıkla ilerleyin. Uzun vadeli planlar için mükemmel zaman. Zirve yakın.',
      ZodiacSign.aquarius: '🌊 Sevgili ${sign.nameTr}, yenilikçi enerjiniz dorukta. Uranüs beklenmedik fırsatlar getiriyor. Değişime açık olun, benzersizliğiniz süper gücünüz.',
      ZodiacSign.pisces: '🐟 Sevgili ${sign.nameTr}, spiritüel bağlantınız güçlü. Neptün yaratıcılığınızı ve sezgilerinizi besliyor. Rüyalarınız mesaj taşıyor, evrenle bir olun.',
    };

    return generalResponses[sign] ?? '✨ Evren bugün sizinle konuşuyor. İçsel sesinizi dinleyin, cevaplar kalbinizde saklı.';
  }

  // Burç uyumu hesaplama fonksiyonları
  String _getCompatibilityWithAries(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🔥🔥🔥 Mükemmel! İki ateş bir arada - tutku patlaması. Ama ego çatışmasına dikkat!',
      ZodiacSign.taurus: '⚠️ Zorlu. Koç hızlı, Boğa yavaş. Sabır gerekli, ama zıtlıklar çeker.',
      ZodiacSign.gemini: '✨ Harika! İkisi de maceraperest. Hiç sıkılmazlar, iletişim güçlü.',
      ZodiacSign.cancer: '💔 Zor. Yengeç hassas, Koç düşüncesiz olabilir. Anlayış şart.',
      ZodiacSign.leo: '🔥🔥 Süper! İki ateş burcu = tutku. Liderlik paylaşılmalı.',
      ZodiacSign.virgo: '😐 Orta. Başak detaycı, Koç aceleci. Denge bulunmalı.',
      ZodiacSign.libra: '💕 İyi! Zıt kutuplar ama çekim var. Terazi dengeler.',
      ZodiacSign.scorpio: '🌋 Yoğun! İkisi de tutkulu ve inatçı. Ya harika ya felaket.',
      ZodiacSign.sagittarius: '🎯 Mükemmel! En uyumlu çift. Macera, özgürlük, eğlence.',
      ZodiacSign.capricorn: '😅 Zorlu. Oğlak planlı, Koç spontan. Çalışırsa güçlü olur.',
      ZodiacSign.aquarius: '💫 İyi! İkisi de bağımsız. Arkadaşlık + aşk = ideal.',
      ZodiacSign.pisces: '🌊 Karışık. Balık hassas, Koç sert. Nazik ol.',
    };
    return compatibilities[userSign] ?? 'Burç uyumunuz analiz ediliyor...';
  }

  String _getCompatibilityWithScorpio(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🌋 Yoğun! İkisi de tutkulu. Savaş ya da aşk - ortası yok.',
      ZodiacSign.taurus: '💕💕 Harika! Karşı burçlar ama mükemmel çekim. Sadakat garantili.',
      ZodiacSign.gemini: '😰 Zor. İkizler hafif, Akrep derin. Anlaşmak güç.',
      ZodiacSign.cancer: '🌊💕 Mükemmel! Su elementleri. Duygusal bağ çok güçlü.',
      ZodiacSign.leo: '🔥⚡ Güç savaşı! İkisi de hakim olmak ister. Ya harika ya felaket.',
      ZodiacSign.virgo: '✨ İyi! Analitik ikili. Güven inşa edilirse kalıcı.',
      ZodiacSign.libra: '😐 Orta. Terazi yüzeysel bulabilir, Akrep derin ister.',
      ZodiacSign.scorpio: '🦂🦂 Yoğun! Aynı burç. Ya ruh eşi ya düşman.',
      ZodiacSign.sagittarius: '⚠️ Zorlu. Yay özgür, Akrep sahiplenici. Güven sorunu.',
      ZodiacSign.capricorn: '💪 Güçlü! İkisi de kararlı ve hırslı. Güç çifti.',
      ZodiacSign.aquarius: '❄️ Çok zor. Kova mesafeli, Akrep yoğun. Zıt kutuplar.',
      ZodiacSign.pisces: '💕💕💕 EN İYİ! Su grubu uyumu. Ruhsal bağ mükemmel.',
    };
    return compatibilities[userSign] ?? 'Burç uyumunuz analiz ediliyor...';
  }

  String _getCompatibilityWithLeo(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '🔥🔥 Süper! Ateş + Ateş. Tutku var ama ego kontrolü şart.',
      ZodiacSign.taurus: '😤 Zorlu. İkisi de inatçı. Ama çekim güçlü.',
      ZodiacSign.gemini: '🎭 İyi! Eğlenceli çift. Sosyal ve aktif.',
      ZodiacSign.cancer: '🏠 Aile odaklı olabilir. Yengeç ilgi verir, Aslan alır.',
      ZodiacSign.leo: '👑👑 Harika veya felaket. İki kral/kraliçe. Sahne paylaşılmalı!',
      ZodiacSign.virgo: '😐 Orta. Başak eleştirir, Aslan övülmek ister. Denge zor.',
      ZodiacSign.libra: '💕 Mükemmel! Romantik çift. Güzellik ve ışık.',
      ZodiacSign.scorpio: '⚡ Güç savaşı! İkisi de dominant. Ya muhteşem ya berbat.',
      ZodiacSign.sagittarius: '🔥🎯 Harika! Ateş grubu. Macera, eğlence, tutku.',
      ZodiacSign.capricorn: '🏆 Güç çifti olabilir. Birlikte başarı.',
      ZodiacSign.aquarius: '💫 Zıt ama çekici. Bağımsızlık vs. sahiplenme.',
      ZodiacSign.pisces: '🌊 Romantik. Balık hayran olur, Aslan korur.',
    };
    return compatibilities[userSign] ?? 'Burç uyumunuz analiz ediliyor...';
  }

  String _getCompatibilityWithGemini(ZodiacSign userSign) {
    final compatibilities = {
      ZodiacSign.aries: '✨ Harika! Enerjik ve eğlenceli. Hiç sıkılmaz.',
      ZodiacSign.taurus: '😅 Zorlu. Boğa yavaş, İkizler hızlı. Sabır lazım.',
      ZodiacSign.gemini: '💬💬 İlginç! Çok konuşma, az eylem riski. Ama eğlenceli.',
      ZodiacSign.cancer: '🌙 Duygusal zorluklar. Yengeç güvenlik, İkizler özgürlük ister.',
      ZodiacSign.leo: '🎭 İyi! Sosyal ve parlak çift. Eğlence garantili.',
      ZodiacSign.virgo: '🧠 Zihinsel uyum. İkisi de Merkür yönetiminde. Analitik.',
      ZodiacSign.libra: '💕💕 Mükemmel! Hava grubu. İletişim ve sosyallik.',
      ZodiacSign.scorpio: '😰 Çok zor. Akrep derin, İkizler yüzeysel bulunur.',
      ZodiacSign.sagittarius: '🎯✈️ Harika! Karşı burçlar ama mükemmel macera.',
      ZodiacSign.capricorn: '📊 Zorlu. Oğlak ciddi, İkizler hafif. Denge lazım.',
      ZodiacSign.aquarius: '💫💫 Süper! Hava grubu. Entelektüel cennet.',
      ZodiacSign.pisces: '🌊 Karışık. Balık duygusal, İkizler mantıksal. Köprü kurun.',
    };
    return compatibilities[userSign] ?? 'Burç uyumunuz analiz ediliyor...';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Premium görünüm
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraStart.withValues(alpha: 0.4),
                  AppColors.auroraEnd.withValues(alpha: 0.3),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.auroraStart, AppColors.auroraEnd],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.auroraStart.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '🔮 Kozmik Asistan',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'MASTER',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Yıldızların bilgeliğini keşfet ✨',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat History - Geniş ve otomatik genişleyen
          if (_chatHistory.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.auroraStart.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _chatHistory.map((message) {
                    final isUser = message['role'] == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isUser
                                    ? [AppColors.starGold, Colors.orange]
                                    : [AppColors.auroraStart, AppColors.auroraEnd],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (isUser ? AppColors.starGold : AppColors.auroraStart).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              isUser ? Icons.person : Icons.auto_awesome,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? AppColors.starGold.withValues(alpha: 0.15)
                                    : AppColors.auroraStart.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isUser
                                      ? AppColors.starGold.withValues(alpha: 0.4)
                                      : AppColors.auroraStart.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                message['content'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Yıldızlara bir soru sor...',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                      prefixIcon: Icon(Icons.chat_bubble_outline, color: Colors.white38, size: 20),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.auroraStart, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: (_) => _askQuestion(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _isLoading ? null : () => _askQuestion(),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isLoading
                            ? [Colors.grey, Colors.grey.shade600]
                            : [AppColors.auroraStart, AppColors.auroraEnd],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _isLoading ? [] : [
                        BoxShadow(
                          color: AppColors.auroraStart.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Hazır Sorular - Genişletilmiş
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Popüler Sorular',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestedQuestions.length,
                    itemBuilder: (context, index) {
                      final question = _suggestedQuestions[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: _buildSuggestionChip(question['text'] as String),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => _askQuestion(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.auroraStart.withValues(alpha: 0.2),
              AppColors.auroraEnd.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.4)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ShareSummaryButtonState extends State<_ShareSummaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-1, -1),
              end: Alignment(1, 1),
              colors: [
                Color(0xFFFF3CAC), // Hot pink
                Color(0xFF784BA0), // Purple
                Color(0xFF2B86C5), // Blue
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withAlpha(60),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF3CAC).withAlpha(120),
                blurRadius: 25,
                offset: const Offset(-3, 6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: const Color(0xFF2B86C5).withAlpha(120),
                blurRadius: 25,
                offset: const Offset(3, 6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withAlpha(30),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Glass effect overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withAlpha(40),
                          Colors.white.withAlpha(5),
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sparkle emoji
                      const Text('✨', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      // Instagram icon - premium design
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFEDA77),
                              Color(0xFFF58529),
                              Color(0xFFDD2A7B),
                              Color(0xFF8134AF),
                              Color(0xFF515BD4),
                            ],
                            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDD2A7B).withAlpha(120),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Inner border
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                            // Camera icon
                            const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            // Dot
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Text content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Instagram\'da Paylaş',
                                style: GoogleFonts.raleway(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withAlpha(60),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('💫', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Hikayende kozmik enerjini paylaş!',
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withAlpha(220),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Text('🔮', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

// Yıldız deseni çizen CustomPainter
class _StarPatternPainter extends CustomPainter {
  final Color color;

  _StarPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Küçük yıldızlar çiz
    final starPositions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.8),
      Offset(size.width * 0.85, size.height * 0.75),
    ];

    for (final pos in starPositions) {
      _drawStar(canvas, pos, 3, paint);
    }

    // Çapraz çizgiler
    paint.strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width * 0.3, size.height * 0.7),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width * 0.7, size.height * 0.3),
      paint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * 3.14159 / 180;
      final x = center.dx + radius * (i % 2 == 0 ? 1 : 0.5) * (i < 2 ? 1 : -1) * (i % 2 == 0 ? (i == 0 ? 1 : -1) : 0);
      final y = center.dy + radius * (i % 2 == 1 ? 1 : 0.5) * (i < 2 ? -1 : 1) * (i % 2 == 1 ? (i == 1 ? -1 : 1) : 0);
      if (i == 0) {
        path.moveTo(center.dx + radius, center.dy);
      }
    }
    // Basit 4 köşeli yıldız
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx, center.dy + radius);
    path.moveTo(center.dx - radius, center.dy);
    path.lineTo(center.dx + radius, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// KOZMOZ Özel Parlayan Buton - Sürekli animasyonlu, göz alıcı
class _KozmozButton extends StatefulWidget {
  final VoidCallback onTap;

  const _KozmozButton({required this.onTap});

  @override
  State<_KozmozButton> createState() => _KozmozButtonState();
}

class _KozmozButtonState extends State<_KozmozButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            // Static gradient background
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD700),
                Color(0xFFFF6B9D),
                Color(0xFF9D4EDD),
                Color(0xFF00D9FF),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: const Color(0xFF00D9FF).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1A).withOpacity(0.85),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Static star icon
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFF9D4EDD),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    '✧',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Static text
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFD700),
                        Color(0xFFFFFFFF),
                        Color(0xFFFF6B9D),
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'KOZMOZ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFFD700).withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Rüya Tabiri Butonu - Mistik mor tema
class _DreamButton extends StatefulWidget {
  final VoidCallback onTap;

  const _DreamButton({required this.onTap});

  @override
  State<_DreamButton> createState() => _DreamButtonState();
}

class _DreamButtonState extends State<_DreamButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final glowIntensity = 0.4 + (_glowController.value * 0.3);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                // Mistik mor gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF9D4EDD).withOpacity(0.8),
                    const Color(0xFF6B3FA0).withOpacity(0.9),
                    const Color(0xFF3D2066).withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFAA77FF).withOpacity(_isHovered ? 0.8 : 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  // Pulsing glow
                  BoxShadow(
                    color: const Color(0xFF9D4EDD).withOpacity(glowIntensity),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: const Color(0xFFAA77FF).withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Moon emoji with glow
                  Container(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '\u{1F319}', // Crescent moon
                      style: TextStyle(
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Text
                  Text(
                    'Ruya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFAA77FF).withOpacity(0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Animasyonlu Header Butonu
class _AnimatedHeaderButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedHeaderButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedHeaderButton> createState() => _AnimatedHeaderButtonState();
}

class _AnimatedHeaderButtonState extends State<_AnimatedHeaderButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                // Daha yoğun gradient - daha görünür
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [widget.color.withAlpha(120), widget.color.withAlpha(80)]
                      : [widget.color.withAlpha(80), widget.color.withAlpha(50)],
                ),
                borderRadius: BorderRadius.circular(16),
                // Daha belirgin border
                border: Border.all(
                  color: widget.color.withAlpha(_isHovered ? 220 : 160),
                  width: 2,
                ),
                // Güçlü glow efekti
                boxShadow: [
                  // Ana glow - nabız efektli
                  BoxShadow(
                    color: widget.color.withAlpha((100 * _pulseAnimation.value).round()),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 2 * _pulseAnimation.value,
                  ),
                  // İç glow
                  BoxShadow(
                    color: widget.color.withAlpha(50),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  if (_isHovered)
                    BoxShadow(
                      color: widget.color.withAlpha(100),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Daha büyük ve parlak ikon
                  AnimatedRotation(
                    turns: _isHovered ? 0.05 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: widget.color.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Daha okunabilir yazı
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: widget.color.withAlpha(150),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
