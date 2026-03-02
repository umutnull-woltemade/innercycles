// ════════════════════════════════════════════════════════════════════════════
// WORD CLOUD SERVICE - Extract top words from journal entries
// ════════════════════════════════════════════════════════════════════════════

import 'journal_service.dart';

class WordFrequency {
  final String word;
  final int count;
  const WordFrequency(this.word, this.count);
}

class WordCloudService {
  final JournalService _journalService;

  WordCloudService(this._journalService);

  static const _stopwordsEn = <String>{
    'the', 'a', 'an', 'is', 'was', 'are', 'were', 'be', 'been', 'being',
    'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
    'should', 'may', 'might', 'shall', 'can', 'need', 'dare', 'ought',
    'used', 'to', 'of', 'in', 'for', 'on', 'with', 'at', 'by', 'from',
    'as', 'into', 'through', 'during', 'before', 'after', 'above', 'below',
    'between', 'out', 'off', 'over', 'under', 'again', 'further', 'then',
    'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'each',
    'every', 'both', 'few', 'more', 'most', 'other', 'some', 'such', 'no',
    'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 'just',
    'because', 'but', 'and', 'or', 'if', 'while', 'about', 'up', 'down',
    'this', 'that', 'these', 'those', 'it', 'its', 'my', 'your', 'his',
    'her', 'our', 'their', 'what', 'which', 'who', 'whom', 'me', 'him',
    'she', 'he', 'we', 'they', 'them', 'i', 'you', 'am', 'also', 'get',
    'got', 'really', 'much', 'like', 'even', 'still', 'well', 'back',
    'thing', 'things', 'way', 'day', 'today', 'time', 'lot', 'bit',
  };

  static const _stopwordsTr = <String>{
    've', 'bir', 'bu', 'da', 'de', 'ile', 'ben', 'sen', 'o', 'biz', 'siz',
    'onlar', 'ama', 'fakat', 'veya', 'ya', 'ne', 'ki', 'mi', 'mu',
    'ise', 'gibi', 'i\u00e7in', 'kadar', 'daha', '\u00e7ok', 'en', 'var',
    'yok', 'oldu', 'olan', 'olarak', '\u015fey', 'her', 'benim', 'senin',
    'onun', 'bizim', 'sizin', 'bunu', '\u015funu', 'onu', 'kendi',
    'sonra', '\u00f6nce', '\u015fimdi', 'bug\u00fcn', 'g\u00fcn',
    'zaman', 'biraz', 'bile', 'hala', 'hem', 'evet', 'hay\u0131r',
    'nas\u0131l', 'neden', 'nerede', 'nere', 'hangi',
    'etti', 'ettim', 'ediyorum', 'oldum',
  };

  /// Get top N words from last [days] of journal entries
  List<WordFrequency> getTopWords({int days = 30, int limit = 30}) {
    final entries = _journalService.getAllEntries();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recent = entries.where((e) => e.date.isAfter(cutoff));

    final wordCounts = <String, int>{};
    for (final entry in recent) {
      final text = (entry.note ?? '').toLowerCase();
      final words = text
          .replaceAll(RegExp(r'[^\w\s\u00e0-\u024f]'), ' ')
          .split(RegExp(r'\s+'))
          .where((w) => w.length > 2)
          .where((w) => !_stopwordsEn.contains(w))
          .where((w) => !_stopwordsTr.contains(w));

      for (final word in words) {
        wordCounts[word] = (wordCounts[word] ?? 0) + 1;
      }
    }

    final sorted = wordCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(limit)
        .map((e) => WordFrequency(e.key, e.value))
        .toList();
  }

  /// Quick top 5 for today feed card
  List<WordFrequency> getTopFive({int days = 14}) =>
      getTopWords(days: days, limit: 5);

  bool get hasEnoughData {
    final entries = _journalService.getAllEntries();
    final cutoff = DateTime.now().subtract(const Duration(days: 14));
    return entries.where((e) => e.date.isAfter(cutoff) && e.note != null).length >= 3;
  }
}
