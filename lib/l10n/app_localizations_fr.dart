// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Kite Reserve';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get logoutButton => 'Déconnexion';

  @override
  String get noAccount => 'Pas de compte ?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'ton@email.com';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordHint => '6 caractères minimum';

  @override
  String get passwordHintError =>
      'Le mot de passe doit faire au moins 6 caractères.';

  @override
  String get loginError => 'Échec de la connexion';

  @override
  String get loginSuccess => 'Connexion réussie !';

  @override
  String get navDashboard => 'Accueil';

  @override
  String get navBooking => 'Réservations';

  @override
  String get navProgress => 'Progression';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSettings => 'Réglages';

  @override
  String welcomeMessage(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get readyForSession => 'Prêt pour une session ?';

  @override
  String get myBalance => 'MON SOLDE';

  @override
  String get sessionsRemaining => 'SÉANCES RESTANTES';

  @override
  String get quickStats => 'STATS RAPIDES';

  @override
  String get ikoLevel => 'Niveau IKO';

  @override
  String get progression => 'Progression';

  @override
  String skillsValidated(int count) {
    return '$count compétences validées';
  }

  @override
  String get weather => 'Météo';

  @override
  String get currentWeather => 'Météo Actuelle';

  @override
  String get windSpeed => 'Vitesse du vent';

  @override
  String get windDirection => 'Direction du vent';

  @override
  String get temperature => 'Température';

  @override
  String get kmh => 'km/h';

  @override
  String get weatherInfo => 'Météo à titre indicatif, susceptible de changer.';

  @override
  String get bookingScreen => 'Réservations';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get selectSlot => 'Créneau horaire';

  @override
  String get selectInstructor => 'Choisir un moniteur';

  @override
  String get morning => 'Matin';

  @override
  String get morningTime => '08h00 - 12h00';

  @override
  String get afternoon => 'Après-midi';

  @override
  String get afternoonTime => '13h00 - 18h00';

  @override
  String get bookingNotes => 'Notes ou préférences (optionnel)';

  @override
  String get bookingNotesHint =>
      'Ex: Préférence pour un moniteur, niveau actuel...';

  @override
  String get bookingSent => 'Demande envoyée ! En attente de validation admin.';

  @override
  String get insufficientBalance =>
      'Solde insuffisant. Veuillez recharger votre compte.';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String get slotFull => 'Complet';

  @override
  String get slotUnavailable => 'Indisponible (Staff absent)';

  @override
  String get remainingSlots => 'Places restantes :';

  @override
  String get weatherDateTooFar =>
      'La date est trop lointaine pour une prévision météo précise.';

  @override
  String get confirmBooking => 'Confirmer la réservation';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get bookingConfirmed => 'Réservation confirmée !';

  @override
  String get bookingCancelled => 'Réservation annulée';

  @override
  String get bookingError => 'Erreur lors de la réservation';

  @override
  String get noAvailableSlots => 'Aucun créneau disponible';

  @override
  String get maxCapacityReached => 'Capacité maximale atteinte';

  @override
  String get ikoLevel1 => 'Niveau 1 - Découverte';

  @override
  String get ikoLevel2 => 'Niveau 2 - Intermédiaire';

  @override
  String get ikoLevel3 => 'Niveau 3 - Indépendant';

  @override
  String get ikoLevel4 => 'Niveau 4 - Perfectionnement';

  @override
  String get skillPreparation => 'Préparation & Sécurité';

  @override
  String get skillPilotage => 'Pilotage zone neutre';

  @override
  String get skillTakeoff => 'Décollage / Atterrissage';

  @override
  String get skillBodyDrag => 'Nage tractée (Body Drag)';

  @override
  String get skillWaterstart => 'Waterstart';

  @override
  String get skillNavigation => 'Navigation de base';

  @override
  String get skillUpwind => 'Remontée au vent';

  @override
  String get skillTransitions => 'Transitions & Sauts';

  @override
  String get skillBasicJump => 'Saut de base';

  @override
  String get skillJibe => 'Jibe';

  @override
  String get skillGrab => 'Saut avec grab';

  @override
  String get adminPanel => 'Panneau Administrateur';

  @override
  String get settings => 'Réglages';

  @override
  String get students => 'Élèves';

  @override
  String get instructors => 'Moniteurs';

  @override
  String get equipment => 'Matériel';

  @override
  String get calendar => 'Calendrier';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get manageStaff => 'Gérer le Staff';

  @override
  String get studentDirectory => 'Répertoire Élèves';

  @override
  String get equipmentManagement => 'Gestion du Matériel';

  @override
  String get language => 'Langue';

  @override
  String get languageSelector => 'Sélectionner la langue';

  @override
  String get weatherLocation => 'Localisation Météo';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get useMyLocation => '📍 Utiliser ma position';

  @override
  String get saveCoordinates => '💾 Enregistrer';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get markAsRead => 'Marquer comme lu';

  @override
  String get deleteNotification => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get confirm => 'Confirmer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get close => 'Fermer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get initSchema => 'Init Schéma';

  @override
  String get initSchemaSuccess =>
      'Données de test et collections initialisées !';

  @override
  String get initSchemaError => 'Erreur d\'initialisation';

  @override
  String get genericError => 'Une erreur est survenue';

  @override
  String get networkError => 'Erreur de connexion';

  @override
  String get unauthorized => 'Non autorisé';

  @override
  String get notFound => 'Non trouvé';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get adminScreenTitle => 'Panneau Administrateur';

  @override
  String get pendingAbsencesAlert => 'ABSENCES À VALIDER';

  @override
  String get dashboardKPIs => 'Dashboard (KPIs)';

  @override
  String get calendarBookings => 'Calendrier';

  @override
  String seeRequests(int count) {
    return 'Voir les $count demandes...';
  }

  @override
  String get registrationTitle => 'Créer un compte';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get fullNameHint => 'Votre nom complet';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get weightLabel => 'Poids (kg)';

  @override
  String get weightHint => 'Optionnel';

  @override
  String get createAccountButton => 'CRÉER LE COMPTE';

  @override
  String get alreadyHaveAccount => 'DÉJÀ UN COMPTE ? SE CONNECTER';

  @override
  String get passwordsMismatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get accountCreatedSuccess =>
      '✅ Compte créé avec succès ! Vous pouvez vous connecter.';

  @override
  String get uploadPhoto => 'Ajouter une photo';
}
