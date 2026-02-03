import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';

/// Bilingual content for ExtendedHoroscopeService (TR + EN)
class ExtendedHoroscopeContent {
  // ============ WEEKLY CONTENT ============

  static List<String> getWeeklyOverviews(ZodiacSign sign, AppLanguage language) {
    final isEn = language == AppLanguage.en;
    final signName = isEn ? sign.name : sign.nameTr;
    final elementName = isEn ? sign.element.name : sign.element.nameTr;

    return isEn
        ? [
            'This week cosmic energies are intensifying for $signName. As planets align in your favor, doors to great opportunities are opening. Listen to your inner voice and follow your intuition.',
            'The universe is sending you powerful messages this week. $signName energy is at its peak and it\'s time to show your potential. Take bold steps, leave your fears behind.',
            'Throughout the week the $elementName element is strengthening. Use this energy to your advantage. While deep transformations occur in your inner world, concrete changes will also be seen in the outer world.',
            'The stars paint a bright picture for $signName this week. New connections, unexpected opportunities and spiritual openings await you. Stay open and trust the flow.',
            'The planetary dance in the sky carries special messages for $signName. This week you may experience destiny moments and make life-changing decisions. Your intuition is sharper than ever.',
            'For $signName this week the energy flow is positive. Obstacles are being removed, paths are opening. The news or development you\'ve been waiting for may come this week.',
            'Cosmic winds are filling $signName\'s sails. If you know which direction you want to go, the universe is ready to support you. Keep your intentions clear.',
            'This week universal energy embraces $signName. Creativity, inspiration and motivation are at their peak. Ideal timing to start projects you\'ve been postponing.',
          ]
        : [
            'Bu hafta $signName burcu için kozmik enerjiler yoğunlaşıyor. Gezegenler sizin lehinize hizalanırken, büyük fırsatların kapıları aralanıyor. İç sesinize kulak verin ve sezgilerinizi takip edin.',
            'Evren bu hafta size güçlü mesajlar gönderiyor. $signName enerjisi dorukta ve potansiyelinizi ortaya koyma zamanı. Cesur adımlar atın, korkularınızı geride bırakın.',
            'Hafta boyunca $elementName elementi güçleniyor. Bu enerjiyi kendi avantajınıza kullanın. İç dünyanızda derin dönüşümler yaşanırken, dış dünyada da somut değişiklikler görülecek.',
            'Yıldızlar bu hafta $signName burcu için parlak bir tablo çiziyor. Yeni bağlantılar, beklenmedik fırsatlar ve ruhsal açılımlar sizi bekliyor. Açık kalın ve akışa güvenin.',
            'Gökyüzündeki gezegen dansı $signName burcuna özel mesajlar taşıyor. Bu hafta kader anları yaşayabilir, hayatınızı değiştirecek kararlar alabilirsiniz. Sezgileriniz her zamankinden keskin.',
            '$signName burcu için bu hafta enerji akışı olumlu yönde. Engeller kalkıyor, yollar açılıyor. Uzun süredir beklediğiniz haber veya gelişme bu hafta gelebilir.',
            'Kozmik rüzgarlar $signName burcunun yelkenlerini şişiriyor. Hangi yöne gitmek istediğinizi biliyorsanız, evren sizi desteklemeye hazır. Niyetlerinizi net tutun.',
            'Bu hafta evrensel enerji $signName burcunu kucaklıyor. Yaratıcılık, ilham ve motivasyon dorukta. Ertelediğiniz projelere başlamak için ideal bir zamanlama.',
          ];
  }

