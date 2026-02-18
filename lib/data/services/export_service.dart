// ════════════════════════════════════════════════════════════════════════════
// EXPORT SERVICE - InnerCycles Data Export
// ════════════════════════════════════════════════════════════════════════════
// Exports journal data as plain text, CSV, or JSON.
// Premium: full history + all formats. Free: last 7 days + text only.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import '../models/journal_entry.dart';
import 'journal_service.dart';

enum ExportFormat { text, csv, json }

class ExportResult {
  final String content;
  final String fileName;
  final String mimeType;

  const ExportResult({
    required this.content,
    required this.fileName,
    required this.mimeType,
  });
}

class ExportService {
  final JournalService _journalService;

  ExportService(this._journalService);

  /// Export journal entries in the specified format
  ExportResult export({
    required ExportFormat format,
    bool isPremium = false,
    bool isEn = true,
  }) {
    final entries = isPremium
        ? _journalService.getAllEntries()
        : _getLastWeekEntries();

    // Sort by date descending
    final sorted = List<JournalEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    switch (format) {
      case ExportFormat.text:
        return _exportText(sorted, isEn);
      case ExportFormat.csv:
        return _exportCsv(sorted, isEn);
      case ExportFormat.json:
        return _exportJson(sorted);
    }
  }

  List<JournalEntry> _getLastWeekEntries() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _journalService.getEntriesByDateRange(weekAgo, now);
  }

  ExportResult _exportText(List<JournalEntry> entries, bool isEn) {
    final buffer = StringBuffer();
    buffer.writeln(
      isEn ? 'InnerCycles Journal Export' : 'InnerCycles Günlük Dışa Aktarma',
    );
    buffer.writeln('=' * 40);
    buffer.writeln(
      '${isEn ? 'Exported' : 'Dışa aktarıldı'}: ${DateTime.now().toString().substring(0, 10)}',
    );
    buffer.writeln('${isEn ? 'Entries' : 'Kayıt'}: ${entries.length}');
    buffer.writeln('=' * 40);
    buffer.writeln();

    for (final entry in entries) {
      buffer.writeln('${isEn ? 'Date' : 'Tarih'}: ${entry.dateKey}');
      buffer.writeln(
        '${isEn ? 'Focus' : 'Odak'}: ${isEn ? entry.focusArea.displayNameEn : entry.focusArea.displayNameTr}',
      );
      buffer.writeln(
        '${isEn ? 'Rating' : 'Puanlama'}: ${entry.overallRating}/5',
      );
      if (entry.note != null && entry.note!.isNotEmpty) {
        buffer.writeln('${isEn ? 'Note' : 'Not'}: ${entry.note}');
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

  ExportResult _exportCsv(List<JournalEntry> entries, bool isEn) {
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

  /// Get entry count for display
  int get totalEntries => _journalService.entryCount;
}
