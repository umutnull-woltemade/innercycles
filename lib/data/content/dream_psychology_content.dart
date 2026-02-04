/// Dream Psychology Content - Freud, Jung, Gestalt, and Modern Approaches
/// In-depth psychological dream analysis content
library;

// ════════════════════════════════════════════════════════════════════════════
// JUNG PSYCHOLOGY - DEPTH PSYCHOLOGY
// ════════════════════════════════════════════════════════════════════════════

/// Jungian dream analysis system
class JungianDreamPsychology {
  /// Collective Unconscious Archetypes
  static const Map<String, ArchetypeDeepAnalysis> archetypes = {
    'shadow': ArchetypeDeepAnalysis(
      name: 'Shadow',
      emoji: '🌑',
      description:
          'Personality aspects that are rejected, suppressed, or unaccepted by the ego. '
          'In dreams, they usually appear as threatening, frightening, or shameful figures.',
      manifestations: [
        'Chasing dangerous figures',
        'People you don\'t know but feel familiar',
        'Disturbing same-gender characters',
        'Criminal, thief, murderer figures',
        'Wild or dangerous animals',
        'Dark, underground places',
      ],
      integrationPath:
          'Confronting the Shadow means trying to understand it rather than reject it. '
          'Ask yourself: "What is this figure trying to teach me?"',
      questions: [
        'Which aspect of me does this figure represent?',
        'What am I suppressing in my life?',
        'What power does this "enemy" actually carry for me?',
        'What would happen if I embraced it?',
      ],
      healingAffirmation:
          'My darkness is as much a part of me as my light. I make peace with all aspects of myself.',
      relatedSymbols: ['wolf', 'snake', 'monster', 'thief', 'darkness'],
    ),
    'anima': ArchetypeDeepAnalysis(
      name: 'Anima (Inner Woman)',
      emoji: '🌙',
      description:
          'The feminine aspect in men\'s unconscious. Represents emotions, intuition, '
          'creativity, and the capacity for relationships.',
      manifestations: [
        'Mysterious, attractive female figures',
        'Wise woman, witch',
        'Princess who needs rescuing',
        'Dangerous, seductive woman',
        'Mother figure (positive/negative)',
        'Mermaid, fairy, angel',
      ],
      integrationPath:
          'Anima integration is about developing emotional intelligence and '
          'accepting feminine energy. Key to understanding relationship patterns.',
      questions: [
        'Which emotion does this female figure represent?',
        'What pattern repeats in my relationships?',
        'Am I at peace with my feminine energy?',
        'How much do I listen to my intuition?',
      ],
      healingAffirmation:
          'I honor the feminine wisdom within me. I trust my intuition.',
      relatedSymbols: ['moon', 'water', 'sea', 'cave', 'flower', 'mirror'],
    ),
    'animus': ArchetypeDeepAnalysis(
      name: 'Animus (Inner Man)',
      emoji: '☀️',
      description:
          'The masculine aspect in women\'s unconscious. Represents logic, action, '
          'determination, and relating to the outer world.',
      manifestations: [
        'Strong, protective male figures',
        'Wise old man',
        'King, prince, hero',
        'Dangerous, aggressive man',
        'Father figure (positive/negative)',
        'Teacher, guide, mentor',
      ],
      integrationPath:
          'Animus integration is about developing inner authority and '
          'expressing masculine energy in a healthy way. Confidence and action capacity.',
      questions: [
        'Which power of mine does this male figure represent?',
        'How much do I trust my own authority?',
        'On whose behalf am I acting in my life?',
        'How do I express my masculine energy?',
      ],
      healingAffirmation:
          'I claim my own power and authority. I am determined in my actions.',
      relatedSymbols: ['sun', 'sword', 'mountain', 'eagle', 'fire', 'lion'],
    ),
    'self': ArchetypeDeepAnalysis(
      name: 'Self',
      emoji: '☯️',
      description:
          'The wholeness of personality, the union of all opposites. Jung\'s highest '
          'archetype, the goal of the individuation process.',
      manifestations: [
        'Mandala, circle, sphere shapes',
        'Gold, diamond, precious stones',
        'Wise elderly figures (both genders)',
        'Light, enlightenment experiences',
        'Center, castle, temple',
        'Child figure (divine child)',
      ],
      integrationPath:
          'Connection with the Self is the reward of the individuation journey. The sense '
          'of wholeness that emerges from the integration of all archetypes.',
      questions: [
        'What is the meaning of my life?',
        'How can I integrate all my aspects?',
        'What is my true potential?',
        'What are my deepest values?',
      ],
      healingAffirmation:
          'I am whole. All my parts dance in harmony.',
      relatedSymbols: ['mandala', 'sun', 'crown', 'diamond', 'tree', 'center'],
    ),
    'persona': ArchetypeDeepAnalysis(
      name: 'Persona (Mask)',
      emoji: '🎭',
      description:
          'Social identity, the face we show to the world. The outer identity '
          'developed to conform to social expectations.',
      manifestations: [
        'Wearing masks, costumes',
        'Being unrecognized, identity confusion',
        'Stage, performance dreams',
        'Being naked (loss of persona)',
        'Changing clothes',
        'Mirror/reflection problems',
      ],
      integrationPath:
          'Being aware of the Persona is understanding that our social identity is not '
          'who we are. Balance between authenticity and social adaptation.',
      questions: [
        'Am I really myself or am I playing a role?',
        'What masks do I have?',
        'Who is underneath my mask?',
        'What does being authentic mean to me?',
      ],
      healingAffirmation:
          'I recognize my masks but they are not me. I have the courage to express my true self.',
      relatedSymbols: ['mask', 'mirror', 'stage', 'costume', 'face'],
    ),
    'hero': ArchetypeDeepAnalysis(
      name: 'Hero',
      emoji: '⚔️',
      description:
          'The development and strengthening of the Ego. Overcoming difficulties, '
          'surmounting obstacles, courage and willpower.',
      manifestations: [
        'Killing monsters, battle',
        'Overcoming obstacles, climbing',
        'Rescue missions',
        'Journey, adventure',
        'Tests and trials',
        'Victory moments',
      ],
      integrationPath:
          'The Hero archetype is necessary to develop ego strength, but beware '
          'of inflation (inflated ego).',
      questions: [
        'What challenges am I facing?',
        'What does the hero within me want?',
        'What am I trying to save?',
        'Where does courage come from?',
      ],
      healingAffirmation:
          'I am my own hero. I have the strength to face challenges.',
      relatedSymbols: ['sword', 'dragon', 'path', 'mountain', 'treasure'],
    ),
    'trickster': ArchetypeDeepAnalysis(
      name: 'Trickster',
      emoji: '🃏',
      description:
          'Energy that breaks rules and brings unexpected change. Chaos, jokes, '
          'transformation, and transcending boundaries.',
      manifestations: [
        'Clown, joker figures',
        'Fox, crow, monkey',
        'Absurd, illogical situations',
        'Jokes, games, deceptions',
        'Role reversals',
        'Unexpected turns',
      ],
      integrationPath:
          'The Trickster is necessary for breaking rigid structures and gaining new '
          'perspectives. Teaches humor and flexibility.',
      questions: [
        'What am I taking too seriously in my life?',
        'Which rules are restricting me?',
        'How can I express my playfulness?',
        'What is chaos teaching me?',
      ],
      healingAffirmation:
          'I can approach life with lightness. Change is my friend.',
      relatedSymbols: ['fox', 'monkey', 'clown', 'crow', 'joker'],
    ),
    'wise_old_man': ArchetypeDeepAnalysis(
      name: 'Wise Old Man/Woman',
      emoji: '🧙',
      description:
          'Inner wisdom, guidance, search for meaning. Spiritual teacher, '
          'mentor, inner voice.',
      manifestations: [
        'Elderly wise figures',
        'Wizard, shaman, monk',
        'Teacher, professor',
        'Religious leaders',
        'Ancestral spirits',
        'Talking animals (wise)',
      ],
      integrationPath:
          'Connection with the Wise Old One is trusting inner guidance and '
          'exploring the deep meanings of life.',
      questions: [
        'How much do I trust my inner wisdom?',
        'Who is my mentor in life?',
        'Which deep questions am I avoiding?',
        'Where am I on my spiritual journey?',
      ],
      healingAffirmation:
          'I listen to the wise voice within me. Guidance is always available.',
      relatedSymbols: ['book', 'staff', 'owl', 'mountain', 'star'],
    ),
    'great_mother': ArchetypeDeepAnalysis(
      name: 'Great Mother',
      emoji: '🌍',
      description:
          'Creative and destructive mother energy. Nurturing, protection, fertility, '
          'but also engulfing, smothering, control.',
      manifestations: [
        'Mother figures (positive/negative)',
        'Mother Nature, earth, sea',
        'Cave, home, nest',
        'Pregnancy, birth',
        'Food, nurturing',
        'Large animals (bear, cow)',
      ],
      integrationPath:
          'The Great Mother archetype is about finding balance between dependency '
          'and independence. Both nurturing and individuation.',
      questions: [
        'How is my relationship with my mother?',
        'Am I nurturing myself?',
        'Do I have dependency patterns?',
        'How am I using my creative energy?',
      ],
      healingAffirmation:
          'I can nurture and protect myself. I make peace with the mother energy within me.',
      relatedSymbols: ['earth', 'cave', 'sea', 'moon', 'flower', 'tree'],
    ),
    'divine_child': ArchetypeDeepAnalysis(
      name: 'Divine Child',
      emoji: '👶',
      description:
          'Innocence, potential, renewal. Creativity, curiosity, new beginnings, '
          'and promise of the future.',
      manifestations: [
        'Baby, small child',
        'Lost child (abandoned)',
        'Wonder child (special powers)',
        'Play, creativity',
        'Innocence',
        'New beginnings',
      ],
      integrationPath:
          'The Divine Child is about healing our inner child and '
          'rediscovering our creativity.',
      questions: [
        'How is my inner child?',
        'When did I lose my joy?',
        'Am I suppressing my creativity?',
        'Am I ready for renewal?',
      ],
      healingAffirmation:
          'I can play with my inner child and rediscover their joy.',
      relatedSymbols: ['baby', 'toy', 'sun', 'bird', 'flower'],
    ),
  };

