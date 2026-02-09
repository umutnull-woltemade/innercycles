import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';

/// Content for ExtendedHoroscopeService with multi-language support
class ExtendedHoroscopeContent {
  // ============ WEEKLY CONTENT ============

  static List<String> getWeeklyOverviews(ZodiacSign sign, AppLanguage language) {
    if (language == AppLanguage.tr) {
      final signName = sign.nameTr;
      final elementName = sign.element.nameTr;
      return [
        'Bu hafta $signName burcu için kozmik enerjiler yoğunlaşıyor. Gezegenler sizin lehinize hizalanırken, büyük fırsatların kapıları aralanıyor. İç sesinize kulak verin ve sezgilerinizi takip edin.',
        'Evren bu hafta size güçlü mesajlar gönderiyor. $signName enerjisi dorukta ve potansiyelinizi ortaya koyma zamanı. Cesur adımlar atın, korkularınızı geride bırakın.',
        'Hafta boyunca $elementName elementi güçleniyor. Bu enerjiyi kendi avantajınıza kullanın. İç dünyanızda derin dönüşümler yaşanırken, dış dünyada da somut değişiklikler görülecek.',
        'Bu hafta $signName burcu için yeni bağlantılar ve fırsatlar temalarını keşfetmek için iyi bir zaman. Açık kalın ve kendinize güvenin.',
        'Bu hafta $signName burcu için önemli yaşam temalarını düşünmeye davet eden bir dönem. Değerlerinizle uyumlu kararları düşünün. Seçimlerinizi yönlendirirken iç bilgeliğinize güvenin.',
        '$signName burcu için bu hafta enerji akışı olumlu yönde. Engeller kalkıyor, yollar açılıyor. Uzun süredir beklediğiniz haber veya gelişme bu hafta gelebilir.',
        'Kozmik rüzgarlar $signName burcunun yelkenlerini şişiriyor. Hangi yöne gitmek istediğinizi biliyorsanız, evren sizi desteklemeye hazır. Niyetlerinizi net tutun.',
        'Bu hafta evrensel enerji $signName burcunu kucaklıyor. Yaratıcılık, ilham ve motivasyon dorukta. Ertelediğiniz projelere başlamak için ideal bir zamanlama.',
      ];
    }

    final signName = sign.name;
    final elementName = sign.element.name;

    return [
      'This week is a good time for $signName to explore themes of new connections and opportunities. Stay open and trust yourself. Listen to your inner voice.',
      'The universe is sending you powerful messages this week. $signName energy is at its peak and it\'s time to show your potential. Take bold steps, leave your fears behind.',
      'Throughout the week the $elementName element is strengthening. Use this energy to your advantage. While deep transformations occur in your inner world, concrete changes will also be seen in the outer world.',
      'This week offers $signName themes of new connections and opportunities for exploration. Stay open and trust your intuition.',
      'This week invites $signName to reflect on important life themes. Consider what decisions align with your values. Trust your inner wisdom as you navigate choices.',
      'For $signName this week the energy flow is positive. Obstacles are being removed, paths are opening. The news or development you\'ve been waiting for may come this week.',
      'Cosmic winds are filling $signName\'s sails. If you know which direction you want to go, the universe is ready to support you. Keep your intentions clear.',
      'This week universal energy embraces $signName. Creativity, inspiration and motivation are at their peak. Ideal timing to start projects you\'ve been postponing.',
    ];
  }

