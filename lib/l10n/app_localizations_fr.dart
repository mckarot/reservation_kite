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
  String get fullNameLabel => 'Nom Complet';

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

  @override
  String get staffManagement => 'Gestion du Staff';

  @override
  String get staffTab => 'Staff';

  @override
  String get absencesTab => 'Absences';

  @override
  String get pendingHeader => 'EN ATTENTE';

  @override
  String get historyHeader => 'HISTORIQUE';

  @override
  String get slotFullDay => 'Journée entière';

  @override
  String get slotMorning => 'Matin';

  @override
  String get slotAfternoon => 'Après-midi';

  @override
  String get reasonLabel => 'Motif';

  @override
  String get noRequests => 'Aucune demande.';

  @override
  String get editInstructor => 'Modifier Moniteur';

  @override
  String get addInstructor => 'Ajouter Moniteur';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get bio => 'Bio';

  @override
  String get specialtiesHint => 'Spécialités (virgule)';

  @override
  String get photoUrl => 'Photo URL';

  @override
  String get loginCredentials => 'Identifiants de connexion';

  @override
  String get passwordHint6 => 'Mot de passe (min 6 car.)';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get addButton => 'Ajouter';

  @override
  String get statusPending => 'Attente';

  @override
  String get statusApproved => 'Validé';

  @override
  String get statusRejected => 'Refusé';

  @override
  String get errorLabel => 'Erreur';

  @override
  String get sessionExpired => 'Session expirée ou profil introuvable';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé dans la base.';

  @override
  String get pupilSpace => 'Espace Élève';

  @override
  String get myProgress => 'Ma Progression';

  @override
  String get history => 'Historique';

  @override
  String get logoutTooltip => 'Se déconnecter';

  @override
  String get homeTab => 'Accueil';

  @override
  String get progressTab => 'Progrès';

  @override
  String get alertsTab => 'Alertes';

  @override
  String get historyTab => 'Historique';

  @override
  String get bookButton => 'Réserver';

  @override
  String get slotUnknown => 'Inconnu';

  @override
  String get noLessonsScheduled => 'Tu n\'as pas encore de cours de prévu.';

  @override
  String get lessonOn => 'Cours du';

  @override
  String get slotLabel => 'Créneau';

  @override
  String get statusUpcoming => 'À VENIR';

  @override
  String get statusCompleted => 'TERMINÉ';

  @override
  String get statusCancelled => 'ANNULÉ';

  @override
  String get profileTab => 'Profil';

  @override
  String get notesTab => 'Notes';

  @override
  String get nameLabel => 'Nom';

  @override
  String get currentBalance => 'Solde actuel';

  @override
  String get credits => 'crédits';

  @override
  String get sellPack => 'Vendre un Pack';

  @override
  String get creditAccount => 'Créditer le compte';

  @override
  String get noStandardPack =>
      'Aucun pack standard trouvé.\nUtilisez la saisie sur mesure ci-dessous.';

  @override
  String get customEntry => 'Saisie sur mesure';

  @override
  String get numberOfSessions => 'Nombre de séances';

  @override
  String packAdded(String name) {
    return 'Pack $name ajouté !';
  }

  @override
  String sessionsAdded(int count) {
    return '$count séances ajoutées !';
  }

  @override
  String get adjustTotal => 'Ajuster le total (Admin)';

  @override
  String get modifyBalance => 'Modifier solde (Manuel)';

  @override
  String get validate => 'Valider';

  @override
  String get invalidNumber => 'Veuillez saisir un nombre valide';

  @override
  String validationTitle(String name) {
    return 'Validation : $name';
  }

  @override
  String get skillsValidatedToday => 'Compétences validées aujourd\'hui';

  @override
  String get ikoGlobalLevel => 'Niveau IKO Global';

  @override
  String get pedagogicalNote => 'Note pédagogique';

  @override
  String get sessionNoteHint => 'Comment s\'est passée la séance ?';

  @override
  String get materialIncident => 'Incident Matériel ?';

  @override
  String get selectEquipmentIssue => 'Sélectionner le matériel avec un souci';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get damaged => 'HS';

  @override
  String get validateProgress => 'Valider la progression';

  @override
  String get progressSaved => 'Progression enregistrée !';

  @override
  String get errorLoadingEquipment => 'Erreur chargement matériel';

  @override
  String get equipmentStatusUpdated => 'Statut matériel mis à jour !';

  @override
  String get monitorSpace => 'Espace Moniteur';

  @override
  String get myAbsences => 'Mes Absences';

  @override
  String get monitorProfileNotActive => 'Profil Moniteur non activé';

  @override
  String get monitorProfileNotActiveDesc =>
      'Votre compte a été créé, mais un administrateur doit encore vous ajouter à l\'effectif de l\'école pour activer votre espace.';

  @override
  String get signOut => 'SE DÉCONNECTER';

  @override
  String get lessonPlan => 'PLANNING DES COURS';

  @override
  String get noLessonsAssigned => 'Aucun cours assigné pour ce jour';

  @override
  String get declareAbsence => 'Déclarer une absence';

  @override
  String get noAbsencesDeclared => 'Aucune absence déclarée.';

  @override
  String get absenceRequestTitle => 'Demande d\'absence';

  @override
  String get timeSlot => 'Créneau';

  @override
  String get absenceReasonHint => 'Motif (ex: Perso, Maladie)';

  @override
  String get send => 'Envoyer';

  @override
  String greeting(String name) {
    return 'Salut, $name ! 🤙';
  }

  @override
  String get offSystem => 'Hors Système';

  @override
  String get fullDay => 'Journée entière';

  @override
  String get reservations => 'Réservations';

  @override
  String get dateLabel => 'Date';

  @override
  String get noReservationsOnSlot => 'Aucune réservation sur ce créneau';

  @override
  String get instructorUnassigned => 'Moniteur non assigné';

  @override
  String get noteLabel => 'Note';

  @override
  String get newReservation => 'Nouvelle Réservation';

  @override
  String get clientNameLabel => 'Nom du Client';

  @override
  String get instructorOptional => 'Moniteur (Optionnel)';

  @override
  String get randomInstructor => 'Au hasard / Équipe';

  @override
  String get notesLabel => 'Notes / Commentaires';

  @override
  String get notesHint => 'Ex: Préférence moniteur...';

  @override
  String get schoolSettings => 'Paramètres de l\'école';

  @override
  String get settingsNotFound => 'Erreur : Paramètres non trouvés';

  @override
  String get morningHours => 'Horaires Matin';

  @override
  String get afternoonHours => 'Horaires Après-midi';

  @override
  String get startLabel => 'Début';

  @override
  String get endLabel => 'Fin';

  @override
  String get maxStudentsPerInstructor => 'Max élèves par moniteur';

  @override
  String get settingsSaved => 'Réglages enregistrés !';

  @override
  String get packCatalog => 'Catalogue des Forfaits';

  @override
  String get packCatalogSubtitle => 'Définir les prix et sessions par pack';

  @override
  String get staffManagementSubtitle => 'Ajouter ou modifier des moniteurs';

  @override
  String get equipmentManagementSubtitle =>
      'Inventaire des ailes, boards et harnais';

  @override
  String get schoolDashboard => 'Pilotage École';

  @override
  String get keyMetrics => 'CHIFFRES CLÉS';

  @override
  String get totalSales => 'Ventes Totales';

  @override
  String get totalEngagement => 'En engagement';

  @override
  String get pendingAbsences => 'ABSENCES À VALIDER';

  @override
  String get pendingRequests => 'DEMANDES EN ATTENTE';

  @override
  String get upcomingPlanning => 'PLANNING À VENIR';

  @override
  String get topClientsVolume => 'TOP CLIENTS (VOLUME)';

  @override
  String get noSessionsPlanned => 'Aucune session prévue';

  @override
  String get chooseInstructor => 'Choisir un moniteur :';

  @override
  String get confirmAndAssign => 'Confirmer & Assigner';

  @override
  String get noStudentsRegistered => 'Aucun élève enregistré';

  @override
  String get balanceLabel => 'Solde';

  @override
  String get newStudent => 'Nouvel Élève';

  @override
  String get createButton => 'Créer';

  @override
  String get noEquipmentInCategory => 'Aucun équipement dans cette catégorie.';

  @override
  String get addEquipment => 'Ajouter du matériel';

  @override
  String get typeLabel => 'Type';

  @override
  String get brandLabel => 'Marque (ex: F-One, North)';

  @override
  String get modelLabel => 'Modèle (ex: Bandit, Rebel)';

  @override
  String get sizeLabel => 'Taille (ex: 9m, 138cm)';

  @override
  String get statusAvailable => 'DISPO';

  @override
  String get statusMaintenance => 'MAINTENANCE';

  @override
  String get statusDamaged => 'HORS SERVICE';

  @override
  String get makeAvailable => 'Rendre Disponible';

  @override
  String get setMaintenance => 'Mettre en Maintenance';

  @override
  String get setDamaged => 'Déclarer Hors Service';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get myNotifications => 'Mes Notifications';

  @override
  String get noNotificationsYet => 'Aucune notification pour le moment.';

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get packCatalogTitle => 'Catalogue Forfaits';

  @override
  String get sessions => 'séances';

  @override
  String get newPack => 'Nouveau Forfait';

  @override
  String get createPackTitle => 'Créer un forfait';

  @override
  String get packNameLabel => 'Nom (ex: Pack 10h)';

  @override
  String get numberOfCredits => 'Nombre de crédits';

  @override
  String get priceLabel => 'Prix (€)';

  @override
  String get defaultIkoLevel => 'Niveau 1';

  @override
  String get myAcquisitions => 'MES ACQUISITIONS';

  @override
  String get instructorNotes => 'NOTES DU MONITEUR';

  @override
  String get noNotesYet => 'Aucune note pour le moment.';

  @override
  String get currentLevel => 'Niveau Actuel';

  @override
  String byInstructor(Object name) {
    return 'Par $name';
  }

  @override
  String get unknownInstructor => 'Moniteur Inconnu';

  @override
  String instructorLabel(Object name) {
    return 'Moniteur: $name';
  }

  @override
  String get addLessonNote => 'Ajouter une note de cours';

  @override
  String get sessionFeedback => 'Feedback de session';

  @override
  String get instructor => 'Moniteur';

  @override
  String get observations => 'Observations';

  @override
  String get observationsHint => 'ex: Bonne progression waterstart...';

  @override
  String currentIkoLevel(Object level) {
    return 'Niveau IKO actuel : $level';
  }

  @override
  String get notDefined => 'Non défini';

  @override
  String get progressChecklist => 'Checklist de progression';

  @override
  String get lessonPlanning => 'PLANNING DES COURS';

  @override
  String get unknown => 'Inconnu';

  @override
  String packDetails(int credits, double price) {
    return '$credits séances • $price€';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get knots => 'nds';

  @override
  String get sunSafetyReminder => 'Protection solaire ☀️';

  @override
  String get sunSafetyTip =>
      'Pensez à mettre de la crème solaire et à prendre vos lunettes de soleil !';

  @override
  String get ikoLevel1Discovery => 'Niveau 1 - Découverte';

  @override
  String get ikoLevel2Intermediate => 'Niveau 2 - Intermédiaire';

  @override
  String get ikoLevel3Independent => 'Niveau 3 - Indépendant';

  @override
  String get ikoLevel4Advanced => 'Niveau 4 - Perfectionnement';

  @override
  String get skillPreparationSafety => 'Préparation & Sécurité';

  @override
  String get skillNeutralZonePiloting => 'Pilotage zone neutre';

  @override
  String get skillTakeoffLanding => 'Décollage / Atterrissage';

  @override
  String get skillBasicNavigation => 'Navigation de base';

  @override
  String get skillTransitionsJumps => 'Transitions & Sauts';

  @override
  String get skillJumpWithGrab => 'Saut avec grab';

  @override
  String get equipmentCategories => 'Catégories d\'équipement';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get confirmDeleteCategory =>
      'Êtes-vous sûr de vouloir supprimer cette catégorie ?';

  @override
  String cannotDeleteCategory(Object count) {
    return 'Impossible de supprimer : $count équipement(s) associé(s)';
  }

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get selectCategory => 'Sélectionner une catégorie';

  @override
  String get noEquipmentCategories => 'Aucune catégorie d\'équipement';

  @override
  String get all => 'Tous';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get themeMode => 'Mode du thème';

  @override
  String get lightMode => 'Mode Clair';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get systemTheme => 'Système (Device)';

  @override
  String get brandColors => 'Couleurs de la marque';

  @override
  String get primaryColor => 'Couleur principale';

  @override
  String get secondaryColor => 'Couleur secondaire';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get themePresets => 'Thèmes prédéfinis';

  @override
  String get customColor => 'Personnalisée...';

  @override
  String get preview => 'Aperçu';

  @override
  String get resetToDefaults => 'Réinitialiser';

  @override
  String get themeApplied => 'Thème appliqué !';

  @override
  String get colorsReset => 'Couleurs réinitialisées';

  @override
  String get weatherLocationSection => 'Météo - Localisation du spot';
}
