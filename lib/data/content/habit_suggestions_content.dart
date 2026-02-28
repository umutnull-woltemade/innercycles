/// Micro-Habit Suggestions — 56 evidence-based habits across 7 categories
/// Apple App Store 4.3(b) compliant. No medical claims. Actionable and specific.
library;

import '../providers/app_providers.dart';

class HabitSuggestion {
  final String id;
  final String
  category; // morning, evening, mindfulness, social, creative, physical, reflective
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

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;

  String localizedDescription(AppLanguage language) =>
      language == AppLanguage.en ? descriptionEn : descriptionTr;
}

const List<HabitSuggestion> allHabitSuggestions = [
  // ═══════════════════════════════════════════════════════════════
  // MORNING — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'mor_01',
    category: 'morning',
    titleEn: 'Three Deep Breaths',
    titleTr: 'Üç Derin Nefes',
    descriptionEn:
        'Take 3 deep breaths before checking your phone. Inhale for 4 counts, hold for 4, exhale for 6.',
    descriptionTr:
        'Telefonunuzu kontrol etmeden önce 3 derin nefes alın. 4 sayarak nefes alın, 4 tutun, 6 sayarak verin.',
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
        'Yataktan kalkmadan önce gün için basit bir niyet belirleyin. Büyük olması gerekmiyor.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_03',
    category: 'morning',
    titleEn: 'Hydrate First',
    titleTr: 'Önce Su İç',
    descriptionEn:
        'Drink a full glass of water within the first 15 minutes of waking up, before any other beverage.',
    descriptionTr:
        'Uyandıktan sonraki ilk 15 dakika içinde, başka bir içecekten önce dolu bir bardak su için.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'mor_04',
    category: 'morning',
    titleEn: 'Sunlight Exposure',
    titleTr: 'Güneş Işığı Maruziyeti',
    descriptionEn:
        'Spend 2 minutes near a window or outdoors within the first hour. Natural light tends to support alertness.',
    descriptionTr:
        'İlk saat içinde 2 dakika bir pencerenin yanında veya dışarıda geçirin. Doğal ışık dikkatliliğe destek olma eğilimindedir.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_05',
    category: 'morning',
    titleEn: 'Gratitude Note',
    titleTr: 'Şükran Notu',
    descriptionEn:
        'Write down one thing you are grateful for this morning. Keep it specific and personal.',
    descriptionTr:
        'Bu sabah minnettar olduğunuz bir şeyi yazın. Spesifik ve kişisel tutun.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_06',
    category: 'morning',
    titleEn: 'Body Stretch',
    titleTr: 'Vücut Esnemesi',
    descriptionEn:
        'Do a 2-minute full-body stretch before starting your routine. Reach overhead, touch your toes, twist gently.',
    descriptionTr:
        'Rutininize başlamadan önce 2 dakikalık tam vücut esnemesi yapın. Yukarıya uzanın, ayak parmaklarınıza dokunun, hafifçe dönün.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'mor_07',
    category: 'morning',
    titleEn: 'Phone-Free First 10',
    titleTr: 'Telefonsuz İlk 10 Dakika',
    descriptionEn:
        'Keep your phone in another room for the first 10 minutes after waking. Notice how the quiet start feels.',
    descriptionTr:
        'Uyandıktan sonraki ilk 10 dakika telefonunuzu başka bir odada bırakın. Sessiz başlangıcın nasıl hissettirdiğini fark edin.',
    durationMinutes: 10,
  ),
  HabitSuggestion(
    id: 'mor_08',
    category: 'morning',
    titleEn: 'One-Sentence Journal',
    titleTr: 'Tek Cümleli Günlük',
    descriptionEn:
        'Write a single sentence about how you feel right now. One sentence is enough to start the habit.',
    descriptionTr:
        'Şu anda nasıl hissettiğiniz hakkında tek bir cümle yazın. Bir cümle alışkanlığı başlatmak için yeterli.',
    durationMinutes: 1,
  ),

  // ═══════════════════════════════════════════════════════════════
  // EVENING — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'eve_01',
    category: 'evening',
    titleEn: 'Screen Sunset',
    titleTr: 'Ekran Batışı',
    descriptionEn:
        'Put screens away 30 minutes before bed. Read, stretch, or talk instead.',
    descriptionTr:
        'Yatmadan 30 dakika önce ekranları kaldırın. Bunun yerine okuyun, esnin veya sohbet edin.',
    durationMinutes: 30,
  ),
  HabitSuggestion(
    id: 'eve_02',
    category: 'evening',
    titleEn: 'Day Review',
    titleTr: 'Gün Değerlendirmesi',
    descriptionEn:
        'Spend 3 minutes reviewing your day. What went well? What would you do differently?',
    descriptionTr:
        'Gününüzü değerlendirmek için 3 dakika ayırın. Ne iyi gitti? Neyi farklı yapardınız?',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'eve_03',
    category: 'evening',
    titleEn: 'Tomorrow Prep',
    titleTr: 'Yarın Hazırlığı',
    descriptionEn:
        'Write down 1-3 priorities for tomorrow before bed. Free your mind from carrying them overnight.',
    descriptionTr:
        'Yatmadan önce yarın için 1-3 öncelik yazın. Zihninizi gece boyunca taşımasından kurtarın.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'eve_04',
    category: 'evening',
    titleEn: 'Warm Wind-Down',
    titleTr: 'Sıcak Rahatlama',
    descriptionEn:
        'Have a warm, caffeine-free drink 45 minutes before bed. Notice the warmth as a signal to relax.',
    descriptionTr:
        'Yatmadan 45 dakika önce sıcak, kafeinsiz bir içecek için. Sıcaklığı rahatlama sinyali olarak fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'eve_05',
    category: 'evening',
    titleEn: 'Body Scan',
    titleTr: 'Beden Taraması',
    descriptionEn:
        'Lie down and scan your body from toes to head. Notice tension without trying to fix it.',
    descriptionTr:
        'Uzanın ve vücudunuzu ayak parmaklarından başınıza tarayın. Gerginliği düzeltmeye çalışmadan fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'eve_06',
    category: 'evening',
    titleEn: 'Three Good Things',
    titleTr: 'Üç İyi Şey',
    descriptionEn:
        'Before sleep, name three good things that happened today, no matter how small.',
    descriptionTr:
        'Uyumadan önce, ne kadar küçük olursa olsun bugün olan üç iyi şeyi sayın.',
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
        '4-7-8 nefes kalıbı uygulayın: 4 sayarak nefes alın, 7 tutun, 8 sayarak verin. 3 kez tekrarlayın.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'eve_08',
    category: 'evening',
    titleEn: 'Dream Intention',
    titleTr: 'Rüya Niyeti',
    descriptionEn:
        'As you fall asleep, silently set an intention to remember your dreams. Keep a notebook nearby.',
    descriptionTr:
        'Uykuya dalarken, rüyalarınızı hatırlamak için sessizce bir niyet belirleyin. Yanınızda bir defter bulundurun.',
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
        'Bugün bir öğünün ilk lokmasını tam dikkatle yiyin. Lezzeti, dokuyu ve sıcaklığı fark edin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'min_02',
    category: 'mindfulness',
    titleEn: 'Pause Before Reacting',
    titleTr: 'Tepki Vermeden Durakla',
    descriptionEn:
        'When you feel a strong reaction, pause for 3 seconds before responding. Notice what shifts.',
    descriptionTr:
        'Güçlü bir tepki hissettiğinizde, karşılık vermeden önce 3 saniye durun. Neyin değiştiğini fark edin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'min_03',
    category: 'mindfulness',
    titleEn: 'Five Senses Check',
    titleTr: 'Beş Duyu Kontrolü',
    descriptionEn:
        'Name 5 things you see, 4 you hear, 3 you feel, 2 you smell, 1 you taste. Grounds you in the present.',
    descriptionTr:
        'Gördüğünüz 5, duyduğunuz 4, hissettiğiniz 3, kokladığınız 2, tattığınız 1 şey sayın. Sizi ana bağlar.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'min_04',
    category: 'mindfulness',
    titleEn: 'Mindful Walking',
    titleTr: 'Bilinçli Yürüyüş',
    descriptionEn:
        'During a short walk, focus entirely on the sensation of your feet touching the ground.',
    descriptionTr:
        'Kısa bir yürüyüş sırasında, tamamen ayaklarınızın yere temas hissine odaklanın.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'min_05',
    category: 'mindfulness',
    titleEn: 'Emotion Naming',
    titleTr: 'Duygu Adlandırma',
    descriptionEn:
        'Three times today, pause and name the exact emotion you are feeling. Naming tends to reduce its intensity.',
    descriptionTr:
        'Bugün üç kez durun ve hissettiğiniz tam duyguyu adlandırın. Adlandırmak yoğunluğu azaltma eğilimindedir.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'min_06',
    category: 'mindfulness',
    titleEn: 'Breathing Anchor',
    titleTr: 'Nefes Çapası',
    descriptionEn:
        'Set 3 reminders today. When each one goes off, take one slow, full breath. That is all.',
    descriptionTr:
        'Bugün 3 hatırlatıcı kurun. Her biri çaldığında, yavaş ve tam bir nefes alın. Bu kadar.',
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
        'Bir sonraki konuşmanızda, cevabınızı planlamadan dinleyin. Sadece alın.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'min_08',
    category: 'mindfulness',
    titleEn: 'Transition Pause',
    titleTr: 'Geçiş Molası',
    descriptionEn:
        'Between activities, take one conscious breath before starting the next thing.',
    descriptionTr:
        'Aktiviteler arasında, bir sonraki şeye başlamadan önce bilinçli bir nefes alın.',
    durationMinutes: 1,
  ),

  // ═══════════════════════════════════════════════════════════════
  // SOCIAL — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'soc_01',
    category: 'social',
    titleEn: 'Genuine Compliment',
    titleTr: 'İçten İltifat',
    descriptionEn:
        'Give one genuine, specific compliment to someone today. Notice how it feels for both of you.',
    descriptionTr:
        'Bugün birine gerçek, spesifik bir iltifat yapın. İkiniz için de nasıl hissettirdiğini fark edin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'soc_02',
    category: 'social',
    titleEn: 'Check-In Text',
    titleTr: 'Hal Hatır Mesajı',
    descriptionEn:
        'Send a short message to someone you care about, just to say you are thinking of them. No favor, no agenda.',
    descriptionTr:
        'Önemsediğiniz birine, sadece onu düşündüğünüzü söyleyen kısa bir mesaj gönderin. İyilik yok, gündem yok.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'soc_03',
    category: 'social',
    titleEn: 'Eye Contact',
    titleTr: 'Göz Teması',
    descriptionEn:
        'During one conversation today, maintain gentle eye contact. Notice how it deepens the connection.',
    descriptionTr:
        'Bugün bir konuşma sırasında nazik göz teması sürdürün. Bağlantıyı nasıl derinleştirdiğini fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'soc_04',
    category: 'social',
    titleEn: 'Express Gratitude',
    titleTr: 'Minnettarlığını İfade Et',
    descriptionEn:
        'Tell someone specifically what you appreciate about them. Be concrete: "I noticed when you..." works well.',
    descriptionTr:
        'Birine onlar hakkında neyi takdir ettiğinizi özellikle söyleyin. Somut olun: "Fark ettiğimde..." iyi çalışır.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'soc_05',
    category: 'social',
    titleEn: 'Ask a Real Question',
    titleTr: 'Gerçek Bir Soru Sor',
    descriptionEn:
        'In a conversation, ask one open-ended question and truly listen to the answer.',
    descriptionTr:
        'Bir konuşmada, açık uçlu bir soru sorun ve cevabı gerçekten dinleyin.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'soc_06',
    category: 'social',
    titleEn: 'Boundary Practice',
    titleTr: 'Sınır Pratiği',
    descriptionEn:
        'Say "no" to one small request today that you would normally agree to out of obligation.',
    descriptionTr:
        'Bugün normalde zorunluluktan kabul edeceğiniz küçük bir isteğe "hayır" deyin.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'soc_07',
    category: 'social',
    titleEn: 'Shared Silence',
    titleTr: 'Paylaşılan Sessizlik',
    descriptionEn:
        'Spend a few minutes in comfortable silence with someone you trust. Not all connection needs words.',
    descriptionTr:
        'Güvendiğiniz biriyle birkaç dakika rahat sessizlikte geçirin. Her bağlantı sözcüklere ihtiyaç duymaz.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'soc_08',
    category: 'social',
    titleEn: 'Name Your Need',
    titleTr: 'İhtiyacını Adlandır',
    descriptionEn:
        'When feeling disconnected, tell someone what you need: "I could use a conversation" or "I need some quiet."',
    descriptionTr:
        'Kopuk hissettiğinizde, birine ihtiyacınızı söyleyin: "Bir sohbete ihtiyacım var" veya "Biraz sessizliğe ihtiyacım var."',
    durationMinutes: 2,
  ),

  // ═══════════════════════════════════════════════════════════════
  // CREATIVE — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'cre_01',
    category: 'creative',
    titleEn: 'Doodle Break',
    titleTr: 'Karalama Molası',
    descriptionEn:
        'Spend 3 minutes doodling freely on paper. No goal, no judgment, just let the pen move.',
    descriptionTr:
        'Kağıt üzerinde 3 dakika serbestçe karalama yapın. Hedef yok, yargı yok, sadece kalemin hareket etmesine izin verin.',
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
        'Bugün işe giderken veya yürürken farklı bir yol kullanın. Yeni çevreler yeni düşünceleri ateşleyebilir.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'cre_03',
    category: 'creative',
    titleEn: 'Write Three Ideas',
    titleTr: 'Üç Fikir Yaz',
    descriptionEn:
        'Write down 3 ideas about anything — silly, practical, impossible. The goal is quantity, not quality.',
    descriptionTr:
        'Herhangi bir konuda 3 fikir yazın — saçma, pratik, imkansız. Amaç kalite değil, miktardır.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'cre_04',
    category: 'creative',
    titleEn: 'Photograph Something Beautiful',
    titleTr: 'Güzel Bir Şey Fotoğrafla',
    descriptionEn:
        'Take one photo today of something you find beautiful or interesting. Look closely at ordinary things.',
    descriptionTr:
        'Bugün güzel veya ilginç bulduğunuz bir şeyin fotoğrafını çekin. Sıradan şeylere yakından bakın.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'cre_05',
    category: 'creative',
    titleEn: 'Rearrange Something',
    titleTr: 'Bir Şeyi Yeniden Düzenle',
    descriptionEn:
        'Move something in your space — a book, a plant, a chair. Small changes in environment tend to shift perspective.',
    descriptionTr:
        'Mekanınızdaki bir şeyi taşıyın — bir kitap, bir bitki, bir sandalye. Çevredeki küçük değişiklikler bakış açısını değiştirebilir.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'cre_06',
    category: 'creative',
    titleEn: 'Listen to Something New',
    titleTr: 'Yeni Bir Şey Dinle',
    descriptionEn:
        'Listen to a genre of music you have never tried. Notice what emotions it stirs.',
    descriptionTr:
        'Hiç denemediğiniz bir müzik türünü dinleyin. Hangi duyguları uyandırdığını fark edin.',
    durationMinutes: 5,
  ),
  HabitSuggestion(
    id: 'cre_07',
    category: 'creative',
    titleEn: 'Cook Without a Recipe',
    titleTr: 'Tarifsiz Pişir',
    descriptionEn:
        'Prepare one meal or snack without following a recipe. Trust your instincts and improvise.',
    descriptionTr:
        'Tarif izlemeden bir öğün veya atıştırmalık hazırlayın. İçgüdülerinize güvenin ve doğaçlama yapın.',
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
        'Rastgele bir kelime seçin ve onunla kısa bir şiir, haiku veya cümle yazın. Oyunculuk yaratıcılığı açar.',
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
        'Her 90 dakikada bir ayağa kalkın ve 30 saniye kollarınızı yukarı doğru esnetin. Vücudunuz sıfırlamayı takdir etme eğilimindedir.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_02',
    category: 'physical',
    titleEn: 'Walking Meeting',
    titleTr: 'Yürüyüş Toplantısı',
    descriptionEn:
        'Take one phone call or conversation while walking instead of sitting. Movement tends to boost thinking.',
    descriptionTr:
        'Bir telefon görüşmesini veya sohbeti oturmak yerine yürürken yapın. Hareket düşünmeyi destekleme eğilimindedir.',
    durationMinutes: 10,
  ),
  HabitSuggestion(
    id: 'phy_03',
    category: 'physical',
    titleEn: 'Posture Check',
    titleTr: 'Duruş Kontrolü',
    descriptionEn:
        'Set 3 reminders to check your posture today. Roll your shoulders back and lengthen your spine.',
    descriptionTr:
        'Bugün duruşunuzu kontrol etmek için 3 hatırlatıcı kurun. Omuzlarınızı arkaya kıvırın ve omurganızı uzatın.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_04',
    category: 'physical',
    titleEn: 'Stairs Over Elevator',
    titleTr: 'Asansör Yerine Merdiven',
    descriptionEn:
        'Choose stairs at least once today. Even one flight tends to give your circulation a boost.',
    descriptionTr:
        'Bugün en az bir kez merdivenleri seçin. Tek bir kat bile kan dolaşımınıza destek olma eğilimindedir.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'phy_05',
    category: 'physical',
    titleEn: 'Gentle Neck Rolls',
    titleTr: 'Nazik Boyun Çırpınmaları',
    descriptionEn:
        'Slowly roll your neck in circles, 5 times each direction. Release the tension you did not know you were holding.',
    descriptionTr:
        'Yavaşça boynunuzu daireler çizerek döndürün, her yönde 5 kez. Tuttuğunuzu bilmediğiniz gerginliği bırakın.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_06',
    category: 'physical',
    titleEn: 'Dance for One Song',
    titleTr: 'Bir Şarkı Boyunca Dans Et',
    descriptionEn:
        'Put on a favorite song and move freely for its full duration. Nobody is watching.',
    descriptionTr:
        'Sevdiğiniz bir şarkıyı açın ve tam süresi boyunca serbestçe hareket edin. Kimse izlemiyor.',
    durationMinutes: 4,
  ),
  HabitSuggestion(
    id: 'phy_07',
    category: 'physical',
    titleEn: 'Cold Water Splash',
    titleTr: 'Soğuk Su Serpintisi',
    descriptionEn:
        'Splash cold water on your face when you feel afternoon drowsiness. A quick reset for alertness.',
    descriptionTr:
        'Öğleden sonra uyuklama hissettiğinizde yüzünüze soğuk su serpin. Dikkatlilik için hızlı bir sıfırlama.',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'phy_08',
    category: 'physical',
    titleEn: 'Evening Walk',
    titleTr: 'Akşam Yürüyüşü',
    descriptionEn:
        'Take a 10-minute walk after dinner. Gentle movement after eating tends to support digestion and mood.',
    descriptionTr:
        'Akşam yemeğinden sonra 10 dakikalık bir yürüyüş yapın. Yemekten sonra hafif hareket sindirime ve ruh haline destek olma eğilimindedir.',
    durationMinutes: 10,
  ),

  // ═══════════════════════════════════════════════════════════════
  // REFLECTIVE — 8 habits
  // ═══════════════════════════════════════════════════════════════
  HabitSuggestion(
    id: 'ref_01',
    category: 'reflective',
    titleEn: 'Midday Pause',
    titleTr: 'Öğlen Molası',
    descriptionEn:
        'At noon, stop for 60 seconds and ask yourself: How am I actually feeling right now?',
    descriptionTr:
        'Öğle saatinde 60 saniye durun ve kendinize sorun: Şu anda aslında nasıl hissediyorum?',
    durationMinutes: 1,
  ),
  HabitSuggestion(
    id: 'ref_02',
    category: 'reflective',
    titleEn: 'Pattern Spotting',
    titleTr: 'Örüntü Fark Etme',
    descriptionEn:
        'At the end of the day, look at your journal and notice one recurring theme. Name it.',
    descriptionTr:
        'Günün sonunda günlüğünüze bakın ve tekrarlayan bir temayı fark edin. Onu adlandırın.',
    durationMinutes: 3,
  ),
  HabitSuggestion(
    id: 'ref_03',
    category: 'reflective',
    titleEn: 'What If Question',
    titleTr: 'Ya Olsaydı Sorusu',
    descriptionEn:
        'Ask yourself one "what if" question today. "What if I said yes?" or "What if I let go?"',
    descriptionTr:
        'Bugün kendinize bir "ya olsaydı" sorusu sorun. "Ya evet deseydim?" veya "Ya bıraksaydım?"',
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
        'Bir ay sonraki kendinize 2-3 cümle yazın. Ne hissetmelerini umuyorsunuz?',
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
        'Bugün üç noktada enerjinizi 1-5 arasında puanlayın: sabah, öğle, akşam. Gününüzün şeklini fark edin.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'ref_06',
    category: 'reflective',
    titleEn: 'Highlight Reel',
    titleTr: 'Önemli Anlar',
    descriptionEn:
        'Before bed, identify the single best moment of the day. Relive it for 30 seconds.',
    descriptionTr:
        'Yatmadan önce günün en iyi tek anını belirleyin. 30 saniye boyunca yeniden yaşayın.',
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
        'Şu anda nasıl hissettiğinizi temsil eden bir renk seçin. Nedenini tek cümle olarak yazın.',
    durationMinutes: 2,
  ),
  HabitSuggestion(
    id: 'ref_08',
    category: 'reflective',
    titleEn: 'Week Theme',
    titleTr: 'Hafta Teması',
    descriptionEn:
        'On Sunday or Monday, choose a single-word theme for the week. Let it guide you without forcing.',
    descriptionTr:
        'Pazar veya Pazartesi, hafta için tek kelimelik bir tema seçin. Zorlamadan rehberlik etmesine izin verin.',
    durationMinutes: 2,
  ),
];