  static List<String> getWeeklyLoveContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Aşk hayatınızda bu hafta hareketli bir dönem başlıyor. Venüs etkisi altında, ilişkilerinizde daha derin bağlar kurabilirsiniz. Bekarlar için sürpriz karşılaşmalar olası.',
        'Kalp çakranız bu hafta aktive oluyor. Duygusal açıdan hassas olabilirsiniz ama bu, sevgiyi daha derin hissetmenize de olanak tanıyor. Partnerinizle özel anlar yaratın.',
        'Romantik enerjiler yükseliyor. İlişkinizde yeni bir sayfa açılabilir veya bekarlar için önemli bir tanışma gerçekleşebilir. Kalbinizi açık tutun.',
        'Bu hafta aşk ve bağlantı temalarını keşfetmeye davet ediliyor. Sezgilerinize güvenin ve etrafınızdaki anlamlı bağlantıları fark edin.',
        'Venüs\'ün olumlu açıları aşk hayatınızı ışıklandırıyor. Çiftler için tutku yeniden alevlenirken, bekarlar manyetik çekicilik yayıyor. Flört enerjisi güçlü.',
        'İlişkilerde iletişim bu hafta kritik öneme sahip. Duygularınızı açıkça ifade edin, karşı tarafı dinleyin. Yanlış anlamalar çözülüyor, bağlar güçleniyor.',
        'Romantik sürprizlere hazır olun. Evren aşk konusunda size güzel haberler getirebilir. Geçmişten biri yeniden hayatınıza girebilir veya yeni biri çıkabilir.',
        'Aşkta cesur olma haftası. Duygularınızı bastırmayın, risk alın. Karşılık görmekten korkmayın - evren cesareti ödüllendirir.',
      ];
    }
    return [
      'A lively period is starting in your love life this week. Under Venus\' influence, you can establish deeper connections in your relationships. Surprise encounters are likely for singles.',
      'Your heart chakra is being activated this week. You may be emotionally sensitive but this also allows you to feel love more deeply. Create special moments with your partner.',
      'Romantic energies are rising. A new chapter may open in your relationship or an important meeting may happen for singles. Keep your heart open.',
      'This week invites exploration of love and connection themes. Trust your intuition and notice meaningful connections around you.',
      'Venus\' favorable aspects are illuminating your love life. While passion reignites for couples, singles are radiating magnetic charm. Flirtation energy is strong.',
      'Communication in relationships is critically important this week. Express your feelings openly, listen to the other side. Misunderstandings are being resolved, bonds are strengthening.',
      'Get ready for romantic surprises. The universe may bring you good news about love. Someone from the past may re-enter your life or someone new may appear.',
      'A week to be brave in love. Don\'t suppress your feelings, take risks. Don\'t be afraid of reciprocation - the universe rewards courage.',
    ];
  }

  static List<String> getWeeklyCareerContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
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
    return [
      'Important developments may occur in your career this week. Your leadership abilities are coming to the fore. Share your ideas boldly.',
      'New professional opportunities may be worth exploring. Think strategically this week and review your long-term plans.',
      'Your creativity at work is at its peak. Your innovative ideas will attract attention. Teamwork and collaborations can bring fruitful results.',
      'Positive news may come in financial matters. Trust your intuition in your financial decisions this week but don\'t neglect logic either.',
      'Time to climb the career ladder. You may catch the attention of your superiors, news of promotion or raise may come. Make yourself visible.',
      'A favorable week for job interviews and negotiations. Express your wishes clearly, ask for what you deserve. The universe supports you.',
      'New job opportunities may knock on your door. Update your LinkedIn profile, expand your network. Offers may come from unexpected places.',
      'Your projects are gaining momentum this week. Obstacles are being removed, processes are accelerating. Delayed approvals, expected decisions may come this week.',
    ];
  }

  static List<String> getWeeklyHealthContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Enerji seviyeniz bu hafta yüksek. Fiziksel aktivitelere zaman ayırın. Bedeninizin size gönderdiği sinyallere dikkat edin.',
        'Zihinsel ve duygusal sağlığınıza odaklanın. Stres yönetimi için meditasyon veya yoga deneyin. Doğada vakit geçirmek faydalı olabilir.',
        'Bu hafta beslenme düzeninizi gözden geçirin. Vücudunuzun ihtiyaç duyduğu besinleri verin. Uyku düzeninize dikkat edin.',
        'Enerji dengenizi korumak için molalar verin. Kendinize şefkat gösterin ve aşırı yorgunluktan kaçının. Şifa enerjileri güçlü.',
      ];
    }
    return [
      'Your energy level is high this week. Make time for physical activities. Pay attention to the signals your body sends you.',
      'Focus on your mental and emotional health. Try meditation or yoga for stress management. Spending time in nature will do you good.',
      'Review your diet this week. Give your body the nutrients it needs. Pay attention to your sleep patterns.',
      'Take breaks to maintain your energy balance. Show yourself compassion and avoid excessive fatigue. Healing energies are strong.',
    ];
  }

  static List<String> getWeeklyFinancialContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Finansal konularda bu hafta dikkatli olun. Büyük harcamalardan önce iki kez düşünün. Tasarruf planları yapmanın tam zamanı.',
        'Maddi bolluk enerjisi güçleniyor. Beklenmedik kazançlar veya fırsatlar gelebilir. Ama ayaklarınızı yere basın.',
        'Yatırımlar için araştırma yapın ama aceleci davranmayın. Bu hafta finansal bilincinizi geliştirmek için ideal.',
        'Para konularında yeni bir bakış açısı geliştirin. Bolluk bilincini aktive edin ve kıtlık korkularını bırakın.',
      ];
    }
    return [
      'Be careful in financial matters this week. Think twice before big expenses. It\'s the perfect time to make savings plans.',
      'Financial abundance energy is strengthening. Unexpected gains or opportunities may come. But keep your feet on the ground.',
      'Research investments but don\'t rush. This week is ideal for developing your financial awareness.',
      'Develop a new perspective on money. Activate abundance consciousness and let go of scarcity fears.',
    ];
  }

  static List<String> getWeeklyAffirmations(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Evrenin bolluğuna açığım ve her şey yolunda.',
        'Her gün her anlamda daha iyiye gidiyorum.',
        'İçimdeki gücü fark ediyorum ve onu kullanıyorum.',
        'Sevgiyi çekiyorum ve sevgi veriyorum.',
        'Korkularımı bırakıyor, güvenle ilerliyorum.',
        'Ruhsal yolculuğumda doğru yöndeyim.',
      ];
    }
    return [
      'I am open to the universe\'s abundance and everything is fine.',
      'Every day I am getting better in every way.',
      'I recognize the power within me and I use it.',
      'I attract love and I give love.',
      'I let go of my fears and move forward with confidence.',
      'I am on the right path in my spiritual journey.',
    ];
  }

  static List<String> getDays(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    }
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  }

  static List<String> getKeyDateEvents(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'romantik fırsatlar',
        'kariyer atılımları',
        'finansal kararlar',
        'sağlık odağı',
        'sosyal etkinlikler',
        'iç huzur',
      ];
    }
    return [
      'romantic opportunities',
      'career breakthroughs',
      'financial decisions',
      'health focus',
      'social events',
      'inner peace',
    ];
  }

  // ============ MONTHLY CONTENT ============

  static List<String> getMonthlyOverviews(ZodiacSign sign, AppLanguage language) {
    if (language == AppLanguage.tr) {
      final signName = sign.nameTr;
      final elementName = sign.element.nameTr;
      return [
        'Bu ay $signName burcu için dönüşüm ve yenilenme zamanı. Gezegenler güçlü açılar oluşturarak, hayatınızda köklü değişikliklere zemin hazırlıyor. İç dünyanızda başlayan dönüşüm, dış dünyanıza yansıyacak.',
        'Ayın enerjileri $signName burcunu destekliyor. Bu dönem kendinizi keşfetmek, potansiyelinizi gerçekleştirmek ve ruhsal olarak büyümek için ideal. Evrenin size sunduğu fırsatları değerlendirin.',
        'Kozmik akış bu ay sizden yana. $elementName enerjisi güçlenirken, doğal yetenekleriniz ve güçlü yanlarınız ön plana çıkıyor. Özgüvenle hareket edin ve hedeflerinize odaklanın.',
        'Bu ay $signName burcu için yeni olasılıklar ve temalar düşünmeye davet eden bir dönem. Yaşamınızdaki değişim ve büyüme alanlarını keşfedin.',
        'Ay boyunca $signName burcunun enerjisi yoğun. Duygusal iniş çıkışlar yaşanabilir ama her biri sizi daha güçlü kılacak. Sabırlı olun, süreç size çalışıyor.',
        'Bu ay evrensel enerji $signName burcunu sarmalıyor. Uzun süredir beklediğiniz değişimler başlıyor. Korkularınızı bırakın, yeniye açılın.',
        'Kozmik takvim bu ay sizin için önemli sayfalar açıyor. Kişisel ve profesyonel yaşamınızda dönüm noktaları var. Her kararınız geleceğinizi şekillendiriyor.',
        '$signName burcu için bereketli bir ay başlıyor. Emeklerinizin karşılığını alma, hedeflerinize yaklaşma zamanı. Evren çabalarınızı görüyor ve ödüllendiriyor.',
      ];
    }

    final signName = sign.name;
    final elementName = sign.element.name;

    return [
      'This month is a time of transformation and renewal for $signName. Planets are forming strong aspects, preparing the ground for fundamental changes in your life. The transformation that begins in your inner world will reflect on your outer world.',
      'The energies of the month support $signName. This period is ideal for discovering yourself, realizing your potential and growing spiritually. Take advantage of the opportunities the universe offers you.',
      'Cosmic flow is on your side this month. As $elementName energy strengthens, your natural talents and strengths come to the fore. Act with confidence and focus on your goals.',
      'This month invites $signName to consider new possibilities and themes. Explore areas of change and growth in your life.',
      'Throughout the month $signName\'s energy is intense. There may be emotional ups and downs but each one will make you stronger. Be patient, the process is working for you.',
      'This month universal energy surrounds $signName. The changes you\'ve been waiting for are starting. Let go of your fears, be open to the new.',
      'The cosmic calendar is opening important pages for you this month. There are turning points in your personal and professional life. Every decision you make shapes your future.',
      'A fruitful month begins for $signName. Time to reap the rewards of your efforts, time to approach your goals. The universe sees and rewards your efforts.',
    ];
  }

  static List<String> getMonthlyLoveContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Aşk hayatınızda bu ay önemli gelişmeler var. Venüs\'ün etkisi altında, ilişkileriniz derinleşiyor ve yeni romantik bağlar kurulabilir. Kalbinizi açık tutun.',
        'Bu ay ilişkilerde dönüşüm yaşanıyor. Eski kalıpları kırmak ve daha otantik bağlar kurmak için ideal bir dönem. Cesur olun ve duygularınızı ifade edin.',
        'Romantik enerjiler yoğunlaşıyor. Bekarlar için önemli karşılaşmalar, çiftler için tutkulu bir dönem başlıyor. Aşkın büyüsüne kendinizi bırakın.',
        'Kalp çakranız bu ay aktif. Derin duygusal bağlantılar, anlamlı konuşmalar ve romantik anlar için güzel bir dönem. Savunmalarınızı indirmeyi düşünün.',
        'Ay boyunca romantik atmosfer güçlü. Sürpriz randevular, beklenmedik itiraflar veya ilişkinizde yeni bir sayfa açılması mümkün.',
        'İlişkilerde netlik zamanı. Belirsizlikler çözülüyor, duygular berraklaşıyor. "Nerede duruyorum?" sorusunun cevabını bu ay alabilirsiniz.',
        'Aşk ve ilişki temalarını keşfetmek için güzel bir ay. İlişkilerinizde neyin önemli olduğunu düşünün. Romantik enerji güçlü.',
        'Bu ay duygusal bağlar güçleniyor. Sevdiklerinizle geçirdiğiniz her an değerli. Kaliteli zaman yaratın, anılar biriktirin.',
      ];
    }
    return [
      'There are important developments in your love life this month. Under Venus\' influence, your relationships are deepening and new romantic bonds can be formed. Keep your heart open.',
      'Transformation is happening in relationships this month. An ideal period to break old patterns and establish more authentic bonds. Be brave and express your feelings.',
      'Romantic energies are intensifying. Important encounters for singles, a passionate period for couples begins. Let yourself be swept away by the magic of love.',
      'Your heart chakra is active this month. A good time for deep emotional connections, meaningful conversations and romantic themes. Consider lowering your defenses.',
      'Strong romantic atmosphere throughout the month. Surprise dates, unexpected confessions or opening a new chapter in your relationship are possible.',
      'Time for clarity in relationships. Uncertainties are being resolved, emotions are becoming clear. You may get the answer to "Where do I stand?" this month.',
      'A beautiful month for exploring love and relationship themes. Consider what matters most in your relationships. Romantic energy is strong.',
      'Emotional bonds are strengthening this month. Every moment you spend with loved ones is precious. Create quality time, collect memories.',
    ];
  }

  static List<String> getMonthlyCareerContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Kariyer hedefleriniz bu ay netleşiyor. Profesyonel alanda yeni fırsatlar ve ilerleme potansiyeli var. Liderlik yeteneklerinizi gösterme zamanı.',
        'İş hayatınızda stratejik hamleler yapın. Bu ay uzun vadeli planlar için zemin hazırlayabilir, önemli kararlar alabilirsiniz. Vizyonunuza güvenin.',
        'Profesyonel ilişkileriniz güçleniyor. Ağ kurma ve işbirlikleri için bereketli bir dönem. Fikirlerinizi paylaşın ve destek arayın.',
        'Kariyer alanında ay boyunca hareketlilik var. Toplantılar, görüşmeler, yeni projeler... Enerji yüksek, fırsatlar bol. Aktif olun.',
        'Bu ay iş yerinde öne çıkma zamanı. Yeteneklerinizi sergileyin, fikirlerinizi sunun. Üstlerinizin dikkatini çekme şansınız yüksek.',
        'Profesyonel alanda kararlılık ve odaklanma temaları öne çıkıyor. Dikkat dağıtıcılardan uzak durun, önceliklerinizi belirleyin.',
        'İş hayatında değişim rüzgarları esiyor. Yeni roller, sorumluluklar veya tamamen farklı bir kariyer yolu gündeme gelebilir.',
        'Ay boyunca iş dünyasında şansınız parlak. Beklenmedik fırsatlar, olumlu haberler veya maddi kazançlar mümkün.',
      ];
    }
    return [
      'Your career goals are becoming clear this month. There is new opportunity and advancement potential in the professional field. Time to show your leadership abilities.',
      'Make strategic moves in your work life. This month you can prepare the ground for long-term plans and make important decisions. Trust your vision.',
      'Your professional relationships are strengthening. A fruitful period for networking and collaborations. Share your ideas and seek support.',
      'There is activity in the career field throughout the month. Meetings, interviews, new projects... Energy is high, opportunities are plentiful. Be active.',
      'Time to stand out at work this month. Showcase your talents, present your ideas. Your chances of catching your superiors\' attention are high.',
      'Determination and focus support professional growth. Consider what distractions to minimize and how to set priorities.',
      'Winds of change are blowing in your work life. New roles, responsibilities or a completely different career path may come up.',
      'Your luck shines bright in the business world throughout the month. Unexpected opportunities, positive news or financial gains are possible.',
    ];
  }

  static List<String> getMonthlyHealthContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Sağlığınıza bu ay özel önem verin. Beslenme, uyku ve egzersiz dengesini gözden geçirin. Bedeniniz size mesajlar gönderiyor - dinleyin.',
        'Enerji seviyelerinizi optimize etmek için doğru zamanlama önemli. Stres yönetimi ve zihinsel sağlık bu ay odak noktası olsun.',
        'Bütünsel sağlık yaklaşımını benimseyin. Beden, zihin ve ruh dengesini kurarak, yaşam kalitenizi artırın.',
      ];
    }
    return [
      'Pay special attention to your health this month. Review your nutrition, sleep and exercise balance. Your body is sending you messages - listen.',
      'Proper timing is important to optimize your energy levels. Stress management and mental health should be the focus this month.',
      'Adopt a holistic health approach. Improve your quality of life by establishing body, mind and soul balance.',
    ];
  }

  static List<String> getMonthlyFinancialContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Finansal konularda bu ay olumlu gelişmeler var. Gelir potansiyeliniz artıyor, yeni gelir kaynakları için fırsatlar beliriyor.',
        'Maddi bolluk enerjisi güçleniyor. Geçmişte yapılan yatırımlar meyvelerini vermeye başlayabilir.',
        'Bütçe yönetimi önemli. İhtiyaçlarla istekleri ayırt edin, gereksiz harcamaları kısın.',
      ];
    }
    return [
      'Positive developments in financial matters this month. Your income potential is increasing, opportunities for new sources of income are emerging.',
      'Financial abundance energy is strengthening. Investments made in the past may start to bear fruit.',
      'Budget management is important. Distinguish between needs and wants, cut unnecessary expenses.',
    ];
  }

  static List<String> getMonthlySpiritualContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu ay ruhsal pratiğinizi derinleştirmek için ideal. Meditasyon, yoga veya nefes çalışması iç dönüşümünüzü hızlandırabilir.',
        'Sezgileriniz güçleniyor. İç sesinizden ve rüyalarınızdan gelen mesajlara dikkat edin. Evren sizi yönlendiriyor.',
        'Ruhunuzun derinliğini keşfetme zamanı. İçe dönük pratikler ve öz-sorgulama soruları derin farkındalıklar getirebilir.',
      ];
    }
    return [
      'This month is ideal for deepening your spiritual practice. Meditation, yoga or breath work can accelerate your inner transformation.',
      'Your intuition is strengthening. Pay attention to the messages coming from your inner voice and dreams. The universe is guiding you.',
      'Time to discover the depth of your soul. Introspective practices and self-inquiry questions can bring profound realizations.',
    ];
  }

  static List<String> getMonthlyMantras(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Her geçen gün dönüşüyor ve yenileniyorum.',
        'Evrenin akışına güveniyorum.',
        'Sevgi ve bolluğu hak ediyorum.',
        'Her zorluk, büyüme için bir fırsat.',
        'Kendimle ve dünyayla barış içindeyim.',
        'İçimdeki ışık yolumu aydınlatıyor.',
      ];
    }
    return [
      'I am transforming and renewing with each passing day.',
      'I trust the flow of the universe.',
      'I am worthy of love and abundance.',
      'Every challenge is an opportunity for growth.',
      'I am at peace with myself and the world.',
      'My inner light guides my path.',
    ];
  }

  static List<String> getMonths(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
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
    return [
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
    ];
  }

  // ============ YEARLY CONTENT ============

  static List<String> getYearlyOverviews(ZodiacSign sign, AppLanguage language) {
    if (language == AppLanguage.tr) {
      final signName = sign.nameTr;
      return [
        'Bu yıl $signName burcu için önemli bir dönüm noktası. Kozmik enerjiler derin dönüşüm ve kişisel büyümeyi destekliyor. Sürece güvenin ve değişimi kucaklayın.',
        '$signName için manifestasyon yılı başlıyor. Besleyip büyüttüğünüz hayaller gerçeğe dönüşmeye hazır. Odaklanın, tutarlı çalışın ve mucizelerin açılmasını izleyin.',
        'Bu yıl $signName için evrim temalarını keşfetme dönemi. Zorluklar öğretmen olabilir, engeller basamak taşına dönüşebilir. Dayanıklılık önemli bir tema.',
        'Genişleme, bu yıl $signName için bir tema olabilir. İster kariyer, ister ilişkiler, ister kişisel gelişim olsun - her alanda büyüme potansiyeli var.',
      ];
    }

    final signName = sign.name;

    return [
      'This year marks a major turning point for $signName. Cosmic energies support deep transformation and personal growth. Trust the process and embrace change.',
      'A year of manifestation themes for $signName. Dreams you\'ve nurtured can move toward reality with focused effort. Stay consistent and trust the process.',
      'This year invites $signName to reflect on personal evolution. Consider how challenges can become teachers and obstacles can become opportunities for growth.',
      'Expansion themes emerge for $signName this year. Whether in career, relationships, or personal development, growth potential exists in many areas of life.',
    ];
  }

  static List<String> getYearlyLoveContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu yıl aşk temaları ön plana çıkabilir. Derin bağlantılar ve ilişki temaları keşfedilebilir. Kalbinizi açık tutmayı düşünün.',
        'Kalp meseleleri için dönüştürücü bir yıl olabilir. Eski kalıpları kırmak ve otantik bağlantılar keşfetmek için güzel bir dönem.',
        'Venüs yıl boyunca aşk hayatınızı kutsayacak. Romantizm, tutku ve duygusal derinlik ilişkilerinizi karakterize ediyor. Aşk bir yol buluyor.',
      ];
    }
    return [
      'Love themes take center stage this year. Deep connections and relationship growth can be explored. Consider opening your heart to meaningful connections.',
      'A transformative year for matters of the heart. Old patterns can break, authentic love can emerge. Whether single or coupled, profound growth is possible.',
      'Venus blesses your love life throughout the year. Romance, passion, and emotional depth characterize your relationships. Love finds a way.',
    ];
  }

  static List<String> getYearlyCareerContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu yıl profesyonel atılımlar için güzel bir dönem olabilir. Terfiler, yeni fırsatlar ve emeklerinizin takdiri temalarını keşfedin.',
        'Bu yıl kariyer evrimi hızlanıyor. İster basamakları tırmanın ister tamamen yol değiştirin, önemli profesyonel büyüme yıldızlarda yazılı.',
        'Yıl boyunca liderlik fırsatları beliriyor. Gücünüze adım atın, vizyonunuzu paylaşın ve profesyonel etkinizin genişlemesini izleyin.',
      ];
    }
    return [
      'Professional breakthrough themes emerge this year. Promotions, new opportunities, and recognition for your efforts are possible. Your hard work can pay off.',
      'Career evolution accelerates this year. Whether climbing the ladder or changing paths entirely, significant professional growth is written in the stars.',
      'Leadership opportunities emerge throughout the year. Step into your power, share your vision, and watch your professional influence expand.',
    ];
  }

  static List<String> getYearlyHealthContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu yıl bütünsel sağlık odağı çağrısında bulunuyor. Zihin, beden ve ruh uyumu öncelik haline geliyor. Esenliğinize yatırım yapın.',
        'Bu yıl enerji yönetimi anahtar. Aktivite ile dinlenmeyi, üretkenlik ile rahatlamayı dengeleyin. Bedeninizin bilgeliğini dinleyin.',
        'Yıl boyunca şifa enerjileri güçlü. Eski sağlık kalıpları dönüşebilir, yeni canlılık ortaya çıkar. Bedeninizin doğal iyileşmesini destekleyin.',
      ];
    }
    return [
      'This year calls for holistic health focus. Mind, body, and spirit alignment becomes priority. Invest in your wellbeing.',
      'Energy management is key this year. Balance activity with rest, productivity with relaxation. Listen to your body\'s wisdom.',
      'Healing energies are strong throughout the year. Old health patterns can transform, new vitality emerges. Support your body\'s natural healing.',
    ];
  }

  static List<String> getYearlyFinancialContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu yıl finansal bolluk temaları öne çıkıyor. Yeni gelir akışları, yatırım fırsatları ve maddi büyüme alanları keşfedilebilir.',
        'Stratejik finansal planlama bu yıl temettü ödüyor. Uzun vadeli düşünce, akıllı yatırımlar ve disiplinli harcama kalıcı zenginlik yaratır.',
        'Jüpiter\'in bereketleri finansal genişleme getiriyor. Büyüme ve refah fırsatları beliriyor. Beklenmedik bolluğa açık kalın.',
      ];
    }
    return [
      'Financial abundance themes emerge this year. New income streams, investment opportunities, and material growth areas can be explored.',
      'Strategic financial planning pays dividends this year. Long-term thinking, wise investments, and disciplined spending create lasting wealth.',
      'Jupiter\'s blessings bring financial expansion. Opportunities for growth and prosperity emerge. Stay open to unexpected abundance.',
    ];
  }

  static List<String> getYearlySpiritualContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Ruhsal uyanış yılı açılıyor. Derin içgörüler, mistik deneyimler ve ruh büyümesi bu yolculuğu karakterize ediyor. Yolunuza güvenin.',
        'Bu yıl ruhsal pratiğiniz derinleşiyor. İster meditasyon, ister dua, ister tefekkür olsun, ilahi ile bağlantınız güçleniyor.',
        'Karmik tamamlanmalar ve yeni başlangıçlar bu yılı ruhsal olarak işaretliyor. Eski döngüler sona eriyor, ruh evriminin yeni bölümleri başlıyor.',
      ];
    }
    return [
      'A year of spiritual awakening unfolds. Deep insights, mystical experiences, and soul growth characterize this journey. Trust your path.',
      'Your spiritual practice deepens this year. Whether meditation, prayer, or contemplation, your connection to the divine strengthens.',
      'Karmic completions and new beginnings mark this year spiritually. Old cycles end, new chapters of soul evolution begin.',
    ];
  }

  static List<String> getYearlyAffirmations(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bu yıl en yüksek potansiyelimi kucaklıyorum.',
        'Yoluma çıkan tüm bereketleri hak ediyorum.',
        'Her gün büyüme için yeni fırsatlar getiriyor.',
        'Yolculuğa güveniyorum ve akışa teslim oluyorum.',
        'Bolluk bana kolayca ve zahmetsizce akıyor.',
        'Hayatımın yönünü ben belirlerim.',
      ];
    }
    return [
      'This year I embrace my highest potential.',
      'I am worthy of all the blessings coming my way.',
      'Every day brings new opportunities for growth.',
      'I trust the journey and surrender to the flow.',
      'Abundance flows to me easily and effortlessly.',
      'I choose the direction of my life.',
    ];
  }

  static List<String> getYearlyThemes(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Dönüşüm ve Yeniden Doğuş',
        'Manifestasyon ve Bolluk',
        'Aşk ve Bağlantı',
        'Kariyer İlerlemesi',
        'Ruhsal Uyanış',
        'Kişisel Güçlenme',
        'Şifa ve Yenilenme',
        'Yaratıcı İfade',
      ];
    }
    return [
      'Transformation and Rebirth',
      'Manifestation and Abundance',
      'Love and Connection',
      'Career Advancement',
      'Spiritual Awakening',
      'Personal Empowerment',
      'Healing and Renewal',
      'Creative Expression',
    ];
  }

  // ============ LOVE HOROSCOPE CONTENT ============

  static List<String> getRomanticOutlooks(ZodiacSign sign, AppLanguage language) {
    if (language == AppLanguage.tr) {
      final signName = sign.nameTr;
      return [
        'Venüs bugün $signName burcuna romantik bereketler yağdırıyor. Aşk havada ve kalbiniz almaya hazır. Beklenmedik bağlantılara açık kalın.',
        '$signName için tutku tutuşuyor. İster bekar ister çift olun, yoğun romantik enerji sizi sarıyor. Arzularınızı cesurca ifade edin.',
        'Duygusal derinlik bugün $signName burcunun aşk hayatını karakterize ediyor. Anlamlı sohbetler ve ruh bağlantıları destekleniyor. Savunmasızlık gücünüzdür.',
        '$signName için romantizm beklenmedik bir şekilde çiçekleniyor. Evren güzel buluşmalar ve şefkatli anlar ayarlıyor. Aşkın büyüsüne güvenin.',
      ];
    }

    final signName = sign.name;

    return [
      'Venus showers $signName with romantic blessings today. Love is in the air, and your heart is ready to receive. Stay open to unexpected connections.',
      'Passion ignites for $signName. Whether single or coupled, intense romantic energy surrounds you. Express your desires boldly.',
      'Emotional depth characterizes $signName\'s love life today. Meaningful conversations and soul connections are favored. Vulnerability is your strength.',
      'Romance blooms unexpectedly for $signName. The universe arranges beautiful meetings and tender moments. Trust the magic of love.',
    ];
  }

  static List<String> getSingleAdvice(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Manyetik enerjiniz bugün yüksek. Kendinizi ortaya koyun - evren anlamlı bağlantılar ayarlıyor. Aşk genellikle en beklemediğimiz anda bizi bulur.',
        'Önce öz-sevgiye odaklanın. Kendi bardağınızı doldurduğunuzda, enerjinize uyan partnerler çekersiniz. Sizi kutlayan bir aşkı hak ediyorsunuz.',
        'Açık ama seçici kalın. Her bağlantı sürmek için değildir, ama her karşılaşma bir şey öğretir. Zamanınızı kimin hak ettiği konusunda sezgilerinize güvenin.',
        'Yıldızlar sabır öneriyor. Kişiniz yolda. Bu zamanı kendinizin en iyi versiyonu olmak için kullanın.',
      ];
    }
    return [
      'Your magnetic energy is high today. Put yourself out there - the universe is arranging meaningful connections. Love often finds us when we least expect it.',
      'Focus on self-love first. When you fill your own cup, you attract partners who match your energy. You deserve a love that celebrates you.',
      'Stay open but discerning. Not every connection is meant to last, but every encounter teaches something. Trust your intuition about who deserves your time.',
      'The stars suggest patience. Your person is on their way. Use this time to become the best version of yourself.',
    ];
  }

  static List<String> getCouplesAdvice(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Bugün kıvılcımı yeniden yakın. Özel bir şey planlayın, takdirinizi ifade edin, neden aşık olduğunuzu hatırlayın. Küçük jestler büyük etkiler yaratır.',
        'Bugün iletişim süper gücünüz. Duygularınızı açıkça paylaşın, derinden dinleyin. Anlayış, kalpler arasındaki her boşluğu köprüler.',
        'Bugün tutku ve şefkat birlikte dans ediyor. Arzuyu duygusal bağlantıyla dengeleyin. Fiziksel ve ruhsal yakınlık güzelce iç içe geçiyor.',
        'Büyüme birlikte gerçekleşir. Birbirinizin hayallerini destekleyin, zaferleri kutlayın, zorluklarda teselli edin. Ortaklığınız bir takım.',
      ];
    }
    return [
      'Rekindle the spark today. Plan something special, express your appreciation, remember why you fell in love. Small gestures create big impacts.',
      'Communication is your superpower today. Share your feelings openly, listen deeply. Understanding bridges any gap between hearts.',
      'Passion and tenderness dance together today. Balance desire with emotional connection. Physical and spiritual intimacy intertwine beautifully.',
      'Growth happens together. Support each other\'s dreams, celebrate victories, comfort during challenges. Your partnership is a team.',
    ];
  }

  static List<String> getSoulConnectionContent(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Ruh bağlantıları zaman ve mekanı aşar. Aradığınız aşk sizi de arıyor. Kalp bağlantılarının kozmik zamanlamasına güvenin.',
        'Kalbiniz, zihninizin kavrayamadığını biliyor. Derin ruh bağları, aşkın gizemli yollarına teslim olduğumuzda oluşur.',
        'Geçmiş yaşam bağlantıları yüzeye çıkabilir. O anı tanıma, o açıklanamaz aşinalık - bunlar ruh imzalarıdır.',
        'Derin bağlantılar zaman alır ama anlamlıdır. Kalp bağlantılarınızı besleyin ve ilişkilerinize değer verin.',
      ];
    }
    return [
      'Soul connections transcend time and space. The love you seek is also seeking you. Trust the cosmic timing of heart connections.',
      'Your heart knows what your mind can\'t comprehend. Deep soul bonds form when we surrender to love\'s mysterious ways.',
      'Past life connections may surface. That instant recognition, that unexplainable familiarity - these are soul signatures.',
      'Deep connections take time but are meaningful. Nurture your heart connections and value your relationships.',
    ];
  }

  static List<String> getVenusInfluence(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Venüs bugün aşk sektörünüzü kutsuyor. Güzellik, uyum ve romantik fırsatlar bol. Aşkın yol göstermesine izin verin.',
        'Aşk gezegeni çekiciliğinizi artırıyor. Başkalarını yakına çeken çekici bir enerji yayıyorsunuz. Bu manyetizmayı akıllıca kullanın.',
        'Venüs kalıcı aşktan fısıldıyor. Bugün kurulan temeller yıllarca ilişkileri destekleyebilir. Partnerleri akıllıca seçin.',
        'Venüs\'ün bakışı altında, aşk yumuşar ve tatlanır. Sert sözler erir, çatışmalar çözülür. Şefkatin iyileştirici gücünü kucaklayın.',
      ];
    }
    return [
      'Venus blesses your love sector today. Beauty, harmony, and romantic opportunities abound. Let love lead the way.',
      'The planet of love amplifies your charm. You radiate attractive energy that draws others near. Use this magnetism wisely.',
      'Venus whispers of lasting love. Foundations built today can support relationships for years to come. Choose partners wisely.',
      'Under Venus\' gaze, love softens and sweetens. Harsh words dissolve, conflicts resolve. Embrace the healing power of affection.',
    ];
  }

  static List<String> getIntimacyAdvice(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return [
        'Duygusal yakınlık fiziksel bağlantıyı derinleştirir. İç dünyanızı, korkularınızı ve hayallerinizi paylaşın. Savunmasızlık en derin bağları yaratır.',
        'Bariyerler düştüğünde tutku akar. Ketlerden kurtulun, otantik ifadeyi kucaklayın. Gerçek yakınlık cesaret gerektirir.',
        'Kutsal duyusallık bugün uyanıyor. Bedeninizi ve partnerinizinkini zevk tapınakları olarak onurlandırın. Farkındalıklı mevcudiyet her dokunuşu artırır.',
        'Yakınlık, kelimesiz bir sohbettir. Kalbinizle dinleyin, ruhunuzla karşılık verin. Beden aşkın dilini konuşur.',
      ];
    }
    return [
      'Emotional intimacy deepens physical connection. Share your inner world, your fears and dreams. Vulnerability creates the deepest bonds.',
      'Passion flows when barriers fall. Let go of inhibitions, embrace authentic expression. True intimacy requires courage.',
      'Sacred sensuality awakens today. Honor your body and your partner\'s as temples of pleasure. Mindful presence enhances every touch.',
      'Intimacy is a conversation without words. Listen with your heart, respond with your soul. The body speaks the language of love.',
    ];
  }
}
