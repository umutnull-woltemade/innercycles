import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/dream_interpretation_models.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/dream_share_card.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Dream Sharing Screen with Social Features
/// Allows users to create shareable cards from dream interpretations
class DreamShareScreen extends ConsumerStatefulWidget {
  final FullDreamInterpretation? interpretation;
  final String? quickShareText;
  final String? quickShareSymbol;

  const DreamShareScreen({
    super.key,
    this.interpretation,
    this.quickShareText,
    this.quickShareSymbol,
  });

  @override
  ConsumerState<DreamShareScreen> createState() => _DreamShareScreenState();
}

class _DreamShareScreenState extends ConsumerState<DreamShareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey _cardKey = GlobalKey();

  // Card configuration state
  DreamShareCardConfig _config = const DreamShareCardConfig();
  DreamCardTemplate _selectedTemplate = DreamCardTemplate.dreamQuote;

  // Content state
  String _mainText = '';
  String _subtitle = '';
  String _headerEmoji = '\u{1F319}';

  // Privacy settings
  bool _shareAnonymously = false;
  bool _shareInterpretationOnly = false;
  bool _shareSymbolOnly = false;

  // Generated content
  String? _generatedPoetry;
  String? _generatedAffirmation;
  List<String> _symbolArtSuggestions = [];

  // Share state
  bool _isSharing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeContent();
    _generateContent();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeContent() {
    if (widget.interpretation != null) {
      final interp = widget.interpretation!;
      _mainText = interp.whisperQuote;
      _subtitle = interp.archetypeName;
      _headerEmoji = interp.shareCard.emoji;
    } else if (widget.quickShareText != null) {
      _mainText = widget.quickShareText!;
      _headerEmoji = widget.quickShareSymbol ?? '\u{1F319}';
    } else {
      // Default content
      _mainText = L10nService.get('dreams.share_screen.default_text', ref.read(languageProvider));
      _headerEmoji = '\u{1F319}';
    }
  }

  void _generateContent() {
    // Generate poetry based on dream
    _generatedPoetry = _generateDreamPoetry();
    _generatedAffirmation = _generateDreamAffirmation();
    _symbolArtSuggestions = _generateSymbolArtSuggestions();
  }

  String _generateDreamPoetry() {
    final language = ref.read(languageProvider);
    if (widget.interpretation == null) {
      return L10nService.get('dreams.share_screen.default_poetry', language);
    }

    final symbols = widget.interpretation!.symbols;
    final mainSymbol = symbols.isNotEmpty ? symbols.first.symbol : L10nService.get('dreams.share_screen.mystery', language);
    final archetype = widget.interpretation!.archetypeName;

    final poetryTemplates = L10nService.getList('dreams.share_screen.poetry_templates', language);
    if (poetryTemplates.isEmpty) {
      return L10nService.get('dreams.share_screen.default_poetry', language);
    }

    final template = poetryTemplates[DateTime.now().microsecond % poetryTemplates.length];
    return template.replaceAll('{mainSymbol}', mainSymbol).replaceAll('{archetype}', archetype);
  }

  String _generateDreamAffirmation() {
    final language = ref.read(languageProvider);
    if (widget.interpretation == null) {
      return L10nService.get('dreams.share_screen.default_affirmation', language);
    }

    final guidance = widget.interpretation!.guidance;
    final moonPhase = MoonService.getCurrentPhase();

    final affirmations = L10nService.getList('dreams.share_screen.affirmations', language);
    if (affirmations.isEmpty) {
      return L10nService.get('dreams.share_screen.default_affirmation', language);
    }

    // First item includes moon phase and guidance
    final result = affirmations[DateTime.now().second % affirmations.length];
    if (result.contains('{moonEmoji}')) {
      return result.replaceAll('{moonEmoji}', moonPhase.emoji).replaceAll('{todayAction}', guidance.todayAction);
    }
    return result;
  }

  List<String> _generateSymbolArtSuggestions() {
    final language = ref.read(languageProvider);
    if (widget.interpretation == null) {
      return L10nService.getList('dreams.share_screen.default_art_suggestions', language);
    }

    final suggestions = <String>[];
    final symbolTemplate = L10nService.get('dreams.share_screen.symbol_art_template', language);
    for (final symbol in widget.interpretation!.symbols.take(3)) {
      suggestions.add(
        '${symbol.symbolEmoji} ${symbolTemplate.replaceAll('{symbol}', symbol.symbol)}',
      );
    }

    final archetypeTemplate = L10nService.get('dreams.share_screen.archetype_symbol_template', language);
    suggestions.add(
      '\u{1F52E} ${archetypeTemplate.replaceAll('{archetype}', widget.interpretation!.archetypeName)}',
    );

    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCardsTab(),
                    _buildCustomizeTab(),
                    _buildTemplatesTab(),
                    _buildGeneratedTab(),
                  ],
                ),
              ),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.mystic.withValues(alpha: 0.3), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.mystic.withValues(alpha: 0.5),
                  AppColors.nebulaPurple.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text('\u{1F4E4}', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('dreams.share_title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get('dreams.share_subtitle', language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Privacy toggle
          IconButton(
            onPressed: () => _showPrivacySheet(),
            icon: Icon(
              _shareAnonymously ? Icons.visibility_off : Icons.visibility,
              color: AppColors.mystic,
            ),
            tooltip: L10nService.get('settings.privacy', language),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.mystic, AppColors.cosmicPurple],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10nService.get('dreams.share_screen.tab_cards', ref.watch(languageProvider))),
          Tab(text: L10nService.get('dreams.share_screen.tab_customize', ref.watch(languageProvider))),
          Tab(text: L10nService.get('dreams.share_screen.tab_templates', ref.watch(languageProvider))),
          Tab(text: L10nService.get('dreams.share_screen.tab_generated', ref.watch(languageProvider))),
        ],
      ),
    );
  }

  // ========================================
  // TAB 1: Cards Preview
  // ========================================
  Widget _buildCardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Main card preview
          Center(child: _buildCurrentCard()),
          const SizedBox(height: 24),

          // Quick template buttons
          Text(
            L10nService.get('dreams.share_screen.quick_templates', ref.watch(languageProvider)),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _buildQuickTemplates(),

          const SizedBox(height: 24),

          // Theme preview strip
          Text(
            L10nService.get('dreams.share_screen.select_theme', ref.watch(languageProvider)),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          _buildThemeStrip(),
        ],
      ),
    );
  }

  Widget _buildCurrentCard() {
    final language = ref.watch(languageProvider);
    return DreamShareCard(
      repaintKey: _cardKey,
      mainText: _getDisplayText(),
      subtitle: _subtitle.isNotEmpty ? _subtitle : null,
      headerEmoji: _headerEmoji,
      footerText: _selectedTemplate.label(language),
      config: _config,
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  String _getDisplayText() {
    if (_shareSymbolOnly && widget.interpretation != null) {
      final symbols = widget.interpretation!.symbols;
      if (symbols.isNotEmpty) {
        return symbols.first.universalMeaning;
      }
    }

    if (_shareInterpretationOnly && widget.interpretation != null) {
      return widget.interpretation!.coreMessage;
    }

    return _mainText;
  }

  Widget _buildQuickTemplates() {
    final language = ref.watch(languageProvider);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: DreamCardTemplate.values.map((template) {
        final isSelected = _selectedTemplate == template;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTemplate = template;
              _updateContentForTemplate(template);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [AppColors.mystic, AppColors.cosmicPurple],
                    )
                  : null,
              color: isSelected ? null : AppColors.surfaceDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.mystic.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              template.label(language),
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _updateContentForTemplate(DreamCardTemplate template) {
    final interp = widget.interpretation;
    final language = ref.read(languageProvider);

    switch (template) {
      case DreamCardTemplate.dreamQuote:
        _mainText =
            interp?.whisperQuote ?? L10nService.get('dreams.share_screen.found_myself_in_dreams', language);
        _subtitle = '';
        _headerEmoji = '\u{1F319}';
        break;
      case DreamCardTemplate.symbolInsight:
        if (interp != null && interp.symbols.isNotEmpty) {
          final symbol = interp.symbols.first;
          _mainText = symbol.symbol;
          _subtitle = symbol.universalMeaning;
          _headerEmoji = symbol.symbolEmoji;
        } else {
          _mainText = L10nService.get('dreams.share_screen.symbol_insight_title', language);
          _subtitle = L10nService.get('dreams.share_screen.subconscious_messages', language);
          _headerEmoji = '\u{1F52E}';
        }
        break;
      case DreamCardTemplate.dailyMessage:
        _mainText =
            _generatedAffirmation ?? L10nService.get('dreams.share_screen.walking_in_dream_light', language);
        _subtitle = '';
        _headerEmoji = '\u{1F31F}';
        break;
      case DreamCardTemplate.moonPhase:
        final moonPhase = MoonService.getCurrentPhase();
        _mainText = moonPhase.meaning;
        _subtitle = '${moonPhase.localizedName(language)} ${L10nService.get('dreams.share_screen.energy', language)}';
        _headerEmoji = moonPhase.emoji;
        break;
      case DreamCardTemplate.personalInsight:
        _mainText = interp?.coreMessage ?? L10nService.get('dreams.share_screen.personal_insight', language);
        _subtitle = '';
        _headerEmoji = '\u{2728}';
        break;
      case DreamCardTemplate.archetypeDiscovery:
        _mainText = interp?.archetypeName ?? L10nService.get('dreams.share_screen.archetype', language);
        _subtitle = interp?.archetypeConnection ?? '';
        _headerEmoji = '\u{1F3AD}';
        break;
      case DreamCardTemplate.weeklySummary:
        _mainText = L10nService.get('dreams.share_screen.weekly_subconscious_guided', language);
        _subtitle = L10nService.get('dreams.share_screen.weekly_dream_summary', language);
        _headerEmoji = '\u{1F4D6}';
        break;
    }
  }

  Widget _buildThemeStrip() {
    final language = ref.watch(languageProvider);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: DreamCardTheme.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = DreamCardTheme.values[index];
          final isSelected = _config.theme == theme;

          return GestureDetector(
            onTap: () {
              setState(() {
                _config = _config.copyWith(theme: theme);
              });
            },
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.starGold
                          : Colors.transparent,
                      width: 2,
                    ),
                    gradient: _getThemePreviewGradient(theme),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  theme.label(language),
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? AppColors.starGold
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  LinearGradient _getThemePreviewGradient(DreamCardTheme theme) {
    switch (theme) {
      case DreamCardTheme.mystical:
        return const LinearGradient(
          colors: [Color(0xFF1A0A2E), Color(0xFF0D0517)],
        );
      case DreamCardTheme.minimal:
        return const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        );
      case DreamCardTheme.cosmic:
        return const LinearGradient(
          colors: [Color(0xFF2D1B4E), Color(0xFF0D0517)],
        );
      case DreamCardTheme.aurora:
        return const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
        );
      case DreamCardTheme.moonlit:
        return const LinearGradient(
          colors: [Color(0xFF1A1A3E), Color(0xFF0D0D1F)],
        );
      case DreamCardTheme.golden:
        return LinearGradient(
          colors: [
            const Color(0xFF2D2410),
            AppColors.starGold.withValues(alpha: 0.3),
          ],
        );
    }
  }

  // ========================================
  // TAB 2: Customize
  // ========================================
  Widget _buildCustomizeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit main text
          _buildSectionTitle(L10nService.get('dreams.share_screen.main_text', ref.watch(languageProvider))),
          const SizedBox(height: 8),
          _buildTextEditor(),

          const SizedBox(height: 24),

          // Font style
          _buildSectionTitle(L10nService.get('dreams.share_screen.font_style', ref.watch(languageProvider))),
          const SizedBox(height: 8),
          _buildFontSelector(),

          const SizedBox(height: 24),

          // Emoji decorations
          _buildSectionTitle(L10nService.get('dreams.share_screen.emoji_decoration', ref.watch(languageProvider))),
          const SizedBox(height: 8),
          _buildEmojiSelector(),

          const SizedBox(height: 24),

          // Toggle options
          _buildSectionTitle(L10nService.get('dreams.share_screen.visual_elements', ref.watch(languageProvider))),
          const SizedBox(height: 8),
          _buildToggleOptions(),

          const SizedBox(height: 24),

          // Color accent
          _buildSectionTitle(L10nService.get('dreams.share_screen.accent_color', ref.watch(languageProvider))),
          const SizedBox(height: 8),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextEditor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: _mainText),
            onChanged: (value) {
              setState(() {
                _mainText = value;
              });
            },
            maxLines: 4,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: L10nService.get('dreams.share_screen.write_text_hint', ref.watch(languageProvider)),
              hintStyle: const TextStyle(color: AppColors.textMuted),
              border: InputBorder.none,
            ),
          ),
          const Divider(color: AppColors.textMuted),
          TextField(
            controller: TextEditingController(text: _subtitle),
            onChanged: (value) {
              setState(() {
                _subtitle = value;
              });
            },
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: L10nService.get('dreams.share_screen.subtitle_hint', ref.watch(languageProvider)),
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSelector() {
    final language = ref.watch(languageProvider);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DreamCardFont.values.map((font) {
        final isSelected = _config.font == font;
        return GestureDetector(
          onTap: () {
            setState(() {
              _config = _config.copyWith(font: font);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [AppColors.mystic, AppColors.cosmicPurple],
                    )
                  : null,
              color: isSelected ? null : AppColors.surfaceDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.mystic.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              font.label(language),
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontStyle: font == DreamCardFont.mystical
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmojiSelector() {
    final dreamEmojis = [
      '\u{1F319}',
      '\u{1F31F}',
      '\u{2728}',
      '\u{1F52E}',
      '\u{1F3AD}',
      '\u{1F30C}',
      '\u{1F320}',
      '\u{2604}',
      '\u{1F300}',
      '\u{1F311}',
      '\u{1F315}',
      '\u{1FA90}',
      '\u{1F9FF}',
      '\u{1F4AB}',
      '\u{1F302}',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Selected emoji display
        GestureDetector(
          onTap: () => _showEmojiPicker(),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.mystic, AppColors.cosmicPurple],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(_headerEmoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
        // Quick emoji picks
        ...dreamEmojis.map((emoji) {
          final isSelected = _headerEmoji == emoji;
          return GestureDetector(
            onTap: () {
              setState(() {
                _headerEmoji = emoji;
              });
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.mystic.withValues(alpha: 0.3)
                    : AppColors.surfaceDark.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.mystic : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nService.get('dreams.share_screen.select_emoji', ref.watch(languageProvider)),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children:
                    [
                      '\u{1F319}',
                      '\u{1F31F}',
                      '\u{2728}',
                      '\u{1F52E}',
                      '\u{1F3AD}',
                      '\u{1F30C}',
                      '\u{1F320}',
                      '\u{2604}',
                      '\u{1F300}',
                      '\u{1F311}',
                      '\u{1F312}',
                      '\u{1F313}',
                      '\u{1F314}',
                      '\u{1F315}',
                      '\u{1F316}',
                      '\u{1F317}',
                      '\u{1F318}',
                      '\u{1FA90}',
                      '\u{1F9FF}',
                      '\u{1F4AB}',
                      '\u{1F302}',
                      '\u{1F40D}',
                      '\u{1F99B}',
                      '\u{1F418}',
                      '\u{1F987}',
                      '\u{1F989}',
                      '\u{1F426}',
                      '\u{1F43A}',
                      '\u{1F981}',
                      '\u{1F98B}',
                      '\u{1F31E}',
                      '\u{1F525}',
                      '\u{1F30A}',
                      '\u{1F343}',
                      '\u{1F338}',
                      '\u{1F48E}',
                      '\u{1F5DD}',
                      '\u{1F573}',
                      '\u{1F30D}',
                      '\u{1F308}',
                    ].map((emoji) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _headerEmoji = emoji;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOptions() {
    final language = ref.watch(languageProvider);
    return Column(
      children: [
        _buildToggleTile(L10nService.get('dreams.share_screen.show_moon_phase', language), _config.showMoonPhase, (value) {
          setState(() {
            _config = _config.copyWith(showMoonPhase: value);
          });
        }),
        _buildToggleTile(L10nService.get('dreams.share_screen.show_watermark', language), _config.showWatermark, (value) {
          setState(() {
            _config = _config.copyWith(showWatermark: value);
          });
        }),
        _buildToggleTile(L10nService.get('dreams.share_screen.emoji_decorations', language), _config.showEmoji, (value) {
          setState(() {
            _config = _config.copyWith(showEmoji: value);
          });
        }),
      ],
    );
  }

  Widget _buildToggleTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.mystic,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      AppColors.mystic,
      AppColors.cosmicPurple,
      AppColors.starGold,
      Colors.pink,
      Colors.cyan,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return Wrap(
      spacing: 12,
      children: colors.map((color) {
        final isSelected = _config.accentColor == color;
        return GestureDetector(
          onTap: () {
            setState(() {
              _config = _config.copyWith(accentColor: color);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ========================================
  // TAB 3: Templates
  // ========================================
  Widget _buildTemplatesTab() {
    final language = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(L10nService.get('dreams.share_screen.ready_templates', language)),
          const SizedBox(height: 16),

          // "Bu gece ruyamda..." template
          _buildTemplateCard(
            emoji: '\u{1F319}',
            title: L10nService.get('dreams.share_screen.template_tonight', language),
            description: L10nService.get('dreams.share_screen.template_tonight_desc', language),
            onTap: () => _useTemplate('dream_tonight'),
          ),

          // Symbol meaning card
          _buildTemplateCard(
            emoji: '\u{1F52E}',
            title: L10nService.get('dreams.share_screen.template_symbol', language),
            description: L10nService.get('dreams.share_screen.template_symbol_desc', language),
            onTap: () => _useTemplate('symbol_meaning'),
          ),

          // Archetype discovery
          _buildTemplateCard(
            emoji: '\u{1F3AD}',
            title: L10nService.get('dreams.share_screen.template_archetype', language),
            description: L10nService.get('dreams.share_screen.template_archetype_desc', language),
            onTap: () => _useTemplate('archetype'),
          ),

          // Moon phase wisdom
          _buildTemplateCard(
            emoji: MoonService.getCurrentPhase().emoji,
            title: L10nService.get('dreams.share_screen.template_moon_phase', language),
            description: L10nService.get('dreams.share_screen.template_moon_phase_desc', language),
            onTap: () => _useTemplate('moon_phase'),
          ),

          // Weekly dream summary
          _buildTemplateCard(
            emoji: '\u{1F4D6}',
            title: L10nService.get('dreams.share_screen.template_weekly', language),
            description: L10nService.get('dreams.share_screen.template_weekly_desc', language),
            onTap: () => _useTemplate('weekly'),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle(L10nService.get('dreams.share_screen.instagram_story_size', language)),
          const SizedBox(height: 16),

          // Story format preview
          _buildStoryFormatPreview(),
        ],
      ),
    );
  }

  Widget _buildTemplateCard({
    required String emoji,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.surfaceDark.withValues(alpha: 0.8),
              AppColors.surfaceDark.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.mystic.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _useTemplate(String templateId) {
    final language = ref.read(languageProvider);
    setState(() {
      switch (templateId) {
        case 'dream_tonight':
          _selectedTemplate = DreamCardTemplate.dreamQuote;
          _mainText = '${L10nService.get('dreams.share_screen.tonight_in_my_dream', language)} $_mainText';
          _headerEmoji = '\u{1F319}';
          break;
        case 'symbol_meaning':
          _selectedTemplate = DreamCardTemplate.symbolInsight;
          _updateContentForTemplate(DreamCardTemplate.symbolInsight);
          break;
        case 'archetype':
          _selectedTemplate = DreamCardTemplate.archetypeDiscovery;
          _updateContentForTemplate(DreamCardTemplate.archetypeDiscovery);
          break;
        case 'moon_phase':
          _selectedTemplate = DreamCardTemplate.moonPhase;
          _updateContentForTemplate(DreamCardTemplate.moonPhase);
          break;
        case 'weekly':
          _selectedTemplate = DreamCardTemplate.weeklySummary;
          _updateContentForTemplate(DreamCardTemplate.weeklySummary);
          break;
      }
    });

    _tabController.animateTo(0);
  }

  Widget _buildStoryFormatPreview() {
    return Center(
      child: Container(
        width: 180,
        height: 320,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.mystic.withValues(alpha: 0.3),
              AppColors.nebulaPurple.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.mystic.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_headerEmoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _mainText.length > 80
                    ? '${_mainText.substring(0, 80)}...'
                    : _mainText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '9:16 Story Format',
                style: TextStyle(color: Colors.white54, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // TAB 4: Generated Content
  // ========================================
  Widget _buildGeneratedTab() {
    final language = ref.watch(languageProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Generated Poetry
          _buildSectionTitle(L10nService.get('dreams.share_screen.dream_poetry', language)),
          const SizedBox(height: 12),
          _buildGeneratedContent(
            content: _generatedPoetry ?? '',
            icon: Icons.auto_awesome,
            onUse: () {
              setState(() {
                _mainText = _generatedPoetry ?? '';
                _headerEmoji = '\u{1F4DC}';
              });
              _tabController.animateTo(0);
            },
          ),

          const SizedBox(height: 24),

          // Daily Affirmation
          _buildSectionTitle(L10nService.get('dreams.share_screen.daily_affirmations', language)),
          const SizedBox(height: 12),
          _buildGeneratedContent(
            content: _generatedAffirmation ?? '',
            icon: Icons.wb_sunny,
            onUse: () {
              setState(() {
                _mainText = _generatedAffirmation ?? '';
                _headerEmoji = '\u{1F31F}';
              });
              _tabController.animateTo(0);
            },
          ),

          const SizedBox(height: 24),

          // Mystical Quotes
          _buildSectionTitle(L10nService.get('dreams.share_screen.mystical_quotes', language)),
          const SizedBox(height: 12),
          ..._buildMysticalQuotes(),

          const SizedBox(height: 24),

          // Symbol Art Suggestions
          _buildSectionTitle(L10nService.get('dreams.share_screen.symbol_art_suggestions', language)),
          const SizedBox(height: 12),
          ..._symbolArtSuggestions.map((suggestion) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.palette, color: AppColors.mystic, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGeneratedContent({
    required String content,
    required IconData icon,
    required VoidCallback onUse,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.mystic.withValues(alpha: 0.1),
            AppColors.nebulaPurple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.starGold, size: 18),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.share_screen.ai_generated', ref.watch(languageProvider)),
                style: const TextStyle(
                  color: AppColors.starGold,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: content));
                  final lang = ref.read(languageProvider);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(L10nService.get('common.copied', lang))));
                },
                icon: const Icon(Icons.copy, size: 16),
                label: Text(L10nService.get('common.copy', ref.watch(languageProvider))),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onUse,
                icon: const Icon(Icons.check, size: 16),
                label: Text(L10nService.get('common.use', ref.watch(languageProvider))),
                style: TextButton.styleFrom(foregroundColor: AppColors.mystic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMysticalQuotes() {
    final language = ref.watch(languageProvider);
    final quotes = L10nService.getList('dreams.share_screen.mystical_quotes_list', language);

    return quotes.map((quote) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _mainText = quote;
            _headerEmoji = '\u{2728}';
          });
          _tabController.animateTo(0);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Text('\u{2728}', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  quote,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(Icons.add, color: AppColors.mystic, size: 18),
            ],
          ),
        ),
      );
    }).toList();
  }

  // ========================================
  // Bottom Actions
  // ========================================
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [AppColors.nebulaPurple.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // Save to gallery
          Expanded(
            child: OutlineButton(
              label: _isSaving ? L10nService.get('common.saving', ref.watch(languageProvider)) : L10nService.get('common.save', ref.watch(languageProvider)),
              icon: Icons.save_alt,
              onPressed: _isSaving ? null : _saveToGallery,
            ),
          ),
          const SizedBox(width: 12),
          // Share
          Expanded(
            flex: 2,
            child: GradientButton(
              label: _isSharing ? L10nService.get('common.sharing', ref.watch(languageProvider)) : L10nService.get('common.share', ref.watch(languageProvider)),
              icon: Icons.share,
              isLoading: _isSharing,
              onPressed: _isSharing ? null : _shareCard,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacySheet() {
    final language = ref.read(languageProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10nService.get('dreams.share_screen.privacy_controls', language),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            _buildPrivacyToggle(
              L10nService.get('dreams.share_screen.share_anonymously', language),
              L10nService.get('dreams.share_screen.share_anonymously_desc', language),
              _shareAnonymously,
              (value) {
                setState(() {
                  _shareAnonymously = value;
                });
                Navigator.pop(context);
              },
            ),
            _buildPrivacyToggle(
              L10nService.get('dreams.share_screen.share_interpretation_only', language),
              L10nService.get('dreams.share_screen.share_interpretation_only_desc', language),
              _shareInterpretationOnly,
              (value) {
                setState(() {
                  _shareInterpretationOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            _buildPrivacyToggle(
              L10nService.get('dreams.share_screen.share_symbol_only', language),
              L10nService.get('dreams.share_screen.share_symbol_only_desc', language),
              _shareSymbolOnly,
              (value) {
                setState(() {
                  _shareSymbolOnly = value;
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.mystic,
          ),
        ],
      ),
    );
  }

  Future<void> _saveToGallery() async {
    final language = ref.read(languageProvider);
    setState(() {
      _isSaving = true;
    });

    try {
      final imageBytes = await DreamCardCapture.captureCard(_cardKey);
      if (imageBytes == null) {
        _showError(L10nService.get('dreams.share_screen.image_creation_error', language));
        return;
      }

      if (kIsWeb) {
        // Web: Download file
        _showSuccess(L10nService.get('dreams.share_screen.image_downloaded', language));
      } else {
        // Mobile: Save to temp and share to photos
        final tempDir = await getTemporaryDirectory();
        final file = File(
          '${tempDir.path}/dream_card_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(imageBytes);

        _showSuccess(L10nService.get('dreams.share_screen.image_saved', language));
      }
    } catch (e) {
      _showError('${L10nService.get('dreams.share_screen.save_error', language)}: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _shareCard() async {
    final language = ref.read(languageProvider);
    setState(() {
      _isSharing = true;
    });

    try {
      final imageBytes = await DreamCardCapture.captureCard(_cardKey);
      if (imageBytes == null) {
        _showError(L10nService.get('dreams.share_screen.image_creation_error', language));
        return;
      }

      // Prepare share text
      String shareText = _mainText;
      if (_subtitle.isNotEmpty) {
        shareText += '\n\n$_subtitle';
      }
      shareText += '\n\n#dreaminterpretation #venusone #cosmicenergy';

      if (kIsWeb) {
        // Web: Copy text and show instructions
        await Clipboard.setData(ClipboardData(text: shareText));
        _showSuccess(L10nService.get('common.text_copied', language));
      } else {
        // Mobile: Use share sheet
        final tempDir = await getTemporaryDirectory();
        final file = File(
          '${tempDir.path}/dream_share_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await file.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: shareText,
          subject: L10nService.get('dreams.share_screen.dream_interpretation', language),
        );
      }
    } catch (e) {
      _showError('${L10nService.get('share.share_error', language)}: $e');
    } finally {
      setState(() {
        _isSharing = false;
      });
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Quick share button to add to dream interpretation results
class DreamQuickShareButton extends ConsumerWidget {
  final String text;
  final String? symbol;
  final VoidCallback? onShare;

  const DreamQuickShareButton({
    super.key,
    required this.text,
    this.symbol,
    this.onShare,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return GestureDetector(
      onTap:
          onShare ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DreamShareScreen(
                  quickShareText: text,
                  quickShareSymbol: symbol,
                ),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mystic.withValues(alpha: 0.3),
              AppColors.cosmicPurple.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mystic.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.share, size: 18, color: AppColors.mystic),
            const SizedBox(width: 8),
            Text(
              L10nService.get('common.share', language),
              style: TextStyle(
                color: AppColors.mystic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