  static List<String> getWeeklyLoveContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'A lively period is starting in your love life this week. Under Venus\' influence, you can establish deeper connections in your relationships. Surprise encounters are likely for singles.',
            'Your heart chakra is being activated this week. You may be emotionally sensitive but this also allows you to feel love more deeply. Create special moments with your partner.',
            'Romantic energies are rising. A new chapter may open in your relationship or an important meeting may happen for singles. Keep your heart open.',
            'This week love can come from unexpected places. Trust your intuition and follow the signs the universe offers you. Fateful connections are possible.',
            'Venus\' favorable aspects are illuminating your love life. While passion reignites for couples, singles are radiating magnetic charm. Flirtation energy is strong.',
            'Communication in relationships is critically important this week. Express your feelings openly, listen to the other side. Misunderstandings are being resolved, bonds are strengthening.',
            'Get ready for romantic surprises. The universe may bring you good news about love. Someone from the past may re-enter your life or someone new may appear.',
            'A week to be brave in love. Don\'t suppress your feelings, take risks. Don\'t be afraid of reciprocation - the universe rewards courage.',
          ]
        : [
            'Aşk hayatınızda bu hafta hareketli bir dönem başlıyor. Venüs etkisi altında, ilişkilerinizde daha derin bağlar kurabilirsiniz. Bekarlar için sürpriz karşılaşmalar olası.',
            'Kalp çakranız bu hafta aktive oluyor. Duygusal açıdan hassas olabilirsiniz ama bu, sevgiyi daha derin hissetmenize de olanak tanıyor. Partnerinizle özel anlar yaratın.',
            'Romantik enerjiler yükseliyor. İlişkinizde yeni bir sayfa açılabilir veya bekarlar için önemli bir tanışma gerçekleşebilir. Kalbinizi açık tutun.',
            'Bu hafta aşk, beklenmedik yerlerden gelebilir. Sezgilerinize güvenin ve evrenin size sunduğu işaretleri takip edin. Kadersel bağlantılar mümkün.',
            'Venüs\'ün olumlu açıları aşk hayatınızı ışıklandırıyor. Çiftler için tutku yeniden alevlenirken, bekarlar manyetik çekicilik yayıyor. Flört enerjisi güçlü.',
            'İlişkilerde iletişim bu hafta kritik öneme sahip. Duygularınızı açıkça ifade edin, karşı tarafı dinleyin. Yanlış anlamalar çözülüyor, bağlar güçleniyor.',
            'Romantik sürprizlere hazır olun. Evren aşk konusunda size güzel haberler getirebilir. Geçmişten biri yeniden hayatınıza girebilir veya yeni biri çıkabilir.',
            'Aşkta cesur olma haftası. Duygularınızı bastırmayın, risk alın. Karşılık görmekten korkmayın - evren cesareti ödüllendirir.',
          ];
  }

  static List<String> getWeeklyCareerContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Important developments may occur in your career this week. Your leadership abilities are coming to the fore. Share your ideas boldly.',
            'New doors are opening in your professional life. Think strategically this week and review your long-term plans. Changes are in your favor.',
            'Your creativity at work is at its peak. Your innovative ideas will attract attention. Teamwork and collaborations can bring fruitful results.',
            'Positive news may come in financial matters. Trust your intuition in your financial decisions this week but don\'t neglect logic either.',
            'Time to climb the career ladder. You may catch the attention of your superiors, news of promotion or raise may come. Make yourself visible.',
            'A favorable week for job interviews and negotiations. Express your wishes clearly, ask for what you deserve. The universe supports you.',
            'New job opportunities may knock on your door. Update your LinkedIn profile, expand your network. Offers may come from unexpected places.',
            'Your projects are gaining momentum this week. Obstacles are being removed, processes are accelerating. Delayed approvals, expected decisions may come this week.',
          ]
        : [
            'Kariyer alanında bu hafta önemli gelişmeler yaşanabilir. Liderlik yetenekleriniz ön plana çıkıyor. Fikirlerinizi cesurca paylaşın.',
            'Profesyonel yaşamınızda yeni kapılar açılıyor. Bu hafta stratejik düşünün ve uzun vadeli planlarınızı gözden geçirin. Değişimler lehinize.',
            'İş yerinde yaratıcılığınız dorukta. Yenilikçi fikirleriniz dikkat çekecek. Ekip çalışması ve işbirlikleri bereketli sonuçlar getirebilir.',
            'Maddi konularda olumlu haberler gelebilir. Bu hafta finansal kararlarınızda sezgilerinize güvenin ama mantığı da ihmal etmeyin.',
            'Kariyer basamaklarında yükseliş zamanı. Üstlerinizin dikkatini çekebilir, terfi veya zam haberi gelebilir. Kendinizi görünür kılın.',
            'İş görüşmeleri ve müzakereler için elverişli bir hafta. İsteklerinizi net ifade edin, hak ettiğinizi isteyin. Evren sizi destekliyor.',
            'Yeni iş fırsatları kapınızı çalabilir. LinkedIn profilinizi güncelleyin, ağınızı genişletin. Beklenmedik yerlerden teklifler gelebilir.',
            'Projeleriniz bu hafta hız kazanıyor. Engeller kalkıyor, süreçler hızlanıyor. Ertelenen onaylar, beklenen kararlar bu hafta gelebilir.',
          ];
  }

  static List<String> getWeeklyHealthContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Your energy level is high this week. Make time for physical activities. Pay attention to the signals your body sends you.',
            'Focus on your mental and emotional health. Try meditation or yoga for stress management. Spending time in nature will do you good.',
            'Review your diet this week. Give your body the nutrients it needs. Pay attention to your sleep patterns.',
            'Take breaks to maintain your energy balance. Show yourself compassion and avoid excessive fatigue. Healing energies are strong.',
          ]
        : [
            'Enerji seviyeniz bu hafta yüksek. Fiziksel aktivitelere zaman ayırın. Bedeninizin size gönderdiği sinyallere dikkat edin.',
            'Zihinsel ve duygusal sağlığınıza odaklanın. Stres yönetimi için meditasyon veya yoga deneyin. Doğada vakit geçirmek size iyi gelecek.',
            'Bu hafta beslenme düzeninizi gözden geçirin. Vücudunuzun ihtiyaç duyduğu besinleri verin. Uyku düzeninize dikkat edin.',
            'Enerji dengenizi korumak için molalar verin. Kendinize şefkat gösterin ve aşırı yorgunluktan kaçının. Şifa enerjileri güçlü.',
          ];
  }

  static List<String> getWeeklyFinancialContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Be careful in financial matters this week. Think twice before big expenses. It\'s the perfect time to make savings plans.',
            'Financial abundance energy is strengthening. Unexpected gains or opportunities may come. But keep your feet on the ground.',
            'Research investments but don\'t rush. This week is ideal for developing your financial awareness.',
            'Develop a new perspective on money. Activate abundance consciousness and let go of scarcity fears.',
          ]
        : [
            'Finansal konularda bu hafta dikkatli olun. Büyük harcamalardan önce iki kez düşünün. Tasarruf planları yapmanın tam zamanı.',
            'Maddi bolluk enerjisi güçleniyor. Beklenmedik kazançlar veya fırsatlar gelebilir. Ama ayaklarınızı yere basın.',
            'Yatırımlar için araştırma yapın ama aceleci davranmayın. Bu hafta finansal bilincinizi geliştirmek için ideal.',
            'Para konularında yeni bir bakış açısı geliştirin. Bolluk bilincini aktive edin ve kıtlık korkularını bırakın.',
          ];
  }

  static List<String> getWeeklyAffirmations(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'I am open to the universe\'s abundance and everything is fine.',
            'Every day I am getting better in every way.',
            'I recognize the power within me and I use it.',
            'I attract love and I give love.',
            'I let go of my fears and move forward with confidence.',
            'I am on the right path in my spiritual journey.',
          ]
        : [
            'Evrenin bolluğuna açığım ve her şey yolunda.',
            'Her gün her anlamda daha iyiye gidiyorum.',
            'İçimdeki gücü fark ediyorum ve onu kullanıyorum.',
            'Sevgiyi çekiyorum ve sevgi veriyorum.',
            'Korkularımı bırakıyor, güvenle ilerliyorum.',
            'Ruhsal yolculuğumda doğru yöndeyim.',
          ];
  }

  static List<String> getDays(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        : ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
  }

  static List<String> getKeyDateEvents(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'romantic opportunities',
            'career breakthroughs',
            'financial decisions',
            'health focus',
            'social events',
            'inner peace',
          ]
        : [
            'romantik fırsatlar',
            'kariyer atılımları',
            'finansal kararlar',
            'sağlık odağı',
            'sosyal etkinlikler',
            'iç huzur',
          ];
  }

  // ============ MONTHLY CONTENT ============

  static List<String> getMonthlyOverviews(ZodiacSign sign, AppLanguage language) {
    final isEn = language == AppLanguage.en;
    final signName = isEn ? sign.name : sign.nameTr;
    final elementName = isEn ? sign.element.name : sign.element.nameTr;

    return isEn
        ? [
            'This month is a time of transformation and renewal for $signName. Planets are forming strong aspects, preparing the ground for fundamental changes in your life. The transformation that begins in your inner world will reflect on your outer world.',
            'The energies of the month support $signName. This period is ideal for discovering yourself, realizing your potential and growing spiritually. Take advantage of the opportunities the universe offers you.',
            'Cosmic flow is on your side this month. As $elementName energy strengthens, your natural talents and strengths come to the fore. Act with confidence and focus on your goals.',
            'Planets are performing a special choreography for $signName this month. Doors of fate are opening, new possibilities are emerging. Events that will change the flow of your life may occur.',
            'Throughout the month $signName\'s energy is intense. There may be emotional ups and downs but each one will make you stronger. Be patient, the process is working for you.',
            'This month universal energy surrounds $signName. The changes you\'ve been waiting for are starting. Let go of your fears, be open to the new.',
            'The cosmic calendar is opening important pages for you this month. There are turning points in your personal and professional life. Every decision you make shapes your future.',
            'A fruitful month begins for $signName. Time to reap the rewards of your efforts, time to approach your goals. The universe sees and rewards your efforts.',
          ]
        : [
            'Bu ay $signName burcu için dönüşüm ve yenilenme zamanı. Gezegenler güçlü açılar oluşturarak, hayatınızda köklü değişikliklere zemin hazırlıyor. İç dünyanızda başlayan dönüşüm, dış dünyanıza yansıyacak.',
            'Ayın enerjileri $signName burcunu destekliyor. Bu dönem kendinizi keşfetmek, potansiyelinizi gerçekleştirmek ve ruhsal olarak büyümek için ideal. Evrenin size sunduğu fırsatları değerlendirin.',
            'Kozmik akış bu ay sizden yana. $elementName enerjisi güçlenirken, doğal yetenekleriniz ve güçlü yanlarınız ön plana çıkıyor. Özgüvenle hareket edin ve hedeflerinize odaklanın.',
            'Gezegenler bu ay $signName burcu için özel bir koreografi sergiliyor. Kader kapıları aralanıyor, yeni olanaklar beliriyor. Hayatınızın akışını değiştirecek olaylar yaşanabilir.',
            'Ay boyunca $signName burcunun enerjisi yoğun. Duygusal iniş çıkışlar yaşanabilir ama her biri sizi daha güçlü kılacak. Sabırlı olun, süreç size çalışıyor.',
            'Bu ay evrensel enerji $signName burcunu sarmalıyor. Uzun süredir beklediğiniz değişimler başlıyor. Korkularınızı bırakın, yeniye açılın.',
            'Kozmik takvim bu ay sizin için önemli sayfalar açıyor. Kişisel ve profesyonel yaşamınızda dönüm noktaları var. Her kararınız geleceğinizi şekillendiriyor.',
            '$signName burcu için bereketli bir ay başlıyor. Emeklerinizin karşılığını alma, hedeflerinize yaklaşma zamanı. Evren çabalarınızı görüyor ve ödüllendiriyor.',
          ];
  }

  static List<String> getMonthlyLoveContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'There are important developments in your love life this month. Under Venus\' influence, your relationships are deepening and new romantic bonds can be formed. Keep your heart open.',
            'Transformation is happening in relationships this month. An ideal period to break old patterns and establish more authentic bonds. Be brave and express your feelings.',
            'Romantic energies are intensifying. Important encounters for singles, a passionate period for couples begins. Let yourself be swept away by the magic of love.',
            'Your heart chakra is working overtime this month. Deep emotional connections, meaningful conversations and romantic moments await you. Lower your defenses.',
            'Strong romantic atmosphere throughout the month. Surprise dates, unexpected confessions or opening a new chapter in your relationship are possible.',
            'Time for clarity in relationships. Uncertainties are being resolved, emotions are becoming clear. You may get the answer to "Where do I stand?" this month.',
            'A lucky month begins in love. Destiny moments for singles, a period of falling in love again for couples. Romance is in the air.',
            'Emotional bonds are strengthening this month. Every moment you spend with loved ones is precious. Create quality time, collect memories.',
          ]
        : [
            'Aşk hayatınızda bu ay önemli gelişmeler var. Venüs\'ün etkisi altında, ilişkileriniz derinleşiyor ve yeni romantik bağlar kurulabilir. Kalbinizi açık tutun.',
            'Bu ay ilişkilerde dönüşüm yaşanıyor. Eski kalıpları kırmak ve daha otantik bağlar kurmak için ideal bir dönem. Cesur olun ve duygularınızı ifade edin.',
            'Romantik enerjiler yoğunlaşıyor. Bekarlar için önemli karşılaşmalar, çiftler için tutkulu bir dönem başlıyor. Aşkın büyüsüne kendinizi bırakın.',
            'Kalp çakranız bu ay fazla mesai yapıyor. Derin duygusal bağlantılar, anlamlı konuşmalar ve romantik anlar sizi bekliyor. Savunmalarınızı indirin.',
            'Ay boyunca romantik atmosfer güçlü. Sürpriz randevular, beklenmedik itiraflar veya ilişkinizde yeni bir sayfa açılması mümkün.',
            'İlişkilerde netlik zamanı. Belirsizlikler çözülüyor, duygular berraklaşıyor. "Nerede duruyorum?" sorusunun cevabını bu ay alabilirsiniz.',
            'Aşkta şanslı bir ay başlıyor. Bekarlar için kader anları, çiftler için yeniden aşık olma dönemi. Romantizm havada.',
            'Bu ay duygusal bağlar güçleniyor. Sevdiklerinizle geçirdiğiniz her an değerli. Kaliteli zaman yaratın, anılar biriktirin.',
          ];
  }

  static List<String> getMonthlyCareerContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Your career goals are becoming clear this month. There is new opportunity and advancement potential in the professional field. Time to show your leadership abilities.',
            'Make strategic moves in your work life. This month you can prepare the ground for long-term plans and make important decisions. Trust your vision.',
            'Your professional relationships are strengthening. A fruitful period for networking and collaborations. Share your ideas and seek support.',
            'There is activity in the career field throughout the month. Meetings, interviews, new projects... Energy is high, opportunities are plentiful. Be active.',
            'Time to stand out at work this month. Showcase your talents, present your ideas. Your chances of catching your superiors\' attention are high.',
            'Determination and focus are needed in the professional field. Stay away from distractions, set your priorities. Results will come.',
            'Winds of change are blowing in your work life. New roles, responsibilities or a completely different career path may come up.',
            'Your luck shines bright in the business world throughout the month. Unexpected opportunities, positive news or financial gains are possible.',
          ]
        : [
            'Kariyer hedefleriniz bu ay netleşiyor. Profesyonel alanda yeni fırsatlar ve ilerleme potansiyeli var. Liderlik yeteneklerinizi gösterme zamanı.',
            'İş hayatınızda stratejik hamleler yapın. Bu ay uzun vadeli planlar için zemin hazırlayabilir, önemli kararlar alabilirsiniz. Vizyonunuza güvenin.',
            'Profesyonel ilişkileriniz güçleniyor. Ağ kurma ve işbirlikleri için bereketli bir dönem. Fikirlerinizi paylaşın ve destek arayın.',
            'Kariyer alanında ay boyunca hareketlilik var. Toplantılar, görüşmeler, yeni projeler... Enerji yüksek, fırsatlar bol. Aktif olun.',
            'Bu ay iş yerinde öne çıkma zamanı. Yeteneklerinizi sergileyin, fikirlerinizi sunun. Üstlerinizin dikkatini çekme şansınız yüksek.',
            'Profesyonel alanda kararlılık ve odaklanma gerekiyor. Dikkat dağıtıcılardan uzak durun, önceliklerinizi belirleyin. Sonuçlar gelecek.',
            'İş hayatında değişim rüzgarları esiyor. Yeni roller, sorumluluklar veya tamamen farklı bir kariyer yolu gündeme gelebilir.',
            'Ay boyunca iş dünyasında şansınız parlak. Beklenmedik fırsatlar, olumlu haberler veya maddi kazançlar mümkün.',
          ];
  }

  static List<String> getMonthlyHealthContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Pay special attention to your health this month. Review your nutrition, sleep and exercise balance. Your body is sending you messages - listen.',
            'Proper timing is important to optimize your energy levels. Stress management and mental health should be the focus this month.',
            'Adopt a holistic health approach. Improve your quality of life by establishing body, mind and soul balance.',
          ]
        : [
            'Sağlığınıza bu ay özel önem verin. Beslenme, uyku ve egzersiz dengesini gözden geçirin. Bedeniniz size mesajlar gönderiyor - dinleyin.',
            'Enerji seviyelerinizi optimize etmek için doğru zamanlama önemli. Stres yönetimi ve zihinsel sağlık bu ay odak noktası olsun.',
            'Bütünsel sağlık yaklaşımını benimseyin. Beden, zihin ve ruh dengesini kurarak, yaşam kalitenizi artırın.',
          ];
  }

  static List<String> getMonthlyFinancialContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Positive developments in financial matters this month. Your income potential is increasing, opportunities for new sources of income are emerging.',
            'Financial abundance energy is strengthening. Investments made in the past may start to bear fruit.',
            'Budget management is important. Distinguish between needs and wants, cut unnecessary expenses.',
          ]
        : [
            'Finansal konularda bu ay olumlu gelişmeler var. Gelir potansiyeliniz artıyor, yeni gelir kaynakları için fırsatlar beliriyor.',
            'Maddi bolluk enerjisi güçleniyor. Geçmişte yapılan yatırımlar meyve vermeye başlayabilir.',
            'Bütçe yönetimi önemli. İhtiyaç ile istek arasındaki farkı ayırt edin, gereksiz harcamaları kesin.',
          ];
  }

  static List<String> getMonthlySpiritualContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'This month is ideal for deepening your spiritual practice. Meditation, yoga or breath work can accelerate your inner transformation.',
            'Your intuition is strengthening. Pay attention to the messages coming from your inner voice and dreams. The universe is guiding you.',
            'Time to discover the depth of your soul. Introspective practices and self-inquiry questions can bring profound realizations.',
          ]
        : [
            'Bu ay ruhsal pratiğinizi derinleştirmek için ideal. Meditasyon, yoga veya nefes çalışması, içsel dönüşümünüzü hızlandırabilir.',
            'Sezgileriniz güçleniyor. İç sesinizden ve rüyalarınızdan gelen mesajlara dikkat edin. Evren size rehberlik ediyor.',
            'Ruhunuzun derinliğini keşfetme zamanı. İçe dönük pratikler ve öz sorgulama soruları, derin farkındalıklar getirebilir.',
          ];
  }

  static List<String> getMonthlyMantras(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'I am transforming and renewing with each passing day.',
            'I trust the flow of the universe.',
            'I am worthy of love and abundance.',
            'Every challenge is an opportunity for growth.',
            'I am at peace with myself and the world.',
            'My inner light guides my path.',
          ]
        : [
            'Her geçen gün dönüşüyor ve yenileniyorum.',
            'Evrenin akışına güveniyorum.',
            'Sevgiye ve bolluğa layığım.',
            'Her zorluk, büyüme fırsatıdır.',
            'Kendimle ve dünyayla barışıktım.',
            'İçimdeki ışık yolumu aydınlatıyor.',
          ];
  }

  static List<String> getMonths(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ]
        : [
            'Ocak',
            'Şubat',
            'Mart',
            'Nisan',
            'Mayıs',
            'Haziran',
            'Temmuz',
            'Ağustos',
            'Eylül',
            'Ekim',
            'Kasım',
            'Aralık'
          ];
  }

  // ============ YEARLY CONTENT ============

  static List<String> getYearlyOverviews(ZodiacSign sign, AppLanguage language) {
    final isEn = language == AppLanguage.en;
    final signName = isEn ? sign.name : sign.nameTr;

    return isEn
        ? [
            'This year marks a major turning point for $signName. Cosmic energies support deep transformation and personal growth. Trust the process and embrace change.',
            'A year of manifestation awaits $signName. Dreams you\'ve nurtured are ready to become reality. Stay focused, work consistently, and watch miracles unfold.',
            'The stars align for $signName\'s evolution this year. Challenges become teachers, obstacles become stepping stones. Your resilience will be your greatest asset.',
            'Expansion is the theme for $signName this year. Whether in career, relationships, or personal development, growth awaits in every area of life.',
          ]
        : [
            'Bu yıl $signName burcu için önemli bir dönüm noktası. Kozmik enerjiler derin dönüşümü ve kişisel büyümeyi destekliyor. Sürece güvenin ve değişimi kucaklayın.',
            '$signName için bir gerçekleştirme yılı bekliyor. Beslediğiniz hayaller gerçeğe dönüşmeye hazır. Odaklanın, tutarlı çalışın ve mucizelerin açılmasını izleyin.',
            'Yıldızlar bu yıl $signName\'ın evrimı için hizalanıyor. Zorluklar öğretmen, engeller basamak oluyor. Dayanıklılığınız en büyük varlığınız olacak.',
            'Bu yıl $signName için genişleme teması. Kariyer, ilişkiler veya kişisel gelişim olsun, hayatın her alanında büyüme bekliyor.',
          ];
  }

  static List<String> getYearlyLoveContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Love takes center stage this year. Deep connections, soulmate encounters, and relationship milestones await. Open your heart to the magic of love.',
            'A transformative year for matters of the heart. Old patterns break, authentic love emerges. Whether single or coupled, profound growth awaits.',
            'Venus blesses your love life throughout the year. Romance, passion, and emotional depth characterize your relationships. Love finds a way.',
          ]
        : [
            'Bu yıl aşk ön planda. Derin bağlantılar, ruh eşi karşılaşmaları ve ilişki dönüm noktaları bekliyor. Kalbinizi aşkın büyüsüne açın.',
            'Kalp meselelerı için dönüştürücü bir yıl. Eski kalıplar kırılıyor, otantik aşk ortaya çıkıyor. Bekar veya çift, derin büyüme bekliyor.',
            'Venüs yıl boyunca aşk hayatınızı kutsuyor. Romantizm, tutku ve duygusal derinlik ilişkilerinizi karakterize ediyor. Aşk bir yol buluyor.',
          ];
  }

  static List<String> getYearlyCareerContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Professional breakthroughs define this year. Promotions, new opportunities, and recognition for your efforts await. Your hard work pays off.',
            'Career evolution accelerates this year. Whether climbing the ladder or changing paths entirely, significant professional growth is written in the stars.',
            'Leadership opportunities emerge throughout the year. Step into your power, share your vision, and watch your professional influence expand.',
          ]
        : [
            'Profesyonel atılımlar bu yılı tanımlıyor. Terfiler, yeni fırsatlar ve çabalarınızın tanınması bekliyor. Sıkı çalışmanız karşılığını veriyor.',
            'Kariyer evrimi bu yıl hızlanıyor. Basamakları tırmanmak veya yolu tamamen değiştirmek olsun, önemli profesyonel büyüme yıldızlarda yazılı.',
            'Yıl boyunca liderlik fırsatları ortaya çıkıyor. Gücünüze adım atın, vizyonunuzu paylaşın ve profesyonel etkinizin genişlemesini izleyin.',
          ];
  }

  static List<String> getYearlyHealthContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'This year calls for holistic health focus. Mind, body, and spirit alignment becomes priority. Invest in your wellbeing.',
            'Energy management is key this year. Balance activity with rest, productivity with relaxation. Listen to your body\'s wisdom.',
            'Healing energies are strong throughout the year. Old health patterns can transform, new vitality emerges. Support your body\'s natural healing.',
          ]
        : [
            'Bu yıl bütünsel sağlık odağı çağırıyor. Zihin, beden ve ruh uyumu öncelik oluyor. Esenliğinize yatırım yapın.',
            'Bu yıl enerji yönetimi anahtar. Aktiviteyi dinlenmeyle, üretkenliği gevşemeyle dengeleyin. Bedeninizin bilgeliğini dinleyin.',
            'Yıl boyunca şifa enerjileri güçlü. Eski sağlık kalıpları dönüşebilir, yeni canlılık ortaya çıkar. Bedeninizin doğal iyileşmesini destekleyin.',
          ];
  }

  static List<String> getYearlyFinancialContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Financial abundance flows this year. New income streams, investment opportunities, and material growth await. Prosperity consciousness activates.',
            'Strategic financial planning pays dividends this year. Long-term thinking, wise investments, and disciplined spending create lasting wealth.',
            'Jupiter\'s blessings bring financial expansion. Opportunities for growth and prosperity emerge. Stay open to unexpected abundance.',
          ]
        : [
            'Bu yıl finansal bolluk akıyor. Yeni gelir kaynakları, yatırım fırsatları ve maddi büyüme bekliyor. Refah bilinci aktive oluyor.',
            'Stratejik finansal planlama bu yıl temettü ödüyor. Uzun vadeli düşünme, akıllı yatırımlar ve disiplinli harcama kalıcı zenginlik yaratıyor.',
            'Jüpiter\'in kutsamaları finansal genişleme getiriyor. Büyüme ve refah fırsatları ortaya çıkıyor. Beklenmedik bolluğa açık kalın.',
          ];
  }

  static List<String> getYearlySpiritualContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'A year of spiritual awakening unfolds. Deep insights, mystical experiences, and soul growth characterize this journey. Trust your path.',
            'Your spiritual practice deepens this year. Whether meditation, prayer, or contemplation, your connection to the divine strengthens.',
            'Karmic completions and new beginnings mark this year spiritually. Old cycles end, new chapters of soul evolution begin.',
          ]
        : [
            'Ruhsal uyanış yılı açılıyor. Derin içgörüler, mistik deneyimler ve ruh büyümesi bu yolculuğu karakterize ediyor. Yolunuza güvenin.',
            'Ruhsal pratiğiniz bu yıl derinleşiyor. Meditasyon, dua veya tefekkür olsun, ilahi ile bağlantınız güçleniyor.',
            'Karmik tamamlanmalar ve yeni başlangıçlar bu yılı ruhsal olarak işaretliyor. Eski döngüler bitiyor, ruh evriminin yeni bölümleri başlıyor.',
          ];
  }

  static List<String> getYearlyAffirmations(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'This year I embrace my highest potential.',
            'I am worthy of all the blessings coming my way.',
            'Every day brings new opportunities for growth.',
            'I trust the journey and surrender to the flow.',
            'Abundance flows to me easily and effortlessly.',
            'I am the creator of my destiny.',
          ]
        : [
            'Bu yıl en yüksek potansiyelimi kucaklıyorum.',
            'Yoluma çıkan tüm kutsamalara layığım.',
            'Her gün büyüme için yeni fırsatlar getiriyor.',
            'Yolculuğa güveniyorum ve akışa teslim oluyorum.',
            'Bolluk bana kolayca ve zahmetsizce akıyor.',
            'Kaderimin yaratıcısıyım.',
          ];
  }

  static List<String> getYearlyThemes(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Transformation and Rebirth',
            'Manifestation and Abundance',
            'Love and Connection',
            'Career Advancement',
            'Spiritual Awakening',
            'Personal Empowerment',
            'Healing and Renewal',
            'Creative Expression',
          ]
        : [
            'Dönüşüm ve Yeniden Doğuş',
            'Gerçekleştirme ve Bolluk',
            'Aşk ve Bağlantı',
            'Kariyer İlerlemesi',
            'Ruhsal Uyanış',
            'Kişisel Güçlenme',
            'İyileşme ve Yenilenme',
            'Yaratıcı İfade',
          ];
  }

  // ============ LOVE HOROSCOPE CONTENT ============

  static List<String> getRomanticOutlooks(ZodiacSign sign, AppLanguage language) {
    final isEn = language == AppLanguage.en;
    final signName = isEn ? sign.name : sign.nameTr;

    return isEn
        ? [
            'Venus showers $signName with romantic blessings today. Love is in the air, and your heart is ready to receive. Stay open to unexpected connections.',
            'Passion ignites for $signName. Whether single or coupled, intense romantic energy surrounds you. Express your desires boldly.',
            'Emotional depth characterizes $signName\'s love life today. Meaningful conversations and soul connections are favored. Vulnerability is your strength.',
            'Romance blooms unexpectedly for $signName. The universe arranges beautiful meetings and tender moments. Trust the magic of love.',
          ]
        : [
            'Venüs bugün $signName\'a romantik kutsamalar yağdırıyor. Aşk havada ve kalbiniz almaya hazır. Beklenmedik bağlantılara açık kalın.',
            '$signName için tutku alevleniyor. Bekar veya çift olun, yoğun romantik enerji sizi sarıyor. Arzularınızı cesurca ifade edin.',
            'Duygusal derinlik bugün $signName\'ın aşk hayatını karakterize ediyor. Anlamlı konuşmalar ve ruh bağlantıları destekleniyor. Kırılganlık gücünüz.',
            '$signName için romantizm beklenmedik bir şekilde çiçek açıyor. Evren güzel buluşmalar ve nazik anlar düzenliyor. Aşkın büyüsüne güvenin.',
          ];
  }

  static List<String> getSingleAdvice(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Your magnetic energy is high today. Put yourself out there - the universe is arranging meaningful connections. Love often finds us when we least expect it.',
            'Focus on self-love first. When you fill your own cup, you attract partners who match your energy. You deserve a love that celebrates you.',
            'Stay open but discerning. Not every connection is meant to last, but every encounter teaches something. Trust your intuition about who deserves your time.',
            'The stars suggest patience. Your person is on their way. Use this time to become the best version of yourself.',
          ]
        : [
            'Manyetik enerjiniz bugün yüksek. Kendinizi ortaya koyun - evren anlamlı bağlantılar düzenliyor. Aşk genellikle en az beklediğimizde bizi buluyor.',
            'Önce öz sevgiye odaklanın. Kendi bardağınızı doldurduğunuzda, enerjinize uyan partnerler çekersiniz. Sizi kutlayan bir aşkı hak ediyorsunuz.',
            'Açık ama seçici kalın. Her bağlantı sürecek şekilde tasarlanmamıştır ama her karşılaşma bir şey öğretir. Zamanınızı kimin hak ettiği konusunda sezgilerinize güvenin.',
            'Yıldızlar sabır öneriyor. Sizin insanınız yolda. Bu zamanı kendinizin en iyi versiyonu olmak için kullanın.',
          ];
  }

  static List<String> getCouplesAdvice(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Rekindle the spark today. Plan something special, express your appreciation, remember why you fell in love. Small gestures create big impacts.',
            'Communication is your superpower today. Share your feelings openly, listen deeply. Understanding bridges any gap between hearts.',
            'Passion and tenderness dance together today. Balance desire with emotional connection. Physical and spiritual intimacy intertwine beautifully.',
            'Growth happens together. Support each other\'s dreams, celebrate victories, comfort during challenges. Your partnership is a team.',
          ]
        : [
            'Bugün kıvılcımı yeniden alevlendirin. Özel bir şey planlayın, takdirinizi ifade edin, neden aşık olduğunuzu hatırlayın. Küçük jestler büyük etkiler yaratır.',
            'İletişim bugün süper gücünüz. Duygularınızı açıkça paylaşın, derinden dinleyin. Anlayış kalpler arasındaki herhangi bir boşluğu köprüler.',
            'Tutku ve şefkat bugün birlikte dans ediyor. Arzuyu duygusal bağlantıyla dengeleyin. Fiziksel ve ruhsal yakınlık güzelce iç içe geçiyor.',
            'Büyüme birlikte gerçekleşir. Birbirinizin hayallerini destekleyin, zaferleri kutlayın, zorluklarda teselli edin. Ortaklığınız bir takım.',
          ];
  }

  static List<String> getSoulConnectionContent(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Soul connections transcend time and space. The love you seek is also seeking you. Trust the cosmic timing of heart connections.',
            'Your heart knows what your mind can\'t comprehend. Deep soul bonds form when we surrender to love\'s mysterious ways.',
            'Past life connections may surface. That instant recognition, that unexplainable familiarity - these are soul signatures.',
            'The universe conspires for true love. When hearts are meant to meet, no obstacle is insurmountable. Have faith in your romantic destiny.',
          ]
        : [
            'Ruh bağlantıları zaman ve mekanı aşar. Aradığınız aşk sizi de arıyor. Kalp bağlantılarının kozmik zamanlamasına güvenin.',
            'Kalbiniz zihninizin kavrayamayacağını bilir. Derin ruh bağları aşkın gizemli yollarına teslim olduğumuzda oluşur.',
            'Geçmiş hayat bağlantıları yüzeye çıkabilir. O anlık tanıma, o açıklanamayan aşinalık - bunlar ruh imzalarıdır.',
            'Evren gerçek aşk için komplo kurar. Kalpler buluşmaya yazgılıysa, hiçbir engel aşılamaz değildir. Romantik kaderinize inancınız olsun.',
          ];
  }

  static List<String> getVenusInfluence(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Venus blesses your love sector today. Beauty, harmony, and romantic opportunities abound. Let love lead the way.',
            'The planet of love amplifies your charm. You radiate attractive energy that draws others near. Use this magnetism wisely.',
            'Venus whispers of lasting love. Foundations built today can support relationships for years to come. Choose partners wisely.',
            'Under Venus\' gaze, love softens and sweetens. Harsh words dissolve, conflicts resolve. Embrace the healing power of affection.',
          ]
        : [
            'Venüs bugün aşk sektörünüzü kutsuyor. Güzellik, uyum ve romantik fırsatlar bolca var. Bırakın aşk yol göstersin.',
            'Aşk gezegeni çekiciliğinizi amplifiye ediyor. Başkalarını yakına çeken çekici bir enerji yayıyorsunuz. Bu manyetizmayı akıllıca kullanın.',
            'Venüs kalıcı aşkı fısıldıyor. Bugün kurulan temeller yıllarca ilişkileri destekleyebilir. Partnerleri akıllıca seçin.',
            'Venüs\'ün bakışı altında aşk yumuşar ve tatlanır. Sert sözler çözülür, çatışmalar çözülür. Sevginin iyileştirici gücünü kucaklayın.',
          ];
  }

  static List<String> getIntimacyAdvice(AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Emotional intimacy deepens physical connection. Share your inner world, your fears and dreams. Vulnerability creates the deepest bonds.',
            'Passion flows when barriers fall. Let go of inhibitions, embrace authentic expression. True intimacy requires courage.',
            'Sacred sensuality awakens today. Honor your body and your partner\'s as temples of pleasure. Mindful presence enhances every touch.',
            'Intimacy is a conversation without words. Listen with your heart, respond with your soul. The body speaks the language of love.',
          ]
        : [
            'Duygusal yakınlık fiziksel bağlantıyı derinleştirir. İç dünyanızı, korkularınızı ve hayallerinizi paylaşın. Kırılganlık en derin bağları yaratır.',
            'Tutku engeller düştüğünde akar. İnhibisyonları bırakın, otantik ifadeyi kucaklayın. Gerçek yakınlık cesaret gerektirir.',
            'Kutsal şehvet bugün uyanıyor. Bedeninizi ve partnerinizinkini zevk tapınakları olarak onurlandırın. Bilinçli mevcudiyet her dokunuşu geliştirir.',
            'Yakınlık kelimesiz bir konuşmadır. Kalbinizle dinleyin, ruhunuzla cevap verin. Beden aşkın dilini konuşur.',
          ];
  }
}
