/// Insight Assistant - Unified Personal Reflection Chat
/// Apple-safe single entry point for dream reflection & pattern awareness
/// Strictly reflective language only - safe for App Store
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../services/insight_routing_service.dart';
import '../services/insight_response_service.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';

/// Insight - Personal Reflection Assistant
/// Single unified chat interface for self-reflection
class InsightScreen extends ConsumerStatefulWidget {
  const InsightScreen({super.key});

  @override
  ConsumerState<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends ConsumerState<InsightScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  late AnimationController _pulseController;

  final InsightRoutingService _routingService = InsightRoutingService();
  final InsightResponseService _responseService = InsightResponseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('insight'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('insight', source: 'direct'));
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final userProfile = ref.read(userProfileProvider);
    final language = ref.read(languageProvider);
    final userName =
        userProfile?.name ?? L10nService.get('insight.default_user', language);

    final greeting = L10nService.get(
      'insight.greeting',
      language,
    ).replaceAll('{name}', userName);
    final intro = L10nService.get('insight.intro', language);
    final disclaimer = L10nService.get('insight.disclaimer', language);

    setState(() {
      _messages.add(
        _ChatMessage(
          text: '$greeting\n\n$intro\n\n$disclaimer',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _sendMessage([String? quickMessage]) async {
    HapticFeedback.mediumImpact();
    final text = quickMessage ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Generate response
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _generateResponse(text);
  }

  void _generateResponse(String userMessage) {
    final userProfile = ref.read(userProfileProvider);
    final language = ref.read(languageProvider);

    // Classify input type (invisible to user)
    final insightType = _routingService.classifyInput(userMessage, language);

    // Generate appropriate reflection response
    final response = _responseService.generateResponse(
      userMessage: userMessage,
      insightType: insightType,
      language: language,
      userName: userProfile?.name,
    );

    setState(() {
      _isTyping = false;
      _messages.add(
        _ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.surfaceDark
          : AppColors.lightBackground,
      // NOTE: Keeping plain AppBar here intentionally. This is a chat screen
      // with a fixed input area pinned at the bottom (Column with Expanded
      // ListView + fixed _buildInputArea). Converting to GlassSliverAppBar
      // inside a CustomScrollView would break the chat layout pattern.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: language == AppLanguage.en ? 'Back' : 'Geri',
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          L10nService.get('insight.title', language),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Chat messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == _messages.length) {
                      return _buildTypingIndicator(isDark, language);
                    }
                    if (index >= _messages.length)
                      return const SizedBox.shrink();
                    return _buildMessageBubble(_messages[index], isDark);
                  },
                ),
              ),

              // Disclaimer
              ContentDisclaimer(
                compact: true,
                customText: DisclaimerTexts.insight(language),
                language: language,
              ),

              // Input area
              _buildInputArea(isDark, language),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message, bool isDark) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAssistantAvatar(isDark),
            const SizedBox(width: 8),
          ],
          Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? (isDark
                              ? AppColors.chatBubbleUser
                              : AppColors.chatAccent)
                        : (isDark ? AppColors.chatSurface : Colors.white),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .slideX(begin: isUser ? 0.1 : -0.1, end: 0, duration: 300.ms),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAssistantAvatar(bool isDark) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: AppColors.chatAccentGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.psychology_outlined,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark, AppLanguage language) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssistantAvatar(isDark),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.chatSurface : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final value = (_pulseController.value + index * 0.2) % 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textMuted.withValues(alpha: 0.3 + value * 0.4),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildInputArea(bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.chatInputArea : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.chatInputField
                    : AppColors.lightSurfaceVariant,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.textMuted.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: L10nService.get('insight.input_hint', language),
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.textMuted.withValues(alpha: 0.38)
                        : AppColors.textMuted,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            label: isEn ? 'Send message' : 'Mesaj gönder',
            button: true,
            child: GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.chatAccentGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.chatAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal chat message model
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
