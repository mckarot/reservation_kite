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

  /// No description provided for @adminScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Panneau Administrateur'**
  String get adminScreenTitle;

  /// No description provided for @pendingAbsencesAlert.
  ///
  /// In fr, this message translates to:
  /// **'ABSENCES À VALIDER'**
  String get pendingAbsencesAlert;

  /// No description provided for @dashboardKPIs.
  ///
  /// In fr, this message translates to:
  /// **'Dashboard (KPIs)'**
  String get dashboardKPIs;

  /// No description provided for @calendarBookings.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get calendarBookings;

  /// No description provided for @seeRequests.
  ///
  /// In fr, this message translates to:
  /// **'Voir les {count} demandes...'**
  String seeRequests(int count);

  /// No description provided for @registrationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registrationTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom Complet'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre nom complet'**
  String get fullNameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPasswordLabel;

  /// No description provided for @weightLabel.
  ///
  /// In fr, this message translates to:
  /// **'Poids (kg)'**
  String get weightLabel;

  /// No description provided for @weightHint.
  ///
  /// In fr, this message translates to:
  /// **'Optionnel'**
  String get weightHint;

  /// No description provided for @createAccountButton.
  ///
  /// In fr, this message translates to:
  /// **'CRÉER LE COMPTE'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'DÉJÀ UN COMPTE ? SE CONNECTER'**
  String get alreadyHaveAccount;

  /// No description provided for @passwordsMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get passwordsMismatch;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'✅ Compte créé avec succès ! Vous pouvez vous connecter.'**
  String get accountCreatedSuccess;

  /// No description provided for @uploadPhoto.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une photo'**
  String get uploadPhoto;

  /// No description provided for @staffManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du Staff'**
  String get staffManagement;

  /// No description provided for @staffTab.
  ///
  /// In fr, this message translates to:
  /// **'Staff'**
  String get staffTab;

  /// No description provided for @absencesTab.
  ///
  /// In fr, this message translates to:
  /// **'Absences'**
  String get absencesTab;

  /// No description provided for @pendingHeader.
  ///
  /// In fr, this message translates to:
  /// **'EN ATTENTE'**
  String get pendingHeader;

  /// No description provided for @historyHeader.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE'**
  String get historyHeader;

  /// No description provided for @slotFullDay.
  ///
  /// In fr, this message translates to:
  /// **'Journée entière'**
  String get slotFullDay;

  /// No description provided for @slotMorning.
  ///
  /// In fr, this message translates to:
  /// **'Matin'**
  String get slotMorning;

  /// No description provided for @slotAfternoon.
  ///
  /// In fr, this message translates to:
  /// **'Après-midi'**
  String get slotAfternoon;

  /// No description provided for @reasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Motif'**
  String get reasonLabel;

  /// No description provided for @noRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande.'**
  String get noRequests;

  /// No description provided for @editInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Modifier Moniteur'**
  String get editInstructor;

  /// No description provided for @addInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Moniteur'**
  String get addInstructor;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom Complet'**
  String get fullName;

  /// No description provided for @bio.
  ///
  /// In fr, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @specialtiesHint.
  ///
  /// In fr, this message translates to:
  /// **'Spécialités (virgule)'**
  String get specialtiesHint;

  /// No description provided for @photoUrl.
  ///
  /// In fr, this message translates to:
  /// **'Photo URL'**
  String get photoUrl;

  /// No description provided for @loginCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants de connexion'**
  String get loginCredentials;

  /// No description provided for @passwordHint6.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe (min 6 car.)'**
  String get passwordHint6;

  /// No description provided for @cancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveButton;

  /// No description provided for @addButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get addButton;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'Attente'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Validé'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get statusRejected;

  /// No description provided for @errorLabel.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get errorLabel;

  /// No description provided for @sessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Session expirée ou profil introuvable'**
  String get sessionExpired;

  /// No description provided for @noUsersFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur trouvé dans la base.'**
  String get noUsersFound;

  /// No description provided for @pupilSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace Élève'**
  String get pupilSpace;

  /// No description provided for @myProgress.
  ///
  /// In fr, this message translates to:
  /// **'Ma Progression'**
  String get myProgress;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @logoutTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logoutTooltip;

  /// No description provided for @homeTab.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTab;

  /// No description provided for @progressTab.
  ///
  /// In fr, this message translates to:
  /// **'Progrès'**
  String get progressTab;

  /// No description provided for @alertsTab.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get alertsTab;

  /// No description provided for @historyTab.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historyTab;

  /// No description provided for @bookButton.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get bookButton;

  /// No description provided for @slotUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get slotUnknown;

  /// No description provided for @noLessonsScheduled.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as pas encore de cours de prévu.'**
  String get noLessonsScheduled;

  /// No description provided for @lessonOn.
  ///
  /// In fr, this message translates to:
  /// **'Cours du'**
  String get lessonOn;

  /// No description provided for @slotLabel.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get slotLabel;

  /// No description provided for @statusUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À VENIR'**
  String get statusUpcoming;

  /// No description provided for @statusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'TERMINÉ'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'ANNULÉ'**
  String get statusCancelled;

  /// No description provided for @profileTab.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTab;

  /// No description provided for @notesTab.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notesTab;

  /// No description provided for @nameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get nameLabel;

  /// No description provided for @currentBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde actuel'**
  String get currentBalance;

  /// No description provided for @credits.
  ///
  /// In fr, this message translates to:
  /// **'crédits'**
  String get credits;

  /// No description provided for @sellPack.
  ///
  /// In fr, this message translates to:
  /// **'Vendre un Pack'**
  String get sellPack;

  /// No description provided for @creditAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créditer le compte'**
  String get creditAccount;

  /// No description provided for @noStandardPack.
  ///
  /// In fr, this message translates to:
  /// **'Aucun pack standard trouvé.\nUtilisez la saisie sur mesure ci-dessous.'**
  String get noStandardPack;

  /// No description provided for @customEntry.
  ///
  /// In fr, this message translates to:
  /// **'Saisie sur mesure'**
  String get customEntry;

  /// No description provided for @numberOfSessions.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de séances'**
  String get numberOfSessions;

  /// No description provided for @packAdded.
  ///
  /// In fr, this message translates to:
  /// **'Pack {name} ajouté !'**
  String packAdded(String name);

  /// No description provided for @sessionsAdded.
  ///
  /// In fr, this message translates to:
  /// **'{count} séances ajoutées !'**
  String sessionsAdded(int count);

  /// No description provided for @adjustTotal.
  ///
  /// In fr, this message translates to:
  /// **'Ajuster le total (Admin)'**
  String get adjustTotal;

  /// No description provided for @modifyBalance.
  ///
  /// In fr, this message translates to:
  /// **'Modifier solde (Manuel)'**
  String get modifyBalance;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @invalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un nombre valide'**
  String get invalidNumber;

  /// No description provided for @validationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Validation : {name}'**
  String validationTitle(String name);

  /// No description provided for @skillsValidatedToday.
  ///
  /// In fr, this message translates to:
  /// **'Compétences validées aujourd\'hui'**
  String get skillsValidatedToday;

  /// No description provided for @ikoGlobalLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau IKO Global'**
  String get ikoGlobalLevel;

  /// No description provided for @pedagogicalNote.
  ///
  /// In fr, this message translates to:
  /// **'Note pédagogique'**
  String get pedagogicalNote;

  /// No description provided for @sessionNoteHint.
  ///
  /// In fr, this message translates to:
  /// **'Comment s\'est passée la séance ?'**
  String get sessionNoteHint;

  /// No description provided for @materialIncident.
  ///
  /// In fr, this message translates to:
  /// **'Incident Matériel ?'**
  String get materialIncident;

  /// No description provided for @selectEquipmentIssue.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner le matériel avec un souci'**
  String get selectEquipmentIssue;

  /// No description provided for @maintenance.
  ///
  /// In fr, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @damaged.
  ///
  /// In fr, this message translates to:
  /// **'HS'**
  String get damaged;

  /// No description provided for @validateProgress.
  ///
  /// In fr, this message translates to:
  /// **'Valider la progression'**
  String get validateProgress;

  /// No description provided for @progressSaved.
  ///
  /// In fr, this message translates to:
  /// **'Progression enregistrée !'**
  String get progressSaved;

  /// No description provided for @errorLoadingEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement matériel'**
  String get errorLoadingEquipment;

  /// No description provided for @equipmentStatusUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Statut matériel mis à jour !'**
  String get equipmentStatusUpdated;

  /// No description provided for @monitorSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace Moniteur'**
  String get monitorSpace;

  /// No description provided for @myAbsences.
  ///
  /// In fr, this message translates to:
  /// **'Mes Absences'**
  String get myAbsences;

  /// No description provided for @monitorProfileNotActive.
  ///
  /// In fr, this message translates to:
  /// **'Profil Moniteur non activé'**
  String get monitorProfileNotActive;

  /// No description provided for @monitorProfileNotActiveDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte a été créé, mais un administrateur doit encore vous ajouter à l\'effectif de l\'école pour activer votre espace.'**
  String get monitorProfileNotActiveDesc;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'SE DÉCONNECTER'**
  String get signOut;

  /// No description provided for @lessonPlan.
  ///
  /// In fr, this message translates to:
  /// **'PLANNING DES COURS'**
  String get lessonPlan;

  /// No description provided for @noLessonsAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Aucun cours assigné pour ce jour'**
  String get noLessonsAssigned;

  /// No description provided for @declareAbsence.
  ///
  /// In fr, this message translates to:
  /// **'Déclarer une absence'**
  String get declareAbsence;

  /// No description provided for @noAbsencesDeclared.
  ///
  /// In fr, this message translates to:
  /// **'Aucune absence déclarée.'**
  String get noAbsencesDeclared;

  /// No description provided for @absenceRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande d\'absence'**
  String get absenceRequestTitle;

  /// No description provided for @timeSlot.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get timeSlot;

  /// No description provided for @absenceReasonHint.
  ///
  /// In fr, this message translates to:
  /// **'Motif (ex: Perso, Maladie)'**
  String get absenceReasonHint;

  /// No description provided for @send.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get send;

  /// No description provided for @greeting.
  ///
  /// In fr, this message translates to:
  /// **'Salut, {name} ! 🤙'**
  String greeting(String name);

  /// No description provided for @offSystem.
  ///
  /// In fr, this message translates to:
  /// **'Hors Système'**
  String get offSystem;

  /// No description provided for @fullDay.
  ///
  /// In fr, this message translates to:
  /// **'Journée entière'**
  String get fullDay;

  /// No description provided for @reservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservations;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @noReservationsOnSlot.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation sur ce créneau'**
  String get noReservationsOnSlot;

  /// No description provided for @instructorUnassigned.
  ///
  /// In fr, this message translates to:
  /// **'Moniteur non assigné'**
  String get instructorUnassigned;

  /// No description provided for @noteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @newReservation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Réservation'**
  String get newReservation;

  /// No description provided for @clientNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du Client'**
  String get clientNameLabel;

  /// No description provided for @instructorOptional.
  ///
  /// In fr, this message translates to:
  /// **'Moniteur (Optionnel)'**
  String get instructorOptional;

  /// No description provided for @randomInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Au hasard / Équipe'**
  String get randomInstructor;

  /// No description provided for @notesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes / Commentaires'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Préférence moniteur...'**
  String get notesHint;

  /// No description provided for @schoolSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages École'**
  String get schoolSettings;

  /// No description provided for @settingsNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : Paramètres non trouvés'**
  String get settingsNotFound;

  /// No description provided for @morningHours.
  ///
  /// In fr, this message translates to:
  /// **'Horaires Matin'**
  String get morningHours;

  /// No description provided for @afternoonHours.
  ///
  /// In fr, this message translates to:
  /// **'Horaires Après-midi'**
  String get afternoonHours;

  /// No description provided for @startLabel.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fin'**
  String get endLabel;

  /// No description provided for @maxStudentsPerInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Max élèves par moniteur'**
  String get maxStudentsPerInstructor;

  /// No description provided for @settingsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Réglages enregistrés !'**
  String get settingsSaved;

  /// No description provided for @packCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue des Forfaits'**
  String get packCatalog;

  /// No description provided for @packCatalogSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Définir les prix et sessions par pack'**
  String get packCatalogSubtitle;

  /// No description provided for @staffManagementSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter ou modifier des moniteurs'**
  String get staffManagementSubtitle;

  /// No description provided for @equipmentManagementSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Inventaire des ailes, boards et harnais'**
  String get equipmentManagementSubtitle;

  /// No description provided for @schoolDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Pilotage École'**
  String get schoolDashboard;

  /// No description provided for @keyMetrics.
  ///
  /// In fr, this message translates to:
  /// **'CHIFFRES CLÉS'**
  String get keyMetrics;

  /// No description provided for @totalSales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes Totales'**
  String get totalSales;

  /// No description provided for @totalEngagement.
  ///
  /// In fr, this message translates to:
  /// **'En engagement'**
  String get totalEngagement;

  /// No description provided for @pendingAbsences.
  ///
  /// In fr, this message translates to:
  /// **'ABSENCES À VALIDER'**
  String get pendingAbsences;

  /// No description provided for @pendingRequests.
  ///
  /// In fr, this message translates to:
  /// **'DEMANDES EN ATTENTE'**
  String get pendingRequests;

  /// No description provided for @upcomingPlanning.
  ///
  /// In fr, this message translates to:
  /// **'PLANNING À VENIR'**
  String get upcomingPlanning;

  /// No description provided for @topClientsVolume.
  ///
  /// In fr, this message translates to:
  /// **'TOP CLIENTS (VOLUME)'**
  String get topClientsVolume;

  /// No description provided for @noSessionsPlanned.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session prévue'**
  String get noSessionsPlanned;

  /// No description provided for @chooseInstructor.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un moniteur :'**
  String get chooseInstructor;

  /// No description provided for @confirmAndAssign.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer & Assigner'**
  String get confirmAndAssign;

  /// No description provided for @noStudentsRegistered.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élève enregistré'**
  String get noStudentsRegistered;

  /// No description provided for @balanceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Solde'**
  String get balanceLabel;

  /// No description provided for @newStudent.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Élève'**
  String get newStudent;

  /// No description provided for @createButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get createButton;

  /// No description provided for @noEquipmentInCategory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun équipement dans cette catégorie.'**
  String get noEquipmentInCategory;

  /// No description provided for @addEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter du matériel'**
  String get addEquipment;

  /// No description provided for @typeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @brandLabel.
  ///
  /// In fr, this message translates to:
  /// **'Marque (ex: F-One, North)'**
  String get brandLabel;

  /// No description provided for @modelLabel.
  ///
  /// In fr, this message translates to:
  /// **'Modèle (ex: Bandit, Rebel)'**
  String get modelLabel;

  /// No description provided for @sizeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taille (ex: 9m, 138cm)'**
  String get sizeLabel;

  /// No description provided for @statusAvailable.
  ///
  /// In fr, this message translates to:
  /// **'DISPO'**
  String get statusAvailable;

  /// No description provided for @statusMaintenance.
  ///
  /// In fr, this message translates to:
  /// **'MAINTENANCE'**
  String get statusMaintenance;

  /// No description provided for @statusDamaged.
  ///
  /// In fr, this message translates to:
  /// **'HORS SERVICE'**
  String get statusDamaged;

  /// No description provided for @makeAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Rendre Disponible'**
  String get makeAvailable;

  /// No description provided for @setMaintenance.
  ///
  /// In fr, this message translates to:
  /// **'Mettre en Maintenance'**
  String get setMaintenance;

  /// No description provided for @setDamaged.
  ///
  /// In fr, this message translates to:
  /// **'Déclarer Hors Service'**
  String get setDamaged;

  /// No description provided for @deleteButton.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteButton;

  /// No description provided for @myNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Mes Notifications'**
  String get myNotifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification pour le moment.'**
  String get noNotificationsYet;

  /// No description provided for @deleteAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout supprimer'**
  String get deleteAll;

  /// No description provided for @packCatalogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue Forfaits'**
  String get packCatalogTitle;

  /// No description provided for @sessions.
  ///
  /// In fr, this message translates to:
  /// **'séances'**
  String get sessions;

  /// No description provided for @newPack.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Forfait'**
  String get newPack;

  /// No description provided for @createPackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un forfait'**
  String get createPackTitle;

  /// No description provided for @packNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom (ex: Pack 10h)'**
  String get packNameLabel;

  /// No description provided for @numberOfCredits.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de crédits'**
  String get numberOfCredits;

  /// No description provided for @priceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix (€)'**
  String get priceLabel;
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