  /// Individuation Process
  static const IndividuationProcess individuationProcess = IndividuationProcess(
    description:
        'Jung\'s concept of individuation is the process of realizing one\'s unique '
        'wholeness. Dreams are the map of this process.',
    stages: [
      IndividuationStage(
        name: 'Persona Awareness',
        description: 'Recognition and questioning of social masks',
        dreamSigns: ['Mask falling off', 'Nakedness', 'Identity confusion'],
        task: 'Understand the difference between who you are and who you appear to be',
      ),
      IndividuationStage(
        name: 'Confronting the Shadow',
        description: 'Acceptance of suppressed aspects',
        dreamSigns: ['Enemy figures', 'Dark places', 'Being chased'],
        task: 'Embrace the aspects you have rejected',
      ),
      IndividuationStage(
        name: 'Anima/Animus Integration',
        description: 'Balancing of opposite gender energy',
        dreamSigns: ['Love dreams', 'Mysterious figures', 'Union'],
        task: 'Find the inner feminine/masculine balance',
      ),
      IndividuationStage(
        name: 'Self Realization',
        description: 'Experience of wholeness and meaning',
        dreamSigns: ['Mandala', 'Center', 'Enlightenment', 'Finding treasure'],
        task: 'Unite all parts, become whole',
      ),
    ],
  );

