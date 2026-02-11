/// INSIGHT CARDS CONTENT - Part 3: Saturn, Uranus, Neptune, Pluto
///
/// Final part of insight cards. See insight_cards_content.dart for class definition.
/// Apple App Store 4.3(b) compliant. No predictive language.
library;

import 'insight_cards_content.dart';
import 'insight_cards_content_part2.dart';

// =============================================================================
// SATURN ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> saturnInsightCards = [
  InsightCard(
    id: 'saturn_01',
    categoryKey: 'saturn',
    titleEn: 'The Architecture of Your Habits',
    titleTr: 'Alışkanlıklarınızın Mimarisi',
    bodyEn:
        'Your daily habits are the invisible scaffolding that holds your life together. Some were chosen consciously; others formed without your awareness. The Saturn archetype invites you to examine this architecture honestly and ask which structures support who you are becoming and which ones hold you in place.',
    bodyTr:
        'Günlük alışkanlıklarınız hayatınızı bir arada tutan görünmez iskele yapısıdır. Bazıları bilinçli olarak seçildi; diğerleri farkındalığınız olmadan oluştu. Satürn arketipi, bu mimariyi dürüstçe incelemenizi ve hangi yapıların olmakta olduğunuz kişiyi desteklediğini, hangilerinin sizi yerinde tuttuğunu sormanızı davet eder.',
    reflectionEn:
        'Which habit serves your growth, and which one are you maintaining out of inertia?',
    reflectionTr:
        'Hangi alışkanlık büyümenize hizmet ediyor ve hangisini ataletinizden dolayı sürdürüyorsunuz?',
    tagsEn: ['habits', 'structure', 'self-examination'],
    tagsTr: ['alışkanlıklar', 'yapı', 'öz-inceleme'],
  ),
  InsightCard(
    id: 'saturn_02',
    categoryKey: 'saturn',
    titleEn: 'The Gift of Limits',
    titleTr: 'Sınırların Hediyesi',
    bodyEn:
        'Limitations are often viewed as obstacles, but they can also be creative catalysts. A painter with fewer colors must find more inventive solutions. A life with constraints can develop a focus and resourcefulness that unlimited freedom rarely produces. Consider where your current limits might actually be shaping you in valuable ways.',
    bodyTr:
        'Sınırlamalar genellikle engel olarak görülür, ancak yaratıcı katalizörler de olabilir. Daha az renge sahip bir ressam daha yaratıcı çözümler bulmalıdır. Kısıtlamaları olan bir yaşam, sınırsız özgürlüğün nadiren ürettiği bir odaklanma ve beceriklilik geliştirebilir. Mevcut sınırlarınızın sizi aslında değerli şekillerde nasıl biçimlendiriyor olabileceğini düşünün.',
    reflectionEn:
        'What limitation in your life has unexpectedly taught you something valuable?',
    reflectionTr:
        'Hayatınızdaki hangi sınırlama size beklenmedik şekilde değerli bir şey öğretti?',
    tagsEn: ['limits', 'creativity', 'resourcefulness'],
    tagsTr: ['sınırlar', 'yaratıcılık', 'beceriklilik'],
  ),
  InsightCard(
    id: 'saturn_03',
    categoryKey: 'saturn',
    titleEn: 'Integrity When No One Watches',
    titleTr: 'Kimse İzlemezken Bütünlük',
    bodyEn:
        'The choices you make when no one is watching reveal your character more honestly than any public performance. The Saturn archetype values the quiet discipline of living according to your values even when there is no audience to appreciate it. These private moments of integrity build a foundation of self-trust.',
    bodyTr:
        'Kimse izlemezken yaptığınız seçimler, karakterinizi herhangi bir kamusal performanstan daha dürüstçe ortaya koyar. Satürn arketipi, takdir edecek bir izleyici olmasa bile değerlerinize göre yaşamanın sessiz disiplinine değer verir. Bu özel bütünlük anları öz-güvenin temelini inşa eder.',
    reflectionEn:
        'What choice did you make today that no one saw but that you are proud of?',
    reflectionTr:
        'Bugün kimsenin görmediği ama gurur duyduğunuz hangi seçimi yaptınız?',
    tagsEn: ['integrity', 'character', 'self-trust'],
    tagsTr: ['bütünlük', 'karakter', 'öz-güven'],
  ),
  InsightCard(
    id: 'saturn_04',
    categoryKey: 'saturn',
    titleEn: 'Time as a Teacher',
    titleTr: 'Öğretmen Olarak Zaman',
    bodyEn:
        'The relationship you have with time shapes everything else. If time feels like an enemy, life becomes a race. If time feels like an ally, patience becomes possible and depth replaces speed. The Saturn archetype invites you to explore how your relationship with time affects the quality of your experience.',
    bodyTr:
        'Zamanla olan ilişkiniz diğer her şeyi şekillendirir. Zaman bir düşman gibi hissedilirse, yaşam bir yarış olur. Zaman bir müttefik gibi hissedilirse, sabır mümkün hale gelir ve derinlik hızın yerini alır. Satürn arketipi, zamanla ilişkinizin deneyiminizin kalitesini nasıl etkilediğini keşfetmenizi davet eder.',
    reflectionEn:
        'Is time your ally or your enemy right now, and what would change if you shifted that relationship?',
    reflectionTr:
        'Şu anda zaman müttefikiniz mi yoksa düşmanınız mı ve bu ilişkiyi değiştirseniz ne değişirdi?',
    tagsEn: ['time', 'patience', 'perspective'],
    tagsTr: ['zaman', 'sabır', 'perspektif'],
  ),
  InsightCard(
    id: 'saturn_05',
    categoryKey: 'saturn',
    titleEn: 'Earned Confidence',
    titleTr: 'Kazanılmış Güven',
    bodyEn:
        'There is a difference between borrowed confidence and earned confidence. Borrowed confidence depends on external praise and crumbles when it is withdrawn. Earned confidence is built through the accumulation of small acts of discipline, follow-through, and honest self-assessment. It is quieter but far more durable.',
    bodyTr:
        'Ödünç alınmış güven ile kazanılmış güven arasında fark vardır. Ödünç alınmış güven dışsal övgüye bağlıdır ve geri çekildiğinde yıkılır. Kazanılmış güven, küçük disiplin eylemleri, sonuna kadar götürme ve dürüst öz-değerlendirmenin birikimi yoluyla inşa edilir. Daha sessizdir ancak çok daha dayanıklıdır.',
    reflectionEn:
        'What have you earned through sustained effort that no one can take from you?',
    reflectionTr:
        'Sürekli çabayla kimsenin sizden alamayacağı ne kazandınız?',
    tagsEn: ['confidence', 'discipline', 'self-trust'],
    tagsTr: ['güven', 'disiplin', 'öz-güven'],
  ),
  InsightCard(
    id: 'saturn_06',
    categoryKey: 'saturn',
    titleEn: 'The Weight of Responsibility',
    titleTr: 'Sorumluluğun Ağırlığı',
    bodyEn:
        'Carrying responsibility can feel heavy, but it also carries a quiet dignity. The Saturn archetype invites you to distinguish between responsibilities you have genuinely chosen and those you have absorbed from others without questioning. Not every burden with your name on it actually belongs to you.',
    bodyTr:
        'Sorumluluk taşımak ağır hissedebilir, ancak aynı zamanda sessiz bir haysiyet taşır. Satürn arketipi, gerçekten seçtiğiniz sorumluluklar ile sorgulamadan başkalarından emdiğiniz sorumlulukları ayırt etmenizi davet eder. Üzerinde adınız yazan her yük gerçekten size ait değildir.',
    reflectionEn:
        'What responsibility are you carrying that might actually belong to someone else?',
    reflectionTr:
        'Aslında başka birine ait olabilecek hangi sorumluluğu taşıyorsunuz?',
    tagsEn: ['responsibility', 'boundaries', 'discernment'],
    tagsTr: ['sorumluluk', 'sınırlar', 'ayırt-etme'],
  ),
  InsightCard(
    id: 'saturn_07',
    categoryKey: 'saturn',
    titleEn: 'Slow Growth Is Still Growth',
    titleTr: 'Yavaş Büyüme Yine de Büyümedir',
    bodyEn:
        'In a culture that celebrates overnight success and rapid transformation, slow growth can feel like failure. But the deepest roots take the longest to develop. The Saturn archetype honors the work that cannot be rushed: the patient building of skill, character, and genuine understanding over seasons and years.',
    bodyTr:
        'Bir gecede başarıyı ve hızlı dönüşümü kutlayan bir kültürde, yavaş büyüme başarısızlık gibi hissedebilir. Ancak en derin kökler gelişmek için en uzun zamanı alır. Satürn arketipi, acele edilemeyecek işi onurlandırır: mevsimler ve yıllar boyunca beceri, karakter ve gerçek anlayışın sabırlı inşası.',
    reflectionEn:
        'What area of your life is growing slowly but surely, even if it is hard to see day to day?',
    reflectionTr:
        'Hayatınızın hangi alanı günden güne görmek zor olsa da yavaş ama emin adımlarla büyüyor?',
    tagsEn: ['patience', 'growth', 'perseverance'],
    tagsTr: ['sabır', 'büyüme', 'sebat'],
  ),
  InsightCard(
    id: 'saturn_08',
    categoryKey: 'saturn',
    titleEn: 'Boundaries as Love',
    titleTr: 'Sevgi Olarak Sınırlar',
    bodyEn:
        'A boundary is not a wall. It is a clear statement of where you end and where another person begins. Setting boundaries is not selfish; it is essential for healthy relationships. When you communicate your limits with clarity and compassion, you make it possible for others to truly know and respect you.',
    bodyTr:
        'Sınır bir duvar değildir. Nerede bittiğinizin ve başka bir kişinin nerede başladığının net bir ifadesidir. Sınır koymak bencillik değildir; sağlıklı ilişkiler için esastır. Sınırlarınızı netlik ve şefkatle ilettiğinizde, başkalarının sizi gerçekten tanımasını ve saygı göstermesini mümkün kılarsınız.',
    reflectionEn:
        'Where do you need to set a boundary that you have been avoiding?',
    reflectionTr:
        'Kaçınmakta olduğunuz nereye bir sınır koymanız gerekiyor?',
    tagsEn: ['boundaries', 'relationships', 'self-respect'],
    tagsTr: ['sınırlar', 'ilişkiler', 'öz-saygı'],
  ),
  InsightCard(
    id: 'saturn_09',
    categoryKey: 'saturn',
    titleEn: 'Mastery Through Repetition',
    titleTr: 'Tekrar Yoluyla Ustalık',
    bodyEn:
        'There is a depth that only comes through repetition. Doing something once teaches you about it; doing it a hundred times teaches you about yourself. The Saturn archetype finds profound satisfaction in the gradual refinement that practice brings, the way a rough stone becomes smooth through the patient work of water.',
    bodyTr:
        'Sadece tekrar yoluyla gelen bir derinlik vardır. Bir şeyi bir kez yapmak size o şey hakkında öğretir; yüz kez yapmak kendiniz hakkında öğretir. Satürn arketipi, pratiğin getirdiği kademeli incelikte, kaba bir taşın suyun sabırlı çalışmasıyla pürüzsüz hale gelmesinde derin bir tatmin bulur.',
    reflectionEn:
        'What practice in your life has taught you more about yourself than about the skill itself?',
    reflectionTr:
        'Hayatınızdaki hangi pratik size becerinin kendisinden çok kendiniz hakkında öğretti?',
    tagsEn: ['mastery', 'practice', 'discipline'],
    tagsTr: ['ustalık', 'pratik', 'disiplin'],
  ),
  InsightCard(
    id: 'saturn_10',
    categoryKey: 'saturn',
    titleEn: 'Choosing What to Carry',
    titleTr: 'Neyi Taşıyacağınızı Seçmek',
    bodyEn:
        'You cannot carry everything. Every commitment, obligation, and worry occupies space in your life and your psyche. The Saturn archetype respects the reality of finite energy and finite time. Choosing consciously what to carry and what to set down is not abandonment; it is wisdom.',
    bodyTr:
        'Her şeyi taşıyamazsınız. Her taahhüt, zorunluluk ve endişe hayatınızda ve psikenizde yer kaplar. Satürn arketipi sınırlı enerji ve sınırlı zaman gerçekliğine saygı duyar. Neyi taşıyacağınızı ve neyi bırakacağınızı bilinçli olarak seçmek terk etme değildir; bilgeliktir.',
    reflectionEn:
        'What are you carrying right now that you could consciously choose to set down?',
    reflectionTr:
        'Şu anda bilinçli olarak bırakmayı seçebileceğiniz neyi taşıyorsunuz?',
    tagsEn: ['priorities', 'letting-go', 'wisdom'],
    tagsTr: ['öncelikler', 'bırakma', 'bilgelik'],
  ),
  InsightCard(
    id: 'saturn_11',
    categoryKey: 'saturn',
    titleEn: 'Accepting What Cannot Be Changed',
    titleTr: 'Değiştirilemeyeni Kabul Etmek',
    bodyEn:
        'Some things in life are beyond your control: other people\'s choices, the passage of time, events that have already occurred. The Saturn archetype teaches that acceptance is not resignation. It is the intelligent redirection of your energy from fighting the unchangeable toward engaging with what you can actually influence.',
    bodyTr:
        'Hayattaki bazı şeyler kontrolünüzün ötesindedir: başkalarının seçimleri, zamanın geçişi, çoktan gerçekleşmiş olaylar. Satürn arketipi, kabulün teslimiyet olmadığını öğretir. Enerjinizi değiştirilemezle savaşmaktan, gerçekten etkileyebileceğiniz şeyle ilgilenmeye akıllıca yeniden yönlendirmektir.',
    reflectionEn:
        'What are you still trying to change that might be asking for acceptance instead?',
    reflectionTr:
        'Bunun yerine kabul istiyor olabilecek neyi hala değiştirmeye çalışıyorsunuz?',
    tagsEn: ['acceptance', 'wisdom', 'control'],
    tagsTr: ['kabul', 'bilgelik', 'kontrol'],
  ),
  InsightCard(
    id: 'saturn_12',
    categoryKey: 'saturn',
    titleEn: 'Legacy of Daily Choices',
    titleTr: 'Günlük Seçimlerin Mirası',
    bodyEn:
        'Your legacy is not built in grand gestures but in the accumulation of daily choices. How you treat people when you are tired, what you prioritize when no one is keeping score, the small kindnesses that seem insignificant in the moment. The Saturn archetype understands that character is what remains when everything else is stripped away.',
    bodyTr:
        'Mirasınız büyük jestlerle değil, günlük seçimlerin birikmesiyle inşa edilir. Yorgunken insanlara nasıl davrandığınız, kimse puan tutmazken neyi önceliklendirdiğiniz, o anda önemsiz görünen küçük nezaketler. Satürn arketipi, her şey soyulduğunda geriye kalanın karakter olduğunu anlar.',
    reflectionEn:
        'What small choice did you make today that reflects the person you want to become?',
    reflectionTr:
        'Bugün olmak istediğiniz kişiyi yansıtan hangi küçük seçimi yaptınız?',
    tagsEn: ['legacy', 'character', 'daily-practice'],
    tagsTr: ['miras', 'karakter', 'günlük-pratik'],
  ),
];

