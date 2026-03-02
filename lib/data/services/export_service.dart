// ════════════════════════════════════════════════════════════════════════════
// EXPORT SERVICE - InnerCycles Data Export
// ════════════════════════════════════════════════════════════════════════════
// Exports journal data as plain text, CSV, JSON, or styled PDF.
// Premium: full history + all formats. Free: last 7 days + text only.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/journal_entry.dart';
import 'journal_service.dart';
import 'l10n_service.dart';
import '../providers/app_providers.dart';

enum ExportFormat { text, csv, json, pdf }

class ExportResult {
  final String content;
  final String fileName;
  final String mimeType;
  final Uint8List? pdfBytes;

  const ExportResult({
    required this.content,
    required this.fileName,
    required this.mimeType,
    this.pdfBytes,
  });
}

class ExportService {
  final JournalService _journalService;

  ExportService(this._journalService);

  /// Export journal entries in the specified format
  Future<ExportResult> export({
    required ExportFormat format,
    bool isPremium = false,
    AppLanguage language = AppLanguage.en,
  }) async {
    final entries = isPremium
        ? _journalService.getAllEntries()
        : _getLastWeekEntries();

    // Sort by date descending
    final sorted = List<JournalEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    switch (format) {
      case ExportFormat.text:
        return _exportText(sorted, language);
      case ExportFormat.csv:
        return _exportCsv(sorted, language);
      case ExportFormat.json:
        return _exportJson(sorted);
      case ExportFormat.pdf:
        return _exportPdf(sorted, language);
    }
  }

