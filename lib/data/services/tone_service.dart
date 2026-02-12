// Tone Service for US/UK English variants
//
// This service provides tone-appropriate copy for different English-speaking markets.
// US English tends to be casual, direct, and friendly.
// UK English tends to be refined, calm, and slightly more formal.

/// Tone region for US/UK English variants
enum ToneRegion { us, uk }

class ToneService {
  static ToneRegion _currentRegion = ToneRegion.us;

  /// Get the current tone region
  static ToneRegion get currentRegion => _currentRegion;

  /// Set the tone region
  static void setRegion(ToneRegion region) {
    _currentRegion = region;
  }

  /// Get text for the current region
  static String getText(String usText, String ukText) {
    return _currentRegion == ToneRegion.us ? usText : ukText;
  }

  /// Apply spelling transformations for the current region
  static String applySpelling(String text) {
    if (_currentRegion == ToneRegion.uk) {
      return _toUkSpelling(text);
    }
    return text;
  }

  static String _toUkSpelling(String text) {
    // Common US -> UK spelling transformations
    final transformations = {
      'color': 'colour',
      'Color': 'Colour',
      'COLOR': 'COLOUR',
      'favor': 'favour',
      'Favor': 'Favour',
      'FAVOR': 'FAVOUR',
      'honor': 'honour',
      'Honor': 'Honour',
      'HONOR': 'HONOUR',
      'behavior': 'behaviour',
      'Behavior': 'Behaviour',
      'BEHAVIOR': 'BEHAVIOUR',
      'personalize': 'personalise',
      'Personalize': 'Personalise',
      'PERSONALIZE': 'PERSONALISE',
      'personalized': 'personalised',
      'Personalized': 'Personalised',
      'PERSONALIZED': 'PERSONALISED',
      'analyze': 'analyse',
      'Analyze': 'Analyse',
      'ANALYZE': 'ANALYSE',
      'realized': 'realised',
      'Realized': 'Realised',
      'organize': 'organise',
      'Organize': 'Organise',
      'recognize': 'recognise',
      'Recognize': 'Recognise',
      'center': 'centre',
      'Center': 'Centre',
      'CENTER': 'CENTRE',
      'theater': 'theatre',
      'Theater': 'Theatre',
      'THEATER': 'THEATRE',
      'meter': 'metre',
      'Meter': 'Metre',
      'fiber': 'fibre',
      'Fiber': 'Fibre',
      'defense': 'defence',
      'Defense': 'Defence',
      'offense': 'offence',
      'Offense': 'Offence',
      'license': 'licence',
      'License': 'Licence',
      'practice': 'practise',
      'Practice': 'Practise',
      'gray': 'grey',
      'Gray': 'Grey',
      'GRAY': 'GREY',
      'jewelry': 'jewellery',
      'Jewelry': 'Jewellery',
      'traveling': 'travelling',
      'Traveling': 'Travelling',
      'canceled': 'cancelled',
      'Canceled': 'Cancelled',
      'modeling': 'modelling',
      'Modeling': 'Modelling',
      'fulfill': 'fulfil',
      'Fulfill': 'Fulfil',
      'skillful': 'skilful',
      'Skillful': 'Skilful',
      'enrollment': 'enrolment',
      'Enrollment': 'Enrolment',
      'catalog': 'catalogue',
      'Catalog': 'Catalogue',
      'dialog': 'dialogue',
      'Dialog': 'Dialogue',
      'program': 'programme',
      'Program': 'Programme',
      'pajamas': 'pyjamas',
      'Pajamas': 'Pyjamas',
      'mom': 'mum',
      'Mom': 'Mum',
      'MOM': 'MUM',
    };

    var result = text;
    for (final entry in transformations.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }
}

/// Marketing copy variants for US and UK markets
class MarketingCopy {
  // CTA Buttons
  static String get getStarted =>
      ToneService.getText('Get Started', 'Begin Your Journey');