// =============================================================================
// URANUS ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> uranusInsightCards = [
  InsightCard(
    id: 'uranus_01',
    categoryKey: 'uranus',
    titleEn: 'The Freedom of Authenticity',
    titleTr: 'Otantikliğin Özgürlüğü',
    bodyEn:
        'The heaviest burden you can carry is the weight of pretending to be someone you are not. Every act of authentic self-expression, even a small one, lightens that load. The Uranus archetype celebrates the radical freedom that comes from choosing truth over conformity, even when conformity would be easier.',
    bodyTr:
        'Taşıyabileceğiniz en ağır yük, olmadığınız biri gibi davranmanın ağırlığıdır. Her otantik kendini ifade eylemi, küçük bile olsa, bu yükü hafifletir. Uranüs arketipi, uyum daha kolay olsa bile, uyum yerine gerçeği seçmekten gelen radikal özgürlüğü kutlar.',
    reflectionEn:
        'Where are you conforming for comfort, and what would authenticity look like there?',
    reflectionTr:
        'Konfor için nerede uymaya çalışıyorsunuz ve orada otantiklik neye benzerdi?',
    tagsEn: ['authenticity', 'freedom', 'conformity'],
    tagsTr: ['otantiklik', 'özgürlük', 'uyum'],
  ),
  InsightCard(
    id: 'uranus_02',
    categoryKey: 'uranus',
    titleEn: 'Breaking Invisible Rules',
    titleTr: 'Görünmez Kuralları Kırmak',
    bodyEn:
        'Many of the rules that govern your behavior were never consciously chosen. They were absorbed from family, school, culture, and social circles. The Uranus archetype invites you to identify these invisible rules and ask whether they still serve you. Not to rebel for its own sake, but to choose consciously which guidelines to keep.',
    bodyTr:
        'Davranışınızı yöneten kuralların çoğu hiçbir zaman bilinçli olarak seçilmemiştir. Aile, okul, kültür ve sosyal çevrelerden emilmiştir. Uranüs arketipi, bu görünmez kuralları belirlemenizi ve hala size hizmet edip etmediğini sormanızı davet eder. Kendi başına isyan için değil, hangi yönergeleri tutacağınızı bilinçli olarak seçmek için.',
    reflectionEn:
        'What unwritten rule are you following that you never consciously agreed to?',
    reflectionTr:
        'Hiçbir zaman bilinçli olarak onaylamadığınız hangi yazılmamış kuralı izliyorsunuz?',
    tagsEn: ['rules', 'consciousness', 'choice'],
    tagsTr: ['kurallar', 'bilinç', 'seçim'],
  ),
  InsightCard(
    id: 'uranus_03',
    categoryKey: 'uranus',
    titleEn: 'Innovation Starts with Discomfort',
    titleTr: 'Yenilik Rahatsızlıkla Başlar',
    bodyEn:
        'Every meaningful innovation begins with the recognition that something is not working. That uncomfortable feeling of dissatisfaction is not a problem; it is a signal that you have outgrown a framework. The Uranus archetype uses this discomfort as creative fuel rather than something to suppress.',
    bodyTr:
        'Her anlamlı yenilik, bir şeyin işe yaramadığının farkına varılmasıyla başlar. Bu rahatsız memnuniyetsizlik hissi bir sorun değildir; bir çerçevenin dışına çıktığınızın sinyalidir. Uranüs arketipi bu rahatsızlığı bastırılacak bir şey yerine yaratıcı yakıt olarak kullanır.',
    reflectionEn:
        'What dissatisfaction in your life might actually be pointing toward necessary innovation?',
    reflectionTr:
        'Hayatınızdaki hangi memnuniyetsizlik aslında gerekli bir yeniliğe işaret ediyor olabilir?',
    tagsEn: ['innovation', 'discomfort', 'growth'],
    tagsTr: ['yenilik', 'rahatsızlık', 'büyüme'],
  ),
  InsightCard(
    id: 'uranus_04',
    categoryKey: 'uranus',
    titleEn: 'Belonging Without Losing Yourself',
    titleTr: 'Kendinizi Kaybetmeden Ait Olmak',
    bodyEn:
        'The tension between belonging and individuality is one of the most human struggles. You need connection, yet you also need to be true to yourself. The Uranus archetype does not resolve this tension but learns to hold it skillfully, finding communities that welcome your uniqueness rather than demanding its erasure.',
    bodyTr:
        'Aidiyet ve bireysellik arasındaki gerilim en insani mücadelelerden biridir. Bağlantıya ihtiyacınız var, ancak aynı zamanda kendinize sadık olmanız da gerekiyor. Uranüs arketipi bu gerilimi çözmez, ama onu ustalıkla tutmayı öğrenir; benzersizliğinizin silinmesini talep etmek yerine hoş karşılayan topluluklar bulur.',
    reflectionEn:
        'Where do you feel you belong most fully while still being completely yourself?',
    reflectionTr:
        'Hala tamamen kendiniz olurken nerede en tam şekilde ait hissediyorsunuz?',
    tagsEn: ['belonging', 'individuality', 'community'],
    tagsTr: ['aidiyet', 'bireysellik', 'topluluk'],
  ),
  InsightCard(
    id: 'uranus_05',
    categoryKey: 'uranus',
    titleEn: 'Sudden Clarity',
    titleTr: 'Ani Netlik',
    bodyEn:
        'Sometimes understanding arrives not gradually but in a sudden flash. A conversation, a line in a book, or even a random thought can shift your entire perspective in an instant. These moments of sudden clarity are gifts of the Uranian archetype. They cannot be forced, but they can be noticed and honored when they arrive.',
    bodyTr:
        'Bazen anlayış kademeli olarak değil, ani bir parlama ile gelir. Bir konuşma, kitaptaki bir satır veya rastgele bir düşünce bile tüm perspektifinizi bir anda değiştirebilir. Bu ani netlik anları Uranüs arketipinin hediyesidir. Zorla getirilemezler, ancak geldiklerinde fark edilip onurlandırılabilirler.',
    reflectionEn:
        'When was the last time you had a flash of insight, and what did it reveal?',
    reflectionTr:
        'En son ne zaman bir içgörü anı yaşadınız ve ne ortaya koydu?',
    tagsEn: ['insight', 'clarity', 'awakening'],
    tagsTr: ['içgörü', 'netlik', 'uyanış'],
  ),
  InsightCard(
    id: 'uranus_06',
    categoryKey: 'uranus',
    titleEn: 'The Outsider Perspective',
    titleTr: 'Dışarıdan Perspektif',
    bodyEn:
        'If you have ever felt like an outsider, know that this position carries a unique advantage. Those who stand slightly apart from the mainstream can see patterns that insiders cannot. The Uranus archetype transforms the pain of not fitting in into the gift of seeing what others miss.',
    bodyTr:
        'Kendinizi hiç dışarıdaki biri gibi hissettiyseniz, bu konumun benzersiz bir avantaj taşıdığını bilin. Ana akımdan biraz ayrı duranlar, içeridekilerin göremediği kalıpları görebilir. Uranüs arketipi, uyuşmama acısını başkalarının kaçırdığını görme hediyesine dönüştürür.',
    reflectionEn:
        'How has being different given you an insight that conformity would have hidden?',
    reflectionTr:
        'Farklı olmak size uyumun gizleyeceği nasıl bir içgörü verdi?',
    tagsEn: ['outsider', 'perspective', 'uniqueness'],
    tagsTr: ['dışarıdaki', 'perspektif', 'benzersizlik'],
  ),
  InsightCard(
    id: 'uranus_07',
    categoryKey: 'uranus',
    titleEn: 'Constructive Disruption',
    titleTr: 'Yapıcı Bozulma',
    bodyEn:
        'Not all disruption is destructive. Sometimes breaking a pattern is the most creative thing you can do. The Uranus archetype distinguishes between disruption that is reactive and disruption that is visionary. The question is not whether to disrupt but whether the disruption serves growth or merely expresses frustration.',
    bodyTr:
        'Her bozulma yıkıcı değildir. Bazen bir kalıbı kırmak yapabileceğiniz en yaratıcı şeydir. Uranüs arketipi, tepkisel bozulma ile vizyoner bozulma arasında ayrım yapar. Soru bozup bozmamak değil, bozulmanın büyümeye hizmet edip etmediği yoksa sadece hayal kırıklığını ifade edip etmediğidir.',
    reflectionEn:
        'What pattern in your life is ready to be disrupted, and what would you build in its place?',
    reflectionTr:
        'Hayatınızdaki hangi kalıp bozulmaya hazır ve yerinde ne inşa ederdiniz?',
    tagsEn: ['disruption', 'creativity', 'change'],
    tagsTr: ['bozulma', 'yaratıcılık', 'değişim'],
  ),
  InsightCard(
    id: 'uranus_08',
    categoryKey: 'uranus',
    titleEn: 'Technology and the Inner World',
    titleTr: 'Teknoloji ve İç Dünya',
    bodyEn:
        'Technology connects you to the world but can disconnect you from yourself. The Uranus archetype values innovation yet also recognizes the importance of preserving inner stillness amid the digital noise. How you relate to your devices reveals something about your relationship with your own thoughts.',
    bodyTr:
        'Teknoloji sizi dünyaya bağlar ancak kendinizden koparabilir. Uranüs arketipi yeniliğe değer verir, ancak dijital gürültünün ortasında iç durağanlığı korumanın önemini de kabul eder. Cihazlarınızla nasıl ilişki kurduğunuz, kendi düşüncelerinizle ilişkiniz hakkında bir şey ortaya koyar.',
    reflectionEn:
        'How did your relationship with technology serve or hinder your inner life today?',
    reflectionTr:
        'Bugün teknolojiyle ilişkiniz iç yaşamınıza nasıl hizmet etti veya engel oldu?',
    tagsEn: ['technology', 'mindfulness', 'balance'],
    tagsTr: ['teknoloji', 'farkındalık', 'denge'],
  ),
  InsightCard(
    id: 'uranus_09',
    categoryKey: 'uranus',
    titleEn: 'The Courage to Change Your Mind',
    titleTr: 'Fikrinizi Değiştirme Cesareti',
    bodyEn:
        'Changing your mind is often seen as weakness, but it is actually a sign of intellectual courage. When new information or deeper understanding arrives, clinging to an old position is not loyalty; it is rigidity. The Uranus archetype respects the mind that can evolve, update, and grow past its previous conclusions.',
    bodyTr:
        'Fikir değiştirmek genellikle zayıflık olarak görülür, ancak aslında entelektüel cesaretin bir işaretidir. Yeni bilgi veya daha derin anlayış geldiğinde, eski bir pozisyona yapışmak sadakat değil, katılıktır. Uranüs arketipi, önceki sonuçlarının ötesine evrilebilen, güncellenebilen ve büyüyebilen zihne saygı duyar.',
    reflectionEn:
        'What belief have you outgrown that you are still carrying out of habit?',
    reflectionTr:
        'Alışkanlıktan hala taşıdığınız hangi inancın dışına çıktınız?',
    tagsEn: ['flexibility', 'growth', 'intellectual-courage'],
    tagsTr: ['esneklik', 'büyüme', 'entelektüel-cesaret'],
  ),
  InsightCard(
    id: 'uranus_10',
    categoryKey: 'uranus',
    titleEn: 'Your Unique Contribution',
    titleTr: 'Benzersiz Katkınız',
    bodyEn:
        'No one else has your exact combination of experiences, insights, and perspective. This uniqueness is not accidental; it is what enables you to contribute something no one else can. The Uranus archetype invites you to stop trying to fit a mold and to discover what becomes possible when you offer the world exactly what only you can.',
    bodyTr:
        'Başka hiç kimse deneyimlerinizin, içgörülerinizin ve perspektifinizin tam kombinasyonuna sahip değildir. Bu benzersizlik tesadüfi değildir; başka hiç kimsenin yapamayacağı bir şeye katkıda bulunmanızı sağlayan şeydir. Uranüs arketipi, bir kalıba uymaya çalışmayı bırakmanızı ve dünyaya sadece sizin sunabileceğiniz şeyi sunduğunuzda nelerin mümkün hale geldiğini keşfetmenizi davet eder.',
    reflectionEn:
        'What can you offer the world that no one else can, because of your unique experience?',
    reflectionTr:
        'Benzersiz deneyiminiz sayesinde başka kimsenin sunamayacağı ne sunabilirsiniz?',
    tagsEn: ['uniqueness', 'contribution', 'purpose'],
    tagsTr: ['benzersizlik', 'katkı', 'amaç'],
  ),
  InsightCard(
    id: 'uranus_11',
    categoryKey: 'uranus',
    titleEn: 'Embracing the Uncomfortable New',
    titleTr: 'Rahatsız Edici Yeniyi Kucaklamak',
    bodyEn:
        'Growth always involves a period where the new way does not yet feel natural. It is tempting to retreat to the familiar simply because it is comfortable. The Uranus archetype encourages you to tolerate the awkwardness of the unfamiliar, knowing that today\'s discomfort is tomorrow\'s new normal.',
    bodyTr:
        'Büyüme her zaman yeni yolun henüz doğal hissettirmediği bir dönemi içerir. Sadece rahat olduğu için tanıdık olana geri çekilmek cazip gelebilir. Uranüs arketipi, bugünün rahatsızlığının yarının yeni normali olduğunu bilerek, yabancı olanın garipliğine tahammül etmenizi teşvik eder.',
    reflectionEn:
        'What new behavior feels awkward now but is aligned with who you are becoming?',
    reflectionTr:
        'Şu anda garip hissettiren ama olmakta olduğunuz kişiyle uyumlu hangi yeni davranış var?',
    tagsEn: ['change', 'growth', 'discomfort'],
    tagsTr: ['değişim', 'büyüme', 'rahatsızlık'],
  ),
  InsightCard(
    id: 'uranus_12',
    categoryKey: 'uranus',
    titleEn: 'Liberation Through Honesty',
    titleTr: 'Dürüstlük Yoluyla Kurtuluş',
    bodyEn:
        'There is an immediate sense of lightness that follows radical honesty with yourself. Admitting what you truly want, what you actually feel, what you really think, can feel dangerous, but it is also profoundly liberating. The Uranus archetype knows that freedom begins with the truth, even when the truth is inconvenient.',
    bodyTr:
        'Kendinize radikal dürüstlüğü takip eden anlık bir hafiflik duygusu vardır. Gerçekten ne istediğinizi, gerçekte ne hissettiğinizi, gerçekten ne düşündüğünüzü kabul etmek tehlikeli hissedebilir, ancak aynı zamanda derinden özgürleştiricidir. Uranüs arketipi, gerçek uygunsuz olsa bile özgürlüğün gerçekle başladığını bilir.',
    reflectionEn:
        'What truth about yourself would set you free if you fully acknowledged it?',
    reflectionTr:
        'Kendiniz hakkında hangi gerçeği tam olarak kabul etseniz sizi özgür kılardı?',
    tagsEn: ['honesty', 'freedom', 'liberation'],
    tagsTr: ['dürüstlük', 'özgürlük', 'kurtuluş'],
  ),
];

