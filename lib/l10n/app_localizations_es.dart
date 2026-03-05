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
  String get fullNameLabel => 'Nombre Completo';

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

  @override
  String get staffManagement => 'Gestión de Personal';

  @override
  String get staffTab => 'Personal';

  @override
  String get absencesTab => 'Ausencias';

  @override
  String get pendingHeader => 'PENDIENTE';

  @override
  String get historyHeader => 'HISTORIAL';

  @override
  String get slotFullDay => 'Día completo';

  @override
  String get slotMorning => 'Mañana';

  @override
  String get slotAfternoon => 'Tarde';

  @override
  String get reasonLabel => 'Motivo';

  @override
  String get noRequests => 'Sin solicitudes.';

  @override
  String get editInstructor => 'Editar Instructor';

  @override
  String get addInstructor => 'Añadir Instructor';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get bio => 'Biografía';

  @override
  String get specialtiesHint => 'Especialidades (separadas por comas)';

  @override
  String get photoUrl => 'URL de foto';

  @override
  String get loginCredentials => 'Credenciales de acceso';

  @override
  String get passwordHint6 => 'Contraseña (mínimo 6 caracteres)';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get addButton => 'Añadir';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusApproved => 'Aprobado';

  @override
  String get statusRejected => 'Rechazado';

  @override
  String get errorLabel => 'Error';

  @override
  String get sessionExpired => 'Sesión expirada o perfil no encontrado';

  @override
  String get noUsersFound => 'No se encontraron usuarios en la base de datos.';

  @override
  String get pupilSpace => 'Área del Estudiante';

  @override
  String get myProgress => 'Mi Progreso';

  @override
  String get history => 'Historial';

  @override
  String get logoutTooltip => 'Cerrar sesión';

  @override
  String get homeTab => 'Inicio';

  @override
  String get progressTab => 'Progreso';

  @override
  String get alertsTab => 'Alertas';

  @override
  String get historyTab => 'Historial';

  @override
  String get bookButton => 'Reservar';

  @override
  String get slotUnknown => 'Desconocido';

  @override
  String get noLessonsScheduled => 'Aún no tienes ninguna clase programada.';

  @override
  String get lessonOn => 'Clase del';

  @override
  String get slotLabel => 'Franja';

  @override
  String get statusUpcoming => 'PRÓXIMAMENTE';

  @override
  String get statusCompleted => 'COMPLETADO';

  @override
  String get statusCancelled => 'CANCELADO';

  @override
  String get profileTab => 'Perfil';

  @override
  String get notesTab => 'Notas';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get currentBalance => 'Saldo actual';

  @override
  String get credits => 'créditos';

  @override
  String get sellPack => 'Vender un Pack';

  @override
  String get creditAccount => 'Acreditar cuenta';

  @override
  String get noStandardPack =>
      'No se encontró ningún pack estándar.\nUtilice la entrada personalizada a continuación.';

  @override
  String get customEntry => 'Entrada personalizada';

  @override
  String get numberOfSessions => 'Número de sesiones';

  @override
  String packAdded(String name) {
    return '¡Pack $name añadido!';
  }

  @override
  String sessionsAdded(int count) {
    return '¡$count sesiones añadidas!';
  }

  @override
  String get adjustTotal => 'Ajustar total (Admin)';

  @override
  String get modifyBalance => 'Modificar saldo (Manual)';

  @override
  String get validate => 'Validar';

  @override
  String get invalidNumber => 'Por favor, introduzca un número válido';

  @override
  String validationTitle(String name) {
    return 'Validación: $name';
  }

  @override
  String get skillsValidatedToday => 'Habilidades validadas hoy';

  @override
  String get ikoGlobalLevel => 'Nivel IKO Global';

  @override
  String get pedagogicalNote => 'Nota pedagógica';

  @override
  String get sessionNoteHint => '¿Cómo fue la sesión?';

  @override
  String get materialIncident => '¿Incidente de equipo?';

  @override
  String get selectEquipmentIssue => 'Seleccionar problema de equipo';

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get damaged => 'Averiado';

  @override
  String get validateProgress => 'Validar progreso';

  @override
  String get progressSaved => '¡Progreso guardado!';

  @override
  String get errorLoadingEquipment => 'Error al cargar equipo';

  @override
  String get equipmentStatusUpdated => '¡Estado del equipo actualizado!';

  @override
  String get monitorSpace => 'Espacio de Instructores';

  @override
  String get myAbsences => 'Mis Ausencias';

  @override
  String get monitorProfileNotActive => 'Perfil de Instructor no activado';

  @override
  String get monitorProfileNotActiveDesc =>
      'Su cuenta ha sido creada, pero un administrador aún necesita agregarlo al personal de la escuela para activar su espacio.';

  @override
  String get signOut => 'CERRAR SESIÓN';

  @override
  String get lessonPlan => 'PLAN DE CLASES';

  @override
  String get noLessonsAssigned => 'No hay clases asignadas para este día';

  @override
  String get declareAbsence => 'Declarar una ausencia';

  @override
  String get noAbsencesDeclared => 'Ninguna ausencia declarada.';

  @override
  String get absenceRequestTitle => 'Solicitud de ausencia';

  @override
  String get timeSlot => 'Franja horaria';

  @override
  String get absenceReasonHint => 'Motivo (ej: Personal, Enfermedad)';

  @override
  String get send => 'Enviar';

  @override
  String greeting(String name) {
    return '¡Hola, $name! 🤙';
  }

  @override
  String get offSystem => 'Fuera del Sistema';

  @override
  String get fullDay => 'Día completo';

  @override
  String get reservations => 'Reservas';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get noReservationsOnSlot => 'No hay reservas para esta franja';

  @override
  String get instructorUnassigned => 'Instructor no asignado';

  @override
  String get noteLabel => 'Nota';

  @override
  String get newReservation => 'Nueva Reserva';

  @override
  String get clientNameLabel => 'Nombre del Cliente';

  @override
  String get instructorOptional => 'Instructor (Opcional)';

  @override
  String get randomInstructor => 'Al azar / Equipo';

  @override
  String get notesLabel => 'Notas / Comentarios';

  @override
  String get notesHint => 'Ej: Preferencia de instructor...';

  @override
  String get schoolSettings => 'Configuración de la escuela';

  @override
  String get settingsNotFound => 'Error: Configuración no encontrada';

  @override
  String get morningHours => 'Horario de Mañana';

  @override
  String get afternoonHours => 'Horario de Tarde';

  @override
  String get startLabel => 'Inicio';

  @override
  String get endLabel => 'Fin';

  @override
  String get maxStudentsPerInstructor => 'Máx. estudiantes por instructor';

  @override
  String get settingsSaved => '¡Configuración guardada!';

  @override
  String get packCatalog => 'Catálogo de Packs';

  @override
  String get packCatalogSubtitle => 'Definir precios y sesiones por pack';

  @override
  String get staffManagementSubtitle => 'Añadir o modificar instructores';

  @override
  String get equipmentManagementSubtitle =>
      'Inventario de cometas, tablas y arneses';

  @override
  String get schoolDashboard => 'Panel de la Escuela';

  @override
  String get keyMetrics => 'MÉTRICAS CLAVE';

  @override
  String get totalSales => 'Ventas Totales';

  @override
  String get totalEngagement => 'En compromiso';

  @override
  String get pendingAbsences => 'AUSENCIAS POR VALIDAR';

  @override
  String get pendingRequests => 'SOLICITUDES PENDIENTES';

  @override
  String get upcomingPlanning => 'CALENDARIO PRÓXIMO';

  @override
  String get topClientsVolume => 'MEJORES CLIENTES (VOLUMEN)';

  @override
  String get noSessionsPlanned => 'No hay sesiones programadas';

  @override
  String get chooseInstructor => 'Elegir un instructor:';

  @override
  String get confirmAndAssign => 'Confirmar y Asignar';

  @override
  String get noStudentsRegistered => 'No hay estudiantes registrados';

  @override
  String get balanceLabel => 'Saldo';

  @override
  String get newStudent => 'Nuevo Estudiante';

  @override
  String get createButton => 'Crear';

  @override
  String get noEquipmentInCategory => 'No hay equipo en esta categoría.';

  @override
  String get addEquipment => 'Añadir equipo';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get brandLabel => 'Marca (ej: F-One, North)';

  @override
  String get modelLabel => 'Modelo (ej: Bandit, Rebel)';

  @override
  String get sizeLabel => 'Tamaño (ej: 9m, 138cm)';

  @override
  String get statusAvailable => 'Disponible';

  @override
  String get statusMaintenance => 'Mantenimiento';

  @override
  String get statusDamaged => 'AVERIADO';

  @override
  String get makeAvailable => 'Hacer disponible';

  @override
  String get setMaintenance => 'Poner en mantenimiento';

  @override
  String get setDamaged => 'Marcar como dañado';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get myNotifications => 'Mis Notificaciones';

  @override
  String get noNotificationsYet => 'Ninguna notificación por el momento.';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get packCatalogTitle => 'Catálogo de Packs';

  @override
  String get sessions => 'sesiones';

  @override
  String get newPack => 'Nuevo Pack';

  @override
  String get createPackTitle => 'Crear un pack';

  @override
  String get packNameLabel => 'Nombre (ej: Pack 10h)';

  @override
  String get numberOfCredits => 'Número de créditos';

  @override
  String get priceLabel => 'Precio (€)';

  @override
  String get defaultIkoLevel => 'Nivel 1';

  @override
  String get myAcquisitions => 'MIS ADQUISICIONES';

  @override
  String get instructorNotes => 'NOTAS DEL INSTRUCTOR';

  @override
  String get noNotesYet => 'Ninguna nota por el momento.';

  @override
  String get currentLevel => 'Nivel Actual';

  @override
  String byInstructor(Object name) {
    return 'Por $name';
  }

  @override
  String get unknownInstructor => 'Instructor Desconocido';

  @override
  String instructorLabel(Object name) {
    return 'Instructor: $name';
  }

  @override
  String get addLessonNote => 'Añadir nota de clase';

  @override
  String get sessionFeedback => 'Feedback de sesión';

  @override
  String get instructor => 'Instructor';

  @override
  String get observations => 'Observaciones';

  @override
  String get observationsHint => 'ej: Buena progresión en waterstart...';

  @override
  String currentIkoLevel(Object level) {
    return 'Nivel IKO actual: $level';
  }

  @override
  String get notDefined => 'No definido';

  @override
  String get progressChecklist => 'Lista de progreso';

  @override
  String get lessonPlanning => 'PLANIFICACIÓN DE CLASES';

  @override
  String get unknown => 'Desconocido';

  @override
  String packDetails(int credits, double price) {
    return '$credits sesiones • $price€';
  }

  @override
  String get notAvailable => 'N/D';

  @override
  String get knots => 'nds';

  @override
  String get sunSafetyReminder => 'Protección Solar ☀️';

  @override
  String get sunSafetyTip =>
      '¡Recuerda aplicar protector solar y traer tus gafas de sol!';

  @override
  String get ikoLevel1Discovery => 'Nivel 1 - Descubrimiento';

  @override
  String get ikoLevel2Intermediate => 'Nivel 2 - Intermedio';

  @override
  String get ikoLevel3Independent => 'Nivel 3 - Independiente';

  @override
  String get ikoLevel4Advanced => 'Nivel 4 - Perfeccionamiento';

  @override
  String get skillPreparationSafety => 'Preparación y Seguridad';

  @override
  String get skillNeutralZonePiloting => 'Pilotaje zona neutra';

  @override
  String get skillTakeoffLanding => 'Despegue / Aterrizaje';

  @override
  String get skillBasicNavigation => 'Navegación básica';

  @override
  String get skillTransitionsJumps => 'Transiciones y Saltos';

  @override
  String get skillJumpWithGrab => 'Salto con grab';

  @override
  String get equipmentCategories => 'Categorías de Equipamiento';

  @override
  String get addCategory => 'Añadir categoría';

  @override
  String get editCategory => 'Editar categoría';

  @override
  String get deleteCategory => 'Eliminar categoría';

  @override
  String get confirmDeleteCategory =>
      '¿Estás seguro de que quieres eliminar esta categoría?';

  @override
  String cannotDeleteCategory(Object count) {
    return 'No se puede eliminar: $count equipo(s) asociado(s)';
  }

  @override
  String get categoryName => 'Nombre de la categoría';

  @override
  String get selectCategory => 'Seleccionar una categoría';

  @override
  String get noEquipmentCategories => 'Sin categorías de equipamiento';

  @override
  String get all => 'Todos';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get themeMode => 'Modo del tema';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get systemTheme => 'Sistema (Dispositivo)';

  @override
  String get brandColors => 'Colores de la marca';

  @override
  String get primaryColor => 'Color principal';

  @override
  String get secondaryColor => 'Color secundario';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get themePresets => 'Temas predefinidos';

  @override
  String get customColor => 'Personalizado...';

  @override
  String get preview => 'Vista previa';

  @override
  String get resetToDefaults => 'Restablecer';

  @override
  String get themeApplied => '¡Tema aplicado!';

  @override
  String get colorsReset => 'Colores restablecidos';

  @override
  String get weatherLocationSection => 'Clima - Ubicación del spot';

  @override
  String get createAdmin => 'Crear un administrador';

  @override
  String get searchButton => 'Buscar';

  @override
  String get searchUserHint => 'Buscar un usuario por correo electrónico';

  @override
  String get promoteButton => 'Promover';

  @override
  String get correctButton => 'Corregir';

  @override
  String get roleMismatch => 'Rol incorrecto';

  @override
  String get confirmAction => 'Confirmar acción';

  @override
  String get promoteConfirmTitle => 'Confirmar promoción';

  @override
  String promoteConfirmContent(String userEmail) {
    return '¿Realmente quieres hacer de $userEmail un administrador?';
  }

  @override
  String promoteSuccess(String userEmail) {
    return '✅ ¡$userEmail ahora es administrador!';
  }

  @override
  String get reconnectMessage =>
      '🔄 Vuelve a conectarte con tus nuevos derechos';

  @override
  String get roleUpdateTitle => 'Corrección de rol';

  @override
  String roleUpdateMessage(String userEmail) {
    return 'Actualizando rol para $userEmail...';
  }

  @override
  String roleCorrected(String userEmail) {
    return '✅ ¡Rol de $userEmail corregido!';
  }

  @override
  String searchError(String error) {
    return 'Error de búsqueda: $error';
  }

  @override
  String get promoSubtext =>
      'luego haz clic en \"Promover\" para hacerlo administrador';

  @override
  String get adminBadge => 'Admin';

  @override
  String get unknownUser => 'Desconocido';

  @override
  String get equipmentRental => 'Alquiler de equipo';

  @override
  String get rentButton => 'Alquilar';

  @override
  String get unavailable => 'No disponible';

  @override
  String get noEquipmentAvailable => 'No hay equipo disponible';

  @override
  String get statusReserved => 'Réservé';

  @override
  String get available => 'disponible(s)';

  @override
  String get confirmButton => 'Confirmar';

  @override
  String get reserveEquipment => 'Reservar equipo';

  @override
  String get selectEquipmentForSession => 'Seleccionar equipo para esta sesión';

  @override
  String get equipmentReserved => 'Equipo reservado con éxito';

  @override
  String get equipmentReservationFailed => 'Error al reservar el equipo';

  @override
  String get validateAndReserve => 'Validar sesión y reservar equipo';

  @override
  String get validateSessionOnly => 'Validar solo la sesión';

  @override
  String get selectedEquipment => 'Equipo seleccionado';

  @override
  String get removeEquipment => 'Eliminar';

  @override
  String get chooseBookingType => '¿Qué quieres hacer?';

  @override
  String get bookLesson => 'Reservar una clase';

  @override
  String get rentEquipment => 'Alquilar equipo';

  @override
  String get lessonDescription => 'Clase con instructor';

  @override
  String get equipmentDescription => 'Solo alquiler de equipo';

  @override
  String get allocateEquipment => 'Allouer du matériel';

  @override
  String get assignedEquipment => 'Matériel assigné';
}
