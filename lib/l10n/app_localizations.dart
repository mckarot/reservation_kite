import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'Kite Reserve'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @logoutButton.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logoutButton;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte ?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'ton@email.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In fr, this message translates to:
  /// **'6 caractères minimum'**
  String get passwordHint;

  /// No description provided for @passwordHintError.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit faire au moins 6 caractères.'**
  String get passwordHintError;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion'**
  String get loginError;

  /// No description provided for @loginSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie !'**
  String get loginSuccess;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navDashboard;

  /// No description provided for @navBooking.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get navBooking;

  /// No description provided for @navProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get navSettings;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String welcomeMessage(String name);

  /// No description provided for @readyForSession.
  ///
  /// In fr, this message translates to:
  /// **'Prêt pour une session ?'**
  String get readyForSession;

  /// No description provided for @myBalance.
  ///
  /// In fr, this message translates to:
  /// **'MON SOLDE'**
  String get myBalance;

  /// No description provided for @sessionsRemaining.
  ///
  /// In fr, this message translates to:
  /// **'SÉANCES RESTANTES'**
  String get sessionsRemaining;

  /// No description provided for @quickStats.
  ///
  /// In fr, this message translates to:
  /// **'STATS RAPIDES'**
  String get quickStats;

  /// No description provided for @ikoLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau IKO'**
  String get ikoLevel;

  /// No description provided for @progression.
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get progression;

  /// No description provided for @skillsValidated.
  ///
  /// In fr, this message translates to:
  /// **'{count} compétences validées'**
  String skillsValidated(int count);

  /// No description provided for @weather.
  ///
  /// In fr, this message translates to:
  /// **'Météo'**
  String get weather;

  /// No description provided for @currentWeather.
  ///
  /// In fr, this message translates to:
  /// **'Météo Actuelle'**
  String get currentWeather;

  /// No description provided for @windSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse du vent'**
  String get windSpeed;

  /// No description provided for @windDirection.
  ///
  /// In fr, this message translates to:
  /// **'Direction du vent'**
  String get windDirection;

  /// No description provided for @temperature.
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get temperature;

  /// No description provided for @kmh.
  ///
  /// In fr, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @weatherInfo.
  ///
  /// In fr, this message translates to:
  /// **'Météo à titre indicatif, susceptible de changer.'**
  String get weatherInfo;

  /// No description provided for @bookingScreen.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get bookingScreen;

  /// No description provided for @selectDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date'**
  String get selectDate;

  /// No description provided for @selectSlot.
  ///
  /// In fr, this message translates to:
  /// **'Créneau horaire'**
  String get selectSlot;

  /// No description provided for @selectInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un moniteur'**
  String get selectInstructor;

  /// No description provided for @morning.
  ///
  /// In fr, this message translates to:
  /// **'Matin'**
  String get morning;

  /// No description provided for @morningTime.
  ///
  /// In fr, this message translates to:
  /// **'08h00 - 12h00'**
  String get morningTime;

  /// No description provided for @afternoon.
  ///
  /// In fr, this message translates to:
  /// **'Après-midi'**
  String get afternoon;

  /// No description provided for @afternoonTime.
  ///
  /// In fr, this message translates to:
  /// **'13h00 - 18h00'**
  String get afternoonTime;

  /// No description provided for @bookingNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes ou préférences (optionnel)'**
  String get bookingNotes;

  /// No description provided for @bookingNotesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Préférence pour un moniteur, niveau actuel...'**
  String get bookingNotesHint;

  /// No description provided for @bookingSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée ! En attente de validation admin.'**
  String get bookingSent;

  /// No description provided for @insufficientBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant. Veuillez recharger votre compte.'**
  String get insufficientBalance;

  /// No description provided for @sendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get sendRequest;

  /// No description provided for @slotFull.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get slotFull;

  /// No description provided for @slotUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Indisponible (Staff absent)'**
  String get slotUnavailable;

  /// No description provided for @remainingSlots.
  ///
  /// In fr, this message translates to:
  /// **'Places restantes :'**
  String get remainingSlots;

  /// No description provided for @weatherDateTooFar.
  ///
  /// In fr, this message translates to:
  /// **'La date est trop lointaine pour une prévision météo précise.'**
  String get weatherDateTooFar;

  /// No description provided for @confirmBooking.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get confirmBooking;

  /// No description provided for @cancelBooking.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelBooking;

  /// No description provided for @bookingConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée !'**
  String get bookingConfirmed;

  /// No description provided for @bookingCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Réservation annulée'**
  String get bookingCancelled;

  /// No description provided for @bookingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la réservation'**
  String get bookingError;

  /// No description provided for @noAvailableSlots.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau disponible'**
  String get noAvailableSlots;

  /// No description provided for @maxCapacityReached.
  ///
  /// In fr, this message translates to:
  /// **'Capacité maximale atteinte'**
  String get maxCapacityReached;

  /// No description provided for @ikoLevel1.
  ///
  /// In fr, this message translates to:
  /// **'Niveau 1 - Découverte'**
  String get ikoLevel1;

  /// No description provided for @ikoLevel2.
  ///
  /// In fr, this message translates to:
  /// **'Niveau 2 - Intermédiaire'**
  String get ikoLevel2;

  /// No description provided for @ikoLevel3.
  ///
  /// In fr, this message translates to:
  /// **'Niveau 3 - Indépendant'**
  String get ikoLevel3;

  /// No description provided for @ikoLevel4.
  ///
  /// In fr, this message translates to:
  /// **'Niveau 4 - Perfectionnement'**
  String get ikoLevel4;

  /// No description provided for @skillPreparation.
  ///
  /// In fr, this message translates to:
  /// **'Préparation & Sécurité'**
  String get skillPreparation;

  /// No description provided for @skillPilotage.
  ///
  /// In fr, this message translates to:
  /// **'Pilotage zone neutre'**
  String get skillPilotage;

  /// No description provided for @skillTakeoff.
  ///
  /// In fr, this message translates to:
  /// **'Décollage / Atterrissage'**
  String get skillTakeoff;

  /// No description provided for @skillBodyDrag.
  ///
  /// In fr, this message translates to:
  /// **'Nage tractée (Body Drag)'**
  String get skillBodyDrag;

  /// No description provided for @skillWaterstart.
  ///
  /// In fr, this message translates to:
  /// **'Waterstart'**
  String get skillWaterstart;

  /// No description provided for @skillNavigation.
  ///
  /// In fr, this message translates to:
  /// **'Navigation de base'**
  String get skillNavigation;

  /// No description provided for @skillUpwind.
  ///
  /// In fr, this message translates to:
  /// **'Remontée au vent'**
  String get skillUpwind;

  /// No description provided for @skillTransitions.
  ///
  /// In fr, this message translates to:
  /// **'Transitions & Sauts'**
  String get skillTransitions;

  /// No description provided for @skillBasicJump.
  ///
  /// In fr, this message translates to:
  /// **'Saut de base'**
  String get skillBasicJump;

  /// No description provided for @skillJibe.
  ///
  /// In fr, this message translates to:
  /// **'Jibe'**
  String get skillJibe;

  /// No description provided for @skillGrab.
  ///
  /// In fr, this message translates to:
  /// **'Saut avec grab'**
  String get skillGrab;

  /// No description provided for @adminPanel.
  ///
  /// In fr, this message translates to:
  /// **'Panneau Administrateur'**
  String get adminPanel;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settings;

  /// No description provided for @students.
  ///
  /// In fr, this message translates to:
  /// **'Élèves'**
  String get students;

  /// No description provided for @instructors.
  ///
  /// In fr, this message translates to:
  /// **'Moniteurs'**
  String get instructors;

  /// No description provided for @equipment.
  ///
  /// In fr, this message translates to:
  /// **'Matériel'**
  String get equipment;

  /// No description provided for @calendar.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get calendar;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @manageStaff.
  ///
  /// In fr, this message translates to:
  /// **'Gérer le Staff'**
  String get manageStaff;

  /// No description provided for @studentDirectory.
  ///
  /// In fr, this message translates to:
  /// **'Répertoire Élèves'**
  String get studentDirectory;

  /// No description provided for @equipmentManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du Matériel'**
  String get equipmentManagement;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @languageSelector.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la langue'**
  String get languageSelector;

  /// No description provided for @weatherLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation Météo'**
  String get weatherLocation;

  /// No description provided for @latitude.
  ///
  /// In fr, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In fr, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @useMyLocation.
  ///
  /// In fr, this message translates to:
  /// **'📍 Utiliser ma position'**
  String get useMyLocation;

  /// No description provided for @saveCoordinates.
  ///
  /// In fr, this message translates to:
  /// **'💾 Enregistrer'**
  String get saveCoordinates;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get noNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme lu'**
  String get markAsRead;

  /// No description provided for @deleteNotification.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteNotification;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @initSchema.
  ///
  /// In fr, this message translates to:
  /// **'Init Schéma'**
  String get initSchema;

  /// No description provided for @initSchemaSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Données de test et collections initialisées !'**
  String get initSchemaSuccess;

  /// No description provided for @initSchemaError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'initialisation'**
  String get initSchemaError;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get networkError;

  /// No description provided for @unauthorized.
  ///
  /// In fr, this message translates to:
  /// **'Non autorisé'**
  String get unauthorized;

  /// No description provided for @notFound.
  ///
  /// In fr, this message translates to:
  /// **'Non trouvé'**
  String get notFound;

  /// No description provided for @tryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