// =============================================================================
// NEPTUNE ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> neptuneInsightCards = [
  InsightCard(
    id: 'neptune_01',
    categoryKey: 'neptune',
    titleEn: 'The Wisdom of Dreams',
    titleTr: 'Rüyaların Bilgeliği',
    bodyEn:
        'Dreams speak in symbols, images, and feelings that bypass the logical mind. They are not random noise but a form of communication from parts of yourself that do not have access to words. The Neptune archetype invites you to pay attention to your dream life, not to decode it literally, but to notice the feelings and themes that surface.',
    bodyTr:
        'Rüyalar, mantıksal zihni atlayan semboller, imgeler ve duygularla konuşur. Rastgele gürültü değil, kelimelere erişimi olmayan yanlarınızdan bir iletişim biçimidir. Neptün arketipi, rüya yaşamınıza dikkat etmenizi davet eder; onu kelimesi kelimesine çözmek için değil, yüzeye çıkan duyguları ve temaları fark etmek için.',
    reflectionEn:
        'What feeling or image from a recent dream has stayed with you, and what might it be reflecting?',
    reflectionTr:
        'Yakın zamandaki bir rüyadan hangi duygu veya imge sizinle kaldı ve neyi yansıtıyor olabilir?',
    tagsEn: ['dreams', 'unconscious', 'symbolism'],
    tagsTr: ['rüyalar', 'bilinçaltı', 'sembolizm'],
  ),
  InsightCard(
    id: 'neptune_02',
    categoryKey: 'neptune',
    titleEn: 'Compassion Without Drowning',
    titleTr: 'Boğulmadan Şefkat',
    bodyEn:
        'Feeling deeply for others is a gift, but without healthy boundaries it can become overwhelming. The Neptune archetype in its wisest form understands that you cannot hold space for another if you are drowning in their pain. Compassion that includes self-preservation is more sustainable and ultimately more helpful.',
    bodyTr:
        'Başkaları için derinden hissetmek bir hediyedir, ancak sağlıklı sınırlar olmadan bunaltıcı hale gelebilir. En bilge halindeki Neptün arketipi, onların acısında boğuluyorsanız başkası için alan tutamayacağınızı anlar. Kendini korumayı içeren şefkat daha sürdürülebilir ve nihayetinde daha yardımcıdır.',
    reflectionEn:
        'Whose pain did you absorb today, and how can you hold compassion without losing yourself?',
    reflectionTr:
        'Bugün kimin acısını absorbe ettiniz ve kendinizi kaybetmeden şefkati nasıl tutabilirsiniz?',
    tagsEn: ['compassion', 'boundaries', 'empathy'],
    tagsTr: ['şefkat', 'sınırlar', 'empati'],
  ),
  InsightCard(
    id: 'neptune_03',
    categoryKey: 'neptune',
    titleEn: 'Art as a Mirror',
    titleTr: 'Ayna Olarak Sanat',
    bodyEn:
        'The art that moves you most, a song, a painting, a film, a poem, often reflects something in your inner world that you have not yet put into words. Your artistic preferences are not random; they are clues to your emotional landscape. What you find beautiful or haunting tells a story about who you are beneath the surface.',
    bodyTr:
        'Sizi en çok hareket ettiren sanat, bir şarkı, bir tablo, bir film, bir şiir, genellikle henüz kelimelere dökmediğiniz iç dünyanızdaki bir şeyi yansıtır. Sanatsal tercihleriniz rastgele değildir; duygusal manzaranıza ipuçlarıdır. Güzel veya unutulmaz bulduğunuz şey, yüzeyin altında kim olduğunuz hakkında bir hikaye anlatır.',
    reflectionEn:
        'What piece of art has moved you recently, and what inner truth might it be reflecting?',
    reflectionTr:
        'Son zamanlarda hangi sanat eseri sizi hareket ettirdi ve hangi iç gerçeği yansıtıyor olabilir?',
    tagsEn: ['art', 'reflection', 'inner-world'],
    tagsTr: ['sanat', 'yansıma', 'iç-dünya'],
  ),
  InsightCard(
    id: 'neptune_04',
    categoryKey: 'neptune',
    titleEn: 'Illusion and Truth',
    titleTr: 'Yanılsama ve Gerçek',
    bodyEn:
        'Not everything that feels real is true, and not everything that feels uncomfortable is false. The Neptune archetype navigates the space between illusion and truth with care. It invites you to question your assumptions, especially the ones that feel most certain, and to remain open to the possibility that reality is more nuanced than it appears.',
    bodyTr:
        'Gerçek hissedilen her şey doğru değildir ve rahatsız hissettiren her şey yanlış değildir. Neptün arketipi, yanılsama ve gerçek arasındaki alanda dikkatle yol alır. Varsayımlarınızı, özellikle en kesin hissedenleri sorgulamanızı ve gerçekliğin göründüğünden daha nüanslı olma olasılığına açık kalmanızı davet eder.',
    reflectionEn:
        'What assumption did you hold today that might be more illusion than truth?',
    reflectionTr:
        'Bugün gerçekten çok yanılsama olabilecek hangi varsayımı tuttunuz?',
    tagsEn: ['illusion', 'truth', 'discernment'],
    tagsTr: ['yanılsama', 'gerçek', 'ayırt-etme'],
  ),
  InsightCard(
    id: 'neptune_05',
    categoryKey: 'neptune',
    titleEn: 'The Healing Power of Music',
    titleTr: 'Müziğin İyileştirici Gücü',
    bodyEn:
        'Music bypasses the intellect and speaks directly to the emotions. A melody can shift your mood, unlock a memory, or express something words cannot reach. The Neptune archetype recognizes music as a form of emotional medicine. Choosing what you listen to consciously can be an act of self-care as real as any other.',
    bodyTr:
        'Müzik zihni atlar ve doğrudan duygulara konuşur. Bir melodi ruh halinizi değiştirebilir, bir anıyı açabilir veya kelimelerin ulaşamayacağı bir şeyi ifade edebilir. Neptün arketipi müziği duygusal bir ilaç biçimi olarak tanır. Dinlediğiniz şeyi bilinçli olarak seçmek, diğer herhangi bir şey kadar gerçek bir öz-bakım eylemi olabilir.',
    reflectionEn:
        'What piece of music would your soul request right now if you listened carefully?',
    reflectionTr:
        'Dikkatlice dinlerseniz ruhunuz şu anda hangi müzik parçasını talep ederdi?',
    tagsEn: ['music', 'healing', 'emotions'],
    tagsTr: ['müzik', 'iyileşme', 'duygular'],
  ),
  InsightCard(
    id: 'neptune_06',
    categoryKey: 'neptune',
    titleEn: 'Surrender as Strength',
    titleTr: 'Güç Olarak Teslim Olmak',
    bodyEn:
        'Surrender does not mean giving up. It means releasing your grip on how things should be and opening to how they actually are. This is one of the most counterintuitive forms of strength. The Neptune archetype teaches that sometimes the bravest thing you can do is stop fighting and let life show you the way.',
    bodyTr:
        'Teslim olmak pes etmek anlamına gelmez. İşlerin nasıl olması gerektiğine ilişkin tutumunuzu bırakmak ve gerçekte nasıl olduklarına açılmak anlamına gelir. Bu, en karşı-sezgisel güç biçimlerinden biridir. Neptün arketipi, bazen yapabileceğiniz en cesur şeyin savaşmayı bırakmak ve hayatın size yolu göstermesine izin vermek olduğunu öğretir.',
    reflectionEn:
        'Where in your life might surrender actually be the strongest move available to you?',
    reflectionTr:
        'Hayatınızın neresinde teslim olmak aslında yapabileceğiniz en güçlü hamle olabilir?',
    tagsEn: ['surrender', 'strength', 'acceptance'],
    tagsTr: ['teslim-olma', 'güç', 'kabul'],
  ),
  InsightCard(
    id: 'neptune_07',
    categoryKey: 'neptune',
    titleEn: 'Sensing the Atmosphere',
    titleTr: 'Atmosferi Hissetmek',
    bodyEn:
        'Some people walk into a room and immediately sense its emotional atmosphere. This sensitivity is not imagined; it is a form of perceptual intelligence. The Neptune archetype honors this capacity while also reminding you that the atmosphere you sense does not always belong to you. Learning to differentiate helps protect your energy.',
    bodyTr:
        'Bazı insanlar bir odaya girer ve hemen duygusal atmosferini hisseder. Bu duyarlılık hayal ürünü değildir; algısal zekanın bir biçimidir. Neptün arketipi bu kapasiteyi onurlarken, hissettiğiniz atmosferin her zaman size ait olmadığını da hatırlatır. Ayrım yapmayı öğrenmek enerjinizi korumaya yardımcı olur.',
    reflectionEn:
        'What emotional atmosphere did you absorb today that was not actually yours?',
    reflectionTr:
        'Bugün aslında size ait olmayan hangi duygusal atmosferi absorbe ettiniz?',
    tagsEn: ['sensitivity', 'empathy', 'boundaries'],
    tagsTr: ['duyarlılık', 'empati', 'sınırlar'],
  ),
  InsightCard(
    id: 'neptune_08',
    categoryKey: 'neptune',
    titleEn: 'The Space Between Breaths',
    titleTr: 'Nefesler Arası Boşluk',
    bodyEn:
        'Between each inhale and exhale, there is a tiny pause. In that pause lives a moment of pure presence, free from thought, free from worry. The Neptune archetype finds sacredness in these microscopic gaps. When you notice them, even briefly, you touch something that exists beyond the usual chatter of the mind.',
    bodyTr:
        'Her nefes alış ve verişin arasında küçücük bir duraklama vardır. O duraklamada düşünceden arınmış, endişeden arınmış saf bir mevcudiyet anı yaşar. Neptün arketipi bu mikroskopik boşluklarda kutsallık bulur. Onları fark ettiğinizde, kısacık bile olsa, zihnin olağan gevezeliğinin ötesinde var olan bir şeye dokunursunuz.',
    reflectionEn:
        'Can you pause right now, take one slow breath, and notice the stillness in the gap?',
    reflectionTr:
        'Şu anda durup, yavaş bir nefes alıp, boşluktaki durağanlığı fark edebilir misiniz?',
    tagsEn: ['breath', 'presence', 'mindfulness'],
    tagsTr: ['nefes', 'mevcudiyet', 'farkındalık'],
  ),
  InsightCard(
    id: 'neptune_09',
    categoryKey: 'neptune',
    titleEn: 'Imagination as a Tool',
    titleTr: 'Araç Olarak Hayal Gücü',
    bodyEn:
        'Imagination is not escapism. It is the faculty that allows you to envision what does not yet exist, to rehearse emotional responses, and to create meaning from raw experience. Every act of empathy relies on imagination. Every creative solution begins there. The Neptune archetype cherishes imagination as one of your most powerful inner resources.',
    bodyTr:
        'Hayal gücü kaçış değildir. Henüz var olmayanı tasavvur etmenize, duygusal tepkileri prova etmenize ve ham deneyimden anlam yaratmanıza olanak tanıyan yetidir. Her empati eylemi hayal gücüne dayanır. Her yaratıcı çözüm orada başlar. Neptün arketipi hayal gücünü en güçlü iç kaynaklarınızdan biri olarak değerlendirir.',
    reflectionEn:
        'How did your imagination serve you today in a way that was not escapism?',
    reflectionTr:
        'Bugün hayal gücünüz size kaçış olmayan bir şekilde nasıl hizmet etti?',
    tagsEn: ['imagination', 'creativity', 'empathy'],
    tagsTr: ['hayal-gücü', 'yaratıcılık', 'empati'],
  ),
  InsightCard(
    id: 'neptune_10',
    categoryKey: 'neptune',
    titleEn: 'Sacred Ordinariness',
    titleTr: 'Kutsal Sıradanlık',
    bodyEn:
        'You do not need extraordinary circumstances to experience something sacred. Washing dishes, walking to the bus stop, or watching rain can become moments of deep presence and quiet reverence. The Neptune archetype finds the transcendent in the everyday, recognizing that ordinary moments, when fully inhabited, become extraordinary.',
    bodyTr:
        'Kutsal bir şey deneyimlemek için olağanüstü koşullara ihtiyacınız yoktur. Bulaşık yıkamak, otobüs durağına yürümek veya yağmuru izlemek derin mevcudiyet ve sessiz saygı anları haline gelebilir. Neptün arketipi, gündelikte aşkınlığı bulur; tam olarak yaşandığında sıradan anların olağanüstü hale geldiğini kabul eder.',
    reflectionEn:
        'What ordinary moment today held an unexpected depth when you gave it your full attention?',
    reflectionTr:
        'Bugün tam dikkatinizi verdiğinizde hangi sıradan an beklenmedik bir derinlik taşıyordu?',
    tagsEn: ['presence', 'sacred', 'everyday'],
    tagsTr: ['mevcudiyet', 'kutsal', 'gündelik'],
  ),
  InsightCard(
    id: 'neptune_11',
    categoryKey: 'neptune',
    titleEn: 'The River of Emotion',
    titleTr: 'Duygu Nehri',
    bodyEn:
        'Emotions, like water, need to flow. When they are dammed up through suppression or denial, pressure builds. When they are allowed to flow freely without direction, flooding occurs. The Neptune archetype seeks the middle path: allowing emotions to move through you while maintaining enough structure to keep you grounded.',
    bodyTr:
        'Duygular, su gibi, akması gerekir. Bastırma veya inkar yoluyla set çekildiğinde baskı birikir. Yön olmadan serbestçe akmalarına izin verildiğinde sel olur. Neptün arketipi orta yolu arar: sizi köklü tutmaya yetecek kadar yapıyı korurken duyguların içinizden akmasına izin verme.',
    reflectionEn:
        'What emotion needs to flow through you right now rather than being stored or avoided?',
    reflectionTr:
        'Şu anda depolanmak veya kaçınılmak yerine hangi duygunun içinizden akması gerekiyor?',
    tagsEn: ['emotions', 'flow', 'balance'],
    tagsTr: ['duygular', 'akış', 'denge'],
  ),
  InsightCard(
    id: 'neptune_12',
    categoryKey: 'neptune',
    titleEn: 'The Longing That Cannot Be Named',
    titleTr: 'Adlandırılamayan Özlem',
    bodyEn:
        'There is a particular kind of longing that has no clear object. It is not for a person, place, or thing but for something nameless: a sense of wholeness, a feeling of being truly home, a taste of something just beyond reach. The Neptune archetype recognizes this longing as a signal of your deepest nature, asking to be acknowledged rather than satisfied.',
    bodyTr:
        'Net bir nesnesi olmayan özel bir özlem türü vardır. Bir kişi, yer veya şey için değil, adlandırılamayan bir şey içindir: bütünlük duygusu, gerçekten evde olma hissi, tam erişimin ötesinde bir şeyin tadı. Neptün arketipi bu özlemi, tatmin edilmekten ziyade kabul edilmeyi isteyen en derin doğanızın bir sinyali olarak tanır.',
    reflectionEn:
        'What do you long for that you cannot quite name, and how does that longing guide you?',
    reflectionTr:
        'Tam olarak adlandıramadığınız neyi özlüyorsunuz ve bu özlem sizi nasıl yönlendiriyor?',
    tagsEn: ['longing', 'depth', 'meaning'],
    tagsTr: ['özlem', 'derinlik', 'anlam'],
  ),
];

