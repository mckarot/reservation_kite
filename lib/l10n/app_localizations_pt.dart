// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Kite Reserve';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginButton => 'Iniciar sessão';

  @override
  String get logoutButton => 'Sair';

  @override
  String get noAccount => 'Não tem conta?';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'seu@email.com';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordHint => 'Mínimo 6 caracteres';

  @override
  String get passwordHintError => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get loginError => 'Erro de login';

  @override
  String get loginSuccess => 'Login bem-sucedido!';

  @override
  String get navDashboard => 'Início';

  @override
  String get navBooking => 'Reservas';

  @override
  String get navProgress => 'Progresso';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Configurações';

  @override
  String welcomeMessage(String name) {
    return 'Olá, $name';
  }

  @override
  String get readyForSession => 'Pronto para uma sessão?';

  @override
  String get myBalance => 'MEU SALDO';

  @override
  String get sessionsRemaining => 'SESSÕES RESTANTES';

  @override
  String get quickStats => 'ESTATÍSTICAS RÁPIDAS';

  @override
  String get ikoLevel => 'Nível IKO';

  @override
  String get progression => 'Progresso';

  @override
  String skillsValidated(int count) {
    return '$count competências validadas';
  }

  @override
  String get weather => 'Tempo';

  @override
  String get currentWeather => 'Tempo Atual';

  @override
  String get windSpeed => 'Velocidade do vento';

  @override
  String get windDirection => 'Direção do vento';

  @override
  String get temperature => 'Temperatura';

  @override
  String get kmh => 'km/h';

  @override
  String get weatherInfo => 'Tempo apenas informativo, sujeito a alterações.';

  @override
  String get bookingScreen => 'Reservas';

  @override
  String get selectDate => 'Selecionar data';

  @override
  String get selectSlot => 'Faixa horária';

  @override
  String get selectInstructor => 'Escolher instrutor';

  @override
  String get morning => 'Manhã';

  @override
  String get morningTime => '08:00 - 12:00';

  @override
  String get afternoon => 'Tarde';

  @override
  String get afternoonTime => '13:00 - 18:00';

  @override
  String get bookingNotes => 'Notas ou preferências (opcional)';

  @override
  String get bookingNotesHint =>
      'Ex: Preferência por um instrutor, nível atual...';

  @override
  String get bookingSent =>
      'Solicitação enviada! Aguardando validação do admin.';

  @override
  String get insufficientBalance =>
      'Saldo insuficiente. Por favor recarregue sua conta.';

  @override
  String get sendRequest => 'Enviar solicitação';

  @override
  String get slotFull => 'Lotado';

  @override
  String get slotUnavailable => 'Indisponível (Staff ausente)';

  @override
  String get remainingSlots => 'Vagas restantes:';

  @override
  String get weatherDateTooFar =>
      'A data é muito distante para uma previsão meteorológica precisa.';

  @override
  String get confirmBooking => 'Confirmar reserva';

  @override
  String get cancelBooking => 'Cancelar reserva';

  @override
  String get bookingConfirmed => 'Reserva confirmada!';

  @override
  String get bookingCancelled => 'Reserva cancelada';

  @override
  String get bookingError => 'Erro de reserva';

  @override
  String get noAvailableSlots => 'Sem vagas disponíveis';

  @override
  String get maxCapacityReached => 'Capacidade máxima atingida';

  @override
  String get ikoLevel1 => 'Nível 1 - Descoberta';

  @override
  String get ikoLevel2 => 'Nível 2 - Intermédio';

  @override
  String get ikoLevel3 => 'Nível 3 - Independente';

  @override
  String get ikoLevel4 => 'Nível 4 - Perfeição';

  @override
  String get skillPreparation => 'Preparação e Segurança';

  @override
  String get skillPilotage => 'Pilotagem zona neutra';

  @override
  String get skillTakeoff => 'Descolagem / Aterragem';

  @override
  String get skillBodyDrag => 'Nado tracionado (Body Drag)';

  @override
  String get skillWaterstart => 'Waterstart';

  @override
  String get skillNavigation => 'Navegação básica';

  @override
  String get skillUpwind => 'Subida ao vento';

  @override
  String get skillTransitions => 'Transições e Saltos';

  @override
  String get skillBasicJump => 'Salto básico';

  @override
  String get skillJibe => 'Jibe';

  @override
  String get skillGrab => 'Salto com grab';

  @override
  String get adminPanel => 'Painel Administrativo';

  @override
  String get settings => 'Configurações';

  @override
  String get students => 'Alunos';

  @override
  String get instructors => 'Instrutores';

  @override
  String get equipment => 'Equipamento';

  @override
  String get calendar => 'Calendário';

  @override
  String get dashboard => 'Painel';

  @override
  String get manageStaff => 'Gerir Staff';

  @override
  String get studentDirectory => 'Diretório de Alunos';

  @override
  String get equipmentManagement => 'Gestão de Equipamento';

  @override
  String get language => 'Idioma';

  @override
  String get languageSelector => 'Selecionar idioma';

  @override
  String get weatherLocation => 'Localização do Tempo';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get useMyLocation => '📍 Usar minha localização';

  @override
  String get saveCoordinates => '💾 Guardar';

  @override
  String get notifications => 'Notificações';

  @override
  String get noNotifications => 'Sem notificações';

  @override
  String get markAsRead => 'Marcar como lido';

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
  String get back => 'Voltar';

  @override
  String get next => 'Seguinte';

  @override
  String get close => 'Fechar';

  @override
  String get refresh => 'Atualizar';

  @override
  String get initSchema => 'Inicializar Esquema';

  @override
  String get initSchemaSuccess => 'Dados de teste e coleções inicializados!';

  @override
  String get initSchemaError => 'Erro de inicialização';

  @override
  String get genericError => 'Ocorreu um erro';

  @override
  String get networkError => 'Erro de conexão';

  @override
  String get unauthorized => 'Não autorizado';

  @override
  String get notFound => 'Não encontrado';

  @override
  String get tryAgain => 'Tentar novamente';
}