  List<JournalEntry> _getLastWeekEntries() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _journalService.getEntriesByDateRange(weekAgo, now);
  }

  ExportResult _exportText(List<JournalEntry> entries, AppLanguage language) {
    final buffer = StringBuffer();
    buffer.writeln(
      L10nService.get(
          'data.services.export.innercycles_journal_export', language),
    );
    buffer.writeln('=' * 40);
    buffer.writeln(
      '${L10nService.get('data.services.export.exported', language)}: ${DateTime.now().toString().substring(0, 10)}',
    );
    buffer.writeln(
        '${L10nService.get('data.services.export.entries', language)}: ${entries.length}');
    buffer.writeln('=' * 40);
    buffer.writeln();

    for (final entry in entries) {
      buffer.writeln(
          '${L10nService.get('data.services.export.date', language)}: ${entry.dateKey}');
      buffer.writeln(
        '${L10nService.get('data.services.export.focus', language)}: ${entry.focusArea.localizedName(language)}',
      );
      buffer.writeln(
        '${L10nService.get('data.services.export.rating', language)}: ${entry.overallRating}/5',
      );
      if (entry.note != null && entry.note!.isNotEmpty) {
        buffer.writeln(
            '${L10nService.get('data.services.export.note', language)}: ${entry.note}');
      }
      buffer.writeln('-' * 30);
    }

    final dateStr = DateTime.now().toString().substring(0, 10);
    return ExportResult(
      content: buffer.toString(),
      fileName: 'innercycles_journal_$dateStr.txt',
      mimeType: 'text/plain',
    );
  }

  ExportResult _exportCsv(List<JournalEntry> entries, AppLanguage language) {
    final buffer = StringBuffer();
    buffer.writeln('date,focus_area,overall_rating,note');

    for (final entry in entries) {
      final note = entry.note?.replaceAll('"', '""') ?? '';
      buffer.writeln(
        '${entry.dateKey},${entry.focusArea.name},${entry.overallRating},"$note"',
      );
    }

    final dateStr = DateTime.now().toString().substring(0, 10);
    return ExportResult(
      content: buffer.toString(),
      fileName: 'innercycles_journal_$dateStr.csv',
      mimeType: 'text/csv',
    );
  }

  ExportResult _exportJson(List<JournalEntry> entries) {
    final data = entries
        .map(
          (e) => {
            'date': e.dateKey,
            'focusArea': e.focusArea.name,
            'overallRating': e.overallRating,
            'subRatings': e.subRatings,
            'note': e.note,
            'createdAt': e.createdAt.toIso8601String(),
          },
        )
        .toList();

    final dateStr = DateTime.now().toString().substring(0, 10);
    return ExportResult(
      content: const JsonEncoder.withIndent('  ').convert({
        'app': 'InnerCycles',
        'exportDate': DateTime.now().toIso8601String(),
        'entryCount': entries.length,
        'entries': data,
      }),
      fileName: 'innercycles_journal_$dateStr.json',
      mimeType: 'application/json',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PDF EXPORT
  // ══════════════════════════════════════════════════════════════════════════

  Future<ExportResult> _exportPdf(List<JournalEntry> entries, AppLanguage language) async {
    final isEn = language == AppLanguage.en;
    final dateStr = DateTime.now().toString().substring(0, 10);

    final pdf = pw.Document(
      title: 'InnerCycles Journal Export',
      author: 'InnerCycles',
    );

    // Colors matching the app's warm palette
    const headerColor = PdfColor.fromInt(0xFFC8553D); // starGold
    const accentColor = PdfColor.fromInt(0xFFD4704A); // celestialGold
    const textColor = PdfColor.fromInt(0xFF3D3229); // espresso
    const mutedColor = PdfColor.fromInt(0xFF8B7B6E);
    const bgColor = PdfColor.fromInt(0xFFFBF7F4); // warm cream

    // Rating bar helper
    pw.Widget ratingBar(int rating) {
      return pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: List.generate(5, (i) {
          return pw.Container(
            width: 12,
            height: 12,
            margin: const pw.EdgeInsets.only(right: 2),
            decoration: pw.BoxDecoration(
              color: i < rating ? headerColor : const PdfColor.fromInt(0xFFE5DDD6),
              borderRadius: pw.BorderRadius.circular(3),
            ),
          );
        }),
      );
    }

    // Focus area color
    PdfColor focusColor(FocusArea area) {
      switch (area) {
        case FocusArea.energy:
          return const PdfColor.fromInt(0xFFC8553D);
        case FocusArea.focus:
          return const PdfColor.fromInt(0xFF5B8DBE);
        case FocusArea.emotions:
          return const PdfColor.fromInt(0xFFD4704A);
        case FocusArea.decisions:
          return const PdfColor.fromInt(0xFF81C784);
        case FocusArea.social:
          return const PdfColor.fromInt(0xFF8B6F5E);
      }
    }

    // Build pages (max 20 entries per page for readability)
    const entriesPerPage = 20;
    final totalPages = (entries.length / entriesPerPage).ceil().clamp(1, 999);

    for (int page = 0; page < totalPages; page++) {
      final pageEntries = entries.skip(page * entriesPerPage).take(entriesPerPage).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header (first page only)
                if (page == 0) ...[
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      color: bgColor,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: headerColor, width: 0.5),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'InnerCycles',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: headerColor,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          isEn ? 'Journal Export' : 'Günlük Dışa Aktarımı',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: mutedColor,
                          ),
                        ),
                        pw.SizedBox(height: 12),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              '${isEn ? 'Date' : 'Tarih'}: $dateStr',
                              style: pw.TextStyle(fontSize: 10, color: mutedColor),
                            ),
                            pw.Text(
                              '${entries.length} ${isEn ? 'entries' : 'kayıt'}',
                              style: pw.TextStyle(fontSize: 10, color: mutedColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                ],

                // Entries
                ...pageEntries.map((entry) {
                  final fColor = focusColor(entry.focusArea);
                  return pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(bottom: 10),
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border(
                        left: pw.BorderSide(color: fColor, width: 3),
                      ),
                      color: bgColor,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              entry.dateKey,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: pw.BoxDecoration(
                                color: fColor,
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                              child: pw.Text(
                                entry.focusArea.localizedName(language),
                                style: const pw.TextStyle(
                                  fontSize: 8,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 6),
                        pw.Row(
                          children: [
                            pw.Text(
                              '${isEn ? 'Rating' : 'Puan'}: ',
                              style: pw.TextStyle(fontSize: 9, color: mutedColor),
                            ),
                            ratingBar(entry.overallRating),
                          ],
                        ),
                        if (entry.subRatings.isNotEmpty) ...[
                          pw.SizedBox(height: 4),
                          pw.Wrap(
                            spacing: 8,
                            children: entry.subRatings.entries.map((sr) {
                              final subNames = isEn
                                  ? entry.focusArea.subRatingNamesEn
                                  : entry.focusArea.subRatingNamesTr;
                              return pw.Text(
                                '${subNames[sr.key] ?? sr.key}: ${sr.value}/5',
                                style: pw.TextStyle(fontSize: 8, color: mutedColor),
                              );
                            }).toList(),
                          ),
                        ],
                        if (entry.note != null && entry.note!.isNotEmpty) ...[
                          pw.SizedBox(height: 6),
                          pw.Text(
                            entry.note!,
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: textColor,
                              lineSpacing: 1.4,
                            ),
                            maxLines: 8,
                          ),
                        ],
                        if (entry.tags.isNotEmpty) ...[
                          pw.SizedBox(height: 4),
                          pw.Wrap(
                            spacing: 4,
                            children: entry.tags.map((tag) {
                              return pw.Container(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: pw.BoxDecoration(
                                  borderRadius: pw.BorderRadius.circular(3),
                                  color: accentColor,
                                ),
                                child: pw.Text(
                                  tag,
                                  style: const pw.TextStyle(fontSize: 7, color: PdfColors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  );
                }),

                pw.Spacer(),

                // Footer
                pw.Center(
                  child: pw.Text(
                    'InnerCycles · ${isEn ? 'Page' : 'Sayfa'} ${page + 1} / $totalPages',
                    style: pw.TextStyle(fontSize: 8, color: mutedColor),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    final bytes = await pdf.save();

    return ExportResult(
      content: '',
      fileName: 'innercycles_journal_$dateStr.pdf',
      mimeType: 'application/pdf',
      pdfBytes: bytes,
    );
  }

  /// Get entry count for display
  int get totalEntries => _journalService.entryCount;
}