  /// Dream Amplification
  static const List<AmplificationTechnique> amplificationTechniques = [
    AmplificationTechnique(
      name: 'Mythological Amplification',
      description:
          'Relating dream symbols to world mythologies. '
          'Deepening personal meaning through universal stories.',
      steps: [
        'Identify the main symbol in the dream',
        'Research its counterparts in mythology',
        'Examine similar stories in different cultures',
        'Make your personal connection',
        'Apply the myth\'s teaching to your life',
      ],
      example:
          'Snake dream → Snake that steals the plant of immortality in the Epic of Gilgamesh → '
          'Asclepius\'s healing snake → Kundalini energy → Theme of transformation and healing',
    ),
    AmplificationTechnique(
      name: 'Symbolic Series Analysis',
      description:
          'Examining multiple dreams as a series. '
          'Recurring symbols and evolving themes.',
      steps: [
        'Review the last 10-20 dreams',
        'List recurring symbols',
        'Track the evolution of symbols',
        'Create a "dream story"',
        'Identify the main theme and message',
      ],
      example:
          'First dream: Drowning → 3rd dream: Learning to swim → 7th dream: Diving → '
          '10th dream: Underwater treasure → Journey of emotional deepening',
    ),
    AmplificationTechnique(
      name: 'Active Imagination',
      description:
          'Technique developed by Jung. Dialoguing with dream images while awake.',
      steps: [
        'Sit in a comfortable position, close your eyes',
        'Call up an image from the dream',
        'Allow the image to move',
        'Talk to the image, ask questions',
        'Record the dialogue',
      ],
      example:
          'To the wise woman in the dream: "Who are you?" → "I am the voice of intuition" → '
          '"What do you want to teach?" → "Feel before you think"',
    ),
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// FREUDIAN PSYCHOANALYSIS
// ════════════════════════════════════════════════════════════════════════════

/// Freudian dream analysis
class FreudianDreamPsychology {
  /// Basic concepts
  static const FreudianTheory basicTheory = FreudianTheory(
    wishFulfillment:
        'According to Freud, every dream is a wish fulfillment. Unconscious desires, '
        'what is suppressed during the day, find symbolic expression at night.',
    latentContent:
        'The dream\'s hidden content (latent content) - the real meaning. '
        'Transforms into manifest content after passing through censorship.',
    manifestContent:
        'The dream\'s apparent content (manifest content) - the remembered story. '
        'The symbolic disguise of the hidden content.',
    dreamWork:
        'Dream work - the process of transforming unconscious material into dreams. '
        'Condensation, displacement, symbolization.',
  );

  /// Dream mechanisms
  static const List<DreamMechanism> mechanisms = [
    DreamMechanism(
      name: 'Condensation',
      description:
          'Multiple ideas, people, or emotions combine into a single image. '
          'A single figure in a dream can represent many meanings.',
      examples: [
        'One face may carry features of multiple people',
        'A single place may represent multiple locations',
        'An object may symbolize multiple emotions',
      ],
      interpretationTip:
          'Consider that each element in the dream may have multiple associations. '
          'Ask: "What else does this image remind me of?"',
    ),
    DreamMechanism(
      name: 'Displacement',
      description:
          'Emotional charge shifts from an important object to a less important one. '
          'The most intense part of the dream may hide the real message.',
      examples: [
        'Anger toward mother is directed at a stranger',
        'Sexual desire is symbolized by an object',
        'Fear appears in a harmless figure',
      ],
      interpretationTip:
          'The most "meaningless" part of the dream, not the most emotional, may be important. '
          'Pay attention to seemingly insignificant details.',
    ),
    DreamMechanism(
      name: 'Symbolization',
      description:
          'Forbidden or unacceptable content is expressed through symbols. '
          'Especially sexual and aggressive content.',
      examples: [
        'Long objects → Masculine symbols',
        'Enclosed spaces → Feminine symbols',
        'Weapons, knives → Aggression',
        'Climbing stairs → Sexual activity',
      ],
      interpretationTip:
          'Symbols may be universal, but personal associations are more important. '
          'Ask: "What does this symbol mean to YOU?"',
    ),
    DreamMechanism(
      name: 'Secondary Revision',
      description:
          'Upon waking, the brain tries to turn the dream into a logical story. '
          'Gaps are filled, inconsistencies are corrected.',
      examples: [
        'Making the dream "make sense" when telling it',
        'Filling in missing parts',
        'Connecting inconsistent scenes',
      ],
      interpretationTip:
          'The inconsistent, illogical parts of the dream are important. '
          'Resist the urge to "fix" them.',
    ),
  ];

  /// Freudian symbols
  static const Map<String, FreudianSymbol> symbols = {
    // Masculine symbols
    'snake': FreudianSymbol(
      symbol: 'Snake',
      freudianMeaning: 'Phallic symbol, sexual energy, danger and attraction',
      unconsciousContent: 'Repressed sexuality or masculine energy',
      relatedFeelings: ['Fear', 'Attraction', 'Power'],
    ),
    'sword': FreudianSymbol(
      symbol: 'Sword',
      freudianMeaning: 'Masculine power, penetration, aggression',
      unconsciousContent: 'Desire for control, sexual drives',
      relatedFeelings: ['Power', 'Aggression', 'Protection'],
    ),
    'weapon': FreudianSymbol(
      symbol: 'Weapon',
      freudianMeaning: 'Phallic symbol, power, threat or protection',
      unconsciousContent: 'Repressed anger, need for control',
      relatedFeelings: ['Fear', 'Power', 'Defense'],
    ),
    // Feminine symbols
    'cave': FreudianSymbol(
      symbol: 'Cave',
      freudianMeaning: 'Womb symbol, unconscious, femininity',
      unconsciousContent: 'Desire to return to mother, need for security',
      relatedFeelings: ['Safety', 'Fear', 'Curiosity'],
    ),
    'house': FreudianSymbol(
      symbol: 'House',
      freudianMeaning: 'Body, self, family. Floors represent layers of the psyche.',
      unconsciousContent: 'Self-image, family dynamics',
      relatedFeelings: ['Security', 'Identity', 'Belonging'],
    ),
    'water': FreudianSymbol(
      symbol: 'Water',
      freudianMeaning: 'Amniotic fluid, unconscious, birth',
      unconsciousContent: 'Emotional world, mother relationship',
      relatedFeelings: ['Calmness', 'Fear', 'Purification'],
    ),
    // Other important symbols
    'flying': FreudianSymbol(
      symbol: 'Flying',
      freudianMeaning: 'Sexual excitement, liberation, superiority',
      unconsciousContent: 'Desire to escape restrictions',
      relatedFeelings: ['Freedom', 'Excitement', 'Fear'],
    ),
    'falling': FreudianSymbol(
      symbol: 'Falling',
      freudianMeaning: 'Loss of control, fear of failure, sexual surrender',
      unconsciousContent: 'Insecurity, ego under threat',
      relatedFeelings: ['Fear', 'Helplessness', 'Panic'],
    ),
    'teeth': FreudianSymbol(
      symbol: 'Teeth (falling out)',
      freudianMeaning: 'Castration anxiety, aging, loss of power',
      unconsciousContent: 'Sexual/power anxieties',
      relatedFeelings: ['Shame', 'Fear', 'Powerlessness'],
    ),
  };

  /// Free association technique
  static const FreeAssociationTechnique freeAssociation =
      FreeAssociationTechnique(
    description:
        'Freud\'s fundamental technique. Starting from dream elements, saying '
        'everything that comes to mind without censorship.',
    steps: [
      'Choose an image from the dream',
      'Say the first thing that comes to mind about that image',
      'Then what comes to mind about that...',
      'Follow the chain, don\'t censor',
      'Pay attention to points of resistance',
      'Look where emotions intensify',
    ],
    tips: [
      'Don\'t try to be logical',
      'Don\'t censor embarrassing thoughts',
      'Pay attention to where you hesitate',
      'Note emotional reactions',
    ],
  );
}

// ════════════════════════════════════════════════════════════════════════════
// GESTALT DREAM WORK
// ════════════════════════════════════════════════════════════════════════════

/// Gestalt dream approach
class GestaltDreamPsychology {
  static const String basicApproach =
      'In Gestalt, every element of the dream is a part of the dreamer. '
      'Rather than interpreting, it\'s important to relive the dream and '
      '"become" each part.';

  /// Gestalt techniques
  static const List<GestaltTechnique> techniques = [
    GestaltTechnique(
      name: 'Hot Seat',
      description:
          'Creating dialogue between different elements in the dream. Giving voice to each part.',
      steps: [
        'Place two chairs: You and the dream figure',
        'Sit in the figure\'s place, speak as them',
        'Sit in your own place, respond to the figure',
        'Continue the dialogue',
        'Observe the shift in emotions',
      ],
      example:
          '"I am the angry dog in your dream. I\'m attacking you because..." → '
          '"I\'m angry at you because you\'re neglecting me."',
    ),
    GestaltTechnique(
      name: 'I Am Everything',
      description:
          'Speak as every object, person, even the space in the dream. Everything represents you.',
      steps: [
        'Choose an element from the dream',
        'Begin with "I am [element]. I..."',
        'Describe yourself in first person',
        'Say how you feel, what you want',
        'Repeat for other elements',
      ],
      example:
          '"I am the closed door in the dream. I keep closed because...'
          'I don\'t want to show what\'s inside."',
    ),
    GestaltTechnique(
      name: 'Present Tense Narration',
      description:
          'Tell the dream not in past tense but as if it\'s happening now. '
          'Keep the emotions alive.',
      steps: [
        'Tell the dream as "now"',
        'Not "I saw" but "I see"',
        'Feel the sensations in your body',
        'Name the emotions',
        'State what you want',
      ],
      example:
          'Not: "I was running in a forest, I was scared" → '
          'Yes: "I am running in a forest. My heart is beating fast. I am scared."',
    ),
    GestaltTechnique(
      name: 'Unfinished Business',
      description:
          'Completing unfinished actions in the dream. Saying unsaid words.',
      steps: [
        'What was left incomplete in the dream?',
        'What did you want to say or do?',
        'Complete it now (in imagination)',
        'Observe the emotional shift',
        'Where does this pattern repeat in life?',
      ],
      example:
          'I couldn\'t yell at my father in the dream → Now, to the empty chair as if it\'s '
          'father: "Dad, I\'m angry at you because..."',
    ),
  ];

  /// Polarities work
  static const PolaritiesWork polarities = PolaritiesWork(
    description:
        'In Gestalt, opposites are important. Opposing elements in dreams '
        'are split parts of the personality.',
    commonPolarities: [
      'Chaser / Runner',
      'Strong / Weak',
      'Good / Bad',
      'Frightening / Frightened',
      'Giver / Taker',
      'Controller / Surrenderer',
    ],
    integration:
        'Experience both poles. Both are you. '
        'Integrating them brings wholeness.',
  );
}

// ════════════════════════════════════════════════════════════════════════════
// MODERN COGNITIVE APPROACH
// ════════════════════════════════════════════════════════════════════════════

/// Modern cognitive dream theory
class CognitiveDreamTheory {
  static const String basicApproach =
      'The cognitive approach views dreams as the brain processing information overnight, '
      'consolidating memories, and problem-solving.';

  /// Cognitive functions
  static const List<CognitiveFunction> functions = [
    CognitiveFunction(
      name: 'Memory Consolidation',
      description:
          'What is learned during the day is transferred to long-term memory during REM sleep at night.',
      dreamManifestation:
          'Daytime experiences repeat in dreams, sometimes in altered form.',
      practicalUse:
          'Good sleep is important before learning. Dreams reinforce learning.',
    ),
    CognitiveFunction(
      name: 'Emotional Processing',
      description:
          'REM sleep processes emotional memories and stores them by "cooling" them down.',
      dreamManifestation:
          'Stressful events are reprocessed in dreams. Trauma dreams.',
      practicalUse:
          'REM sleep is critical for emotional healing. Sleep deprivation increases anxiety.',
    ),
    CognitiveFunction(
      name: 'Problem Solving',
      description:
          'The brain continues working on problems while sleeping. Creative solutions may emerge.',
      dreamManifestation:
          '"Aha!" moments upon waking. Finding solutions in dreams.',
      practicalUse:
          'Think about the problem before sleep. New ideas may come in the morning.',
    ),
    CognitiveFunction(
      name: 'Threat Simulation',
      description:
          'Evolutionary theory: Dreams allow us to safely rehearse dangerous situations.',
      dreamManifestation:
          'Chase, fight, escape dreams. Threat scenarios.',
      practicalUse:
          'Nightmares may be "training." Subconscious preparation.',
    ),
  ];

  /// Cognitive questions for dream journaling
  static const List<String> cognitiveQuestions = [
    'What events from yesterday is this dream connected to?',
    'What does the problem in the dream reflect in real life?',
    'Which emotion was intense in the dream? Do I experience this emotion during the day too?',
    'Does the dream contain a solution suggestion?',
    'What might the brain be "processing"?',
    'Is this dream part of a pattern?',
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// MODEL CLASSES
// ════════════════════════════════════════════════════════════════════════════

class ArchetypeDeepAnalysis {
  final String name;
  final String emoji;
  final String description;
  final List<String> manifestations;
  final String integrationPath;
  final List<String> questions;
  final String healingAffirmation;
  final List<String> relatedSymbols;

  const ArchetypeDeepAnalysis({
    required this.name,
    required this.emoji,
    required this.description,
    required this.manifestations,
    required this.integrationPath,
    required this.questions,
    required this.healingAffirmation,
    required this.relatedSymbols,
  });
}

class IndividuationProcess {
  final String description;
  final List<IndividuationStage> stages;

  const IndividuationProcess({
    required this.description,
    required this.stages,
  });
}

class IndividuationStage {
  final String name;
  final String description;
  final List<String> dreamSigns;
  final String task;

  const IndividuationStage({
    required this.name,
    required this.description,
    required this.dreamSigns,
    required this.task,
  });
}

class AmplificationTechnique {
  final String name;
  final String description;
  final List<String> steps;
  final String example;

  const AmplificationTechnique({
    required this.name,
    required this.description,
    required this.steps,
    required this.example,
  });
}

class FreudianTheory {
  final String wishFulfillment;
  final String latentContent;
  final String manifestContent;
  final String dreamWork;

  const FreudianTheory({
    required this.wishFulfillment,
    required this.latentContent,
    required this.manifestContent,
    required this.dreamWork,
  });
}

class DreamMechanism {
  final String name;
  final String description;
  final List<String> examples;
  final String interpretationTip;

  const DreamMechanism({
    required this.name,
    required this.description,
    required this.examples,
    required this.interpretationTip,
  });
}

class FreudianSymbol {
  final String symbol;
  final String freudianMeaning;
  final String unconsciousContent;
  final List<String> relatedFeelings;

  const FreudianSymbol({
    required this.symbol,
    required this.freudianMeaning,
    required this.unconsciousContent,
    required this.relatedFeelings,
  });
}

class FreeAssociationTechnique {
  final String description;
  final List<String> steps;
  final List<String> tips;

  const FreeAssociationTechnique({
    required this.description,
    required this.steps,
    required this.tips,
  });
}

class GestaltTechnique {
  final String name;
  final String description;
  final List<String> steps;
  final String example;

  const GestaltTechnique({
    required this.name,
    required this.description,
    required this.steps,
    required this.example,
  });
}

class PolaritiesWork {
  final String description;
  final List<String> commonPolarities;
  final String integration;

  const PolaritiesWork({
    required this.description,
    required this.commonPolarities,
    required this.integration,
  });
}

class CognitiveFunction {
  final String name;
  final String description;
  final String dreamManifestation;
  final String practicalUse;

  const CognitiveFunction({
    required this.name,
    required this.description,
    required this.dreamManifestation,
    required this.practicalUse,
  });
}
