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

  @override
  String get adminScreenTitle => 'Painel Administrativo';

  @override
  String get pendingAbsencesAlert => 'AUSENCIAS PARA VALIDAR';

  @override
  String get dashboardKPIs => 'Painel (KPIs)';

  @override
  String get calendarBookings => 'Calendário';

  @override
  String seeRequests(int count) {
    return 'Ver $count solicitações...';
  }

  @override
  String get registrationTitle => 'Criar conta';

  @override
  String get fullNameLabel => 'Nome Completo';

  @override
  String get fullNameHint => 'Seu nome completo';

  @override
  String get confirmPasswordLabel => 'Confirmar senha';

  @override
  String get weightLabel => 'Peso (kg)';

  @override
  String get weightHint => 'Opcional';

  @override
  String get createAccountButton => 'CRIAR CONTA';

  @override
  String get alreadyHaveAccount => 'JÁ TEM UMA CONTA? ENTRAR';

  @override
  String get passwordsMismatch => 'As senhas não coincidem.';

  @override
  String get accountCreatedSuccess =>
      '✅ Conta criada com sucesso! Você pode fazer login.';

  @override
  String get uploadPhoto => 'Adicionar uma foto';

  @override
  String get staffManagement => 'Gestão de Equipa';

  @override
  String get staffTab => 'Equipa';

  @override
  String get absencesTab => 'Ausências';

  @override
  String get pendingHeader => 'PENDENTE';

  @override
  String get historyHeader => 'HISTÓRICO';

  @override
  String get slotFullDay => 'Dia inteiro';

  @override
  String get slotMorning => 'Manhã';

  @override
  String get slotAfternoon => 'Tarde';

  @override
  String get reasonLabel => 'Motivo';

  @override
  String get noRequests => 'Sem solicitações.';

  @override
  String get editInstructor => 'Editar Instrutor';

  @override
  String get addInstructor => 'Adicionar Instrutor';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get bio => 'Biografia';

  @override
  String get specialtiesHint => 'Especialidades (separadas por vírgula)';

  @override
  String get photoUrl => 'URL da foto';

  @override
  String get loginCredentials => 'Credenciais de login';

  @override
  String get passwordHint6 => 'Senha (mínimo 6 caracteres)';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get addButton => 'Adicionar';

  @override
  String get statusPending => 'Pendente';

  @override
  String get statusApproved => 'Aprovado';

  @override
  String get statusRejected => 'Rejeitado';

  @override
  String get errorLabel => 'Erro';

  @override
  String get sessionExpired => 'Sessão expirada ou perfil não encontrado';

  @override
  String get noUsersFound => 'Nenhum usuário encontrado na base de dados.';

  @override
  String get pupilSpace => 'Área do Aluno';

  @override
  String get myProgress => 'Meu Progresso';

  @override
  String get history => 'Histórico';

  @override
  String get logoutTooltip => 'Sair';

  @override
  String get homeTab => 'Início';

  @override
  String get progressTab => 'Progresso';

  @override
  String get alertsTab => 'Alertas';

  @override
  String get historyTab => 'Histórico';

  @override
  String get bookButton => 'Reservar';

  @override
  String get slotUnknown => 'Desconhecido';

  @override
  String get noLessonsScheduled =>
      'Você ainda não tem nenhuma aula programada.';

  @override
  String get lessonOn => 'Aula de';

  @override
  String get slotLabel => 'Período';

  @override
  String get statusUpcoming => 'PRÓXIMO';

  @override
  String get statusCompleted => 'CONCLUÍDO';

  @override
  String get statusCancelled => 'CANCELADO';

  @override
  String get profileTab => 'Perfil';

  @override
  String get notesTab => 'Notas';

  @override
  String get nameLabel => 'Nome';

  @override
  String get currentBalance => 'Saldo atual';

  @override
  String get credits => 'créditos';

  @override
  String get sellPack => 'Vender um Pacote';

  @override
  String get creditAccount => 'Creditar conta';

  @override
  String get noStandardPack =>
      'Nenhum pacote padrão encontrado.\nUse a entrada personalizada abaixo.';

  @override
  String get customEntry => 'Entrada personalizada';

  @override
  String get numberOfSessions => 'Número de sessões';

  @override
  String packAdded(String name) {
    return 'Pacote $name adicionado!';
  }

  @override
  String sessionsAdded(int count) {
    return '$count sessões adicionadas!';
  }

  @override
  String get adjustTotal => 'Ajustar total (Admin)';

  @override
  String get modifyBalance => 'Modificar saldo (Manual)';

  @override
  String get validate => 'Validar';

  @override
  String get invalidNumber => 'Por favor, insira um número válido';

  @override
  String validationTitle(String name) {
    return 'Validação: $name';
  }

  @override
  String get skillsValidatedToday => 'Competências validadas hoje';

  @override
  String get ikoGlobalLevel => 'Nível IKO Global';

  @override
  String get pedagogicalNote => 'Nota pedagógica';

  @override
  String get sessionNoteHint => 'Como foi a sessão?';

  @override
  String get materialIncident => 'Incidente de equipamento?';

  @override
  String get selectEquipmentIssue => 'Selecionar equipamento com problema';

  @override
  String get maintenance => 'Manutenção';

  @override
  String get damaged => 'Danificado';

  @override
  String get validateProgress => 'Validar progresso';

  @override
  String get progressSaved => 'Progresso guardado!';

  @override
  String get errorLoadingEquipment => 'Erro ao carregar equipamento';

  @override
  String get equipmentStatusUpdated => 'Status do equipamento atualizado!';

  @override
  String get monitorSpace => 'Espaço do Instrutor';

  @override
  String get myAbsences => 'Minhas Ausências';

  @override
  String get monitorProfileNotActive => 'Perfil de Instrutor não ativado';

  @override
  String get monitorProfileNotActiveDesc =>
      'Sua conta foi criada, mas um administrador ainda precisa adicioná-lo à equipe da escola para ativar seu espaço.';

  @override
  String get signOut => 'SAIR';

  @override
  String get lessonPlan => 'PLANO DE AULAS';

  @override
  String get noLessonsAssigned => 'Nenhuma aula atribuída para este dia';

  @override
  String get declareAbsence => 'Declarar uma ausência';

  @override
  String get noAbsencesDeclared => 'Nenhuma ausência declarada.';

  @override
  String get absenceRequestTitle => 'Solicitação de ausência';

  @override
  String get timeSlot => 'Período';

  @override
  String get absenceReasonHint => 'Motivo (ex: Pessoal, Doença)';

  @override
  String get send => 'Enviar';

  @override
  String greeting(String name) {
    return 'Olá, $name! 🤙';
  }

  @override
  String get offSystem => 'Fora do Sistema';

  @override
  String get fullDay => 'Dia inteiro';

  @override
  String get reservations => 'Reservas';

  @override
  String get dateLabel => 'Data';

  @override
  String get noReservationsOnSlot => 'Nenhuma reserva para este período';

  @override
  String get instructorUnassigned => 'Instrutor não atribuído';

  @override
  String get noteLabel => 'Nota';

  @override
  String get newReservation => 'Nova Reserva';

  @override
  String get clientNameLabel => 'Nome do Cliente';

  @override
  String get instructorOptional => 'Instrutor (Opcional)';

  @override
  String get randomInstructor => 'Aleatório / Equipe';

  @override
  String get notesLabel => 'Notas / Comentários';

  @override
  String get notesHint => 'Ex: Preferência de instrutor...';

  @override
  String get schoolSettings => 'Configurações da escola';

  @override
  String get settingsNotFound => 'Erro: Configurações não encontradas';

  @override
  String get morningHours => 'Horário da Manhã';

  @override
  String get afternoonHours => 'Horário da Tarde';

  @override
  String get startLabel => 'Início';

  @override
  String get endLabel => 'Fim';

  @override
  String get maxStudentsPerInstructor => 'Máx. alunos por instrutor';

  @override
  String get settingsSaved => 'Configurações guardadas!';

  @override
  String get packCatalog => 'Catálogo de Pacotes';

  @override
  String get packCatalogSubtitle => 'Definir preços e sessões por pacote';

  @override
  String get staffManagementSubtitle => 'Adicionar ou modificar instrutores';

  @override
  String get equipmentManagementSubtitle =>
      'Inventário de kites, pranchas e arneses';

  @override
  String get schoolDashboard => 'Painel da Escola';

  @override
  String get keyMetrics => 'MÉTRICAS CHAVE';

  @override
  String get totalSales => 'Vendas Totais';

  @override
  String get totalEngagement => 'Em compromisso';

  @override
  String get pendingAbsences => 'AUSENCIAS PARA VALIDAR';

  @override
  String get pendingRequests => 'PEDIDOS PENDENTES';

  @override
  String get upcomingPlanning => 'CALENDÁRIO PRÓXIMO';

  @override
  String get topClientsVolume => 'MELHORES CLIENTES (VOLUME)';

  @override
  String get noSessionsPlanned => 'Nenhuma sessão programada';

  @override
  String get chooseInstructor => 'Escolher um instrutor:';

  @override
  String get confirmAndAssign => 'Confirmar e Atribuir';

  @override
  String get noStudentsRegistered => 'Nenhum aluno registrado';

  @override
  String get balanceLabel => 'Saldo';

  @override
  String get newStudent => 'Novo Aluno';

  @override
  String get createButton => 'Criar';

  @override
  String get noEquipmentInCategory => 'Nenhum equipamento nesta categoria.';

  @override
  String get addEquipment => 'Adicionar equipamento';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get brandLabel => 'Marca (ex: F-One, North)';

  @override
  String get modelLabel => 'Modelo (ex: Bandit, Rebel)';

  @override
  String get sizeLabel => 'Tamanho (ex: 9m, 138cm)';

  @override
  String get statusAvailable => 'DISPONÍVEL';

  @override
  String get statusMaintenance => 'MANUTENÇÃO';

  @override
  String get statusDamaged => 'DANIFICADO';

  @override
  String get makeAvailable => 'Tornar Disponível';

  @override
  String get setMaintenance => 'Colocar em Manutenção';

  @override
  String get setDamaged => 'Declarar como Danificado';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get myNotifications => 'Minhas Notificações';

  @override
  String get noNotificationsYet => 'Nenhuma notificação por enquanto.';

  @override
  String get deleteAll => 'Eliminar tudo';

  @override
  String get packCatalogTitle => 'Catálogo de Pacotes';

  @override
  String get sessions => 'sessões';

  @override
  String get newPack => 'Novo Pacote';

  @override
  String get createPackTitle => 'Criar um pacote';

  @override
  String get packNameLabel => 'Nome (ex: Pacote 10h)';

  @override
  String get numberOfCredits => 'Número de créditos';

  @override
  String get priceLabel => 'Preço (€)';

  @override
  String get defaultIkoLevel => 'Nível 1';

  @override
  String get myAcquisitions => 'MINHAS AQUISIÇÕES';

  @override
  String get instructorNotes => 'NOTAS DO INSTRUTOR';

  @override
  String get noNotesYet => 'Nenhuma nota por enquanto.';

  @override
  String get currentLevel => 'Nível Atual';

  @override
  String byInstructor(Object name) {
    return 'Por $name';
  }

  @override
  String get unknownInstructor => 'Instrutor Desconhecido';

  @override
  String instructorLabel(Object name) {
    return 'Instrutor: $name';
  }

  @override
  String get addLessonNote => 'Adicionar nota de aula';

  @override
  String get sessionFeedback => 'Feedback da sessão';

  @override
  String get instructor => 'Instrutor';

  @override
  String get observations => 'Observações';

  @override
  String get observationsHint => 'ex: Boa progressão no waterstart...';

  @override
  String currentIkoLevel(Object level) {
    return 'Nível IKO atual: $level';
  }

  @override
  String get notDefined => 'Não definido';

  @override
  String get progressChecklist => 'Lista de progresso';

  @override
  String get lessonPlanning => 'PLANEJAMENTO DE AULAS';

  @override
  String get unknown => 'Desconhecido';

  @override
  String packDetails(int credits, double price) {
    return '$credits sessões • $price€';
  }

  @override
  String get notAvailable => 'N/D';

  @override
  String get knots => 'nds';

  @override
  String get sunSafetyReminder => 'Proteção Solar ☀️';

  @override
  String get sunSafetyTip =>
      'Lembre-se de aplicar protetor solar e trazer seus óculos de sol!';

  @override
  String get ikoLevel1Discovery => 'Nível 1 - Descoberta';

  @override
  String get ikoLevel2Intermediate => 'Nível 2 - Intermédio';

  @override
  String get ikoLevel3Independent => 'Nível 3 - Independente';

  @override
  String get ikoLevel4Advanced => 'Nível 4 - Perfeição';

  @override
  String get skillPreparationSafety => 'Preparação e Segurança';

  @override
  String get skillNeutralZonePiloting => 'Pilotagem zona neutra';

  @override
  String get skillTakeoffLanding => 'Descolagem / Aterragem';

  @override
  String get skillBasicNavigation => 'Navegação básica';

  @override
  String get skillTransitionsJumps => 'Transições e Saltos';

  @override
  String get skillJumpWithGrab => 'Salto com grab';

  @override
  String get equipmentCategories => 'Categorias de Equipamento';

  @override
  String get addCategory => 'Adicionar categoria';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get deleteCategory => 'Excluir categoria';

  @override
  String get confirmDeleteCategory =>
      'Tem certeza de que deseja excluir esta categoria?';

  @override
  String cannotDeleteCategory(Object count) {
    return 'Não é possível excluir: $count equipamento(s) associado(s)';
  }

  @override
  String get categoryName => 'Nome da categoria';

  @override
  String get selectCategory => 'Selecionar uma categoria';

  @override
  String get noEquipmentCategories => 'Sem categorias de equipamento';

  @override
  String get all => 'Todos';

  @override
  String get appearanceSection => 'Aparência';

  @override
  String get themeMode => 'Modo do tema';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get systemTheme => 'Sistema (Dispositivo)';

  @override
  String get brandColors => 'Cores da marca';

  @override
  String get primaryColor => 'Cor primária';

  @override
  String get secondaryColor => 'Cor secundária';

  @override
  String get accentColor => 'Cor de destaque';

  @override
  String get themePresets => 'Temas predefinidos';

  @override
  String get customColor => 'Personalizado...';

  @override
  String get preview => 'Visualizar';

  @override
  String get resetToDefaults => 'Redefinir';

  @override
  String get themeApplied => 'Tema aplicado!';

  @override
  String get colorsReset => 'Cores redefinidas';
}
