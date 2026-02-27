// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Kite Reserve';

  @override
  String get loginTitle => 'Inicio de sesión';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get logoutButton => 'Cerrar sesión';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'tu@email.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Mínimo 6 caracteres';

  @override
  String get passwordHintError =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get loginError => 'Error de inicio de sesión';

  @override
  String get loginSuccess => '¡Inicio de sesión exitoso!';

  @override
  String get navDashboard => 'Inicio';

  @override
  String get navBooking => 'Reservas';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Configuración';

  @override
  String welcomeMessage(String name) {
    return 'Hola, $name';
  }

  @override
  String get readyForSession => '¿Listo para una sesión?';

  @override
  String get myBalance => 'MI SALDO';

  @override
  String get sessionsRemaining => 'SESIONES RESTANTES';

  @override
  String get quickStats => 'ESTADÍSTICAS RÁPIDAS';

  @override
  String get ikoLevel => 'Nivel IKO';

  @override
  String get progression => 'Progreso';

  @override
  String skillsValidated(int count) {
    return '$count habilidades validadas';
  }

  @override
  String get weather => 'Tiempo';

  @override
  String get currentWeather => 'Tiempo Actual';

  @override
  String get windSpeed => 'Velocidad del viento';

  @override
  String get windDirection => 'Dirección del viento';

  @override
  String get temperature => 'Temperatura';

  @override
  String get kmh => 'km/h';

  @override
  String get weatherInfo => 'Tiempo solo informativo, sujeto a cambios.';

  @override
  String get bookingScreen => 'Reservas';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectSlot => 'Franja horaria';

  @override
  String get selectInstructor => 'Elegir instructor';

  @override
  String get morning => 'Mañana';

  @override
  String get morningTime => '08:00 - 12:00';

  @override
  String get afternoon => 'Tarde';

  @override
  String get afternoonTime => '13:00 - 18:00';

  @override
  String get bookingNotes => 'Notas o preferencias (opcional)';

  @override
  String get bookingNotesHint =>
      'Ej: Preferencia por un instructor, nivel actual...';

  @override
  String get bookingSent =>
      '¡Solicitud enviada! Esperando validación del admin.';

  @override
  String get insufficientBalance =>
      'Saldo insuficiente. Por favor recarga tu cuenta.';

  @override
  String get sendRequest => 'Enviar solicitud';

  @override
  String get slotFull => 'Completo';

  @override
  String get slotUnavailable => 'No disponible (Staff ausente)';

  @override
  String get remainingSlots => 'Plazas restantes:';

  @override
  String get weatherDateTooFar =>
      'La fecha es demasiado lejana para una previsión meteorológica precisa.';

  @override
  String get confirmBooking => 'Confirmar reserva';

  @override
  String get cancelBooking => 'Cancelar reserva';

  @override
  String get bookingConfirmed => '¡Reserva confirmada!';

  @override
  String get bookingCancelled => 'Reserva cancelada';

  @override
  String get bookingError => 'Error de reserva';

  @override
  String get noAvailableSlots => 'No hay plazas disponibles';

  @override
  String get maxCapacityReached => 'Capacidad máxima alcanzada';

  @override
  String get ikoLevel1 => 'Nivel 1 - Descubrimiento';

  @override
  String get ikoLevel2 => 'Nivel 2 - Intermedio';

  @override
  String get ikoLevel3 => 'Nivel 3 - Independiente';

  @override
  String get ikoLevel4 => 'Nivel 4 - Perfeccionamiento';

  @override
  String get skillPreparation => 'Preparación y Seguridad';

  @override
  String get skillPilotage => 'Pilotaje zona neutra';

  @override
  String get skillTakeoff => 'Despegue / Aterrizaje';

  @override
  String get skillBodyDrag => 'Nado tractado (Body Drag)';

  @override
  String get skillWaterstart => 'Waterstart';

  @override
  String get skillNavigation => 'Navegación básica';

  @override
  String get skillUpwind => 'Remontada al viento';

  @override
  String get skillTransitions => 'Transiciones y Saltos';

  @override
  String get skillBasicJump => 'Salto básico';

  @override
  String get skillJibe => 'Jibe';

  @override
  String get skillGrab => 'Salto con grab';

  @override
  String get adminPanel => 'Panel de Administración';

  @override
  String get settings => 'Configuración';

  @override
  String get students => 'Estudiantes';

  @override
  String get instructors => 'Instructores';

  @override
  String get equipment => 'Equipo';

  @override
  String get calendar => 'Calendario';

  @override
  String get dashboard => 'Tablero';

  @override
  String get manageStaff => 'Gestionar Staff';

  @override
  String get studentDirectory => 'Directorio de Estudiantes';

  @override
  String get equipmentManagement => 'Gestión de Equipo';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelector => 'Seleccionar idioma';

  @override
  String get weatherLocation => 'Ubicación del Tiempo';

  @override
  String get latitude => 'Latitud';

  @override
  String get longitude => 'Longitud';

  @override
  String get useMyLocation => '📍 Usar mi ubicación';

  @override
  String get saveCoordinates => '💾 Guardar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'Sin notificaciones';

  @override
  String get markAsRead => 'Marcar como leído';

  @override
  String get deleteNotification => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get close => 'Cerrar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get initSchema => 'Inicializar Esquema';

  @override
  String get initSchemaSuccess =>
      '¡Datos de prueba y colecciones inicializados!';

  @override
  String get initSchemaError => 'Error de inicialización';

  @override
  String get genericError => 'Ha ocurrido un error';

  @override
  String get networkError => 'Error de conexión';

  @override
  String get unauthorized => 'No autorizado';

  @override
  String get notFound => 'No encontrado';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get adminScreenTitle => 'Panel de Administración';

  @override
  String get pendingAbsencesAlert => 'AUSENCIAS POR VALIDAR';

  @override
  String get dashboardKPIs => 'Tablero (KPIs)';

  @override
  String get calendarBookings => 'Calendario';

  @override
  String seeRequests(int count) {
    return 'Ver $count solicitudes...';
  }

  @override
  String get registrationTitle => 'Crear cuenta';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get fullNameHint => 'Tu nombre completo';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get weightLabel => 'Peso (kg)';

  @override
  String get weightHint => 'Opcional';

  @override
  String get createAccountButton => 'CREAR CUENTA';

  @override
  String get alreadyHaveAccount => '¿YA TIENES CUENTA? INICIAR SESIÓN';

  @override
  String get passwordsMismatch => 'Las contraseñas no coinciden.';

  @override
  String get accountCreatedSuccess =>
      '✅ ¡Cuenta creada exitosamente! Puedes iniciar sesión.';

  @override
  String get uploadPhoto => 'Añadir una foto';
}
