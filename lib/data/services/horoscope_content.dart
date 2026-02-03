import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';

/// Centralized horoscope content provider with multi-language support.
/// All horoscope texts are stored here and accessed via language parameter.
class HoroscopeContent {
  HoroscopeContent._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ESOTERIC SUMMARIES - Burç bazlı mistik özetler
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getEsotericSummaries(ZodiacSign sign, AppLanguage lang) {
    final content = _esotericSummaries[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _esotericSummaries = {
    ZodiacSign.aries: {
      AppLanguage.tr: [
        'Ateş senin içinde yanmaktan yorulmaz, çünkü sen ateşin ta kendisisin. Bugün ruhun, başlangıcın gizli sırrını hatırlamak için uyanıyor. Öncü olmak kaderindir - ama bu sefer, savaşmak yerine aydınlatmak için ileri atıl. İçindeki savaşçı şimdi bilge bir lider olarak dönüşüyor.',
        'Mars enerjisi bugün damarlarında volkanik bir güç gibi akıyor. Eski ezoterik öğretiler, Koç burcunun ruhunun "İlk Işık" olduğunu söyler - karanlıktan önce var olan, yaratımın kendisi olan ışık. Bugün o ışığı taşımak için çağırıldın. Korkusuzca parla.',
        'Kozmik savaşçı arketipi içinde uyanıyor. Cesaretinin kökü, maddi dünyada değil, ruhsal alemde yatıyor. Bugün eylemlerinin arkasındaki niyet, sonucundan daha önemli. Bilincinle hareket et.',
      ],
      AppLanguage.en: [
        'The fire within you never tires of burning, because you are the fire itself. Today your soul awakens to remember the secret of beginnings. Being a pioneer is your destiny - but this time, step forward to illuminate rather than fight. The warrior within you is now transforming into a wise leader.',
        'Mars energy flows through your veins like volcanic power today. Ancient esoteric teachings say that the soul of Aries is the "First Light" - the light that existed before darkness, the creation itself. Today you are called to carry that light. Shine fearlessly.',
        'The cosmic warrior archetype awakens within you. The root of your courage lies not in the material world, but in the spiritual realm. Today the intention behind your actions is more important than the outcome. Move with consciousness.',
      ],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: [
        'Toprak ananın kutsal kızı olarak, bugün bedeninin bir tapınak olduğunu hatırla. Her nefes, her lokma, her dokunuşun içinde tanrısallık saklı. Venüs seni maddi dünyanın ötesinde bir güzelliğe çağırıyor - ruhun güzelliğine.',
        'Boğanın sabırlılığı, aslında zamansız bilgeliğe erişimin anahtarıdır. Acelenin olmadığı yerde, evren sırlarını fısıldamaya başlar. Bugün yavaşla ve dinle - toprağın altında akan kadim nehirlerin sesini duyacaksın.',
        'Değerlilik duygum bugün sıcak bir ışık gibi içinde parlayacak. Sen, evrenin en nadide hazinelerinden birisin. Bu bir ego tatmini değil - bu, Venüs\'ün sana hatırlatmak istediği kozmik bir gerçek. Kendinle barışık ol.',
      ],
      AppLanguage.en: [
        'As the sacred daughter of Mother Earth, remember today that your body is a temple. Divinity is hidden in every breath, every bite, every touch. Venus calls you to a beauty beyond the material world - the beauty of the soul.',
        'The patience of Taurus is actually the key to accessing timeless wisdom. Where there is no rush, the universe begins to whisper its secrets. Slow down today and listen - you will hear the sound of ancient rivers flowing beneath the earth.',
        'Your sense of worth will shine like a warm light within you today. You are one of the universe\'s rarest treasures. This is not ego gratification - this is a cosmic truth that Venus wants to remind you of. Be at peace with yourself.',
      ],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: [
        'İkizlerin gizemi, birliğin içindeki çokluktadır. Bugün zihnin, bin bir gece masallarındaki sihirli halı gibi - seni farklı alemlere taşıyacak. Her düşünce bir kapı, her kelime bir anahtar. Merkür seni bilginin labirentlerinde gezintiye çıkarıyor.',
        'Simyacıların "kutsal evlilik"i, içindeki erkek ve dişi enerjilerin birleşimini temsil eder. İkizler burcu olarak, bu dengeyi doğal olarak taşıyorsun. Bugün iç sesinle dış sesin arasında köprü kur.',
        'Hafiflik senin süper gücün. Kelebeğin kanat çırpışı nasıl uzaklarda fırtınalar yaratırsa, sen de bugün küçük ama derin etkiler bırakacaksın. Konuşmalarının arkasındaki niyet, kelimelerin ötesine taşacak.',
      ],
      AppLanguage.en: [
        'The mystery of the Twins lies in the plurality within unity. Today your mind is like the magic carpet from Arabian Nights - it will carry you to different realms. Every thought is a door, every word is a key. Mercury takes you on a journey through the labyrinths of knowledge.',
        'The alchemists\' "sacred marriage" represents the union of masculine and feminine energies within you. As a Gemini, you naturally carry this balance. Today, build a bridge between your inner voice and outer voice.',
        'Lightness is your superpower. Just as a butterfly\'s wing flutter creates storms far away, you too will leave small but profound effects today. The intention behind your conversations will transcend words.',
      ],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: [
        'Ay\'ın evladı olarak, duygu okyanusunun derinliklerinde hazineler saklıyorsun. Bugün, iç dünyanı keşfetme zamanı. Kabuğunun altında, evrenin tüm sırları kodlanmış durumda. Sezgilerine güven - onlar yıldızlardan gelen mesajlar.',
        'Anne arketipi içinde canlanıyor - ama bu sadece başkalarını beslemek değil, önce kendini beslemek demek. Yengeç, geriye doğru yürür çünkü bazen ilerlemenin yolu geçmişe bakmaktan geçer. Bugün eski yaraları iyileştirme fırsatın var.',
        'Suların hafızası vardır ve sen o hafızanın taşıyıcısısın. Atalarının bilgeliği bugün rüyalarında ve sezgilerinde konuşacak. Dinle - çünkü onlar seni korumak ve yönlendirmek için buradalar.',
      ],
      AppLanguage.en: [
        'As a child of the Moon, you hide treasures in the depths of the emotional ocean. Today is the time to explore your inner world. Beneath your shell, all the secrets of the universe are encoded. Trust your intuitions - they are messages from the stars.',
        'The Mother archetype comes alive within you - but this means nourishing yourself first, not just others. The Crab walks backward because sometimes the path forward lies in looking back. Today you have the opportunity to heal old wounds.',
        'Waters have memory and you are the carrier of that memory. The wisdom of your ancestors will speak in your dreams and intuitions today. Listen - because they are here to protect and guide you.',
      ],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: [
        'Güneşin kraliyet çocuğu olarak, bugün tahtına oturma zamanı. Ama bu bir ego oyunu değil - gerçek krallık, başkalarının ışığını da parlatmaktır. Senin ışığın, karanlıkta kaybolmuş ruhlara yol gösterecek.',
        'Aslanın kükremesi, evrenin yaratıcı gücünün sesidir. Bugün yaratıcılığın doruklarda - ister sanat olsun, ister bir proje, ister bir ilişki. Her yaratış, tanrısal enerjinin maddeye dönüşmesidir.',
        'Altının simyası içinde gerçekleşiyor. Ham madde altına dönüştüğü gibi, sen de bugün en yüksek potansiyeline doğru evriliyorsun. Güneş seni kutsayarak parlatıyor.',
      ],
      AppLanguage.en: [
        'As the royal child of the Sun, today is the time to take your throne. But this is not an ego game - true royalty is making others\' light shine too. Your light will guide souls lost in darkness.',
        'The lion\'s roar is the voice of the universe\'s creative power. Today your creativity is at its peak - whether it\'s art, a project, or a relationship. Every creation is divine energy transforming into matter.',
        'The alchemy of gold is happening within you. Just as raw material transforms into gold, you are evolving toward your highest potential today. The Sun blesses and makes you shine.',
      ],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: [
        'Kutsal bakire arketipi, saflığın ve bütünlüğün sembolüdür. Bugün detaylarda tanrıyı göreceksin - her küçük düzende, her ince ayarda ilahi bir düzen saklı. Merkür seni mükemmelliğin peşine değil, anlamlılığın peşine yönlendiriyor.',
        'Şifacı arketipi bugün güçleniyor. Ama önce kendini iyileştirmelisin. Başkalarına sunduğun hizmet, önce kendi ruhuna sunduğun sevgiden akmalı. Kendine şefkat göster.',
        'Başak burcunun gizli gücü, kaosu düzene çevirebilme yeteneğidir. Bugün zihinsel berraklık dorukta - karmaşık durumlar basitleşiyor, çözümler belirginleşiyor. Bu bir armağan - iyi kullan.',
      ],
      AppLanguage.en: [
        'The sacred virgin archetype is the symbol of purity and wholeness. Today you will see the divine in details - in every small order, every fine adjustment, a divine order is hidden. Mercury guides you not toward perfection, but toward meaningfulness.',
        'The healer archetype is strengthening today. But first you must heal yourself. The service you offer others must flow from the love you first give to your own soul. Show yourself compassion.',
        'The secret power of Virgo is the ability to turn chaos into order. Today mental clarity is at its peak - complex situations are simplifying, solutions are becoming clear. This is a gift - use it well.',
      ],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: [
        'Dengenin ustası olarak, bugün iç ve dış dünyanın uyumunu sağlamaya çağırılıyorsun. Terazinin iki kefesi, ruhun iki yarısı gibidir - birini ihmal etmek, bütünü bozmak demektir. Venüs seni güzelliğin ötesinde bir ahenke davet ediyor.',
        'İlişkiler senin aynan - ama aynanın iki yüzü var. Bugün başkalarında gördüğün, aslında kendindeki saklılığı gösteriyor. Bu bir çağrı: kendini tanımak için başkalarını kullan, ama kendini onlarda kaybetme.',
        'Harmoni arayışı asla sona ermeyen bir danstır. Bugün o dansın ritmine güven. Bazen öne çık, bazen geri çekil - ama her zaman müziği dinle. Evren senin partnerin.',
      ],
      AppLanguage.en: [
        'As the master of balance, today you are called to harmonize the inner and outer worlds. The two pans of the scale are like the two halves of your soul - neglecting one means disrupting the whole. Venus invites you to a harmony beyond beauty.',
        'Relationships are your mirror - but the mirror has two sides. What you see in others today actually shows what is hidden in yourself. This is a call: use others to know yourself, but don\'t lose yourself in them.',
        'The search for harmony is a dance that never ends. Today, trust the rhythm of that dance. Sometimes step forward, sometimes step back - but always listen to the music. The universe is your partner.',
      ],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: [
        'Ölüm ve yeniden doğuş efendisi olarak, bugün bir dönüşümün eşiğindesin. Plüton\'un karanlık suları seni çağırıyor - korkma, çünkü derinliklerde altın parlıyor. Eski benliğini bırakma zamanı.',
        'Akrebin zehri, aynı zamanda şifadır - bu paradoksu sen herkesten iyi bilirsin. Bugün gölge yanının elini tut. Onu reddetmek yerine, onu dönüştürmeyi seç. Gücün orada saklı.',
        'Tutku senin yakıt kaynağın, ama yanlış yöne aktığında yıkıcı olabilir. Bugün tutkularını bilinçli bir şekilde yönlendir. Obsesyon yerine, derin bağlılık. Kontrol yerine, teslimiyet.',
      ],
      AppLanguage.en: [
        'As the master of death and rebirth, today you are on the threshold of transformation. Pluto\'s dark waters call you - don\'t be afraid, because gold shines in the depths. It\'s time to release your old self.',
        'The scorpion\'s venom is also medicine - you know this paradox better than anyone. Today, hold the hand of your shadow side. Instead of rejecting it, choose to transform it. Your power is hidden there.',
        'Passion is your fuel source, but it can be destructive when flowing in the wrong direction. Today, consciously direct your passions. Deep commitment instead of obsession. Surrender instead of control.',
      ],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: [
        'Kozmik gezgin olarak, bugün fiziksel değil ruhsal bir yolculuğa çıkıyorsun. Jüpiter seni sınırların ötesine, bilinen dünyanın kenarlarına çağırıyor. Orada ne bulacaksın? Belki de her zaman aradığın cevap: kendin.',
        'Okun hedefi, sadece uzaktaki bir nokta değil - o nokta senin en yüksek potansiyelin. Bugün nişan al, ama acelenin olmadığını fark et. Okun uçuşu, hedefe varmasından daha değerlidir.',
        'Filozof arketipi içinde uyanıyor. Sorular cevaplardan daha kıymetli. Bugün "neden" diye sormaktan çekinme - evren, meraklılarına sırlarını fısıldar.',
      ],
      AppLanguage.en: [
        'As a cosmic traveler, today you embark on a spiritual journey, not a physical one. Jupiter calls you beyond limits, to the edges of the known world. What will you find there? Perhaps the answer you\'ve always sought: yourself.',
        'The arrow\'s target is not just a distant point - that point is your highest potential. Today, take aim, but realize there\'s no rush. The arrow\'s flight is more valuable than reaching the target.',
        'The philosopher archetype awakens within you. Questions are more precious than answers. Today, don\'t hesitate to ask "why" - the universe whispers its secrets to the curious.',
      ],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: [
        'Dağın zirvesine tırman, ama zirve seni bekliyor olması değil, yolculuğun seni dönüştürmesi önemlidir. Satürn sana sabır ve disiplin veriyor - ama bugün bunların ötesinde bir şey var: içsel otorite.',
        'Zamanın efendisi olarak, bugün geçmiş ve geleceğin arasındaki ince çizgide duruyorsun. Atalarının mirası omuzlarında, ama yükü taşımak değil, onu dönüştürmek senin görevin.',
        'Oğlak burcunun gizli yüzü, karanlığın içinde bile parlayan yıldızdır. Dışarıdan soğuk görünebilirsin, ama içinde bir volkan var. Bugün o içsel ateşi onurlandır.',
      ],
      AppLanguage.en: [
        'Climb the mountain peak, but what matters is not that the peak awaits you, but that the journey transforms you. Saturn gives you patience and discipline - but today there\'s something beyond: inner authority.',
        'As the master of time, today you stand on the thin line between past and future. Your ancestors\' legacy is on your shoulders, but your task is not to carry the burden, but to transform it.',
        'The secret face of Capricorn is the star that shines even in darkness. You may appear cold on the outside, but there\'s a volcano within. Today, honor that inner fire.',
      ],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: [
        'Geleceğin taşıyıcısı olarak, bugün zamanın ötesinden gelen mesajları alıyorsun. Uranüs seni konfor bölgenin dışına itiyor - orası büyümenin gerçekleştiği yer. Farklılığın senin armağanın.',
        'Kolektif bilincin çanağısın - ama önce kendi bilincini temizlemelisin. Bugün zihinsel netlik önemli. Başkalarının düşüncelerinden ayrı, kendinin düşüncelerini bul.',
        'Devrimci ruh içinde yanıyor. Ama gerçek devrim, önce iç dünyada başlar. Bugün eski kalıpları kır - ama yenilerini inşa etmeyi de unutma.',
      ],
      AppLanguage.en: [
        'As the carrier of the future, today you receive messages from beyond time. Uranus pushes you outside your comfort zone - that\'s where growth happens. Your difference is your gift.',
        'You are the vessel of collective consciousness - but first you must cleanse your own consciousness. Mental clarity is important today. Find your own thoughts, separate from others\' thoughts.',
        'The revolutionary spirit burns within you. But true revolution begins first in the inner world. Today, break old patterns - but don\'t forget to build new ones.',
      ],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: [
        'Rüyaların ve gerçekliğin sınırlarını eriten mistik olarak, bugün iki dünya arasında köprü kuruyorsun. Neptün seni hayalin ötesine, vizyonun alemine çağırıyor. Orada gördüklerini dünyaya getir.',
        'Okyanusun damlası olarak, tüm okyanusun bilgisini taşıyorsun. Bugün sezgilerin açık - görünmeyeni görecek, duyulmayanı duyacaksın. Bu bir lanet değil, bir armağan.',
        'Şifa veren yaralı arketipi içinde canlanıyor. Kendi acıların, başkalarını iyileştirmeni sağlayan ilaç oldu. Bugün o ilacı paylaş - ama kendine de bir doz ayır.',
      ],
      AppLanguage.en: [
        'As the mystic who dissolves the boundaries between dreams and reality, today you build a bridge between two worlds. Neptune calls you beyond imagination, to the realm of vision. Bring what you see there to the world.',
        'As a drop of the ocean, you carry the knowledge of the entire ocean. Today your intuitions are open - you will see the unseen, hear the unheard. This is not a curse, but a gift.',
        'The wounded healer archetype comes alive within you. Your own pain became the medicine that heals others. Today, share that medicine - but save a dose for yourself.',
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // LOVE ADVICES - Aşk tavsiyeleri
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getLoveAdvices(AppLanguage lang) {
    return _loveAdvices[lang] ?? _loveAdvices[AppLanguage.tr]!;
  }

  static final Map<AppLanguage, List<String>> _loveAdvices = {
    AppLanguage.tr: [
      'Aşk, ruhun aynaya bakışıdır. Bugün partnerinde gördüğün, aslında kendi iç dünyanın yansımasıdır. Bu yansımaya sevgiyle bak - çünkü kendini sevmeden başkasını sevemezsin.',
      'Kalpten kalbe uzanan görünmez ipler var. Bugün o ipleri hisset - kimi çekiyor, kimi itiyor? Çekimi takip et, ama bilincini kaybetme. Aşk bir teslimiyet, ama bilinçli bir teslimiyet.',
      'Kutsal birleşme, iki yarının bütün olması değil - iki bütünün birleşmesidir. Önce kendin bütün ol. Sonra başka bir bütünle dans et. Bu, gerçek aşkın simyası.',
      'Venüs bugün kalbini okşuyor. Eski yaralar iyileşiyor, yeni kapılar açılıyor. Aşk kapına geldiğinde, onu tanıyacak mısın? Bazen aşk, beklediğimiz kılıkta gelmez.',
      'Ruh eşinin arayışı, aslında kendi ruhunun arayışıdır. Dışarıda aradığın, içinde zaten var. Bugün iç denize dal - orada seni bekleyen bir hazine var.',
      'Bağ kurmak, zincirlemek değil - köprü inşa etmektir. Bugün ilişkilerindeki köprüleri güçlendir. Ama köprünün iki ucunun da sağlam olması gerek.',
      'Aşkın alevi, kontrol edilmezse yakar. Ama bilinçli alev, aydınlatır ve ısıtır. Bugün tutkunu bilinçle harmanla. Sonuç: dönüştürücü bir ilişki.',
      'Kalp çakran bugün aktif. Yeşilin şifa gücünü hisset. Geçmişte kırılmış kalbin artık kaynıyor. Yeni bağlar kurmaya hazırsın.',
    ],
    AppLanguage.en: [
      'Love is the soul looking in a mirror. What you see in your partner today is actually a reflection of your inner world. Look at this reflection with love - because you cannot love another without loving yourself.',
      'There are invisible threads extending from heart to heart. Feel those threads today - which ones pull, which ones push? Follow the pull, but don\'t lose your awareness. Love is surrender, but conscious surrender.',
      'Sacred union is not two halves becoming whole - it is two wholes uniting. First, become whole yourself. Then dance with another whole. This is the alchemy of true love.',
      'Venus caresses your heart today. Old wounds are healing, new doors are opening. When love comes to your door, will you recognize it? Sometimes love doesn\'t come in the guise we expect.',
      'The search for your soulmate is actually the search for your own soul. What you seek outside already exists within. Today, dive into the inner sea - a treasure awaits you there.',
      'Making connections is not chaining - it\'s building bridges. Today, strengthen the bridges in your relationships. But both ends of the bridge need to be solid.',
      'The flame of love burns when uncontrolled. But conscious flame illuminates and warms. Today, blend your passion with awareness. The result: a transformative relationship.',
      'Your heart chakra is active today. Feel the healing power of green. Your broken heart from the past is now mending. You are ready to form new bonds.',
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CAREER ADVICES - Kariyer tavsiyeleri
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getCareerAdvices(AppLanguage lang) {
    return _careerAdvices[lang] ?? _careerAdvices[AppLanguage.tr]!;
  }

  static final Map<AppLanguage, List<String>> _careerAdvices = {
    AppLanguage.tr: [
      'İş hayatın, ruhani yolculuğunun bir yansımasıdır. Bugün yaptığın işin arkasındaki derin anlamı keşfet. Para kazanmak değil, değer yaratmak - işte gerçek zenginlik.',
      'Yeteneklerin, evrenin sana verdiği hediyelerdir. Bugün o hediyeleri dünyayla paylaş. Korku değil, cömertlik rehberin olsun. Verdikçe alacaksın.',
      'Liderlik, önde yürümek değil - ışık tutmaktır. Bugün başkalarına yol gösterme fırsatın var. Ama önce kendi yolunu aydınlat.',
      'Maddi dünya, ruhani dünyanın aynasıdır. Kariyer hedeflerin, ruhani hedeflerinle uyumlu mu? Bugün bu soruyu kendine sor. Cevap seni şaşırtabilir.',
      'Başarının gerçek ölçüsü, ne kadar kazandığın değil - ne kadar anlamlı iş yaptığındır. Bugün anlam ara. Onu bulduğunda, başarı peşinden gelecek.',
      'Bolluk bilinci bugün aktive oluyor. Kıtlık korkusunu bırak. Evren sonsuz bolluk sunuyor - seni sınırlayan sadece inançların.',
      'Yaratıcılığının profesyonel alandaki gücünü keşfet. Bugün alışıldık yolları terk et. Yenilikçi fikirlerin, seni farklı kılacak.',
      'Sabır ve zamanlama her şey. Bugün aceleci kararlar verme. Bekle, gözle, sonra hareket et. Evrenin ritmiyle uyumlu ol.',
    ],
    AppLanguage.en: [
      'Your work life is a reflection of your spiritual journey. Discover the deeper meaning behind your work today. Creating value, not making money - that\'s true wealth.',
      'Your talents are gifts from the universe. Share those gifts with the world today. Let generosity, not fear, be your guide. The more you give, the more you receive.',
      'Leadership is not walking ahead - it\'s holding the light. Today you have the opportunity to guide others. But first, illuminate your own path.',
      'The material world is a mirror of the spiritual world. Are your career goals aligned with your spiritual goals? Ask yourself this question today. The answer may surprise you.',
      'The true measure of success is not how much you earn - but how meaningful your work is. Seek meaning today. When you find it, success will follow.',
      'Abundance consciousness activates today. Let go of scarcity fear. The universe offers infinite abundance - only your beliefs limit you.',
      'Discover the power of your creativity in the professional arena. Leave conventional paths today. Your innovative ideas will set you apart.',
      'Patience and timing are everything. Don\'t make hasty decisions today. Wait, observe, then act. Be in harmony with the universe\'s rhythm.',
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HEALTH ADVICES - Sağlık tavsiyeleri
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getHealthAdvices(AppLanguage lang) {
    return _healthAdvices[lang] ?? _healthAdvices[AppLanguage.tr]!;
  }

  static final Map<AppLanguage, List<String>> _healthAdvices = {
    AppLanguage.tr: [
      'Bedenin, ruhunun tapınağıdır. Bugün o tapınağı onurlandır. Her lokma bir ayin, her nefes bir dua, her hareket bir dans olsun.',
      'Enerji bedenin bugün hassas. Çevrendeki enerjilere dikkat et. Seni tüketen ortamlardan uzaklaş, seni besleyen ortamlara yakın dur.',
      'Topraklama bugün önemli. Çıplak ayaklarını toprağa bas, ellerini sulara değdir. Doğayla bağlanmak, en güçlü şifadır.',
      'Nefes, yaşam gücünün taşıyıcısıdır. Bugün bilinçli nefes al. Her nefesle ışık al, her verişle karanlık bırak.',
      'Uyku, küçük ölümdür - ve her uyku, yeniden doğuştur. Bugün uyku düzenine dikkat et. Rüyaların mesajlar taşıyor.',
      'Su elementiyle çalışmak bugün şifa getirecek. Banyo yap, yüz, ya da sadece suyu izle. Su, duygu bedenini arındırıyor.',
      'Hareket meditasyonu bugün sana uygun. Yoga, dans, ya da sadece yürüyüş - bedenini bilinçle hareket ettir.',
      'Kök çakra bugün dikkat istiyor. Güvenlik, istikrar, topraklanma - bunlara odaklan. Temeller sağlam olunca, üst katlar güvende.',
    ],
    AppLanguage.en: [
      'Your body is the temple of your soul. Honor that temple today. Let every bite be a ritual, every breath a prayer, every movement a dance.',
      'Your energy body is sensitive today. Pay attention to the energies around you. Distance yourself from draining environments, stay close to nourishing ones.',
      'Grounding is important today. Place your bare feet on the earth, touch your hands to water. Connecting with nature is the most powerful healing.',
      'Breath is the carrier of life force. Breathe consciously today. Take in light with each inhale, release darkness with each exhale.',
      'Sleep is a small death - and every sleep is a rebirth. Pay attention to your sleep pattern today. Your dreams carry messages.',
      'Working with the water element will bring healing today. Take a bath, swim, or just watch water. Water purifies your emotional body.',
      'Movement meditation suits you today. Yoga, dance, or just walking - move your body with awareness.',
      'The root chakra demands attention today. Security, stability, grounding - focus on these. When foundations are solid, the upper floors are safe.',
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MOODS - Ruh halleri
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getMoods(AppLanguage lang) {
    return _moods[lang] ?? _moods[AppLanguage.tr]!;
  }

  static final Map<AppLanguage, List<String>> _moods = {
    AppLanguage.tr: [
      'Sezgisel', 'Dönüşümde', 'Aydınlanmış', 'Topraklı', 'Akışta',
      'Uyanan', 'Alıcı', 'Yaratıcı', 'Mistik', 'Bütünleşmiş', 'Ateşli', 'Dingin',
    ],
    AppLanguage.en: [
      'Intuitive', 'Transforming', 'Enlightened', 'Grounded', 'Flowing',
      'Awakening', 'Receptive', 'Creative', 'Mystical', 'Integrated', 'Fiery', 'Serene',
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED COLORS - Burç bazlı kutsal renkler
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getSacredColors(ZodiacSign sign, AppLanguage lang) {
    final content = _sacredColors[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _sacredColors = {
    ZodiacSign.aries: {
      AppLanguage.tr: ['Ateş Kırmızısı', 'Altın', 'Turuncu', 'Mercan'],
      AppLanguage.en: ['Fire Red', 'Gold', 'Orange', 'Coral'],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: ['Zümrüt Yeşili', 'Gül Pembesi', 'Toprak Tonları', 'Bakır'],
      AppLanguage.en: ['Emerald Green', 'Rose Pink', 'Earth Tones', 'Copper'],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: ['Lavanta', 'Gök Mavisi', 'Sarı', 'Gümüş'],
      AppLanguage.en: ['Lavender', 'Sky Blue', 'Yellow', 'Silver'],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: ['İnci Beyazı', 'Ay Gümüşü', 'Deniz Mavisi', 'Sedef'],
      AppLanguage.en: ['Pearl White', 'Moon Silver', 'Sea Blue', 'Nacre'],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: ['Güneş Altını', 'Kraliyet Kırmızısı', 'Turuncu', 'Bronz'],
      AppLanguage.en: ['Sun Gold', 'Royal Red', 'Orange', 'Bronze'],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: ['Orman Yeşili', 'Bej', 'Krem', 'Buğday Rengi'],
      AppLanguage.en: ['Forest Green', 'Beige', 'Cream', 'Wheat'],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: ['Gül Kuvarsi', 'Pastel Mavi', 'Fildişi', 'Bakır'],
      AppLanguage.en: ['Rose Quartz', 'Pastel Blue', 'Ivory', 'Copper'],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: ['Bordo', 'Siyah', 'Koyu Mor', 'Kan Kırmızısı'],
      AppLanguage.en: ['Burgundy', 'Black', 'Deep Purple', 'Blood Red'],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: ['Kraliyet Moru', 'Turkuaz', 'Safir Mavisi', 'İndigo'],
      AppLanguage.en: ['Royal Purple', 'Turquoise', 'Sapphire Blue', 'Indigo'],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: ['Derin Kahve', 'Koyu Yeşil', 'Antrasit', 'Obsidyen'],
      AppLanguage.en: ['Deep Brown', 'Dark Green', 'Anthracite', 'Obsidian'],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: ['Elektrik Mavisi', 'Mor', 'Teal', 'Platin'],
      AppLanguage.en: ['Electric Blue', 'Purple', 'Teal', 'Platinum'],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: ['Deniz Yeşili', 'Lavanta', 'Akuamarin', 'Opal'],
      AppLanguage.en: ['Sea Green', 'Lavender', 'Aquamarine', 'Opal'],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // COSMIC MESSAGES - Evrenin günlük mesajları
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getCosmicMessages(ZodiacSign sign, AppLanguage lang) {
    final content = _cosmicMessages[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _cosmicMessages = {
    ZodiacSign.aries: {
      AppLanguage.tr: [
        '🔥 Bugün cesaretin rehberin, kalbin pusulan olsun.',
        '⚔️ İçindeki savaşçı bilge, dışındaki dünya hazır.',
        '🌟 Işığını yakma zamanı - dünya seni görmeyi bekliyor.',
      ],
      AppLanguage.en: [
        '🔥 Let your courage be your guide, your heart your compass today.',
        '⚔️ The warrior within is wise, the world outside is ready.',
        '🌟 Time to ignite your light - the world awaits to see you.',
      ],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: [
        '🌿 Sabır en güçlü büyün, şükran en derin şifan.',
        '💎 Değerini bil, çünkü evren senin değerini biliyor.',
        '🌸 Güzellik peşinde koşma, güzellik zaten sensin.',
      ],
      AppLanguage.en: [
        '🌿 Patience is your strongest magic, gratitude your deepest healing.',
        '💎 Know your worth, for the universe knows your value.',
        '🌸 Don\'t chase beauty, you already are beauty.',
      ],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: [
        '🦋 Değişim seni korkutmasın, sen değişimin kendisisin.',
        '💫 Her düşünce bir tohum, dikkatli seç ve ek.',
        '🌬️ Kelimelerinle dünyalar yarat, bilgeliğinle köprüler kur.',
      ],
      AppLanguage.en: [
        '🦋 Don\'t let change frighten you, you are change itself.',
        '💫 Every thought is a seed, choose and plant carefully.',
        '🌬️ Create worlds with your words, build bridges with your wisdom.',
      ],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: [
        '🌙 Duygularını kucakla, onlar senin süper gücün.',
        '🏠 İç evin güvende, dış dünyaya oradan bak.',
        '🌊 Akışa güven, dalga seni doğru kıyıya taşıyacak.',
      ],
      AppLanguage.en: [
        '🌙 Embrace your emotions, they are your superpower.',
        '🏠 Your inner home is safe, look at the outer world from there.',
        '🌊 Trust the flow, the wave will carry you to the right shore.',
      ],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: [
        '☀️ Parladığında dünya daha aydınlık bir yer oluyor.',
        '👑 Gerçek krallık kalplerde hüküm sürmektir.',
        '🎭 Sahne seninle dolsun, ama başrolü egona verme.',
      ],
      AppLanguage.en: [
        '☀️ When you shine, the world becomes a brighter place.',
        '👑 True royalty is ruling in hearts.',
        '🎭 Let the stage be filled with you, but don\'t give the lead to your ego.',
      ],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: [
        '🌾 Mükemmel olan sensin, mükemmeliyetçilik değil.',
        '💚 Önce kendini iyileştir, sonra dünyayı.',
        '✨ Detaylarda kaybolma, büyük resmi de gör.',
      ],
      AppLanguage.en: [
        '🌾 You are what\'s perfect, not perfectionism.',
        '💚 First heal yourself, then the world.',
        '✨ Don\'t get lost in details, see the big picture too.',
      ],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: [
        '⚖️ Denge içeride başlar, dışarısı yansıma.',
        '🌹 Güzellik gözlerinde, harmoni kalbinde.',
        '🤝 İlişkilerin aynan - kendini orda gör.',
      ],
      AppLanguage.en: [
        '⚖️ Balance begins within, the outside is a reflection.',
        '🌹 Beauty in your eyes, harmony in your heart.',
        '🤝 Your relationships are your mirror - see yourself there.',
      ],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: [
        '🦂 Karanlık seni korkutmaz, sen karanlığı aydınlatırsın.',
        '🔮 Dönüşüm senin doğan, her gün yeniden doğ.',
        '💜 Tutkunun gücü seni yakar veya aydınlatır - sen seç.',
      ],
      AppLanguage.en: [
        '🦂 Darkness doesn\'t scare you, you illuminate the darkness.',
        '🔮 Transformation is your nature, be reborn every day.',
        '💜 The power of your passion burns or illuminates you - you choose.',
      ],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: [
        '🏹 Hedefine odaklan, ok çoktan yaydan çıktı.',
        '🗺️ Yolculuk varış noktasından değerli.',
        '🔥 Özgürlük içeride, dışarıdaki zincirler yanılsama.',
      ],
      AppLanguage.en: [
        '🏹 Focus on your target, the arrow has already left the bow.',
        '🗺️ The journey is more valuable than the destination.',
        '🔥 Freedom is within, the chains outside are illusion.',
      ],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: [
        '🏔️ Zirve sabırlıları bekler, sen zaten yoldasın.',
        '⏳ Zaman senin müttefikin, ona karşı değil onunla çalış.',
        '🏛️ İnşa ettiğin her şey miras, bilinçle yap.',
      ],
      AppLanguage.en: [
        '🏔️ The summit awaits the patient, you are already on your way.',
        '⏳ Time is your ally, work with it not against it.',
        '🏛️ Everything you build is legacy, do it consciously.',
      ],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: [
        '⚡ Farklılığın armağanın, normallik senin için değil.',
        '🌐 Kolektif kalbinde, ama bireysel ışığını koru.',
        '🚀 Geleceği görmek yetmez, onu yaratmak da gerek.',
      ],
      AppLanguage.en: [
        '⚡ Your difference is your gift, normality is not for you.',
        '🌐 Collective in your heart, but protect your individual light.',
        '🚀 Seeing the future isn\'t enough, you must also create it.',
      ],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: [
        '🐟 İki dünya arasında köprüsün, her ikisinde de evdesin.',
        '🌌 Rüyaların gerçeğin tohumları, onları sulamayı unutma.',
        '💙 Sezgilerin pusulandan keskin, ona güven.',
      ],
      AppLanguage.en: [
        '🐟 You are a bridge between two worlds, at home in both.',
        '🌌 Your dreams are seeds of reality, don\'t forget to water them.',
        '💙 Your intuitions are sharper than a compass, trust them.',
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PAST INSIGHTS - Geçmişin yankısı
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getPastInsights(ZodiacSign sign, AppLanguage lang) {
    final content = _pastInsights[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _pastInsights = {
    ZodiacSign.aries: {
      AppLanguage.tr: [
        'Geçmişte attığın cesur adımların meyvelerini bugün topluyorsun. O zaman göze aldığın riskler, şimdi seni güçlendiren deneyimlere dönüştü.',
        'Mars enerjisinin geçmişteki izleri bugün belirginleşiyor. Bir zamanlar savaştığın ama kazanamadığını düşündüğün bir mücadele var mı?',
        'Atalarından gelen savaşçı ruhu taşıyorsun. Onların cesareti, senin damarlarında akıyor.',
      ],
      AppLanguage.en: [
        'Today you harvest the fruits of the brave steps you took in the past. The risks you took then have transformed into experiences that strengthen you now.',
        'The traces of Mars energy from the past are becoming evident today. Is there a battle you fought but thought you didn\'t win?',
        'You carry the warrior spirit from your ancestors. Their courage flows in your veins.',
      ],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: [
        'Geçmişte ektiğin tohumlar artık filizleniyor. Sabırla beklediğin zamanlar boşa gitmedi; evren her şeyi kayıt altına aldı.',
        'Venüs\'ün geçmişteki izleri kalbinde hâlâ canlı. Bir zamanlar çok değer verdiğin ama kaybettiğini düşündüğün bir şey aslında hiç kaybolmadı.',
        'Toprak hafızası atalarının bilgeliğini taşır. Onların el emeği, alın teri, sabırla inşa ettikleri her şey senin DNA\'nda kodlu.',
      ],
      AppLanguage.en: [
        'The seeds you planted in the past are now sprouting. The times you waited patiently were not in vain; the universe recorded everything.',
        'The traces of Venus from the past are still alive in your heart. Something you once valued deeply but thought you lost was never really lost.',
        'Earth memory carries the wisdom of your ancestors. Their handiwork, their sweat, everything they patiently built is coded in your DNA.',
      ],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: [
        'Geçmişte söylediğin veya söyleyemediğin kelimeler bugün yankılanıyor. İletişimin gücünü o zaman tam anlamamış olabilirsin.',
        'Merkür\'ün hafızasında saklı sırlar var. Geçmişte öğrendiğin ama kullanmadığın bir bilgi, bugün hayatına anlam katacak.',
        'Zihnin bir zaman makinesi gibi çalışıyor. Geçmişe seyahat ettiğinde, oradan sadece nostalji değil, bilgelik de getir.',
      ],
      AppLanguage.en: [
        'The words you said or couldn\'t say in the past echo today. You may not have fully understood the power of communication then.',
        'There are secrets hidden in Mercury\'s memory. Knowledge you learned but didn\'t use in the past will add meaning to your life today.',
        'Your mind works like a time machine. When you travel to the past, bring back wisdom, not just nostalgia.',
      ],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: [
        'Ay\'ın kadim hafızası, geçmişin tüm duygusal izlerini taşır. Çocukluğundan gelen bir his, bir koku, bir melodi bugün ani bir şekilde geri gelebilir.',
        'Aile ağacının kökleri derinlere uzanıyor. Atalarının sevinçleri, acıları, umutları ve korkuları senin hücrelerinde yaşıyor.',
        'Duygusal hafızan bir hazine sandığı gibi. İçinde hem ışıltılı mücevherler hem de eski yaralar var.',
      ],
      AppLanguage.en: [
        'The Moon\'s ancient memory carries all the emotional traces of the past. A feeling, a smell, a melody from your childhood may suddenly return today.',
        'The roots of your family tree extend deep. Your ancestors\' joys, pains, hopes, and fears live in your cells.',
        'Your emotional memory is like a treasure chest. Inside are both glittering jewels and old wounds.',
      ],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: [
        'Geçmişte parlak bir yıldız gibi ışıdığın anlar var. O anların enerjisi hâlâ seninle.',
        'Güneş\'in kadim hafızası, kralların ve kraliçelerin bilgeliğini taşır. Geçmiş hayatlarında belki de tahtlarda oturdun.',
        'Bir zamanlar sahip olduğun ama kaybettiğini düşündüğün bir güç var. Belki özgüvenin, belki yaratıcılığın.',
      ],
      AppLanguage.en: [
        'There are moments in the past when you shone like a bright star. The energy of those moments is still with you.',
        'The Sun\'s ancient memory carries the wisdom of kings and queens. Perhaps in past lives you sat on thrones.',
        'There is a power you once had but thought you lost. Perhaps your confidence, perhaps your creativity.',
      ],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: [
        'Geçmişte mükemmeliyetçiliğin seni yorduğu zamanlar oldu. Her detayı kontrol etmeye çalışırken, büyük resmi kaçırmış olabilirsin.',
        'Merkür\'ün analitik hafızası, geçmişin her detayını kaydetmiş. Ama bu kayıtlar seni hapsetmek için değil, özgürleştirmek için var.',
        'Şifacı arketipinin geçmişi derin. Belki de geçmişte başkalarını iyileştirirken kendini ihmal ettin.',
      ],
      AppLanguage.en: [
        'There were times in the past when your perfectionism tired you. While trying to control every detail, you may have missed the big picture.',
        'Mercury\'s analytical memory has recorded every detail of the past. But these records exist to free you, not imprison you.',
        'The healer archetype has a deep past. Perhaps in the past you neglected yourself while healing others.',
      ],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: [
        'Geçmişte kurduğun dengeler ve bozulan dengeler, bugünün temelini oluşturuyor.',
        'Venüs\'ün geçmişteki izleri, güzellik arayışının tarihçesidir. Geçmişte güzel bulduğun şeyler değişti mi?',
        'Adalet terazisinin geçmişi ağır. Belki de geçmişte haksızlığa uğradın veya farkında olmadan haksızlık ettin.',
      ],
      AppLanguage.en: [
        'The balances you established and broke in the past form the foundation of today.',
        'Venus\'s traces from the past are the history of your search for beauty. Have the things you found beautiful in the past changed?',
        'The past of the justice scale is heavy. Perhaps in the past you were wronged or unknowingly caused injustice.',
      ],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: [
        'Geçmişte öldüğün ve yeniden doğduğun kaç kez oldu? Her dönüşüm seni daha güçlü kıldı.',
        'Plüton\'un karanlık hafızası, gizli sırlar ve derin dönüşümler barındırıyor.',
        'Bir zamanlar büyük bir kayıp yaşadın - belki bir ilişki, belki bir parça benliğin. O kayıp seni şekillendirdi.',
      ],
      AppLanguage.en: [
        'How many times have you died and been reborn in the past? Each transformation made you stronger.',
        'Pluto\'s dark memory holds secret secrets and deep transformations.',
        'You once experienced a great loss - perhaps a relationship, perhaps a part of yourself. That loss shaped you.',
      ],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: [
        'Geçmişte çıktığın yolculuklar - fiziksel veya ruhsal - bugün senin kim olduğunun haritasını çizdi.',
        'Jüpiter\'in genişleyen hafızası, sınırları aşma çabalarının tarihidir.',
        'Okçunun geçmişi, attığı okların izini taşır. Her ok bir niyet, bir umut, bir hayaldi.',
      ],
      AppLanguage.en: [
        'The journeys you took in the past - physical or spiritual - drew the map of who you are today.',
        'Jupiter\'s expanding memory is the history of your efforts to transcend boundaries.',
        'The archer\'s past carries the traces of the arrows shot. Each arrow was an intention, a hope, a dream.',
      ],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: [
        'Geçmişte tırmandığın dağlar, bugünkü zirvenin temeli. Her zorlu adım, her soğuk gece seni güçlendirdi.',
        'Satürn\'ün ağır hafızası, zamanın ve sınırların bilincini taşır.',
        'Atalarının inşa ettikleri - evler, aileler, gelenekler - senin mirasın.',
      ],
      AppLanguage.en: [
        'The mountains you climbed in the past are the foundation of today\'s peak. Every difficult step, every cold night strengthened you.',
        'Saturn\'s heavy memory carries the consciousness of time and boundaries.',
        'What your ancestors built - homes, families, traditions - is your legacy.',
      ],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: [
        'Geçmişte farklı olduğun için dışlandığın zamanlar oldu mu? O anlar seni kırmadı, aksine benzersizliğini keşfetmeni sağladı.',
        'Uranüs\'ün devrimci hafızası, kırılan zincirlerin ve yıkılan duvarların tarihidir.',
        'Kolektif bilinçle bağın, geçmişte bazen bunaltıcı oldu. Herkesin acısını hissetmek yorucu.',
      ],
      AppLanguage.en: [
        'Were there times in the past when you were excluded for being different? Those moments didn\'t break you, they helped you discover your uniqueness.',
        'Uranus\'s revolutionary memory is the history of broken chains and demolished walls.',
        'Your connection with collective consciousness was sometimes overwhelming in the past. Feeling everyone\'s pain is exhausting.',
      ],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: [
        'Geçmişte rüyalar ve gerçeklik arasında kaybolduğun zamanlar oldu. O bulanık sınırlar seni korkutmuş olabilir.',
        'Neptün\'ün sisli hafızası, geçmiş hayatların ve paralel gerçekliklerin izlerini taşır.',
        'Okyanusun hafızası sonsuz. Geçmişte akıttığın her gözyaşı, yaşadığın her duygu o okyanusu besledi.',
      ],
      AppLanguage.en: [
        'There were times in the past when you got lost between dreams and reality. Those blurry boundaries may have frightened you.',
        'Neptune\'s misty memory carries traces of past lives and parallel realities.',
        'The ocean\'s memory is infinite. Every tear you shed, every emotion you felt in the past fed that ocean.',
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PRESENT ENERGIES - Şimdinin enerjisi
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getPresentEnergies(ZodiacSign sign, AppLanguage lang) {
    final content = _presentEnergies[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _presentEnergies = {
    ZodiacSign.aries: {
      AppLanguage.tr: [
        'Şu an, içindeki ateş en parlak haliyle yanıyor. Bu an, harekete geçme zamanı.',
        'Mars enerjisi tam şu an zirvede. Bedeninde bir titreşim, bir hazırlık hissi var mı?',
        'Bu an, öncü ruhunun sahneye çıkma zamanı. Çevrende herkes beklerken, sen ilk adımı at.',
      ],
      AppLanguage.en: [
        'Right now, the fire within you burns at its brightest. This is the moment to take action.',
        'Mars energy is at its peak right now. Do you feel a vibration, a sense of readiness in your body?',
        'This is the moment for your pioneer spirit to take the stage. While everyone waits, you take the first step.',
      ],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: [
        'Şu an, beş duyunun en keskin olduğu zaman. Dokunduğun her şey, tattığın her lokma mesaj veriyor.',
        'Venüs enerjisi şu an seni sarmalıyor. Güzellik her yerde, ama onu görmek için yavaşlamalısın.',
        'Toprak elementi şu an seni destekliyor. Ayaklarının altındaki sağlamlığı hisset.',
      ],
      AppLanguage.en: [
        'Right now, your five senses are at their sharpest. Everything you touch, every bite you taste sends a message.',
        'Venus energy wraps around you right now. Beauty is everywhere, but you must slow down to see it.',
        'The earth element supports you right now. Feel the solidity beneath your feet.',
      ],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: [
        'Şu an, zihnin bin kanatlı bir kelebek gibi. Fikirler, bağlantılar, olasılıklar her yerde.',
        'Merkür tam şu an seninle konuşuyor. Kulak ver - kelimeler, işaretler, rastlantılar hepsi anlam taşıyor.',
        'İletişim kanalların şu an sonuna kadar açık. Söylemek istediğin bir şey var mı? Şimdi söyle.',
      ],
      AppLanguage.en: [
        'Right now, your mind is like a butterfly with a thousand wings. Ideas, connections, possibilities everywhere.',
        'Mercury is speaking to you right now. Listen - words, signs, coincidences all carry meaning.',
        'Your communication channels are wide open right now. Is there something you want to say? Say it now.',
      ],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: [
        'Şu an, duygusal okyanusun sakin bir koy gibi. Bu dinginlikte derin ol.',
        'Ay enerjisi şu an seni koruyor. Kabuğunun içinde güvende hisset.',
        'Sezgilerin şu an zirve yapıyor. Mantık bir kenarda, içgüdüler ön planda.',
      ],
      AppLanguage.en: [
        'Right now, your emotional ocean is like a calm bay. Go deep in this tranquility.',
        'Moon energy protects you right now. Feel safe inside your shell.',
        'Your intuitions are peaking right now. Logic aside, instincts in the foreground.',
      ],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: [
        'Şu an, Güneş senin için doğuyor. Işığın her zamankinden parlak.',
        'Yaratıcı enerjin şu an volkanik. İçinden bir şey dışarı çıkmak istiyor.',
        'Kraliyet enerjisi şu an zirvede. Liderlik etme, ilham verme zamanı.',
      ],
      AppLanguage.en: [
        'Right now, the Sun rises for you. Your light is brighter than ever.',
        'Your creative energy is volcanic right now. Something wants to come out from within.',
        'Royal energy is at its peak right now. Time to lead, to inspire.',
      ],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: [
        'Şu an, detaylar netleşiyor. Daha önce görmediğin şeyleri görüyorsun.',
        'Merkür\'ün analitik gücü şu an seninle. Karmaşık durumlar basitleşiyor.',
        'Şifacı enerjin şu an aktif. Kendinde veya başkalarında iyileştirme fırsatı var.',
      ],
      AppLanguage.en: [
        'Right now, details are becoming clear. You see things you didn\'t see before.',
        'Mercury\'s analytical power is with you right now. Complex situations are simplifying.',
        'Your healer energy is active right now. There\'s an opportunity for healing in yourself or others.',
      ],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: [
        'Şu an, denge noktasındasın. Ne geçmişte ne gelecekte - tam burada, tam şimdi.',
        'Venüs enerjisi şu an ilişkilerini aydınlatıyor. Çevrendeki insanları gerçekten gör.',
        'Estetik duyarlılığın şu an keskin. Güzellik her yerde, ama çirkinlik de görünür.',
      ],
      AppLanguage.en: [
        'Right now, you are at the balance point. Neither in the past nor the future - right here, right now.',
        'Venus energy illuminates your relationships right now. Really see the people around you.',
        'Your aesthetic sensitivity is sharp right now. Beauty is everywhere, but ugliness is also visible.',
      ],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: [
        'Şu an, dönüşümün tam ortasındasın. Bir şey ölüyor, bir şey doğuyor.',
        'Plüton enerjisi şu an yoğun. Derinlerde bir şeyler kıpırdıyor.',
        'Tutku ve güç şu an zirve yapıyor. Bu enerjiyi bilinçli yönlendir.',
      ],
      AppLanguage.en: [
        'Right now, you are in the midst of transformation. Something is dying, something is being born.',
        'Pluto energy is intense right now. Something stirs in the depths.',
        'Passion and power are peaking right now. Direct this energy consciously.',
      ],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: [
        'Şu an, ufuklar sonsuza açılıyor. Her yön bir olasılık, her yol bir macera.',
        'Jüpiter enerjisi şu an seni genişletiyor. Sınırların esniyorsun.',
        'Felsefi zihnin şu an aktif. Büyük sorular, derin düşünceler.',
      ],
      AppLanguage.en: [
        'Right now, horizons open to infinity. Every direction a possibility, every path an adventure.',
        'Jupiter energy expands you right now. Your boundaries are stretching.',
        'Your philosophical mind is active right now. Big questions, deep thoughts.',
      ],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: [
        'Şu an, dağın tam yamacındasın. Ne başlangıç ne zirve - yolculuğun ortası.',
        'Satürn enerjisi şu an seni disipline çağırıyor. Yapı, düzen, sorumluluk.',
        'İçsel otorite şu an güçleniyor. Dışarıdan onay aramayı bırak.',
      ],
      AppLanguage.en: [
        'Right now, you are on the mountainside. Neither the beginning nor the peak - the middle of the journey.',
        'Saturn energy calls you to discipline right now. Structure, order, responsibility.',
        'Inner authority strengthens right now. Stop seeking approval from outside.',
      ],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: [
        'Şu an, sıradışı olan normal. Farklılığın, benzersizliğin kabul görüyor.',
        'Uranüs enerjisi şu an elektrik gibi. Ani fikirler, beklenmedik bağlantılar.',
        'Kolektif bilinçle bağın şu an güçlü. İnsanlığın nabzını hissediyorsun.',
      ],
      AppLanguage.en: [
        'Right now, the unusual is normal. Your difference, your uniqueness is accepted.',
        'Uranus energy is like electricity right now. Sudden ideas, unexpected connections.',
        'Your connection with collective consciousness is strong right now. You feel humanity\'s pulse.',
      ],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: [
        'Şu an, iki dünya arasında köprüdesin. Görünen ve görünmeyen birleşiyor.',
        'Neptün enerjisi şu an buğulu bir perde gibi. Her şey biraz silik, biraz belirsiz.',
        'Sezgisel kapasiten şu an sonuna kadar açık. Hissettiğin her şey gerçek.',
      ],
      AppLanguage.en: [
        'Right now, you are a bridge between two worlds. The visible and invisible merge.',
        'Neptune energy is like a misty veil right now. Everything is a bit hazy, a bit unclear.',
        'Your intuitive capacity is wide open right now. Everything you feel is real.',
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FUTURE GUIDANCES - Geleceğin fısıltısı
  // ═══════════════════════════════════════════════════════════════════════════

  static List<String> getFutureGuidances(ZodiacSign sign, AppLanguage lang) {
    final content = _futureGuidances[sign];
    if (content == null) return [];
    return content[lang] ?? content[AppLanguage.tr] ?? [];
  }

  static final Map<ZodiacSign, Map<AppLanguage, List<String>>> _futureGuidances = {
    ZodiacSign.aries: {
      AppLanguage.tr: [
        'Gelecek, senin için yeni savaş alanları değil, yeni zafer alanları hazırlıyor.',
        'Ufukta parlayan ışık, yeni başlangıçların habercisi. Ama bu sefer acele etme.',
        'Mars önümüzdeki dönemde seni destekleyecek, ama farklı bir şekilde. Ham güç yerine, rafine güç.',
      ],
      AppLanguage.en: [
        'The future prepares new victory fields for you, not new battlefields.',
        'The light shining on the horizon heralds new beginnings. But this time don\'t rush.',
        'Mars will support you in the coming period, but differently. Refined power instead of raw power.',
      ],
    },
    ZodiacSign.taurus: {
      AppLanguage.tr: [
        'Gelecek, bolluk vaadediyor - ama bu bolluk sadece maddi değil. Ruhsal zenginlik de.',
        'Venüs önümüzdeki dönemde sana güzellik ve uyum getirecek.',
        'Toprak elementi gelecekte seni taşımaya devam edecek, ama yeni bir biçimde.',
      ],
      AppLanguage.en: [
        'The future promises abundance - but this abundance is not just material. Spiritual wealth too.',
        'Venus will bring you beauty and harmony in the coming period.',
        'The earth element will continue to carry you in the future, but in a new form.',
      ],
    },
    ZodiacSign.gemini: {
      AppLanguage.tr: [
        'Gelecek, senin için bilgi ve bilgeliğin birleştiği bir dönem.',
        'Merkür gelecekte sana yeni iletişim kanalları açacak.',
        'İkili doğan gelecekte bütünleşme fırsatı bulacak.',
      ],
      AppLanguage.en: [
        'The future is a period where knowledge and wisdom merge for you.',
        'Mercury will open new communication channels for you in the future.',
        'The twin nature will find an opportunity for integration in the future.',
      ],
    },
    ZodiacSign.cancer: {
      AppLanguage.tr: [
        'Gelecek, evinin - hem fiziksel hem ruhsal - dönüşümünü getiriyor.',
        'Ay döngüleri önümüzdeki dönemde seni destekleyecek.',
        'Aile bağların gelecekte yeni bir biçim alacak.',
      ],
      AppLanguage.en: [
        'The future brings the transformation of your home - both physical and spiritual.',
        'Moon cycles will support you in the coming period.',
        'Your family ties will take a new form in the future.',
      ],
    },
    ZodiacSign.leo: {
      AppLanguage.tr: [
        'Gelecek, senin için yaratıcı patlama zamanı.',
        'Güneş önümüzdeki dönemde seni özel bir şekilde aydınlatacak.',
        'Liderlik rolün gelecekte evrilecek.',
      ],
      AppLanguage.en: [
        'The future is a time of creative explosion for you.',
        'The Sun will illuminate you in a special way in the coming period.',
        'Your leadership role will evolve in the future.',
      ],
    },
    ZodiacSign.virgo: {
      AppLanguage.tr: [
        'Gelecek, senin için mükemmeliyetçiliğin rahatladığı bir dönem.',
        'Merkür önümüzdeki dönemde pratik zekana destek verecek.',
        'Şifacı rolün gelecekte derinleşecek.',
      ],
      AppLanguage.en: [
        'The future is a period when your perfectionism relaxes.',
        'Mercury will support your practical intelligence in the coming period.',
        'Your healer role will deepen in the future.',
      ],
    },
    ZodiacSign.libra: {
      AppLanguage.tr: [
        'Gelecek, ilişkilerinde köklü değişiklikler getiriyor.',
        'Venüs önümüzdeki dönemde aşk alanını canlandıracak.',
        'Adalet arayışın gelecekte karşılık bulacak.',
      ],
      AppLanguage.en: [
        'The future brings fundamental changes in your relationships.',
        'Venus will enliven the love area in the coming period.',
        'Your search for justice will be answered in the future.',
      ],
    },
    ZodiacSign.scorpio: {
      AppLanguage.tr: [
        'Gelecek, senin için büyük dönüşümün tamamlandığı dönem.',
        'Plüton önümüzdeki dönemde sana güç ve derinlik verecek.',
        'Gizli yeteneklerin gelecekte ortaya çıkacak.',
      ],
      AppLanguage.en: [
        'The future is the period when your great transformation is completed.',
        'Pluto will give you power and depth in the coming period.',
        'Your hidden talents will emerge in the future.',
      ],
    },
    ZodiacSign.sagittarius: {
      AppLanguage.tr: [
        'Gelecek, uzun zamandır hayal ettiğin macerayı getiriyor.',
        'Jüpiter önümüzdeki dönemde kapıları ardına kadar açacak.',
        'Öğretmen rolün gelecekte belirginleşecek.',
      ],
      AppLanguage.en: [
        'The future brings the adventure you\'ve long dreamed of.',
        'Jupiter will open doors wide in the coming period.',
        'Your teacher role will become more prominent in the future.',
      ],
    },
    ZodiacSign.capricorn: {
      AppLanguage.tr: [
        'Gelecek, zirveye ulaşmanın zamanı. Yıllarca tırmandığın dağın tepesi görünüyor.',
        'Satürn önümüzdeki dönemde ödülleri dağıtacak.',
        'Miras ve gelenek konuları gelecekte önem kazanacak.',
      ],
      AppLanguage.en: [
        'The future is the time to reach the summit. The peak of the mountain you\'ve climbed for years is visible.',
        'Saturn will distribute rewards in the coming period.',
        'Legacy and tradition matters will gain importance in the future.',
      ],
    },
    ZodiacSign.aquarius: {
      AppLanguage.tr: [
        'Gelecek, vizyonlarının gerçekleşme zamanı.',
        'Uranüs önümüzdeki dönemde beklenmedik kapılar açacak.',
        'Topluluk ve kolektif çalışma gelecekte öne çıkacak.',
      ],
      AppLanguage.en: [
        'The future is the time for your visions to manifest.',
        'Uranus will open unexpected doors in the coming period.',
        'Community and collective work will come to the fore in the future.',
      ],
    },
    ZodiacSign.pisces: {
      AppLanguage.tr: [
        'Gelecek, rüyalarının gerçeğe dönüştüğü dönem.',
        'Neptün önümüzdeki dönemde ilhamı artıracak.',
        'Şifa yolculuğun gelecekte tamamlanmaya yaklaşıyor.',
      ],
      AppLanguage.en: [
        'The future is the period when your dreams turn into reality.',
        'Neptune will increase inspiration in the coming period.',
        'Your healing journey is nearing completion in the future.',
      ],
    },
  };
}
