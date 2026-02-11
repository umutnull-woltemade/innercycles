import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/user_profile.dart';
import '../models/zodiac_sign.dart';
import '../models/planet.dart';
import '../providers/app_providers.dart';
import 'l10n_service.dart';
import 'moon_service.dart';

/// PDF Report Generator Service for Birth Charts and Horoscopes
class PdfReportService {
  static final PdfReportService _instance = PdfReportService._internal();
  factory PdfReportService() => _instance;
  PdfReportService._internal();

  // Current language for report generation (set during report generation)
  AppLanguage _currentLanguage = AppLanguage.tr;

  // Brand colors
  static const _primaryColor = PdfColor.fromInt(0xFF7C3AED);
  static const _goldColor = PdfColor.fromInt(0xFFFFD700);
  static const _textMuted = PdfColor.fromInt(0xFFA0A0A0);

  /// Generate a complete birth chart report
  Future<Uint8List> generateBirthChartReport({
    required UserProfile profile,
    required Map<Planet, ZodiacSign> planetPositions,
    required Map<Planet, int> planetHouses,
    required ZodiacSign? ascendant,
    required ZodiacSign? moonSign,
    AppLanguage language = AppLanguage.tr,
  }) async {
    _currentLanguage = language;
    final pdf = pw.Document();

    // Load fonts
    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final italicFont = await PdfGoogleFonts.nunitoItalic();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
        header: (context) => _buildHeader(profile, context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildTitleSection(profile),
          pw.SizedBox(height: 20),
          _buildBirthDataSection(profile),
          pw.SizedBox(height: 30),
          _buildBigThreeSection(profile.sunSign, moonSign, ascendant),
          pw.SizedBox(height: 30),
          _buildPlanetPositionsSection(planetPositions, planetHouses),
          pw.SizedBox(height: 30),
          _buildElementDistributionSection(planetPositions),
          pw.SizedBox(height: 30),
          _buildModalityDistributionSection(planetPositions),
          pw.SizedBox(height: 30),
          _buildPersonalityInterpretation(profile.sunSign, moonSign, ascendant),
        ],
      ),
    );

    return pdf.save();
  }

  /// Generate a daily horoscope report
  Future<Uint8List> generateDailyHoroscopeReport({
    required UserProfile profile,
    required String horoscope,
    required DateTime date,
  }) async {
    final pdf = pw.Document();

    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final italicFont = await PdfGoogleFonts.nunitoItalic();

    final moonPhase = MoonService.getCurrentPhase(date);
    final moonSign = MoonService.getCurrentMoonSign(date);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildDailyHeader(profile, date),
            pw.SizedBox(height: 30),
            _buildMoonInfoSection(moonPhase, moonSign),
            pw.SizedBox(height: 30),
            _buildDailyHoroscopeContent(horoscope),
            pw.SizedBox(height: 30),
            _buildDailyRecommendations(profile.sunSign),
            pw.Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  /// Generate compatibility report
  Future<Uint8List> generateCompatibilityReport({
    required UserProfile profile1,
    required UserProfile profile2,
    required int compatibilityScore,
    required Map<String, int> categoryScores,
    required String analysis,
  }) async {
    final pdf = pw.Document();

    final regularFont = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final italicFont = await PdfGoogleFonts.nunitoItalic();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: regularFont,
          bold: boldFont,
          italic: italicFont,
        ),
        header: (context) =>
            _buildCompatibilityHeader(profile1, profile2, context),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildCompatibilityTitleSection(profile1, profile2),
          pw.SizedBox(height: 30),
          _buildCompatibilityScoreSection(compatibilityScore),
          pw.SizedBox(height: 30),
          _buildCategoryScoresSection(categoryScores),
          pw.SizedBox(height: 30),
          _buildCompatibilityAnalysis(analysis),
        ],
      ),
    );

    return pdf.save();
  }

  // ============== Private Build Methods ==============

  pw.Widget _buildHeader(UserProfile profile, pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _goldColor, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'VENUS ONE',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
              letterSpacing: 2,
            ),
          ),
          pw.Text(
            L10nService.get(
              'pdf_report.headers.birth_chart_report',
              _currentLanguage,
            ),
            style: const pw.TextStyle(fontSize: 10, color: _textMuted),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _textMuted, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Venus One - ${L10nService.get('pdf_report.headers.cosmic_guide', _currentLanguage)}',
            style: const pw.TextStyle(fontSize: 8, color: _textMuted),
          ),
          pw.Text(
            '${L10nService.get('pdf_report.headers.page', _currentLanguage)} ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: _textMuted),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTitleSection(UserProfile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF3E8FF),
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _primaryColor, width: 1),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            profile.sunSign.symbol,
            style: const pw.TextStyle(fontSize: 48),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            profile.name ??
                L10nService.get('pdf_report.defaults.user', _currentLanguage),
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '${profile.sunSign.localizedName(_currentLanguage)} ${L10nService.get('pdf_report.units.sign_suffix', _currentLanguage)}',
            style: const pw.TextStyle(fontSize: 16, color: _textMuted),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildBirthDataSection(UserProfile profile) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFFEF9E7),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildBirthDataItem(
            L10nService.get(
              'pdf_report.birth_data.birth_date',
              _currentLanguage,
            ),
            '${profile.birthDate.day}.${profile.birthDate.month}.${profile.birthDate.year}',
          ),
          _buildBirthDataItem(
            L10nService.get(
              'pdf_report.birth_data.birth_time',
              _currentLanguage,
            ),
            profile.birthTime ??
                L10nService.get(
                  'pdf_report.birth_data.unknown',
                  _currentLanguage,
                ),
          ),
          _buildBirthDataItem(
            L10nService.get(
              'pdf_report.birth_data.birth_place',
              _currentLanguage,
            ),
            profile.birthPlace ??
                L10nService.get(
                  'pdf_report.birth_data.unknown',
                  _currentLanguage,
                ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildBirthDataItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: _textMuted),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildBigThreeSection(
    ZodiacSign sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? ascendant,
  ) {
    final unknown = L10nService.get(
      'pdf_report.birth_data.unknown',
      _currentLanguage,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get('pdf_report.sections.big_three', _currentLanguage),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildBigThreeItem(
                L10nService.get(
                  'pdf_report.big_three_items.sun_sign',
                  _currentLanguage,
                ),
                sunSign.symbol,
                sunSign.localizedName(_currentLanguage),
                L10nService.get(
                  'pdf_report.big_three_items.sun_description',
                  _currentLanguage,
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildBigThreeItem(
                L10nService.get(
                  'pdf_report.big_three_items.moon_sign',
                  _currentLanguage,
                ),
                moonSign?.symbol ?? '?',
                moonSign?.localizedName(_currentLanguage) ?? unknown,
                L10nService.get(
                  'pdf_report.big_three_items.moon_description',
                  _currentLanguage,
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildBigThreeItem(
                L10nService.get(
                  'pdf_report.big_three_items.ascendant',
                  _currentLanguage,
                ),
                ascendant?.symbol ?? '?',
                ascendant?.localizedName(_currentLanguage) ?? unknown,
                L10nService.get(
                  'pdf_report.big_three_items.ascendant_description',
                  _currentLanguage,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildBigThreeItem(
    String title,
    String symbol,
    String sign,
    String description,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF0F0F5),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(fontSize: 10, color: _textMuted),
          ),
          pw.SizedBox(height: 8),
          pw.Text(symbol, style: const pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 4),
          pw.Text(
            sign,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            description,
            style: const pw.TextStyle(fontSize: 8, color: _textMuted),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPlanetPositionsSection(
    Map<Planet, ZodiacSign> positions,
    Map<Planet, int> houses,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.planet_positions',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          border: pw.TableBorder.all(color: _textMuted, width: 0.5),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF3E8FF),
              ),
              children: [
                _buildTableCell(
                  L10nService.get(
                    'pdf_report.table_headers.planet',
                    _currentLanguage,
                  ),
                  isHeader: true,
                ),
                _buildTableCell(
                  L10nService.get(
                    'pdf_report.table_headers.sign',
                    _currentLanguage,
                  ),
                  isHeader: true,
                ),
                _buildTableCell(
                  L10nService.get(
                    'pdf_report.table_headers.house',
                    _currentLanguage,
                  ),
                  isHeader: true,
                ),
                _buildTableCell(
                  L10nService.get(
                    'pdf_report.table_headers.meaning',
                    _currentLanguage,
                  ),
                  isHeader: true,
                ),
              ],
            ),
            // Data rows
            ...positions.entries.map((entry) {
              final planet = entry.key;
              final sign = entry.value;
              final house = houses[planet] ?? 1;
              return pw.TableRow(
                children: [
                  _buildTableCell(
                    '${planet.symbol} ${planet.localizedName(_currentLanguage)}',
                  ),
                  _buildTableCell(
                    '${sign.symbol} ${sign.localizedName(_currentLanguage)}',
                  ),
                  _buildTableCell(
                    '$house. ${L10nService.get('pdf_report.table_headers.house', _currentLanguage)}',
                  ),
                  _buildTableCell(
                    _getPlanetMeaning(planet, _currentLanguage),
                    fontSize: 8,
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    double fontSize = 10,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? _primaryColor : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildElementDistributionSection(
    Map<Planet, ZodiacSign> positions,
  ) {
    final elementCounts = <Element, int>{};
    for (final sign in positions.values) {
      elementCounts[sign.element] = (elementCounts[sign.element] ?? 0) + 1;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.element_distribution',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: Element.values.map((element) {
            final count = elementCounts[element] ?? 0;
            return _buildElementItem(element, count, positions.length);
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildElementItem(Element element, int count, int total) {
    final percentage = (count / total * 100).round();
    final planetsLabel = L10nService.get(
      'pdf_report.units.planets',
      _currentLanguage,
    );
    return pw.Column(
      children: [
        pw.Text(element.symbol, style: const pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 4),
        pw.Text(
          element.localizedName(_currentLanguage),
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          '$count $planetsLabel ($percentage%)',
          style: const pw.TextStyle(fontSize: 10, color: _textMuted),
        ),
      ],
    );
  }

  pw.Widget _buildModalityDistributionSection(
    Map<Planet, ZodiacSign> positions,
  ) {
    final modalityCounts = <Modality, int>{};
    for (final sign in positions.values) {
      modalityCounts[sign.modality] = (modalityCounts[sign.modality] ?? 0) + 1;
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.modality_distribution',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: Modality.values.map((modality) {
            final count = modalityCounts[modality] ?? 0;
            return _buildModalityItem(modality, count, positions.length);
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildModalityItem(Modality modality, int count, int total) {
    final percentage = (count / total * 100).round();
    final planetsLabel = L10nService.get(
      'pdf_report.units.planets',
      _currentLanguage,
    );
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF0F0F5),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            modality.localizedName(_currentLanguage),
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '$count $planetsLabel ($percentage%)',
            style: const pw.TextStyle(fontSize: 10, color: _textMuted),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _getModalityMeaning(modality),
            style: const pw.TextStyle(fontSize: 8, color: _textMuted),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getModalityMeaning(Modality modality) {
    final key = switch (modality) {
      Modality.cardinal => 'cardinal',
      Modality.fixed => 'fixed',
      Modality.mutable => 'mutable',
    };
    return L10nService.get(
      'pdf_report.modality_meanings.$key',
      _currentLanguage,
    );
  }

  pw.Widget _buildPersonalityInterpretation(
    ZodiacSign sunSign,
    ZodiacSign? moonSign,
    ZodiacSign? ascendant,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.personality_interpretation',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: const PdfColor.fromInt(0xFFF3E8FF),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                L10nService.getWithParams(
                  'pdf_report.interpretations.sun_in_sign',
                  _currentLanguage,
                  params: {'sign': sunSign.localizedName(_currentLanguage)},
                ),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                _getSunSignInterpretation(sunSign, _currentLanguage),
                style: const pw.TextStyle(fontSize: 10),
              ),
              if (moonSign != null) ...[
                pw.SizedBox(height: 15),
                pw.Text(
                  L10nService.getWithParams(
                    'pdf_report.interpretations.moon_in_sign',
                    _currentLanguage,
                    params: {'sign': moonSign.localizedName(_currentLanguage)},
                  ),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  _getMoonSignInterpretation(moonSign, _currentLanguage),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
              if (ascendant != null) ...[
                pw.SizedBox(height: 15),
                pw.Text(
                  L10nService.getWithParams(
                    'pdf_report.interpretations.ascendant_in_sign',
                    _currentLanguage,
                    params: {'sign': ascendant.localizedName(_currentLanguage)},
                  ),
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  _getAscendantInterpretation(ascendant, _currentLanguage),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ============== Daily Horoscope Methods ==============

  pw.Widget _buildDailyHeader(UserProfile profile, DateTime date) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColor.fromInt(0xFFF3E8FF), PdfColor.fromInt(0xFFE8F4FF)],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        children: [
          pw.Text(
            profile.sunSign.symbol,
            style: const pw.TextStyle(fontSize: 48),
          ),
          pw.SizedBox(width: 20),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                L10nService.get(
                  'pdf_report.sections.daily_horoscope',
                  _currentLanguage,
                ),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: _primaryColor,
                  letterSpacing: 2,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                profile.sunSign.localizedName(_currentLanguage),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${date.day}.${date.month}.${date.year}',
                style: const pw.TextStyle(fontSize: 12, color: _textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildMoonInfoSection(MoonPhase phase, MoonSign sign) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFFEF9E7),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Column(
            children: [
              pw.Text(phase.emoji, style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 4),
              pw.Text(
                L10nService.get(
                  'pdf_report.moon_labels.moon_phase',
                  _currentLanguage,
                ),
                style: const pw.TextStyle(fontSize: 8, color: _textMuted),
              ),
              pw.Text(
                phase.localizedName(_currentLanguage),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            children: [
              pw.Text(sign.symbol, style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 4),
              pw.Text(
                L10nService.get(
                  'pdf_report.moon_labels.moon_sign',
                  _currentLanguage,
                ),
                style: const pw.TextStyle(fontSize: 8, color: _textMuted),
              ),
              pw.Text(
                sign.localizedName(_currentLanguage),
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDailyHoroscopeContent(String horoscope) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primaryColor, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        horoscope,
        style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
      ),
    );
  }

  pw.Widget _buildDailyRecommendations(ZodiacSign sign) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.daily_recommendation',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Expanded(
              child: _buildRecommendationItem(
                L10nService.get(
                  'pdf_report.labels.lucky_number',
                  _currentLanguage,
                ),
                _getLuckyNumber(sign).toString(),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildRecommendationItem(
                L10nService.get(
                  'pdf_report.labels.lucky_color',
                  _currentLanguage,
                ),
                _getLuckyColor(sign, _currentLanguage),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: _buildRecommendationItem(
                L10nService.get('pdf_report.labels.caution', _currentLanguage),
                _getCautionArea(sign, _currentLanguage),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildRecommendationItem(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF0F0F5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8, color: _textMuted),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============== Compatibility Report Methods ==============

  pw.Widget _buildCompatibilityHeader(
    UserProfile profile1,
    UserProfile profile2,
    pw.Context context,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _goldColor, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'VENUS ONE',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
              letterSpacing: 2,
            ),
          ),
          pw.Text(
            L10nService.get(
              'pdf_report.labels.compatibility_report',
              _currentLanguage,
            ),
            style: const pw.TextStyle(fontSize: 10, color: _textMuted),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCompatibilityTitleSection(
    UserProfile profile1,
    UserProfile profile2,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColor.fromInt(0xFFFFE8F0), PdfColor.fromInt(0xFFF3E8FF)],
        ),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Column(
            children: [
              pw.Text(
                profile1.sunSign.symbol,
                style: const pw.TextStyle(fontSize: 36),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                profile1.name ??
                    L10nService.get(
                      'pdf_report.defaults.person_1',
                      _currentLanguage,
                    ),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                profile1.sunSign.localizedName(_currentLanguage),
                style: const pw.TextStyle(fontSize: 10, color: _textMuted),
              ),
            ],
          ),
          pw.Text(
            '+',
            style: const pw.TextStyle(fontSize: 24, color: _goldColor),
          ),
          pw.Column(
            children: [
              pw.Text(
                profile2.sunSign.symbol,
                style: const pw.TextStyle(fontSize: 36),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                profile2.name ??
                    L10nService.get(
                      'pdf_report.defaults.person_2',
                      _currentLanguage,
                    ),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                profile2.sunSign.localizedName(_currentLanguage),
                style: const pw.TextStyle(fontSize: 10, color: _textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCompatibilityScoreSection(int score) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            L10nService.get(
              'pdf_report.sections.overall_compatibility',
              _currentLanguage,
            ),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _textMuted,
              letterSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            width: 100,
            height: 100,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(color: _getScoreColor(score), width: 4),
            ),
            child: pw.Center(
              child: pw.Text(
                '%$score',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCategoryScoresSection(Map<String, int> categoryScores) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          L10nService.get(
            'pdf_report.sections.category_compatibility',
            _currentLanguage,
          ),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 15),
        ...categoryScores.entries.map(
          (entry) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: _buildCategoryScoreBar(entry.key, entry.value),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCategoryScoreBar(String category, int score) {
    return pw.Row(
      children: [
        pw.SizedBox(
          width: 100,
          child: pw.Text(category, style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Expanded(
          child: pw.Stack(
            children: [
              pw.Container(
                height: 12,
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFE0E0E0),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
              ),
              pw.Container(
                height: 12,
                width: score * 2.0,
                decoration: pw.BoxDecoration(
                  color: _getScoreColor(score),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 10),
        pw.Text(
          '%$score',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildCompatibilityAnalysis(String analysis) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primaryColor, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            L10nService.get(
              'pdf_report.sections.detailed_analysis',
              _currentLanguage,
            ),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            analysis,
            style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  // ============== Helper Methods ==============

  PdfColor _getScoreColor(int score) {
    if (score >= 80) return const PdfColor.fromInt(0xFF4CAF50);
    if (score >= 60) return const PdfColor.fromInt(0xFF8BC34A);
    if (score >= 40) return const PdfColor.fromInt(0xFFFFEB3B);
    if (score >= 20) return const PdfColor.fromInt(0xFFFF9800);
    return const PdfColor.fromInt(0xFFF44336);
  }

  String _getPlanetMeaning(Planet planet, AppLanguage language) {
    final key = switch (planet) {
      Planet.sun => 'sun',
      Planet.moon => 'moon',
      Planet.mercury => 'mercury',
      Planet.venus => 'venus',
      Planet.mars => 'mars',
      Planet.jupiter => 'jupiter',
      Planet.saturn => 'saturn',
      Planet.uranus => 'uranus',
      Planet.neptune => 'neptune',
      Planet.pluto => 'pluto',
      Planet.northNode => 'north_node',
      Planet.southNode => 'south_node',
      Planet.chiron => 'chiron',
      Planet.lilith => 'lilith',
      Planet.ascendant => 'ascendant',
      Planet.midheaven => 'midheaven',
      Planet.ic => 'ic',
      Planet.descendant => 'descendant',
    };
    return L10nService.get('pdf_report.planet_meanings.$key', language);
  }

  String _getSunSignInterpretation(ZodiacSign sign, AppLanguage language) {
    final key = sign.name.toLowerCase();
    return L10nService.get(
      'pdf_report.sun_sign_interpretations.$key',
      language,
    );
  }

  String _getMoonSignInterpretation(ZodiacSign sign, AppLanguage language) {
    final key = sign.name.toLowerCase();
    return L10nService.get(
      'pdf_report.moon_sign_interpretations.$key',
      language,
    );
  }

  String _getAscendantInterpretation(ZodiacSign sign, AppLanguage language) {
    final key = sign.name.toLowerCase();
    return L10nService.get(
      'pdf_report.ascendant_interpretations.$key',
      language,
    );
  }

  int _getLuckyNumber(ZodiacSign sign) {
    final now = DateTime.now();
    final seed = now.day + now.month + sign.index;
    return (seed % 9) + 1;
  }

  String _getLuckyColor(ZodiacSign sign, AppLanguage language) {
    final colorKeys = [
      'red',
      'blue',
      'green',
      'purple',
      'orange',
      'yellow',
      'pink',
      'white',
    ];
    final now = DateTime.now();
    final index = (now.day + sign.index) % colorKeys.length;
    return L10nService.get('pdf_report.colors.${colorKeys[index]}', language);
  }

  String _getCautionArea(ZodiacSign sign, AppLanguage language) {
    final areaKeys = [
      'communication',
      'finance',
      'health',
      'relationships',
      'work',
      'family',
    ];
    final now = DateTime.now();
    final index = (now.day + sign.index + 3) % areaKeys.length;
    return L10nService.get(
      'pdf_report.caution_areas.${areaKeys[index]}',
      language,
    );
  }

  // ============== Public Methods ==============

  /// Preview PDF in system viewer
  Future<void> previewPdf(Uint8List pdfData) async {
    await Printing.layoutPdf(onLayout: (_) => pdfData);
  }

  /// Share PDF
  Future<void> sharePdf(Uint8List pdfData, String filename) async {
    await Printing.sharePdf(bytes: pdfData, filename: filename);
  }

  /// Save PDF to device
  Future<bool> savePdf(Uint8List pdfData, String filename) async {
    try {
      await Printing.sharePdf(bytes: pdfData, filename: filename);
      return true;
    } catch (e) {
      return false;
    }
  }
}
