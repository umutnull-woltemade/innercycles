/// Micro-Habit Suggestions — 56 evidence-based habits across 7 categories
/// Apple App Store 4.3(b) compliant. No medical claims. Actionable and specific.
library;

class HabitSuggestion {
  final String id;
  final String category; // morning, evening, mindfulness, social, creative, physical, reflective
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final int durationMinutes; // estimated time commitment

  const HabitSuggestion({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.durationMinutes,
  });
}

const List<HabitSuggestion> allHabitSuggestions = [
  // ═══════════════════════════════════════════════════════════════
  // MORNING — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'mor_01',
    category: 'morning',
    titleEn: 'Three Deep Breaths',
    titleTr: 'Uc Derin Nefes',
    descriptionEn:
        'Take 3 deep breaths before checking your phone. Inhale for 4 counts, hold for 4, exhale for 6.',
    descriptionTr:
        'Telefonunuzu kontrol etmeden once 3 derin nefes alin. 4 sayarak nefes alin, 4 tutun, 6 sayarak verin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'mor_02',
    category: 'morning',
    titleEn: 'Morning Intention',
    titleTr: 'Sabah Niyeti',
    descriptionEn:
        'Before getting out of bed, set one simple intention for the day. It does not need to be big.',
    descriptionTr:
        'Yataktan kalkmadan once gun icin basit bir niyet belirleyin. Buyuk olmasi gerekmiyor.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_03',
    category: 'morning',
    titleEn: 'Hydrate First',
    titleTr: 'Once Su Ic',
    descriptionEn:
        'Drink a full glass of water within the first 15 minutes of waking up, before any other beverage.',
    descriptionTr:
        'Uyandiktan sonraki ilk 15 dakika icinde, baska bir icecekten once dolu bir bardak su icin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'mor_04',
    category: 'morning',
    titleEn: 'Sunlight Exposure',
    titleTr: 'Gunes Isigi Maruziyeti',
    descriptionEn:
        'Spend 2 minutes near a window or outdoors within the first hour. Natural light tends to support alertness.',
    descriptionTr:
        'Ilk saat icinde 2 dakika bir pencerenin yaninida veya disarida gecirin. Dogal isik dikkatlilige destek olma egilimindedir.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_05',
    category: 'morning',
    titleEn: 'Gratitude Note',
    titleTr: 'Sukran Notu',
    descriptionEn:
        'Write down one thing you are grateful for this morning. Keep it specific and personal.',
    descriptionTr:
        'Bu sabah minnettar oldugunuz bir seyi yazin. Spesifik ve kisisel tutun.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_06',
    category: 'morning',
    titleEn: 'Body Stretch',
    titleTr: 'Vucud Esnemesi',
    descriptionEn:
        'Do a 2-minute full-body stretch before starting your routine. Reach overhead, touch your toes, twist gently.',
    descriptionTr:
        'Rutininize baslamadan once 2 dakikalik tam vucut esnemesi yapin. Yukariya uzanin, ayak parmaklariniza dokunun, hafifce donun.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_07',
    category: 'morning',
    titleEn: 'Phone-Free First 10',
    titleTr: 'Telefonsuz Ilk 10 Dakika',
    descriptionEn:
        'Keep your phone in another room for the first 10 minutes after waking. Notice how the quiet start feels.',
    descriptionTr:
        'Uyandiktan sonraki ilk 10 dakika telefonunuzu baska bir odada birakn. Sessiz baslangiicin nasil hissettirdigini fark edin.',
    durationMinutes: 10,
  ),
  HabitSuggestion(
    id: 'mor_08',
    category: 'morning',
    titleEn: 'One-Sentence Journal',
    titleTr: 'Tek Cumleli Gunluk',
    descriptionEn:
        'Write a single sentence about how you feel right now. One sentence is enough to start the habit.',
    descriptionTr:
        'Su anda nasil hissettiginiz hakkinda tek bir cumle yazin. Bir cumle aliskanligi baslatmak icin yeterli.',
    durationMinutes: 1,
  ),

  // ═══════════════════════════════════════════════════════════════
  // EVENING — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'eve_01',
    category: 'evening',
    titleEn: 'Screen Sunset',
    titleTr: 'Ekran Batisi',
    descriptionEn:
        'Put screens away 30 minutes before bed. Read, stretch, or talk instead.',
    descriptionTr:
        'Yatmadan 30 dakika once ekranlari kaldirin. Bunun yerine okuyun, esnin veya sohbet edin.',
    durationMinutes: 30,
  ),
  HabitSuggestion(
    id: 'eve_02',
    category: 'evening',
    titleEn: 'Day Review',
    titleTr: 'Gun Degerlendirmesi',
    descriptionEn:
        'Spend 3 minutes reviewing your day. What went well? What would you do differently?',
    descriptionTr:
        'Gununuzu degerlendirmek icin 3 dakika ayirin. Ne iyi gitti? Neyi farkli yapardiniz?',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'eve_03',
    category: 'evening',
    titleEn: 'Tomorrow Prep',
    titleTr: 'Yarin Hazirligi',
    descriptionEn:
        'Write down 1-3 priorities for tomorrow before bed. Free your mind from carrying them overnight.',
    descriptionTr:
        'Yatmadan once yarin icin 1-3 oncelik yazin. Zihninizi gece boyunca tasimasinindan kurtarin.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'eve_04',
    category: 'evening',
    titleEn: 'Warm Wind-Down',
    titleTr: 'Sicak Rahatlama',
    descriptionEn:
        'Have a warm, caffeine-free drink 45 minutes before bed. Notice the warmth as a signal to relax.',
    descriptionTr:
        'Yatmadan 45 dakika once sicak, kafeinsiz bir icecek icin. Sicakligi rahatlama sinyali olarak fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'eve_05',
    category: 'evening',
    titleEn: 'Body Scan',
    titleTr: 'Beden Tarami',
    descriptionEn:
        'Lie down and scan your body from toes to head. Notice tension without trying to fix it.',
    descriptionTr:
        'Uzanin ve vucudunuzu ayak parmaklarindan basliniza tara. Gerginligi duzeltmeye calismadan fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'eve_06',
    category: 'evening',
    titleEn: 'Three Good Things',
    titleTr: 'Uc Iyi Sey',
    descriptionEn:
        'Before sleep, name three good things that happened today, no matter how small.',
    descriptionTr:
        'Uyumadan once, ne kadar kucuk olursa olsun bugun olan uc iyi seyi sayln.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'eve_07',
    category: 'evening',
    titleEn: 'Breathing 4-7-8',
    titleTr: 'Nefes 4-7-8',
    descriptionEn:
        'Practice the 4-7-8 breathing pattern: inhale 4 counts, hold 7, exhale 8. Repeat 3 times.',
    descriptionTr:
        '4-7-8 nefes kalibi uygualyin: 4 sayarak nefes alin, 7 tutun, 8 sayarak verin. 3 kez tekrarlayin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'eve_08',
    category: 'evening',
    titleEn: 'Dream Intention',
    titleTr: 'Ruya Niyeti',
    descriptionEn:
        'As you fall asleep, silently set an intention to remember your dreams. Keep a notebook nearby.',
    descriptionTr:
        'Uykuya dalarken, ruyalarinizi hatirlamak icin sessizce bir niyet belirleyin. Yaninizda bir defter bulundurun.',
    durationMinutes: 1,
  ),

  // ═══════════════════════════════════════════════════════════════
  // MINDFULNESS — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'min_01',
    category: 'mindfulness',
    titleEn: 'One Mindful Bite',
    titleTr: 'Bilinçli Bir Lokma',
    descriptionEn:
        'Eat the first bite of one meal today with full attention. Notice flavor, texture, and temperature.',
    descriptionTr:
        'Bugun bir ogunun ilk lokmasini tam dikkatle yiyin. Lezzeti, dokuyu ve sicakligi fark edin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'min_02',
    category: 'mindfulness',
    titleEn: 'Pause Before Reacting',
    titleTr: 'Tepki Vermeden Duraklin',
    descriptionEn:
        'When you feel a strong reaction, pause for 3 seconds before responding. Notice what shifts.',
    descriptionTr:
        'Guclu bir tepki hissettiginizde, karsilik vermeden once 3 saniye durun. Neyin degistigini fark edin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'min_03',
    category: 'mindfulness',
    titleEn: 'Five Senses Check',
    titleTr: 'Bes Duyu Kontrolu',
    descriptionEn:
        'Name 5 things you see, 4 you hear, 3 you feel, 2 you smell, 1 you taste. Grounds you in the present.',
    descriptionTr:
        'Gordugunuz 5, duydugunuz 4, hissettiginiz 3, kokladiginiz 2, tattiginiz 1 sey sayinin. Sizi ana baglar.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'min_04',
    category: 'mindfulness',
    titleEn: 'Mindful Walking',
    titleTr: 'Bilinçli Yuruyus',
    descriptionEn:
        'During a short walk, focus entirely on the sensation of your feet touching the ground.',
    descriptionTr:
        'Kisa bir yuruyus sirasinda, tamamen ayaklarinizin yere temas hissine odaklanin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'min_05',
    category: 'mindfulness',
    titleEn: 'Emotion Naming',
    titleTr: 'Duygu Adlandirma',
    descriptionEn:
        'Three times today, pause and name the exact emotion you are feeling. Naming tends to reduce its intensity.',
    descriptionTr:
        'Bugun uc kez durun ve hissettiginiz tam duyguyu adlandirin. Adlandirmak yogunlugu azaltma egilimindedir.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'min_06',
    category: 'mindfulness',
    titleEn: 'Breathing Anchor',
    titleTr: 'Nefes Capasi',
    descriptionEn:
        'Set 3 reminders today. When each one goes off, take one slow, full breath. That is all.',
    descriptionTr:
        'Bugun 3 hatirlatici kurun. Her biri caldiginda, yavas ve tam bir nefes alin. Bu kadar.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'min_07',
    category: 'mindfulness',
    titleEn: 'Listen Fully',
    titleTr: 'Tamamen Dinle',
    descriptionEn:
        'In your next conversation, listen without planning your response. Just receive.',
    descriptionTr:
        'Bir sonraki konusmanizda, cevabnizi planlamadan dinleyin. Sadece alin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'min_08',
    category: 'mindfulness',
    titleEn: 'Transition Pause',
    titleTr: 'Gecis Molasi',
    descriptionEn:
        'Between activities, take one conscious breath before starting the next thing.',
    descriptionTr:
        'Aktiviteler arasinda, bir sonraki seye baslamadan once bilinçli bir nefes alin.',
    durationMinutes: 1,
  ),

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'soc_01',
    category: 'social',
    titleEn: 'Genuine Compliment',
    titleTr: 'Icten Iltifat',
    descriptionEn:
        'Give one genuine, specific compliment to someone today. Notice how it feels for both of you.',
    descriptionTr:
        'Bugun birine gercek, spesifik bir iltifat yapin. Ikiniz icin de nasil hissettirdigini fark edin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'soc_02',
    category: 'social',
    titleEn: 'Check-In Text',
    titleTr: 'Hal Hatir Mesaji',
    descriptionEn:
        'Send a short message to someone you care about, just to say you are thinking of them. No favor, no agenda.',
    descriptionTr:
        'Onemsediginiz birine, sadece onu dusundugunuzu soyleyen kisa bir mesaj gonderin. Iyilik yok, gundem yok.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'soc_03',
    category: 'social',
    titleEn: 'Eye Contact',
    titleTr: 'Goz Temasi',
    descriptionEn:
        'During one conversation today, maintain gentle eye contact. Notice how it deepens the connection.',
    descriptionTr:
        'Bugun bir konusma sirasinda nazik goz temasi surduru. Baglantyi nasil derinlestirdigini fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'soc_04',
    category: 'social',
    titleEn: 'Express Gratitude',
    titleTr: 'Minnettarligini Ifade Et',
    descriptionEn:
        'Tell someone specifically what you appreciate about them. Be concrete: "I noticed when you..." works well.',
    descriptionTr:
        'Birine onlar hakkinda neyi takdir ettiginizi ozellikle soyleylin. Somut olun: "Farkettiginizde..." iyi calisr.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'soc_05',
    category: 'social',
    titleEn: 'Ask a Real Question',
    titleTr: 'Gercek Bir Soru Sor',
    descriptionEn:
        'In a conversation, ask one open-ended question and truly listen to the answer.',
    descriptionTr:
        'Bir konusmada, acik uclu bir soru sorun ve ceveabia gercekten dinleyin.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'soc_06',
    category: 'social',
    titleEn: 'Boundary Practice',
    titleTr: 'Sinir Pratigi',
    descriptionEn:
        'Say "no" to one small request today that you would normally agree to out of obligation.',
    descriptionTr:
        'Bugun normalde zorunluluktan kabul edeceginiz kucuk bir istege "hayir" deyin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'soc_07',
    category: 'social',
    titleEn: 'Shared Silence',
    titleTr: 'Paylasilan Sessizlik',
    descriptionEn:
        'Spend a few minutes in comfortable silence with someone you trust. Not all connection needs words.',
    descriptionTr:
        'Guvendiginiz biriyle birkaç dakika rahat sessizlikte gecirin. Her baglanti sozculklere ihtiyac duymaz.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'soc_08',
    category: 'social',
    titleEn: 'Name Your Need',
    titleTr: 'Ihtiyacini Adlandir',
    descriptionEn:
        'When feeling disconnected, tell someone what you need: "I could use a conversation" or "I need some quiet."',
    descriptionTr:
        'Kopuk hissettiginizde, birine ihtiyacinizi soyleylin: "Bir sohbete ihtiyacim var" veya "Biraz sessizlige ihtiyacim var."',
    durationMinutes: 2,
  ),

  // ═══════════════════════════════════════════════════════════════
  // CREATIVE — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'cre_01',
    category: 'creative',
    titleEn: 'Doodle Break',
    titleTr: 'Karalama Molasi',
    descriptionEn:
        'Spend 3 minutes doodling freely on paper. No goal, no judgment, just let the pen move.',
    descriptionTr:
        'Kagit uzerinde 3 dakika serbestce karalama yapin. Hedef yok, yargi yok, sadece kalemin hareket etmesine izin verin.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'cre_02',
    category: 'creative',
    titleEn: 'New Route',
    titleTr: 'Yeni Rota',
    descriptionEn:
        'Take a different path on your commute or walk today. New surroundings tend to spark new thoughts.',
    descriptionTr:
        'Bugun isine giderken veya yururken farkli bir yol kullanin. Yeni cevreler yeni dusunceleri atesleyebilir.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'cre_03',
    category: 'creative',
    titleEn: 'Write Three Ideas',
    titleTr: 'Uc Fikir Yaz',
    descriptionEn:
        'Write down 3 ideas about anything — silly, practical, impossible. The goal is quantity, not quality.',
    descriptionTr:
        'Herhangi bir konuda 3 fikir yazan — sacma, pratik, imkansiz. Amac kalite degil, miktardir.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'cre_04',
    category: 'creative',
    titleEn: 'Photograph Something Beautiful',
    titleTr: 'Guzel Bir Sey Fotografla',
    descriptionEn:
        'Take one photo today of something you find beautiful or interesting. Look closely at ordinary things.',
    descriptionTr:
        'Bugun guzel veya ilginc buldugunuz bir seyin fotografini cekin. Siradan seylere yakindan bakin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'cre_05',
    category: 'creative',
    titleEn: 'Rearrange Something',
    titleTr: 'Bir Seyi Yeniden Duzenle',
    descriptionEn:
        'Move something in your space — a book, a plant, a chair. Small changes in environment tend to shift perspective.',
    descriptionTr:
        'Mekaninizdaki bir seyi tasyin — bir kitap, bir bitki, bir sandalye. Cevredeki kucuk degisiklikler bakis acisini degistirebilir.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'cre_06',
    category: 'creative',
    titleEn: 'Listen to Something New',
    titleTr: 'Yeni Bir Sey Dinle',
    descriptionEn:
        'Listen to a genre of music you have never tried. Notice what emotions it stirs.',
    descriptionTr:
        'Hic denemedigniz bir muzik turunu dinleyin. Hangi duygulari uyandirdigini fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'cre_07',
    category: 'creative',
    titleEn: 'Cook Without a Recipe',
    titleTr: 'Tarifsiz Pisir',
    descriptionEn:
        'Prepare one meal or snack without following a recipe. Trust your instincts and improvise.',
    descriptionTr:
        'Tarif izlemeden bir ogun veya atistirmalik hazirlayin. Icguduelerinize guvenin ve dogaclama yapin.',
    durationMinutes: 15,
  ),
  HabitSuggestion(
    id: 'cre_08',
    category: 'creative',
    titleEn: 'Word Play',
    titleTr: 'Kelime Oyunu',
    descriptionEn:
        'Pick a random word and write a short poem, haiku, or sentence with it. Playfulness opens creativity.',
    descriptionTr:
        'Rastgele bir kelime secin ve onunla kisa bir siir, haiku veya cumle yazin. Oyunculuk yaraticiligi acar.',
    durationMinutes: 3,
  ),

  // ═══════════════════════════════════════════════════════════════
  // PHYSICAL — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'phy_01',
    category: 'physical',
    titleEn: 'Desk Stretch',
    titleTr: 'Masa Esnemesi',
    descriptionEn:
        'Every 90 minutes, stand up and stretch your arms overhead for 30 seconds. Your body tends to appreciate the reset.',
    descriptionTr:
        'Her 90 dakikada bir ayaga kalkin ve 30 saniye kollarinizi yukari dogru esnetin. Vucudunuz sifirlamayi takdir etme egilimindedir.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_02',
    category: 'physical',
    titleEn: 'Walking Meeting',
    titleTr: 'Yuruyus Toplantisi',
    descriptionEn:
        'Take one phone call or conversation while walking instead of sitting. Movement tends to boost thinking.',
    descriptionTr:
        'Bir telefon gorusmesini veya sohbeti otumak yerine yururken yapin. Hareket dusunmeyi destekleme egilimindedir.',
    durationMinutes: 10,
  ),
  HabitSuggestion(
    id: 'phy_03',
    category: 'physical',
    titleEn: 'Posture Check',
    titleTr: 'Durus Kontrolu',
    descriptionEn:
        'Set 3 reminders to check your posture today. Roll your shoulders back and lengthen your spine.',
    descriptionTr:
        'Bugun durusunuzu kontrol etmek icin 3 hatirlatici kurun. Omuzlarinizi arkaya kivirin ve omurganizi uzatin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_04',
    category: 'physical',
    titleEn: 'Stairs Over Elevator',
    titleTr: 'Asansor Yerine Merdiven',
    descriptionEn:
        'Choose stairs at least once today. Even one flight tends to give your circulation a boost.',
    descriptionTr:
        'Bugun en az bir kez merdivenleri secin. Tek bir kat bile kan dolisminize destek olma egilimindedir.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'phy_05',
    category: 'physical',
    titleEn: 'Gentle Neck Rolls',
    titleTr: 'Nazik Boyun Cirpinmalari',
    descriptionEn:
        'Slowly roll your neck in circles, 5 times each direction. Release the tension you did not know you were holding.',
    descriptionTr:
        'Yavaca boynnuzu daireler cizerek dondurun, her yonde 5 kez. Tuttugunuzu bilmediginiz gerginligi birakn.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_06',
    category: 'physical',
    titleEn: 'Dance for One Song',
    titleTr: 'Bir Sarki Boyunca Dans Et',
    descriptionEn:
        'Put on a favorite song and move freely for its full duration. Nobody is watching.',
    descriptionTr:
        'Sevdiginiz bir sarkiyi acin ve tam suresi boyunca serbestce hareket edin. Kimse izlemiyor.',
    durationMinutes: 4,
  ),
  HabitSuggestion(
    id: 'phy_07',
    category: 'physical',
    titleEn: 'Cold Water Splash',
    titleTr: 'Soguk Su Serpintisi',
    descriptionEn:
        'Splash cold water on your face when you feel afternoon drowsiness. A quick reset for alertness.',
    descriptionTr:
        'Oleden sonra uyuklama hissettiginizde yuzunuze soguk su serpin. Dikkatlilik icin hizli bir sifirlama.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_08',
    category: 'physical',
    titleEn: 'Evening Walk',
    titleTr: 'Aksam Yuruyusu',
    descriptionEn:
        'Take a 10-minute walk after dinner. Gentle movement after eating tends to support digestion and mood.',
    descriptionTr:
        'Aksam yemeginden sonra 10 dakikalik bir yuruyus yapin. Yemekten sonra hafif hareket sindirime ve ruh haline destek olma egilimindedir.',
    durationMinutes: 10,
  ),

  // ═══════════════════════════════════════════════════════════════
  // REFLECTIVE — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'ref_01',
    category: 'reflective',
    titleEn: 'Midday Pause',
    titleTr: 'Oglen Molasi',
    descriptionEn:
        'At noon, stop for 60 seconds and ask yourself: How am I actually feeling right now?',
    descriptionTr:
        'Ogle saatinde 60 saniye durun ve kendinize sorun: Su anda aslinda nasil hissediyorum?',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'ref_02',
    category: 'reflective',
    titleEn: 'Pattern Spotting',
    titleTr: 'Orunatu Farketme',
    descriptionEn:
        'At the end of the day, look at your journal and notice one recurring theme. Name it.',
    descriptionTr:
        'Gunun sonunda gunlugunuze bakin ve tekrarlayan bir temayi fark edin. Onu adlandirin.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'ref_03',
    category: 'reflective',
    titleEn: 'What If Question',
    titleTr: 'Ya Olsaydi Sorusu',
    descriptionEn:
        'Ask yourself one "what if" question today. "What if I said yes?" or "What if I let go?"',
    descriptionTr:
        'Bugun kendinize bir "ya olsaydi" sorusu sorun. "Ya evet deseyidim?" veya "Ya birakaydim?"',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'ref_04',
    category: 'reflective',
    titleEn: 'Letter to Future Self',
    titleTr: 'Gelecek Kendine Mektup',
    descriptionEn:
        'Write 2-3 sentences to your future self, one month from now. What do you hope they feel?',
    descriptionTr:
        'Bir ay sonraki kendinize 2-3 cumle yazin. Ne hissetmelerini umuyorsunuz?',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'ref_05',
    category: 'reflective',
    titleEn: 'Energy Audit',
    titleTr: 'Enerji Denetimi',
    descriptionEn:
        'Rate your energy 1-5 at three points today: morning, afternoon, evening. Notice the shape of your day.',
    descriptionTr:
        'Bugun uc noktada enerjinizi 1-5 arasinda puanlayin: sabah, ogle, aksam. Gununuzun seklini fark edin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'ref_06',
    category: 'reflective',
    titleEn: 'Highlight Reel',
    titleTr: 'Onemli Anlar',
    descriptionEn:
        'Before bed, identify the single best moment of the day. Relive it for 30 seconds.',
    descriptionTr:
        'Yatmadan once gunun en iyi tekk anini belirleyin. 30 saniye boyunca yeniden yasin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'ref_07',
    category: 'reflective',
    titleEn: 'Emotion Color',
    titleTr: 'Duygu Rengi',
    descriptionEn:
        'Choose a color that represents how you feel right now. Write one sentence about why.',
    descriptionTr:
        'Su anda nasil hissettiginizi temsil eden bir renk secin. Nedenini tek cumle olarak yazin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'ref_08',
    category: 'reflective',
    titleEn: 'Week Theme',
    titleTr: 'Hafta Temasi',
    descriptionEn:
        'On Sunday or Monday, choose a single-word theme for the week. Let it guide you without forcing.',
    descriptionTr:
        'Pazar veya Pazartesi, hafta icin tek kelimelik bir tema secin. Zorlamadan rehberlik etmesine izin verin.',
    durationMinutes: 2,
  ),
];
