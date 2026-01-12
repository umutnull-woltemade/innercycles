/// Comprehensive global cities database for astrology birth location
/// Contains major cities from all continents with coordinates

class CityData {
  final String name;
  final String country;
  final double lat;
  final double lng;
  final String? region;

  const CityData({
    required this.name,
    required this.country,
    required this.lat,
    required this.lng,
    this.region,
  });

  String get displayName => region != null ? '$name, $region ($country)' : '$name ($country)';
}

class WorldCities {
  static const List<CityData> allCities = [
    // ========== TURKIYE (81 IL) ==========
    CityData(name: 'Istanbul', country: 'Türkiye', lat: 41.0082, lng: 28.9784),
    CityData(name: 'Ankara', country: 'Türkiye', lat: 39.9334, lng: 32.8597),
    CityData(name: 'Izmir', country: 'Türkiye', lat: 38.4192, lng: 27.1287),
    CityData(name: 'Bursa', country: 'Türkiye', lat: 40.1885, lng: 29.0610),
    CityData(name: 'Antalya', country: 'Türkiye', lat: 36.8969, lng: 30.7133),
    CityData(name: 'Adana', country: 'Türkiye', lat: 37.0000, lng: 35.3213),
    CityData(name: 'Konya', country: 'Türkiye', lat: 37.8746, lng: 32.4932),
    CityData(name: 'Gaziantep', country: 'Türkiye', lat: 37.0662, lng: 37.3833),
    CityData(name: 'Sanliurfa', country: 'Türkiye', lat: 37.1591, lng: 38.7969),
    CityData(name: 'Diyarbakir', country: 'Türkiye', lat: 37.9144, lng: 40.2306),
    CityData(name: 'Mersin', country: 'Türkiye', lat: 36.8121, lng: 34.6415),
    CityData(name: 'Kayseri', country: 'Türkiye', lat: 38.7312, lng: 35.4787),
    CityData(name: 'Eskisehir', country: 'Türkiye', lat: 39.7767, lng: 30.5206),
    CityData(name: 'Samsun', country: 'Türkiye', lat: 41.2867, lng: 36.33),
    CityData(name: 'Denizli', country: 'Türkiye', lat: 37.7765, lng: 29.0864),
    CityData(name: 'Malatya', country: 'Türkiye', lat: 38.3552, lng: 38.3095),
    CityData(name: 'Kahramanmaras', country: 'Türkiye', lat: 37.5858, lng: 36.9371),
    CityData(name: 'Erzurum', country: 'Türkiye', lat: 39.9055, lng: 41.2658),
    CityData(name: 'Van', country: 'Türkiye', lat: 38.4891, lng: 43.4089),
    CityData(name: 'Batman', country: 'Türkiye', lat: 37.8812, lng: 41.1351),
    CityData(name: 'Elazig', country: 'Türkiye', lat: 38.6810, lng: 39.2264),
    CityData(name: 'Kocaeli', country: 'Türkiye', lat: 40.8533, lng: 29.8815),
    CityData(name: 'Manisa', country: 'Türkiye', lat: 38.6191, lng: 27.4289),
    CityData(name: 'Aydin', country: 'Türkiye', lat: 37.8560, lng: 27.8416),
    CityData(name: 'Balikesir', country: 'Türkiye', lat: 39.6484, lng: 27.8826),
    CityData(name: 'Tekirdag', country: 'Türkiye', lat: 40.9833, lng: 27.5167),
    CityData(name: 'Trabzon', country: 'Türkiye', lat: 41.0027, lng: 39.7168),
    CityData(name: 'Sakarya', country: 'Türkiye', lat: 40.7569, lng: 30.3781),
    CityData(name: 'Mugla', country: 'Türkiye', lat: 37.2153, lng: 28.3636),
    CityData(name: 'Hatay', country: 'Türkiye', lat: 36.4018, lng: 36.3498),
    CityData(name: 'Mardin', country: 'Türkiye', lat: 37.3212, lng: 40.7245),
    CityData(name: 'Adiyaman', country: 'Türkiye', lat: 37.7648, lng: 38.2786),
    CityData(name: 'Afyonkarahisar', country: 'Türkiye', lat: 38.7507, lng: 30.5567),
    CityData(name: 'Agri', country: 'Türkiye', lat: 39.7191, lng: 43.0503),
    CityData(name: 'Aksaray', country: 'Türkiye', lat: 38.3687, lng: 34.0370),
    CityData(name: 'Amasya', country: 'Türkiye', lat: 40.6499, lng: 35.8353),
    CityData(name: 'Ardahan', country: 'Türkiye', lat: 41.1105, lng: 42.7022),
    CityData(name: 'Artvin', country: 'Türkiye', lat: 41.1828, lng: 41.8183),
    CityData(name: 'Bartin', country: 'Türkiye', lat: 41.6344, lng: 32.3375),
    CityData(name: 'Bayburt', country: 'Türkiye', lat: 40.2552, lng: 40.2249),
    CityData(name: 'Bilecik', country: 'Türkiye', lat: 40.0567, lng: 30.0665),
    CityData(name: 'Bingol', country: 'Türkiye', lat: 38.8854, lng: 40.4966),
    CityData(name: 'Bitlis', country: 'Türkiye', lat: 38.4006, lng: 42.1095),
    CityData(name: 'Bolu', country: 'Türkiye', lat: 40.7390, lng: 31.6061),
    CityData(name: 'Burdur', country: 'Türkiye', lat: 37.7203, lng: 30.2906),
    CityData(name: 'Canakkale', country: 'Türkiye', lat: 40.1553, lng: 26.4142),
    CityData(name: 'Cankiri', country: 'Türkiye', lat: 40.6013, lng: 33.6134),
    CityData(name: 'Corum', country: 'Türkiye', lat: 40.5506, lng: 34.9556),
    CityData(name: 'Duzce', country: 'Türkiye', lat: 40.8438, lng: 31.1565),
    CityData(name: 'Edirne', country: 'Türkiye', lat: 41.6818, lng: 26.5623),
    CityData(name: 'Erzincan', country: 'Türkiye', lat: 39.7500, lng: 39.5000),
    CityData(name: 'Giresun', country: 'Türkiye', lat: 40.9128, lng: 38.3895),
    CityData(name: 'Gumushane', country: 'Türkiye', lat: 40.4386, lng: 39.5086),
    CityData(name: 'Hakkari', country: 'Türkiye', lat: 37.5833, lng: 43.7333),
    CityData(name: 'Igdir', country: 'Türkiye', lat: 39.9237, lng: 44.0450),
    CityData(name: 'Isparta', country: 'Türkiye', lat: 37.7648, lng: 30.5566),
    CityData(name: 'Karabuk', country: 'Türkiye', lat: 41.2061, lng: 32.6204),
    CityData(name: 'Karaman', country: 'Türkiye', lat: 37.1759, lng: 33.2287),
    CityData(name: 'Kars', country: 'Türkiye', lat: 40.6167, lng: 43.1000),
    CityData(name: 'Kastamonu', country: 'Türkiye', lat: 41.3887, lng: 33.7827),
    CityData(name: 'Kilis', country: 'Türkiye', lat: 36.7184, lng: 37.1212),
    CityData(name: 'Kirikkale', country: 'Türkiye', lat: 39.8468, lng: 33.5153),
    CityData(name: 'Kirklareli', country: 'Türkiye', lat: 41.7333, lng: 27.2167),
    CityData(name: 'Kirsehir', country: 'Türkiye', lat: 39.1425, lng: 34.1709),
    CityData(name: 'Kutahya', country: 'Türkiye', lat: 39.4167, lng: 29.9833),
    CityData(name: 'Mus', country: 'Türkiye', lat: 38.9462, lng: 41.7539),
    CityData(name: 'Nevsehir', country: 'Türkiye', lat: 38.6939, lng: 34.6857),
    CityData(name: 'Nigde', country: 'Türkiye', lat: 37.9667, lng: 34.6833),
    CityData(name: 'Ordu', country: 'Türkiye', lat: 40.9839, lng: 37.8764),
    CityData(name: 'Osmaniye', country: 'Türkiye', lat: 37.0746, lng: 36.2478),
    CityData(name: 'Rize', country: 'Türkiye', lat: 41.0201, lng: 40.5234),
    CityData(name: 'Siirt', country: 'Türkiye', lat: 37.9333, lng: 41.9500),
    CityData(name: 'Sinop', country: 'Türkiye', lat: 42.0231, lng: 35.1531),
    CityData(name: 'Sirnak', country: 'Türkiye', lat: 37.5164, lng: 42.4611),
    CityData(name: 'Sivas', country: 'Türkiye', lat: 39.7477, lng: 37.0179),
    CityData(name: 'Tokat', country: 'Türkiye', lat: 40.3167, lng: 36.5500),
    CityData(name: 'Tunceli', country: 'Türkiye', lat: 39.1079, lng: 39.5401),
    CityData(name: 'Usak', country: 'Türkiye', lat: 38.6823, lng: 29.4082),
    CityData(name: 'Yalova', country: 'Türkiye', lat: 40.6500, lng: 29.2667),
    CityData(name: 'Yozgat', country: 'Türkiye', lat: 39.8181, lng: 34.8147),
    CityData(name: 'Zonguldak', country: 'Türkiye', lat: 41.4564, lng: 31.7987),

    // ========== KKTC ==========
    CityData(name: 'Lefkosa', country: 'KKTC', lat: 35.1856, lng: 33.3823),
    CityData(name: 'Girne', country: 'KKTC', lat: 35.3364, lng: 33.3182),
    CityData(name: 'Gazimagusa', country: 'KKTC', lat: 35.1257, lng: 33.9415),
    CityData(name: 'Guzelyurt', country: 'KKTC', lat: 35.1994, lng: 32.9918),
    CityData(name: 'Iskele', country: 'KKTC', lat: 35.2864, lng: 33.8836),

    // ========== ALMANYA ==========
    CityData(name: 'Berlin', country: 'Almanya', lat: 52.5200, lng: 13.4050),
    CityData(name: 'Hamburg', country: 'Almanya', lat: 53.5511, lng: 9.9937),
    CityData(name: 'Munih', country: 'Almanya', lat: 48.1351, lng: 11.5820),
    CityData(name: 'Koln', country: 'Almanya', lat: 50.9375, lng: 6.9603),
    CityData(name: 'Frankfurt', country: 'Almanya', lat: 50.1109, lng: 8.6821),
    CityData(name: 'Stuttgart', country: 'Almanya', lat: 48.7758, lng: 9.1829),
    CityData(name: 'Dusseldorf', country: 'Almanya', lat: 51.2277, lng: 6.7735),
    CityData(name: 'Dortmund', country: 'Almanya', lat: 51.5136, lng: 7.4653),
    CityData(name: 'Essen', country: 'Almanya', lat: 51.4556, lng: 7.0116),
    CityData(name: 'Leipzig', country: 'Almanya', lat: 51.3397, lng: 12.3731),
    CityData(name: 'Bremen', country: 'Almanya', lat: 53.0793, lng: 8.8017),
    CityData(name: 'Dresden', country: 'Almanya', lat: 51.0504, lng: 13.7373),
    CityData(name: 'Hannover', country: 'Almanya', lat: 52.3759, lng: 9.7320),
    CityData(name: 'Nurnberg', country: 'Almanya', lat: 49.4521, lng: 11.0767),

    // ========== INGILTERE ==========
    CityData(name: 'Londra', country: 'Ingiltere', lat: 51.5074, lng: -0.1278),
    CityData(name: 'Birmingham', country: 'Ingiltere', lat: 52.4862, lng: -1.8904),
    CityData(name: 'Manchester', country: 'Ingiltere', lat: 53.4808, lng: -2.2426),
    CityData(name: 'Liverpool', country: 'Ingiltere', lat: 53.4084, lng: -2.9916),
    CityData(name: 'Leeds', country: 'Ingiltere', lat: 53.8008, lng: -1.5491),
    CityData(name: 'Sheffield', country: 'Ingiltere', lat: 53.3811, lng: -1.4701),
    CityData(name: 'Bristol', country: 'Ingiltere', lat: 51.4545, lng: -2.5879),
    CityData(name: 'Newcastle', country: 'Ingiltere', lat: 54.9783, lng: -1.6178),
    CityData(name: 'Nottingham', country: 'Ingiltere', lat: 52.9548, lng: -1.1581),
    CityData(name: 'Leicester', country: 'Ingiltere', lat: 52.6369, lng: -1.1398),
    CityData(name: 'Edinburgh', country: 'Iskocya', lat: 55.9533, lng: -3.1883),
    CityData(name: 'Glasgow', country: 'Iskocya', lat: 55.8642, lng: -4.2518),
    CityData(name: 'Cardiff', country: 'Galler', lat: 51.4816, lng: -3.1791),
    CityData(name: 'Belfast', country: 'Kuzey Irlanda', lat: 54.5973, lng: -5.9301),

    // ========== FRANSA ==========
    CityData(name: 'Paris', country: 'Fransa', lat: 48.8566, lng: 2.3522),
    CityData(name: 'Marsilya', country: 'Fransa', lat: 43.2965, lng: 5.3698),
    CityData(name: 'Lyon', country: 'Fransa', lat: 45.7640, lng: 4.8357),
    CityData(name: 'Toulouse', country: 'Fransa', lat: 43.6047, lng: 1.4442),
    CityData(name: 'Nice', country: 'Fransa', lat: 43.7102, lng: 7.2620),
    CityData(name: 'Nantes', country: 'Fransa', lat: 47.2184, lng: -1.5536),
    CityData(name: 'Strasbourg', country: 'Fransa', lat: 48.5734, lng: 7.7521),
    CityData(name: 'Montpellier', country: 'Fransa', lat: 43.6108, lng: 3.8767),
    CityData(name: 'Bordeaux', country: 'Fransa', lat: 44.8378, lng: -0.5792),
    CityData(name: 'Lille', country: 'Fransa', lat: 50.6292, lng: 3.0573),

    // ========== ITALYA ==========
    CityData(name: 'Roma', country: 'Italya', lat: 41.9028, lng: 12.4964),
    CityData(name: 'Milano', country: 'Italya', lat: 45.4642, lng: 9.1900),
    CityData(name: 'Napoli', country: 'Italya', lat: 40.8518, lng: 14.2681),
    CityData(name: 'Torino', country: 'Italya', lat: 45.0703, lng: 7.6869),
    CityData(name: 'Palermo', country: 'Italya', lat: 38.1157, lng: 13.3615),
    CityData(name: 'Cenova', country: 'Italya', lat: 44.4056, lng: 8.9463),
    CityData(name: 'Bolunya', country: 'Italya', lat: 44.4949, lng: 11.3426),
    CityData(name: 'Floransa', country: 'Italya', lat: 43.7696, lng: 11.2558),
    CityData(name: 'Venedik', country: 'Italya', lat: 45.4408, lng: 12.3155),
    CityData(name: 'Bari', country: 'Italya', lat: 41.1171, lng: 16.8719),

    // ========== ISPANYA ==========
    CityData(name: 'Madrid', country: 'Ispanya', lat: 40.4168, lng: -3.7038),
    CityData(name: 'Barselona', country: 'Ispanya', lat: 41.3851, lng: 2.1734),
    CityData(name: 'Valensiya', country: 'Ispanya', lat: 39.4699, lng: -0.3763),
    CityData(name: 'Sevilla', country: 'Ispanya', lat: 37.3891, lng: -5.9845),
    CityData(name: 'Zaragoza', country: 'Ispanya', lat: 41.6488, lng: -0.8891),
    CityData(name: 'Malaga', country: 'Ispanya', lat: 36.7213, lng: -4.4214),
    CityData(name: 'Murcia', country: 'Ispanya', lat: 37.9922, lng: -1.1307),
    CityData(name: 'Palma', country: 'Ispanya', lat: 39.5696, lng: 2.6502),
    CityData(name: 'Bilbao', country: 'Ispanya', lat: 43.2630, lng: -2.9350),
    CityData(name: 'Alicante', country: 'Ispanya', lat: 38.3452, lng: -0.4810),

    // ========== HOLLANDA ==========
    CityData(name: 'Amsterdam', country: 'Hollanda', lat: 52.3676, lng: 4.9041),
    CityData(name: 'Rotterdam', country: 'Hollanda', lat: 51.9244, lng: 4.4777),
    CityData(name: 'Lahey', country: 'Hollanda', lat: 52.0705, lng: 4.3007),
    CityData(name: 'Utrecht', country: 'Hollanda', lat: 52.0907, lng: 5.1214),
    CityData(name: 'Eindhoven', country: 'Hollanda', lat: 51.4416, lng: 5.4697),

    // ========== BELCIKA ==========
    CityData(name: 'Bruksel', country: 'Belcika', lat: 50.8503, lng: 4.3517),
    CityData(name: 'Antwerp', country: 'Belcika', lat: 51.2194, lng: 4.4025),
    CityData(name: 'Gent', country: 'Belcika', lat: 51.0543, lng: 3.7174),
    CityData(name: 'Brugge', country: 'Belcika', lat: 51.2093, lng: 3.2247),
    CityData(name: 'Liege', country: 'Belcika', lat: 50.6326, lng: 5.5797),

    // ========== AVUSTURYA ==========
    CityData(name: 'Viyana', country: 'Avusturya', lat: 48.2082, lng: 16.3738),
    CityData(name: 'Graz', country: 'Avusturya', lat: 47.0707, lng: 15.4395),
    CityData(name: 'Linz', country: 'Avusturya', lat: 48.3069, lng: 14.2858),
    CityData(name: 'Salzburg', country: 'Avusturya', lat: 47.8095, lng: 13.0550),
    CityData(name: 'Innsbruck', country: 'Avusturya', lat: 47.2692, lng: 11.4041),

    // ========== ISVICRE ==========
    CityData(name: 'Zurich', country: 'Isvicre', lat: 47.3769, lng: 8.5417),
    CityData(name: 'Cenevre', country: 'Isvicre', lat: 46.2044, lng: 6.1432),
    CityData(name: 'Basel', country: 'Isvicre', lat: 47.5596, lng: 7.5886),
    CityData(name: 'Bern', country: 'Isvicre', lat: 46.9480, lng: 7.4474),
    CityData(name: 'Lozan', country: 'Isvicre', lat: 46.5197, lng: 6.6323),

    // ========== RUSYA ==========
    CityData(name: 'Moskova', country: 'Rusya', lat: 55.7558, lng: 37.6173),
    CityData(name: 'St. Petersburg', country: 'Rusya', lat: 59.9311, lng: 30.3609),
    CityData(name: 'Novosibirsk', country: 'Rusya', lat: 55.0084, lng: 82.9357),
    CityData(name: 'Yekaterinburg', country: 'Rusya', lat: 56.8389, lng: 60.6057),
    CityData(name: 'Kazan', country: 'Rusya', lat: 55.7887, lng: 49.1221),
    CityData(name: 'Sochi', country: 'Rusya', lat: 43.6028, lng: 39.7342),

    // ========== POLONYA ==========
    CityData(name: 'Varsova', country: 'Polonya', lat: 52.2297, lng: 21.0122),
    CityData(name: 'Krakow', country: 'Polonya', lat: 50.0647, lng: 19.9450),
    CityData(name: 'Lodz', country: 'Polonya', lat: 51.7592, lng: 19.4560),
    CityData(name: 'Wroclaw', country: 'Polonya', lat: 51.1079, lng: 17.0385),
    CityData(name: 'Poznan', country: 'Polonya', lat: 52.4064, lng: 16.9252),
    CityData(name: 'Gdansk', country: 'Polonya', lat: 54.3520, lng: 18.6466),

    // ========== YUNANISTAN ==========
    CityData(name: 'Atina', country: 'Yunanistan', lat: 37.9838, lng: 23.7275),
    CityData(name: 'Selanik', country: 'Yunanistan', lat: 40.6401, lng: 22.9444),
    CityData(name: 'Patras', country: 'Yunanistan', lat: 38.2466, lng: 21.7346),
    CityData(name: 'Heraklion', country: 'Yunanistan', lat: 35.3387, lng: 25.1442),
    CityData(name: 'Rodos', country: 'Yunanistan', lat: 36.4349, lng: 28.2176),

    // ========== PORTEKIZ ==========
    CityData(name: 'Lizbon', country: 'Portekiz', lat: 38.7223, lng: -9.1393),
    CityData(name: 'Porto', country: 'Portekiz', lat: 41.1579, lng: -8.6291),
    CityData(name: 'Braga', country: 'Portekiz', lat: 41.5454, lng: -8.4265),
    CityData(name: 'Coimbra', country: 'Portekiz', lat: 40.2033, lng: -8.4103),
    CityData(name: 'Faro', country: 'Portekiz', lat: 37.0194, lng: -7.9322),

    // ========== ISVEC ==========
    CityData(name: 'Stockholm', country: 'Isvec', lat: 59.3293, lng: 18.0686),
    CityData(name: 'Goteborg', country: 'Isvec', lat: 57.7089, lng: 11.9746),
    CityData(name: 'Malmo', country: 'Isvec', lat: 55.6050, lng: 13.0038),
    CityData(name: 'Uppsala', country: 'Isvec', lat: 59.8586, lng: 17.6389),

    // ========== NORVEC ==========
    CityData(name: 'Oslo', country: 'Norvec', lat: 59.9139, lng: 10.7522),
    CityData(name: 'Bergen', country: 'Norvec', lat: 60.3913, lng: 5.3221),
    CityData(name: 'Trondheim', country: 'Norvec', lat: 63.4305, lng: 10.3951),
    CityData(name: 'Stavanger', country: 'Norvec', lat: 58.9700, lng: 5.7331),

    // ========== DANIMARKA ==========
    CityData(name: 'Kopenhag', country: 'Danimarka', lat: 55.6761, lng: 12.5683),
    CityData(name: 'Aarhus', country: 'Danimarka', lat: 56.1629, lng: 10.2039),
    CityData(name: 'Odense', country: 'Danimarka', lat: 55.4038, lng: 10.4024),
    CityData(name: 'Aalborg', country: 'Danimarka', lat: 57.0488, lng: 9.9217),

    // ========== FINLANDIYA ==========
    CityData(name: 'Helsinki', country: 'Finlandiya', lat: 60.1699, lng: 24.9384),
    CityData(name: 'Espoo', country: 'Finlandiya', lat: 60.2055, lng: 24.6559),
    CityData(name: 'Tampere', country: 'Finlandiya', lat: 61.4978, lng: 23.7610),
    CityData(name: 'Turku', country: 'Finlandiya', lat: 60.4518, lng: 22.2666),

    // ========== IRLANDA ==========
    CityData(name: 'Dublin', country: 'Irlanda', lat: 53.3498, lng: -6.2603),
    CityData(name: 'Cork', country: 'Irlanda', lat: 51.8985, lng: -8.4756),
    CityData(name: 'Limerick', country: 'Irlanda', lat: 52.6638, lng: -8.6267),
    CityData(name: 'Galway', country: 'Irlanda', lat: 53.2707, lng: -9.0568),

    // ========== CEKYA ==========
    CityData(name: 'Prag', country: 'Cekya', lat: 50.0755, lng: 14.4378),
    CityData(name: 'Brno', country: 'Cekya', lat: 49.1951, lng: 16.6068),
    CityData(name: 'Ostrava', country: 'Cekya', lat: 49.8209, lng: 18.2625),
    CityData(name: 'Pilsen', country: 'Cekya', lat: 49.7384, lng: 13.3736),

    // ========== MACARISTAN ==========
    CityData(name: 'Budapeste', country: 'Macaristan', lat: 47.4979, lng: 19.0402),
    CityData(name: 'Debrecen', country: 'Macaristan', lat: 47.5316, lng: 21.6273),
    CityData(name: 'Szeged', country: 'Macaristan', lat: 46.2530, lng: 20.1414),
    CityData(name: 'Miskolc', country: 'Macaristan', lat: 48.1035, lng: 20.7784),

    // ========== ROMANYA ==========
    CityData(name: 'Bukres', country: 'Romanya', lat: 44.4268, lng: 26.1025),
    CityData(name: 'Cluj-Napoca', country: 'Romanya', lat: 46.7712, lng: 23.6236),
    CityData(name: 'Timisoara', country: 'Romanya', lat: 45.7489, lng: 21.2087),
    CityData(name: 'Iasi', country: 'Romanya', lat: 47.1585, lng: 27.6014),
    CityData(name: 'Constanta', country: 'Romanya', lat: 44.1598, lng: 28.6348),

    // ========== BULGARISTAN ==========
    CityData(name: 'Sofya', country: 'Bulgaristan', lat: 42.6977, lng: 23.3219),
    CityData(name: 'Plovdiv', country: 'Bulgaristan', lat: 42.1354, lng: 24.7453),
    CityData(name: 'Varna', country: 'Bulgaristan', lat: 43.2141, lng: 27.9147),
    CityData(name: 'Burgas', country: 'Bulgaristan', lat: 42.5048, lng: 27.4626),

    // ========== UKRAYNA ==========
    CityData(name: 'Kiev', country: 'Ukrayna', lat: 50.4501, lng: 30.5234),
    CityData(name: 'Kharkiv', country: 'Ukrayna', lat: 49.9935, lng: 36.2304),
    CityData(name: 'Odessa', country: 'Ukrayna', lat: 46.4825, lng: 30.7233),
    CityData(name: 'Dnipro', country: 'Ukrayna', lat: 48.4647, lng: 35.0462),
    CityData(name: 'Lviv', country: 'Ukrayna', lat: 49.8397, lng: 24.0297),

    // ========== ABD ==========
    CityData(name: 'New York', country: 'ABD', region: 'New York', lat: 40.7128, lng: -74.0060),
    CityData(name: 'Los Angeles', country: 'ABD', region: 'California', lat: 34.0522, lng: -118.2437),
    CityData(name: 'Chicago', country: 'ABD', region: 'Illinois', lat: 41.8781, lng: -87.6298),
    CityData(name: 'Houston', country: 'ABD', region: 'Texas', lat: 29.7604, lng: -95.3698),
    CityData(name: 'Phoenix', country: 'ABD', region: 'Arizona', lat: 33.4484, lng: -112.0740),
    CityData(name: 'Philadelphia', country: 'ABD', region: 'Pennsylvania', lat: 39.9526, lng: -75.1652),
    CityData(name: 'San Antonio', country: 'ABD', region: 'Texas', lat: 29.4241, lng: -98.4936),
    CityData(name: 'San Diego', country: 'ABD', region: 'California', lat: 32.7157, lng: -117.1611),
    CityData(name: 'Dallas', country: 'ABD', region: 'Texas', lat: 32.7767, lng: -96.7970),
    CityData(name: 'San Jose', country: 'ABD', region: 'California', lat: 37.3382, lng: -121.8863),
    CityData(name: 'Austin', country: 'ABD', region: 'Texas', lat: 30.2672, lng: -97.7431),
    CityData(name: 'Jacksonville', country: 'ABD', region: 'Florida', lat: 30.3322, lng: -81.6557),
    CityData(name: 'Fort Worth', country: 'ABD', region: 'Texas', lat: 32.7555, lng: -97.3308),
    CityData(name: 'Columbus', country: 'ABD', region: 'Ohio', lat: 39.9612, lng: -82.9988),
    CityData(name: 'San Francisco', country: 'ABD', region: 'California', lat: 37.7749, lng: -122.4194),
    CityData(name: 'Charlotte', country: 'ABD', region: 'North Carolina', lat: 35.2271, lng: -80.8431),
    CityData(name: 'Indianapolis', country: 'ABD', region: 'Indiana', lat: 39.7684, lng: -86.1581),
    CityData(name: 'Seattle', country: 'ABD', region: 'Washington', lat: 47.6062, lng: -122.3321),
    CityData(name: 'Denver', country: 'ABD', region: 'Colorado', lat: 39.7392, lng: -104.9903),
    CityData(name: 'Washington DC', country: 'ABD', lat: 38.9072, lng: -77.0369),
    CityData(name: 'Boston', country: 'ABD', region: 'Massachusetts', lat: 42.3601, lng: -71.0589),
    CityData(name: 'Nashville', country: 'ABD', region: 'Tennessee', lat: 36.1627, lng: -86.7816),
    CityData(name: 'Las Vegas', country: 'ABD', region: 'Nevada', lat: 36.1699, lng: -115.1398),
    CityData(name: 'Miami', country: 'ABD', region: 'Florida', lat: 25.7617, lng: -80.1918),
    CityData(name: 'Atlanta', country: 'ABD', region: 'Georgia', lat: 33.7490, lng: -84.3880),
    CityData(name: 'Portland', country: 'ABD', region: 'Oregon', lat: 45.5152, lng: -122.6784),
    CityData(name: 'Detroit', country: 'ABD', region: 'Michigan', lat: 42.3314, lng: -83.0458),
    CityData(name: 'Minneapolis', country: 'ABD', region: 'Minnesota', lat: 44.9778, lng: -93.2650),
    CityData(name: 'Orlando', country: 'ABD', region: 'Florida', lat: 28.5383, lng: -81.3792),
    CityData(name: 'Tampa', country: 'ABD', region: 'Florida', lat: 27.9506, lng: -82.4572),

    // ========== KANADA ==========
    CityData(name: 'Toronto', country: 'Kanada', lat: 43.6532, lng: -79.3832),
    CityData(name: 'Montreal', country: 'Kanada', lat: 45.5017, lng: -73.5673),
    CityData(name: 'Vancouver', country: 'Kanada', lat: 49.2827, lng: -123.1207),
    CityData(name: 'Calgary', country: 'Kanada', lat: 51.0447, lng: -114.0719),
    CityData(name: 'Edmonton', country: 'Kanada', lat: 53.5461, lng: -113.4938),
    CityData(name: 'Ottawa', country: 'Kanada', lat: 45.4215, lng: -75.6972),
    CityData(name: 'Winnipeg', country: 'Kanada', lat: 49.8951, lng: -97.1384),
    CityData(name: 'Quebec City', country: 'Kanada', lat: 46.8139, lng: -71.2080),

    // ========== MEKSIKA ==========
    CityData(name: 'Mexico City', country: 'Meksika', lat: 19.4326, lng: -99.1332),
    CityData(name: 'Guadalajara', country: 'Meksika', lat: 20.6597, lng: -103.3496),
    CityData(name: 'Monterrey', country: 'Meksika', lat: 25.6866, lng: -100.3161),
    CityData(name: 'Puebla', country: 'Meksika', lat: 19.0414, lng: -98.2063),
    CityData(name: 'Tijuana', country: 'Meksika', lat: 32.5149, lng: -117.0382),
    CityData(name: 'Cancun', country: 'Meksika', lat: 21.1619, lng: -86.8515),

    // ========== BREZILYA ==========
    CityData(name: 'Sao Paulo', country: 'Brezilya', lat: -23.5505, lng: -46.6333),
    CityData(name: 'Rio de Janeiro', country: 'Brezilya', lat: -22.9068, lng: -43.1729),
    CityData(name: 'Brasilia', country: 'Brezilya', lat: -15.7975, lng: -47.8919),
    CityData(name: 'Salvador', country: 'Brezilya', lat: -12.9714, lng: -38.5014),
    CityData(name: 'Fortaleza', country: 'Brezilya', lat: -3.7172, lng: -38.5433),
    CityData(name: 'Belo Horizonte', country: 'Brezilya', lat: -19.9167, lng: -43.9345),

    // ========== ARJANTIN ==========
    CityData(name: 'Buenos Aires', country: 'Arjantin', lat: -34.6037, lng: -58.3816),
    CityData(name: 'Cordoba', country: 'Arjantin', lat: -31.4201, lng: -64.1888),
    CityData(name: 'Rosario', country: 'Arjantin', lat: -32.9468, lng: -60.6393),
    CityData(name: 'Mendoza', country: 'Arjantin', lat: -32.8895, lng: -68.8458),

    // ========== KOLOMBIYA ==========
    CityData(name: 'Bogota', country: 'Kolombiya', lat: 4.7110, lng: -74.0721),
    CityData(name: 'Medellin', country: 'Kolombiya', lat: 6.2518, lng: -75.5636),
    CityData(name: 'Cali', country: 'Kolombiya', lat: 3.4516, lng: -76.5320),
    CityData(name: 'Barranquilla', country: 'Kolombiya', lat: 10.9639, lng: -74.7964),

    // ========== SILI ==========
    CityData(name: 'Santiago', country: 'Sili', lat: -33.4489, lng: -70.6693),
    CityData(name: 'Valparaiso', country: 'Sili', lat: -33.0472, lng: -71.6127),
    CityData(name: 'Concepcion', country: 'Sili', lat: -36.8270, lng: -73.0498),

    // ========== PERU ==========
    CityData(name: 'Lima', country: 'Peru', lat: -12.0464, lng: -77.0428),
    CityData(name: 'Arequipa', country: 'Peru', lat: -16.4090, lng: -71.5375),
    CityData(name: 'Cusco', country: 'Peru', lat: -13.5320, lng: -71.9675),

    // ========== AVUSTRALYA ==========
    CityData(name: 'Sydney', country: 'Avustralya', lat: -33.8688, lng: 151.2093),
    CityData(name: 'Melbourne', country: 'Avustralya', lat: -37.8136, lng: 144.9631),
    CityData(name: 'Brisbane', country: 'Avustralya', lat: -27.4698, lng: 153.0251),
    CityData(name: 'Perth', country: 'Avustralya', lat: -31.9505, lng: 115.8605),
    CityData(name: 'Adelaide', country: 'Avustralya', lat: -34.9285, lng: 138.6007),
    CityData(name: 'Gold Coast', country: 'Avustralya', lat: -28.0167, lng: 153.4000),
    CityData(name: 'Canberra', country: 'Avustralya', lat: -35.2809, lng: 149.1300),

    // ========== YENI ZELANDA ==========
    CityData(name: 'Auckland', country: 'Yeni Zelanda', lat: -36.8509, lng: 174.7645),
    CityData(name: 'Wellington', country: 'Yeni Zelanda', lat: -41.2866, lng: 174.7756),
    CityData(name: 'Christchurch', country: 'Yeni Zelanda', lat: -43.5321, lng: 172.6362),
    CityData(name: 'Hamilton', country: 'Yeni Zelanda', lat: -37.7870, lng: 175.2793),

    // ========== JAPONYA ==========
    CityData(name: 'Tokyo', country: 'Japonya', lat: 35.6762, lng: 139.6503),
    CityData(name: 'Osaka', country: 'Japonya', lat: 34.6937, lng: 135.5023),
    CityData(name: 'Kyoto', country: 'Japonya', lat: 35.0116, lng: 135.7681),
    CityData(name: 'Yokohama', country: 'Japonya', lat: 35.4437, lng: 139.6380),
    CityData(name: 'Nagoya', country: 'Japonya', lat: 35.1815, lng: 136.9066),
    CityData(name: 'Sapporo', country: 'Japonya', lat: 43.0618, lng: 141.3545),
    CityData(name: 'Kobe', country: 'Japonya', lat: 34.6901, lng: 135.1956),
    CityData(name: 'Fukuoka', country: 'Japonya', lat: 33.5904, lng: 130.4017),
    CityData(name: 'Hiroshima', country: 'Japonya', lat: 34.3853, lng: 132.4553),

    // ========== CIN ==========
    CityData(name: 'Pekin', country: 'Cin', lat: 39.9042, lng: 116.4074),
    CityData(name: 'Sanghay', country: 'Cin', lat: 31.2304, lng: 121.4737),
    CityData(name: 'Guangzhou', country: 'Cin', lat: 23.1291, lng: 113.2644),
    CityData(name: 'Shenzhen', country: 'Cin', lat: 22.5431, lng: 114.0579),
    CityData(name: 'Chengdu', country: 'Cin', lat: 30.5728, lng: 104.0668),
    CityData(name: 'Xian', country: 'Cin', lat: 34.3416, lng: 108.9398),
    CityData(name: 'Hangzhou', country: 'Cin', lat: 30.2741, lng: 120.1551),
    CityData(name: 'Wuhan', country: 'Cin', lat: 30.5928, lng: 114.3055),
    CityData(name: 'Hong Kong', country: 'Hong Kong', lat: 22.3193, lng: 114.1694),

    // ========== GUNEY KORE ==========
    CityData(name: 'Seul', country: 'Guney Kore', lat: 37.5665, lng: 126.9780),
    CityData(name: 'Busan', country: 'Guney Kore', lat: 35.1796, lng: 129.0756),
    CityData(name: 'Incheon', country: 'Guney Kore', lat: 37.4563, lng: 126.7052),
    CityData(name: 'Daegu', country: 'Guney Kore', lat: 35.8714, lng: 128.6014),
    CityData(name: 'Daejeon', country: 'Guney Kore', lat: 36.3504, lng: 127.3845),

    // ========== HINDISTAN ==========
    CityData(name: 'Mumbai', country: 'Hindistan', lat: 19.0760, lng: 72.8777),
    CityData(name: 'Delhi', country: 'Hindistan', lat: 28.7041, lng: 77.1025),
    CityData(name: 'Bangalore', country: 'Hindistan', lat: 12.9716, lng: 77.5946),
    CityData(name: 'Hyderabad', country: 'Hindistan', lat: 17.3850, lng: 78.4867),
    CityData(name: 'Chennai', country: 'Hindistan', lat: 13.0827, lng: 80.2707),
    CityData(name: 'Kolkata', country: 'Hindistan', lat: 22.5726, lng: 88.3639),
    CityData(name: 'Ahmedabad', country: 'Hindistan', lat: 23.0225, lng: 72.5714),
    CityData(name: 'Pune', country: 'Hindistan', lat: 18.5204, lng: 73.8567),
    CityData(name: 'Jaipur', country: 'Hindistan', lat: 26.9124, lng: 75.7873),

    // ========== SINGAPUR ==========
    CityData(name: 'Singapur', country: 'Singapur', lat: 1.3521, lng: 103.8198),

    // ========== MALEZYA ==========
    CityData(name: 'Kuala Lumpur', country: 'Malezya', lat: 3.1390, lng: 101.6869),
    CityData(name: 'George Town', country: 'Malezya', lat: 5.4141, lng: 100.3288),
    CityData(name: 'Johor Bahru', country: 'Malezya', lat: 1.4927, lng: 103.7414),

    // ========== TAYLAND ==========
    CityData(name: 'Bangkok', country: 'Tayland', lat: 13.7563, lng: 100.5018),
    CityData(name: 'Chiang Mai', country: 'Tayland', lat: 18.7883, lng: 98.9853),
    CityData(name: 'Phuket', country: 'Tayland', lat: 7.8804, lng: 98.3923),
    CityData(name: 'Pattaya', country: 'Tayland', lat: 12.9236, lng: 100.8825),

    // ========== VIETNAM ==========
    CityData(name: 'Ho Chi Minh', country: 'Vietnam', lat: 10.8231, lng: 106.6297),
    CityData(name: 'Hanoi', country: 'Vietnam', lat: 21.0278, lng: 105.8342),
    CityData(name: 'Da Nang', country: 'Vietnam', lat: 16.0544, lng: 108.2022),

    // ========== ENDONEZYA ==========
    CityData(name: 'Jakarta', country: 'Endonezya', lat: -6.2088, lng: 106.8456),
    CityData(name: 'Surabaya', country: 'Endonezya', lat: -7.2575, lng: 112.7521),
    CityData(name: 'Bandung', country: 'Endonezya', lat: -6.9175, lng: 107.6191),
    CityData(name: 'Bali', country: 'Endonezya', lat: -8.3405, lng: 115.0920),
    CityData(name: 'Medan', country: 'Endonezya', lat: 3.5952, lng: 98.6722),

    // ========== FILIPINLER ==========
    CityData(name: 'Manila', country: 'Filipinler', lat: 14.5995, lng: 120.9842),
    CityData(name: 'Cebu', country: 'Filipinler', lat: 10.3157, lng: 123.8854),
    CityData(name: 'Davao', country: 'Filipinler', lat: 7.1907, lng: 125.4553),

    // ========== BIRLESIK ARAP EMIRLIKLERI ==========
    CityData(name: 'Dubai', country: 'BAE', lat: 25.2048, lng: 55.2708),
    CityData(name: 'Abu Dhabi', country: 'BAE', lat: 24.4539, lng: 54.3773),
    CityData(name: 'Sharjah', country: 'BAE', lat: 25.3573, lng: 55.4033),

    // ========== SUUDI ARABISTAN ==========
    CityData(name: 'Riyad', country: 'Suudi Arabistan', lat: 24.7136, lng: 46.6753),
    CityData(name: 'Cidde', country: 'Suudi Arabistan', lat: 21.4858, lng: 39.1925),
    CityData(name: 'Mekke', country: 'Suudi Arabistan', lat: 21.3891, lng: 39.8579),
    CityData(name: 'Medine', country: 'Suudi Arabistan', lat: 24.5247, lng: 39.5692),
    CityData(name: 'Dammam', country: 'Suudi Arabistan', lat: 26.4207, lng: 50.0888),

    // ========== KATAR ==========
    CityData(name: 'Doha', country: 'Katar', lat: 25.2854, lng: 51.5310),

    // ========== KUVEYT ==========
    CityData(name: 'Kuveyt', country: 'Kuveyt', lat: 29.3759, lng: 47.9774),

    // ========== BAHREYN ==========
    CityData(name: 'Manama', country: 'Bahreyn', lat: 26.2285, lng: 50.5860),

    // ========== UMMAN ==========
    CityData(name: 'Muskat', country: 'Umman', lat: 23.5880, lng: 58.3829),

    // ========== MISIR ==========
    CityData(name: 'Kahire', country: 'Misir', lat: 30.0444, lng: 31.2357),
    CityData(name: 'Iskenderiye', country: 'Misir', lat: 31.2001, lng: 29.9187),
    CityData(name: 'Giza', country: 'Misir', lat: 30.0131, lng: 31.2089),
    CityData(name: 'Luxor', country: 'Misir', lat: 25.6872, lng: 32.6396),
    CityData(name: 'Aswan', country: 'Misir', lat: 24.0889, lng: 32.8998),
    CityData(name: 'Sharm El Sheikh', country: 'Misir', lat: 27.9158, lng: 34.3300),

    // ========== GUNEY AFRIKA ==========
    CityData(name: 'Johannesburg', country: 'Guney Afrika', lat: -26.2041, lng: 28.0473),
    CityData(name: 'Cape Town', country: 'Guney Afrika', lat: -33.9249, lng: 18.4241),
    CityData(name: 'Durban', country: 'Guney Afrika', lat: -29.8587, lng: 31.0218),
    CityData(name: 'Pretoria', country: 'Guney Afrika', lat: -25.7479, lng: 28.2293),

    // ========== KENYA ==========
    CityData(name: 'Nairobi', country: 'Kenya', lat: -1.2921, lng: 36.8219),
    CityData(name: 'Mombasa', country: 'Kenya', lat: -4.0435, lng: 39.6682),

    // ========== NIJERYA ==========
    CityData(name: 'Lagos', country: 'Nijerya', lat: 6.5244, lng: 3.3792),
    CityData(name: 'Abuja', country: 'Nijerya', lat: 9.0765, lng: 7.3986),
    CityData(name: 'Kano', country: 'Nijerya', lat: 12.0022, lng: 8.5920),

    // ========== GANA ==========
    CityData(name: 'Accra', country: 'Gana', lat: 5.6037, lng: -0.1870),

    // ========== FAS ==========
    CityData(name: 'Kazablanka', country: 'Fas', lat: 33.5731, lng: -7.5898),
    CityData(name: 'Marrakech', country: 'Fas', lat: 31.6295, lng: -7.9811),
    CityData(name: 'Rabat', country: 'Fas', lat: 34.0209, lng: -6.8416),
    CityData(name: 'Fes', country: 'Fas', lat: 34.0181, lng: -5.0078),
    CityData(name: 'Tanger', country: 'Fas', lat: 35.7595, lng: -5.8340),

    // ========== TUNUS ==========
    CityData(name: 'Tunus', country: 'Tunus', lat: 36.8065, lng: 10.1815),
    CityData(name: 'Sousse', country: 'Tunus', lat: 35.8245, lng: 10.6346),

    // ========== CEZAYIR ==========
    CityData(name: 'Cezayir', country: 'Cezayir', lat: 36.7538, lng: 3.0588),
    CityData(name: 'Oran', country: 'Cezayir', lat: 35.6987, lng: -0.6349),

    // ========== IRAN ==========
    CityData(name: 'Tahran', country: 'Iran', lat: 35.6892, lng: 51.3890),
    CityData(name: 'Isfahan', country: 'Iran', lat: 32.6546, lng: 51.6680),
    CityData(name: 'Mashad', country: 'Iran', lat: 36.2605, lng: 59.6168),
    CityData(name: 'Shiraz', country: 'Iran', lat: 29.5918, lng: 52.5837),
    CityData(name: 'Tabriz', country: 'Iran', lat: 38.0800, lng: 46.2919),

    // ========== IRAK ==========
    CityData(name: 'Bagdat', country: 'Irak', lat: 33.3152, lng: 44.3661),
    CityData(name: 'Basra', country: 'Irak', lat: 30.5081, lng: 47.7835),
    CityData(name: 'Erbil', country: 'Irak', lat: 36.1901, lng: 44.0091),
    CityData(name: 'Musul', country: 'Irak', lat: 36.3350, lng: 43.1189),

    // ========== LUBNAN ==========
    CityData(name: 'Beyrut', country: 'Lubnan', lat: 33.8938, lng: 35.5018),
    CityData(name: 'Trablus', country: 'Lubnan', lat: 34.4333, lng: 35.8333),

    // ========== URDUN ==========
    CityData(name: 'Amman', country: 'Urdun', lat: 31.9454, lng: 35.9284),
    CityData(name: 'Akabe', country: 'Urdun', lat: 29.5269, lng: 35.0078),

    // ========== ISRAIL ==========
    CityData(name: 'Tel Aviv', country: 'Israil', lat: 32.0853, lng: 34.7818),
    CityData(name: 'Kudus', country: 'Israil', lat: 31.7683, lng: 35.2137),
    CityData(name: 'Hayfa', country: 'Israil', lat: 32.7940, lng: 34.9896),

    // ========== AZERBAYCAN ==========
    CityData(name: 'Baku', country: 'Azerbaycan', lat: 40.4093, lng: 49.8671),
    CityData(name: 'Gence', country: 'Azerbaycan', lat: 40.6828, lng: 46.3606),

    // ========== GURCISTAN ==========
    CityData(name: 'Tiflis', country: 'Gurcistan', lat: 41.7151, lng: 44.8271),
    CityData(name: 'Batum', country: 'Gurcistan', lat: 41.6168, lng: 41.6367),

    // ========== ERMENISTAN ==========
    CityData(name: 'Erivan', country: 'Ermenistan', lat: 40.1792, lng: 44.4991),

    // ========== KAZAKISTAN ==========
    CityData(name: 'Nur-Sultan', country: 'Kazakistan', lat: 51.1694, lng: 71.4491),
    CityData(name: 'Almaty', country: 'Kazakistan', lat: 43.2220, lng: 76.8512),
    CityData(name: 'Shimkent', country: 'Kazakistan', lat: 42.3417, lng: 69.5901),

    // ========== OZBEKISTAN ==========
    CityData(name: 'Taskent', country: 'Ozbekistan', lat: 41.2995, lng: 69.2401),
    CityData(name: 'Semerkand', country: 'Ozbekistan', lat: 39.6270, lng: 66.9750),
    CityData(name: 'Buhara', country: 'Ozbekistan', lat: 39.7681, lng: 64.4556),

    // ========== PAKISTAN ==========
    CityData(name: 'Karaci', country: 'Pakistan', lat: 24.8607, lng: 67.0011),
    CityData(name: 'Lahor', country: 'Pakistan', lat: 31.5497, lng: 74.3436),
    CityData(name: 'Islamabad', country: 'Pakistan', lat: 33.6844, lng: 73.0479),
    CityData(name: 'Ravalpindi', country: 'Pakistan', lat: 33.5651, lng: 73.0169),

    // ========== BANGLADES ==========
    CityData(name: 'Dakka', country: 'Banglades', lat: 23.8103, lng: 90.4125),
    CityData(name: 'Chittagong', country: 'Banglades', lat: 22.3569, lng: 91.7832),

    // ========== SRI LANKA ==========
    CityData(name: 'Kolombo', country: 'Sri Lanka', lat: 6.9271, lng: 79.8612),
    CityData(name: 'Kandy', country: 'Sri Lanka', lat: 7.2906, lng: 80.6337),

    // ========== NEPAL ==========
    CityData(name: 'Katmandu', country: 'Nepal', lat: 27.7172, lng: 85.3240),
    CityData(name: 'Pokhara', country: 'Nepal', lat: 28.2096, lng: 83.9856),

    // ========== TAYVAN ==========
    CityData(name: 'Taipei', country: 'Tayvan', lat: 25.0330, lng: 121.5654),
    CityData(name: 'Kaohsiung', country: 'Tayvan', lat: 22.6273, lng: 120.3014),
    CityData(name: 'Taichung', country: 'Tayvan', lat: 24.1477, lng: 120.6736),

    // ========== KIBRIS ==========
    CityData(name: 'Lefkosa (Guney)', country: 'Kibris', lat: 35.1676, lng: 33.3736),
    CityData(name: 'Limasol', country: 'Kibris', lat: 34.6841, lng: 33.0379),
    CityData(name: 'Larnaka', country: 'Kibris', lat: 34.9003, lng: 33.6232),
    CityData(name: 'Baf', country: 'Kibris', lat: 34.7720, lng: 32.4297),

    // ========== MALTA ==========
    CityData(name: 'Valletta', country: 'Malta', lat: 35.8989, lng: 14.5146),

    // ========== HIRVATISTAN ==========
    CityData(name: 'Zagreb', country: 'Hirvatistan', lat: 45.8150, lng: 15.9819),
    CityData(name: 'Split', country: 'Hirvatistan', lat: 43.5081, lng: 16.4402),
    CityData(name: 'Dubrovnik', country: 'Hirvatistan', lat: 42.6507, lng: 18.0944),

    // ========== SLOVENYA ==========
    CityData(name: 'Ljubljana', country: 'Slovenya', lat: 46.0569, lng: 14.5058),

    // ========== SLOVAKYA ==========
    CityData(name: 'Bratislava', country: 'Slovakya', lat: 48.1486, lng: 17.1077),

    // ========== SIRBISTAN ==========
    CityData(name: 'Belgrat', country: 'Sirbistan', lat: 44.7866, lng: 20.4489),
    CityData(name: 'Novi Sad', country: 'Sirbistan', lat: 45.2671, lng: 19.8335),

    // ========== ARNAVUTLUK ==========
    CityData(name: 'Tiran', country: 'Arnavutluk', lat: 41.3275, lng: 19.8187),

    // ========== KARADAG ==========
    CityData(name: 'Podgorica', country: 'Karadag', lat: 42.4304, lng: 19.2594),

    // ========== BOSNA HERSEK ==========
    CityData(name: 'Saraybosna', country: 'Bosna Hersek', lat: 43.8563, lng: 18.4131),
    CityData(name: 'Mostar', country: 'Bosna Hersek', lat: 43.3438, lng: 17.8078),

    // ========== KUZEY MAKEDONYA ==========
    CityData(name: 'Uskup', country: 'Kuzey Makedonya', lat: 41.9981, lng: 21.4254),
    CityData(name: 'Ohrid', country: 'Kuzey Makedonya', lat: 41.1231, lng: 20.8016),

    // ========== KOSOVA ==========
    CityData(name: 'Pristine', country: 'Kosova', lat: 42.6629, lng: 21.1655),
    CityData(name: 'Prizren', country: 'Kosova', lat: 42.2139, lng: 20.7397),

    // ========== LITVANYA ==========
    CityData(name: 'Vilnius', country: 'Litvanya', lat: 54.6872, lng: 25.2797),
    CityData(name: 'Kaunas', country: 'Litvanya', lat: 54.8985, lng: 23.9036),

    // ========== LETONYA ==========
    CityData(name: 'Riga', country: 'Letonya', lat: 56.9496, lng: 24.1052),

    // ========== ESTONYA ==========
    CityData(name: 'Tallinn', country: 'Estonya', lat: 59.4370, lng: 24.7536),
    CityData(name: 'Tartu', country: 'Estonya', lat: 58.3780, lng: 26.7290),

    // ========== BELARUS ==========
    CityData(name: 'Minsk', country: 'Belarus', lat: 53.9006, lng: 27.5590),

    // ========== MOLDOVA ==========
    CityData(name: 'Kisinev', country: 'Moldova', lat: 47.0105, lng: 28.8638),

    // ========== LUKSEMBURG ==========
    CityData(name: 'Luksemburg', country: 'Luksemburg', lat: 49.6116, lng: 6.1319),

    // ========== MONACO ==========
    CityData(name: 'Monaco', country: 'Monaco', lat: 43.7384, lng: 7.4246),

    // ========== ANDORRA ==========
    CityData(name: 'Andorra la Vella', country: 'Andorra', lat: 42.5063, lng: 1.5218),

    // ========== IZLANDA ==========
    CityData(name: 'Reykjavik', country: 'Izlanda', lat: 64.1466, lng: -21.9426),
  ];

  /// Search cities by name (case-insensitive)
  static List<CityData> search(String query) {
    if (query.isEmpty) return allCities;
    final lowerQuery = query.toLowerCase();
    return allCities.where((city) {
      return city.name.toLowerCase().contains(lowerQuery) ||
          city.country.toLowerCase().contains(lowerQuery) ||
          (city.region?.toLowerCase().contains(lowerQuery) ?? false) ||
          city.displayName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get cities by country
  static List<CityData> byCountry(String country) {
    return allCities.where((city) => city.country == country).toList();
  }

  /// Get Turkish cities only
  static List<CityData> get turkishCities {
    return allCities.where((city) =>
      city.country == 'Türkiye' || city.country == 'KKTC'
    ).toList();
  }

  /// Get international cities (non-Turkish)
  static List<CityData> get internationalCities {
    return allCities.where((city) =>
      city.country != 'Türkiye' && city.country != 'KKTC'
    ).toList();
  }
}
