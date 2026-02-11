import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_tokens.dart';

/// Scaffold with cosmic gradient background and glass AppBar.
///
/// Replaces standard Scaffold for all InnerCycles screens. Provides
/// a consistent cosmic/gradient background with a frosted glass AppBar.
class GlassScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundStart;
  final Color? backgroundEnd;

  const GlassScaffold({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
    this.showBackButton = true,
    this.backgroundStart,
    this.backgroundEnd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgStart = backgroundStart ??
        (isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF0F2F8));
    final bgEnd = backgroundEnd ??
        (isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFFFFFF));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: title != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: AppBar(
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    elevation: 0,
                    centerTitle: true,
                    leading: showBackButton && Navigator.of(context).canPop()
                        ? _GlassBackButton()
                        : null,
                    title: Text(
                      title!,
                      style: TextStyle(
                        fontSize: GlassTokens.fontHeadline,
                        fontWeight: GlassTokens.weightSemibold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    actions: actions,
                  ),
                ),
              ),
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    );
  }
}
