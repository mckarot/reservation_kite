// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kite Reserve';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginButton => 'Sign in';

  @override
  String get logoutButton => 'Logout';

  @override
  String get noAccount => 'No account?';

  @override
  String get createAccount => 'Create account';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Minimum 6 characters';

  @override
  String get passwordHintError => 'Password must be at least 6 characters.';

  @override
  String get loginError => 'Login failed';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get navDashboard => 'Home';

  @override
  String get navBooking => 'Bookings';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSettings => 'Settings';

  @override
  String welcomeMessage(String name) {
    return 'Hello, $name';
  }

  @override
  String get readyForSession => 'Ready for a session?';

  @override
  String get myBalance => 'MY BALANCE';

  @override
  String get sessionsRemaining => 'SESSIONS REMAINING';

  @override
  String get quickStats => 'QUICK STATS';

  @override
  String get ikoLevel => 'IKO Level';

  @override
  String get progression => 'Progress';

  @override
  String skillsValidated(int count) {
    return '$count skills validated';
  }

  @override
  String get weather => 'Weather';

  @override
  String get currentWeather => 'Current Weather';

  @override
  String get windSpeed => 'Wind speed';

  @override
  String get windDirection => 'Wind direction';

  @override
  String get temperature => 'Temperature';

  @override
  String get kmh => 'km/h';

  @override
  String get weatherInfo => 'Weather for information only, subject to change.';

  @override
  String get bookingScreen => 'Bookings';

  @override
  String get selectDate => 'Select a date';

  @override
  String get selectSlot => 'Time slot';

  @override
  String get selectInstructor => 'Choose an instructor';

  @override
  String get morning => 'Morning';

  @override
  String get morningTime => '08:00 - 12:00';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get afternoonTime => '13:00 - 18:00';

  @override
  String get bookingNotes => 'Notes or preferences (optional)';

  @override
  String get bookingNotesHint =>
      'Ex: Preference for an instructor, current level...';

  @override
  String get bookingSent => 'Request sent! Waiting for admin validation.';

  @override
  String get insufficientBalance =>
      'Insufficient balance. Please recharge your account.';

  @override
  String get sendRequest => 'Send request';

  @override
  String get slotFull => 'Full';

  @override
  String get slotUnavailable => 'Unavailable (Staff absent)';

  @override
  String get remainingSlots => 'Remaining slots:';

  @override
  String get weatherDateTooFar =>
      'The date is too far for accurate weather forecast.';

  @override
  String get confirmBooking => 'Confirm booking';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String get bookingConfirmed => 'Booking confirmed!';

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get bookingError => 'Booking error';

  @override
  String get noAvailableSlots => 'No slots available';

  @override
  String get maxCapacityReached => 'Maximum capacity reached';

  @override
  String get ikoLevel1 => 'Level 1 - Discovery';

  @override
  String get ikoLevel2 => 'Level 2 - Intermediate';

  @override
  String get ikoLevel3 => 'Level 3 - Independent';

  @override
  String get ikoLevel4 => 'Level 4 - Advanced';

  @override
  String get skillPreparation => 'Preparation & Safety';

  @override
  String get skillPilotage => 'Neutral zone piloting';

  @override
  String get skillTakeoff => 'Takeoff / Landing';

  @override
  String get skillBodyDrag => 'Body Drag';

  @override
  String get skillWaterstart => 'Waterstart';

  @override
  String get skillNavigation => 'Basic navigation';

  @override
  String get skillUpwind => 'Upwind';

  @override
  String get skillTransitions => 'Transitions & Jumps';

  @override
  String get skillBasicJump => 'Basic jump';

  @override
  String get skillJibe => 'Jibe';

  @override
  String get skillGrab => 'Jump with grab';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get settings => 'Settings';

  @override
  String get students => 'Students';

  @override
  String get instructors => 'Instructors';

  @override
  String get equipment => 'Equipment';

  @override
  String get calendar => 'Calendar';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get manageStaff => 'Manage Staff';

  @override
  String get studentDirectory => 'Student Directory';

  @override
  String get equipmentManagement => 'Equipment Management';

  @override
  String get language => 'Language';

  @override
  String get languageSelector => 'Select language';

  @override
  String get weatherLocation => 'Weather Location';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get useMyLocation => '📍 Use my location';

  @override
  String get saveCoordinates => '💾 Save';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get deleteNotification => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get close => 'Close';

  @override
  String get refresh => 'Refresh';

  @override
  String get initSchema => 'Init Schema';

  @override
  String get initSchemaSuccess => 'Test data and collections initialized!';

  @override
  String get initSchemaError => 'Initialization error';

  @override
  String get genericError => 'An error occurred';

  @override
  String get networkError => 'Connection error';

  @override
  String get unauthorized => 'Unauthorized';

  @override
  String get notFound => 'Not found';

  @override
  String get tryAgain => 'Try again';

  @override
  String get adminScreenTitle => 'Admin Panel';

  @override
  String get pendingAbsencesAlert => 'ABSENCES TO VALIDATE';

  @override
  String get dashboardKPIs => 'Dashboard (KPIs)';

  @override
  String get calendarBookings => 'Calendar';

  @override
  String seeRequests(int count) {
    return 'See $count requests...';
  }

  @override
  String get registrationTitle => 'Create account';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Your full name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get weightHint => 'Optional';

  @override
  String get createAccountButton => 'CREATE ACCOUNT';

  @override
  String get alreadyHaveAccount => 'ALREADY HAVE AN ACCOUNT? LOGIN';

  @override
  String get passwordsMismatch => 'Passwords do not match.';

  @override
  String get accountCreatedSuccess =>
      '✅ Account created successfully! You can login.';

  @override
  String get uploadPhoto => 'Add a photo';
}