// =============================================================================
// PLUTO ARCHETYPE CARDS (12)
// =============================================================================

const List<InsightCard> plutoInsightCards = [
  InsightCard(
    id: 'pluto_01',
    categoryKey: 'pluto',
    titleEn: 'What Lies Beneath',
    titleTr: 'Yüzeyin Altında Yatan',
    bodyEn:
        'Your conscious mind is only the surface layer of a much deeper psychological landscape. Beneath your everyday thoughts lie motivations, fears, and desires that powerfully shape your behavior. The Pluto archetype invites you to explore what lies below your surface awareness, not to fix it, but to understand the hidden forces at work in your life.',
    bodyTr:
        'Bilinçli zihniniz çok daha derin bir psikolojik manzaranın sadece yüzey katmanıdır. Günlük düşüncelerinizin altında davranışınızı güçlü bir şekilde şekillendiren motivasyonlar, korkular ve arzular yatar. Plüton arketipi, yüzey farkındalığınızın altında yatanı keşfetmenizi davet eder; onu düzeltmek için değil, hayatınızdaki gizli güçleri anlamak için.',
    reflectionEn:
        'What motivation drove your behavior today that you did not fully acknowledge?',
    reflectionTr:
        'Bugün tam olarak kabul etmediğiniz hangi motivasyon davranışınızı yönlendirdi?',
    tagsEn: ['unconscious', 'depth', 'self-awareness'],
    tagsTr: ['bilinçaltı', 'derinlik', 'öz-farkındalık'],
  ),
  InsightCard(
    id: 'pluto_02',
    categoryKey: 'pluto',
    titleEn: 'The Phoenix Process',
    titleTr: 'Anka Kuşu Süreci',
    bodyEn:
        'Transformation rarely feels graceful while it is happening. It often involves disorientation, loss, and the uncomfortable unraveling of what once felt solid. The Pluto archetype understands that this dismantling is not destruction for its own sake but the necessary clearing that precedes genuine renewal. What is falling apart may be falling into place.',
    bodyTr:
        'Dönüşüm gerçekleşirken nadiren zarif hisseder. Genellikle yön kaybı, kayıp ve bir zamanlar sağlam hissedilen şeyin rahatsız edici çözülmesini içerir. Plüton arketipi, bu çözülmenin kendi başına yıkım olmadığını, gerçek yenilenmeyi önceleyen gerekli temizleme olduğunu anlar. Dağılan şey yerine oturuyor olabilir.',
    reflectionEn:
        'What in your life is currently falling apart, and what might be trying to emerge from the rubble?',
    reflectionTr:
        'Hayatınızda şu anda ne dağılıyor ve enkazdan ne ortaya çıkmaya çalışıyor olabilir?',
    tagsEn: ['transformation', 'renewal', 'change'],
    tagsTr: ['dönüşüm', 'yenilenme', 'değişim'],
  ),
  InsightCard(
    id: 'pluto_03',
    categoryKey: 'pluto',
    titleEn: 'Power and Its Shadow',
    titleTr: 'Güç ve Gölgesi',
    bodyEn:
        'Everyone has a relationship with power, whether they acknowledge it or not. How you use power, whether over others, over yourself, or in collaboration, reveals deep truths about your character. The Pluto archetype asks you to examine your relationship with power honestly: where you seek it, where you fear it, and where you give it away.',
    bodyTr:
        'Herkesin güçle bir ilişkisi vardır, kabul etsin ya da etmesin. Gücü nasıl kullandığınız, başkaları üzerinde, kendiniz üzerinde veya iş birliği içinde, karakteriniz hakkında derin gerçekleri ortaya koyar. Plüton arketipi, güçle ilişkinizi dürüstçe incelemenizi ister: nerede aradığınızı, nerede korktuğunuzu ve nerede verdiğinizi.',
    reflectionEn:
        'How did you relate to power today, either your own or someone else\'s?',
    reflectionTr:
        'Bugün güçle nasıl ilişki kurdunuz, ister kendi gücünüz ister başkasının?',
    tagsEn: ['power', 'shadow', 'self-examination'],
    tagsTr: ['güç', 'gölge', 'öz-inceleme'],
  ),
  InsightCard(
    id: 'pluto_04',
    categoryKey: 'pluto',
    titleEn: 'Letting Go of Control',
    titleTr: 'Kontrolü Bırakmak',
    bodyEn:
        'The need to control is often a response to past experiences where you felt unsafe or powerless. Understanding the root of your need for control can help you loosen your grip where it no longer serves you. The Pluto archetype teaches that the deepest form of personal power is not controlling outcomes but trusting your ability to handle whatever comes.',
    bodyTr:
        'Kontrol ihtiyacı genellikle güvensiz veya güçsüz hissettiğiniz geçmiş deneyimlere bir yanıttır. Kontrol ihtiyacınızın kökenini anlamak, artık size hizmet etmeyen yerde tutuşunuzu gevşetmenize yardımcı olabilir. Plüton arketipi, kişisel gücün en derin biçiminin sonuçları kontrol etmek değil, ne gelirse gelsin başa çıkma yeteneğinize güvenmek olduğunu öğretir.',
    reflectionEn:
        'Where are you trying to control what cannot be controlled, and what fear drives that impulse?',
    reflectionTr:
        'Kontrol edilemeyeni nerede kontrol etmeye çalışıyorsunuz ve hangi korku bu dürtüyü yönlendiriyor?',
    tagsEn: ['control', 'trust', 'fear'],
    tagsTr: ['kontrol', 'güven', 'korku'],
  ),
  InsightCard(
    id: 'pluto_05',
    categoryKey: 'pluto',
    titleEn: 'The Shadow Knows',
    titleTr: 'Gölge Bilir',
    bodyEn:
        'Your shadow, the parts of yourself you reject or hide, does not disappear when you ignore it. It shows up in projections onto others, in recurring conflicts, and in self-sabotaging patterns. The Pluto archetype sees shadow work not as something to fear but as one of the most powerful paths to wholeness.',
    bodyTr:
        'Gölgeniz, kendinizin reddettiğiniz veya sakladığınız kısımları, görmezden geldiğinizde kaybolmaz. Başkalarına yapılan yansıtmalarda, tekrarlayan çatışmalarda ve kendini sabote eden kalıplarda ortaya çıkar. Plüton arketipi gölge çalışmasını korkacak bir şey olarak değil, bütünlüğe giden en güçlü yollardan biri olarak görür.',
    reflectionEn:
        'What quality that irritates you in others might actually be a disowned part of yourself?',
    reflectionTr:
        'Başkalarında sizi rahatsız eden hangi nitelik aslında kendinizin sahiplenmediğiniz bir parçası olabilir?',
    tagsEn: ['shadow', 'projection', 'wholeness'],
    tagsTr: ['gölge', 'yansıtma', 'bütünlük'],
  ),
  InsightCard(
    id: 'pluto_06',
    categoryKey: 'pluto',
    titleEn: 'The Courage to Grieve',
    titleTr: 'Yas Tutma Cesareti',
    bodyEn:
        'Grief is not only about death. You grieve lost possibilities, ended relationships, versions of yourself you have outgrown, and dreams that did not materialize. The Pluto archetype honors grief as a necessary passage. When you allow yourself to fully grieve what is gone, you create space for what is emerging.',
    bodyTr:
        'Yas sadece ölümle ilgili değildir. Kaybedilen olasılıklar, biten ilişkiler, dışına çıktığınız benlik versiyonları ve gerçekleşmeyen hayaller için yas tutarsınız. Plüton arketipi yası gerekli bir geçiş olarak onurlandırır. Gidenin yasını tam olarak tutmanıza izin verdiğinizde, ortaya çıkana alan yaratırsınız.',
    reflectionEn:
        'What loss, large or small, have you not yet fully allowed yourself to grieve?',
    reflectionTr:
        'Büyük veya küçük, hangi kaybın yasını henüz tam olarak tutmanıza izin vermediniz?',
    tagsEn: ['grief', 'loss', 'healing'],
    tagsTr: ['yas', 'kayıp', 'iyileşme'],
  ),
  InsightCard(
    id: 'pluto_07',
    categoryKey: 'pluto',
    titleEn: 'Regeneration After Crisis',
    titleTr: 'Kriz Sonrası Yenilenme',
    bodyEn:
        'Crisis has a strange gift buried within it: the opportunity to rebuild with greater clarity about what actually matters. When life strips away the non-essential, what remains is often more authentic than what was lost. The Pluto archetype trusts this regenerative process even when the crisis itself feels unbearable.',
    bodyTr:
        'Krizin içine gömülü tuhaf bir hediyesi vardır: gerçekten neyin önemli olduğu konusunda daha büyük netlikle yeniden inşa etme fırsatı. Hayat gereksizi soyduğunda, geriye kalan genellikle kaybedilenden daha otantiktir. Plüton arketipi, krizin kendisi dayanılmaz hissettirdiğinde bile bu yenileyici sürece güvenir.',
    reflectionEn:
        'What did a past crisis reveal to you about what truly matters in your life?',
    reflectionTr:
        'Geçmiş bir kriz size hayatınızda gerçekten neyin önemli olduğunu nasıl ortaya koydu?',
    tagsEn: ['crisis', 'regeneration', 'clarity'],
    tagsTr: ['kriz', 'yenilenme', 'netlik'],
  ),
  InsightCard(
    id: 'pluto_08',
    categoryKey: 'pluto',
    titleEn: 'The Stories That Bind',
    titleTr: 'Bağlayan Hikayeler',
    bodyEn:
        'Some of the stories you carry about yourself were formed during difficult experiences and served as protection at the time. But stories like "I am not enough" or "People always leave" can outlive their usefulness and become chains. The Pluto archetype gives you permission to examine these binding stories and decide whether they still deserve your belief.',
    bodyTr:
        'Kendiniz hakkında taşıdığınız bazı hikayeler zor deneyimler sırasında oluşmuş ve o zaman koruma işlevi görmüştür. Ancak "Yeterli değilim" veya "İnsanlar her zaman terk eder" gibi hikayeler yararlılıklarını aşabilir ve zincirlere dönüşebilir. Plüton arketipi, bu bağlayıcı hikayeleri incelemenize ve hala inancınızı hak edip etmediklerine karar vermenize izin verir.',
    reflectionEn:
        'What old story about yourself are you ready to examine and possibly release?',
    reflectionTr:
        'Kendiniz hakkında hangi eski hikayeyi incelemeye ve muhtemelen bırakmaya hazırsınız?',
    tagsEn: ['stories', 'beliefs', 'liberation'],
    tagsTr: ['hikayeler', 'inançlar', 'kurtuluş'],
  ),
  InsightCard(
    id: 'pluto_09',
    categoryKey: 'pluto',
    titleEn: 'Intimacy Requires Depth',
    titleTr: 'Yakınlık Derinlik Gerektirir',
    bodyEn:
        'Surface-level connection can be pleasant but rarely satisfies the deeper human need for genuine intimacy. True closeness requires the willingness to be seen in your complexity, not just your best moments. The Pluto archetype understands that the relationships that transform you are the ones where both people dare to go below the surface.',
    bodyTr:
        'Yüzey düzeyinde bağlantı hoş olabilir ancak gerçek yakınlık için daha derin insan ihtiyacını nadiren tatmin eder. Gerçek yakınlık, sadece en iyi anlarınızda değil, karmaşıklığınızda görülmeye istekli olmayı gerektirir. Plüton arketipi, sizi dönüştüren ilişkilerin her iki kişinin de yüzeyin altına inmeye cesaret ettiği ilişkiler olduğunu anlar.',
    reflectionEn:
        'In which relationship could you risk showing more of your true depth?',
    reflectionTr:
        'Hangi ilişkide gerçek derinliğinizi daha fazla gösterme riskini alabilirsiniz?',
    tagsEn: ['intimacy', 'depth', 'vulnerability'],
    tagsTr: ['yakınlık', 'derinlik', 'kırılganlık'],
  ),
  InsightCard(
    id: 'pluto_10',
    categoryKey: 'pluto',
    titleEn: 'Transforming Pain into Purpose',
    titleTr: 'Acıyı Amaca Dönüştürmek',
    bodyEn:
        'The most painful experiences of your life carry the potential to become sources of deep wisdom and compassion. Not because suffering is noble, but because navigating difficulty builds a kind of understanding that cannot be acquired any other way. The Pluto archetype recognizes the alchemical potential in your darkest chapters.',
    bodyTr:
        'Hayatınızın en acı verici deneyimleri derin bilgelik ve şefkat kaynakları olma potansiyelini taşır. Acı çekmenin asil olduğu için değil, zorluğu aşmanın başka hiçbir şekilde edinilemeyen bir tür anlayış inşa ettiği için. Plüton arketipi en karanlık bölümlerinizdeki simyasal potansiyeli tanır.',
    reflectionEn:
        'What difficult experience from your past has become a source of wisdom you now share with others?',
    reflectionTr:
        'Geçmişinizden hangi zor deneyim artık başkalarıyla paylaştığınız bir bilgelik kaynağı haline geldi?',
    tagsEn: ['pain', 'purpose', 'transformation'],
    tagsTr: ['acı', 'amaç', 'dönüşüm'],
  ),
  InsightCard(
    id: 'pluto_11',
    categoryKey: 'pluto',
    titleEn: 'The Death of the Old Self',
    titleTr: 'Eski Benliğin Ölümü',
    bodyEn:
        'Growing up does not stop at adulthood. Throughout your life, old versions of yourself must die to make way for who you are becoming. These symbolic deaths can feel disorienting, as though you no longer recognize yourself. The Pluto archetype reassures you that this disorientation is not loss of self but expansion of self.',
    bodyTr:
        'Büyümek yetişkinlikte durmaz. Hayatınız boyunca eski benlik versiyonlarınız, olmakta olduğunuz kişiye yol açmak için ölmelidir. Bu sembolik ölümler, sanki artık kendinizi tanımıyormuşsunuz gibi yön kaybettirici hissedebilir. Plüton arketipi, bu yön kaybının benlik kaybı değil, benliğin genişlemesi olduğunu güvence verir.',
    reflectionEn:
        'What version of yourself has recently died, and who is emerging in its place?',
    reflectionTr:
        'Kendinizin yakın zamanda hangi versiyonu öldü ve yerinde kim ortaya çıkıyor?',
    tagsEn: ['growth', 'transformation', 'identity'],
    tagsTr: ['büyüme', 'dönüşüm', 'kimlik'],
  ),
  InsightCard(
    id: 'pluto_12',
    categoryKey: 'pluto',
    titleEn: 'The Gift of Darkness',
    titleTr: 'Karanlığın Hediyesi',
    bodyEn:
        'Not all growth happens in the light. Some of the most important inner work takes place in the dark: in periods of confusion, loss, or not-knowing. The Pluto archetype does not rush you through these dark passages. It trusts that the seeds planted in darkness will eventually break through the soil when the time is right.',
    bodyTr:
        'Tüm büyüme ışıkta gerçekleşmez. En önemli iç çalışmanın bir kısmı karanlıkta gerçekleşir: kafa karışıklığı, kayıp veya bilmeme dönemlerinde. Plüton arketipi sizi bu karanlık geçitlerden acele ettirmez. Karanlıkta ekilen tohumların zamanı geldiğinde sonunda toprağı yırtacağına güvenir.',
    reflectionEn:
        'What is growing in you right now that has not yet come into the light?',
    reflectionTr:
        'Şu anda içinizde henüz ışığa çıkmamış ne büyüyor?',
    tagsEn: ['darkness', 'growth', 'patience'],
    tagsTr: ['karanlık', 'büyüme', 'sabır'],
  ),
];

// =============================================================================
// COMBINED ACCESSOR - PART 3
// =============================================================================

/// All insight cards from Part 3 (Saturn + Uranus + Neptune + Pluto = 48 cards)
const List<InsightCard> insightCardsPart3 = [
  ...saturnInsightCards,
  ...uranusInsightCards,
  ...neptuneInsightCards,
  ...plutoInsightCards,
];

// =============================================================================
// MASTER ACCESSOR - ALL 120 INSIGHT CARDS
// =============================================================================

/// All 120 insight cards across all planetary archetypes
List<InsightCard> get allInsightCards => [
      ...insightCardsPart1,
      ...insightCardsPart2,
      ...insightCardsPart3,
    ];