  static String get learnMore =>
      ToneService.getText('Learn More', 'Discover More');

  static String get checkItOut =>
      ToneService.getText('Check it out', 'Have a look');

  static String get tryNow => ToneService.getText('Try Now', 'Try It Now');

  static String get signUp => ToneService.getText('Sign Up', 'Create Account');

  static String get downloadFree =>
      ToneService.getText('Download Free', 'Download for Free');

  // Greetings
  static String get hi => ToneService.getText('Hi', 'Hello');

  static String get hey => ToneService.getText('Hey', 'Hello');

  static String greeting(String name) =>
      ToneService.getText('Hey $name!', 'Hello $name,');

  // Feature descriptions
  static String get personalizedInsights => ToneService.getText(
    'Personalized insights just for you',
    'Personalised insights tailored to you',
  );

  static String get checkYourInsights =>
      ToneService.getText('Check your daily insights', 'View your daily insights');

  static String get exploreYourChart =>
      ToneService.getText('Explore your chart', 'Discover your chart');

  static String get unlockFeatures =>
      ToneService.getText('Unlock all features', 'Access all features');

  // Push notifications
  static String get cosmicMissesYou => ToneService.getText(
    'The cosmos misses you!',
    'Welcome back to your reflection space.',
  );

  static String get dontMiss =>
      ToneService.getText("Don't miss out!", "Don't miss this.");

  static String get readyForYou =>
      ToneService.getText('Ready for you!', 'Ready for you.');

  // Error messages
  static String get somethingWentWrong => ToneService.getText(
    'Oops! Something went wrong.',
    'Apologies, something went wrong.',
  );

  static String get tryAgain =>
      ToneService.getText('Try again', 'Please try again');

  // Success messages
  static String get awesome => ToneService.getText('Awesome!', 'Wonderful!');

  static String get gotIt => ToneService.getText('Got it!', 'Understood!');

  static String get allSet =>
      ToneService.getText("You're all set!", "You're all ready!");

  // Marketing headlines
  static String get heroHeadline => ToneService.getText(
    'Your Personal Reflection Journal, Always With You',
    'Your Personal Reflection Journal, Always at Hand',
  );

  static String get heroSubheadline => ToneService.getText(
    'Get personalized insights, daily reflections, and mindful guidance — powered by AI and timeless wisdom.',
    'Receive personalised insights, daily reflections, and mindful guidance — powered by AI and timeless wisdom.',
  );

  static String get valueProposition => ToneService.getText(
    'Every insight is tailored to your personal journey — not generic content.',
    'Every insight is tailored to your personal journey — not generic content.',
  );

  static String get socialProof => ToneService.getText(
    'Trusted by 500K+ cosmic seekers worldwide',
    'Trusted by 500,000+ cosmic seekers worldwide',
  );

  static String get finalCta =>
      ToneService.getText('The Stars Are Waiting', 'The Stars Await');

  // Email subject lines
  static String welcomeSubject(String appName) => ToneService.getText(
    'Welcome to $appName — Your Cosmic Journey Begins',
    'Welcome to $appName — Your Cosmic Journey Awaits',
  );

  static String get birthdaySubject => ToneService.getText(
    'Happy Birthday! Your Solar Return is here',
    'Many Happy Returns! Your Solar Return awaits',
  );

  // Casual expressions to formal
  static String get checkOut => ToneService.getText('Check out', 'Discover');

  static String get superEasy =>
      ToneService.getText('Super easy', 'Quite simple');

  static String get totally => ToneService.getText('totally', 'completely');

  static String get amazing => ToneService.getText('amazing', 'remarkable');

  static String get awesome2 => ToneService.getText('awesome', 'wonderful');
}

/// Extension for applying tone to any string
extension ToneStringExtension on String {
  /// Apply UK spelling transformations if UK region is active
  String get withTone => ToneService.applySpelling(this);
}
