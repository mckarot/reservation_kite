// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Kite Reserve';

  @override
  String get loginTitle => '登录';

  @override
  String get loginButton => '登录';

  @override
  String get logoutButton => '退出';

  @override
  String get noAccount => '没有账户？';

  @override
  String get createAccount => '创建账户';

  @override
  String get emailLabel => '电子邮件';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get passwordLabel => '密码';

  @override
  String get passwordHint => '最少 6 个字符';

  @override
  String get passwordHintError => '密码必须至少包含 6 个字符。';

  @override
  String get loginError => '登录失败';

  @override
  String get loginSuccess => '登录成功！';

  @override
  String get navDashboard => '首页';

  @override
  String get navBooking => '预订';

  @override
  String get navProgress => '进展';

  @override
  String get navProfile => '个人资料';

  @override
  String get navSettings => '设置';

  @override
  String welcomeMessage(String name) {
    return '你好，$name';
  }

  @override
  String get readyForSession => '准备好上课了吗？';

  @override
  String get myBalance => '我的余额';

  @override
  String get sessionsRemaining => '剩余课程';

  @override
  String get quickStats => '快速统计';

  @override
  String get ikoLevel => 'IKO 级别';

  @override
  String get progression => '进展';

  @override
  String skillsValidated(int count) {
    return '$count 项技能已验证';
  }

  @override
  String get weather => '天气';

  @override
  String get currentWeather => '当前天气';

  @override
  String get windSpeed => '风速';

  @override
  String get windDirection => '风向';

  @override
  String get temperature => '温度';

  @override
  String get kmh => '公里/小时';

  @override
  String get weatherInfo => '天气仅供参考，可能会有变化。';

  @override
  String get bookingScreen => '预订';

  @override
  String get selectDate => '选择日期';

  @override
  String get selectSlot => '时间段';

  @override
  String get selectInstructor => '选择教练';

  @override
  String get morning => '早上';

  @override
  String get morningTime => '08:00 - 12:00';

  @override
  String get afternoon => '下午';

  @override
  String get afternoonTime => '13:00 - 18:00';

  @override
  String get bookingNotes => '备注或偏好（可选）';

  @override
  String get bookingNotesHint => '例如：偏好某位教练，当前水平...';

  @override
  String get bookingSent => '请求已发送！等待管理员确认。';

  @override
  String get insufficientBalance => '余额不足，请充值。';

  @override
  String get sendRequest => '发送请求';

  @override
  String get slotFull => '已满';

  @override
  String get slotUnavailable => '不可用（员工缺席）';

  @override
  String get remainingSlots => '剩余位置：';

  @override
  String get weatherDateTooFar => '日期太远，无法提供准确的天气预报。';

  @override
  String get confirmBooking => '确认预订';

  @override
  String get cancelBooking => '取消预订';

  @override
  String get bookingConfirmed => '预订已确认！';

  @override
  String get bookingCancelled => '预订已取消';

  @override
  String get bookingError => '预订错误';

  @override
  String get noAvailableSlots => '无可用时间段';

  @override
  String get maxCapacityReached => '已达最大容量';

  @override
  String get ikoLevel1 => '1 级 - 入门';

  @override
  String get ikoLevel2 => '2 级 - 中级';

  @override
  String get ikoLevel3 => '3 级 - 独立';

  @override
  String get ikoLevel4 => '4 级 - 高级';

  @override
  String get skillPreparation => '准备与安全';

  @override
  String get skillPilotage => '中立区操控';

  @override
  String get skillTakeoff => '起飞/降落';

  @override
  String get skillBodyDrag => '拖曳游泳';

  @override
  String get skillWaterstart => '水上起步';

  @override
  String get skillNavigation => '基础航行';

  @override
  String get skillUpwind => '逆风航行';

  @override
  String get skillTransitions => '转换与跳跃';

  @override
  String get skillBasicJump => '基础跳跃';

  @override
  String get skillJibe => '换向';

  @override
  String get skillGrab => '抓板跳跃';

  @override
  String get adminPanel => '管理面板';

  @override
  String get settings => '设置';

  @override
  String get students => '学生';

  @override
  String get instructors => '教练';

  @override
  String get equipment => '设备';

  @override
  String get calendar => '日历';

  @override
  String get dashboard => '仪表板';

  @override
  String get manageStaff => '管理员工';

  @override
  String get studentDirectory => '学生目录';

  @override
  String get equipmentManagement => '设备管理';

  @override
  String get language => '语言';

  @override
  String get languageSelector => '选择语言';

  @override
  String get weatherLocation => '天气位置';

  @override
  String get latitude => '纬度';

  @override
  String get longitude => '经度';

  @override
  String get useMyLocation => '📍 使用我的位置';

  @override
  String get saveCoordinates => '💾 保存';

  @override
  String get notifications => '通知';

  @override
  String get noNotifications => '无通知';

  @override
  String get markAsRead => '标记为已读';

  @override
  String get deleteNotification => '删除';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get confirm => '确认';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get close => '关闭';

  @override
  String get refresh => '刷新';

  @override
  String get initSchema => '初始化架构';

  @override
  String get initSchemaSuccess => '测试数据和集合已初始化！';

  @override
  String get initSchemaError => '初始化错误';

  @override
  String get genericError => '发生错误';

  @override
  String get networkError => '连接错误';

  @override
  String get unauthorized => '未授权';

  @override
  String get notFound => '未找到';

  @override
  String get tryAgain => '重试';

  @override
  String get adminScreenTitle => '管理面板';

  @override
  String get pendingAbsencesAlert => '待确认的缺勤';

  @override
  String get dashboardKPIs => '仪表板（KPI）';

  @override
  String get calendarBookings => '日历';

  @override
  String seeRequests(int count) {
    return '查看 $count 个请求...';
  }

  @override
  String get registrationTitle => '创建账户';

  @override
  String get fullNameLabel => '全名';

  @override
  String get fullNameHint => '您的全名';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get weightLabel => '体重（kg）';

  @override
  String get weightHint => '可选';

  @override
  String get createAccountButton => '创建账户';

  @override
  String get alreadyHaveAccount => '已有账户？登录';

  @override
  String get passwordsMismatch => '密码不匹配。';

  @override
  String get accountCreatedSuccess => '✅ 账户创建成功！您可以登录了。';

  @override
  String get uploadPhoto => '添加照片';

  @override
  String get staffManagement => '员工管理';

  @override
  String get staffTab => '员工';

  @override
  String get absencesTab => '缺席';

  @override
  String get pendingHeader => '待处理';

  @override
  String get historyHeader => '历史记录';

  @override
  String get slotFullDay => '全天';

  @override
  String get slotMorning => '早上';

  @override
  String get slotAfternoon => '下午';

  @override
  String get reasonLabel => '原因';

  @override
  String get noRequests => '无请求。';

  @override
  String get editInstructor => '编辑教练';

  @override
  String get addInstructor => '添加教练';

  @override
  String get fullName => '全名';

  @override
  String get bio => '个人简介';

  @override
  String get specialtiesHint => '专长（用逗号分隔）';

  @override
  String get photoUrl => '照片网址';

  @override
  String get loginCredentials => '登录凭证';

  @override
  String get passwordHint6 => '密码（至少 6 个字符）';

  @override
  String get cancelButton => '取消';

  @override
  String get saveButton => '保存';

  @override
  String get addButton => '添加';

  @override
  String get statusPending => '待处理';

  @override
  String get statusApproved => '已批准';

  @override
  String get statusRejected => '已拒绝';

  @override
  String get errorLabel => '错误';

  @override
  String get sessionExpired => '会话已过期或未找到个人资料';

  @override
  String get noUsersFound => '数据库中未找到用户。';

  @override
  String get pupilSpace => '学生区域';

  @override
  String get myProgress => '我的进度';

  @override
  String get history => '历史记录';

  @override
  String get logoutTooltip => '退出';

  @override
  String get homeTab => '首页';

  @override
  String get progressTab => '进度';

  @override
  String get alertsTab => '提醒';

  @override
  String get historyTab => '历史记录';

  @override
  String get bookButton => '预订';

  @override
  String get slotUnknown => '未知';

  @override
  String get noLessonsScheduled => '您还没有任何课程安排。';

  @override
  String get lessonOn => '课程日期';

  @override
  String get slotLabel => '时间段';

  @override
  String get statusUpcoming => '即将开始';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusCancelled => '已取消';

  @override
  String get profileTab => '个人资料';

  @override
  String get notesTab => '备注';

  @override
  String get nameLabel => '姓名';

  @override
  String get currentBalance => '当前余额';

  @override
  String get credits => '积分';

  @override
  String get sellPack => '出售套餐';

  @override
  String get creditAccount => '充值账户';

  @override
  String get noStandardPack => '未找到标准套餐。\n请使用下面的自定义输入。';

  @override
  String get customEntry => '自定义输入';

  @override
  String get numberOfSessions => '课程数量';

  @override
  String packAdded(String name) {
    return '套餐 $name 已添加！';
  }

  @override
  String sessionsAdded(int count) {
    return '已添加 $count 节课！';
  }

  @override
  String get adjustTotal => '调整总额（管理员）';

  @override
  String get modifyBalance => '修改余额（手动）';

  @override
  String get validate => '验证';

  @override
  String get invalidNumber => '请输入有效的数字';

  @override
  String validationTitle(String name) {
    return '验证：$name';
  }

  @override
  String get skillsValidatedToday => '今天验证的技能';

  @override
  String get ikoGlobalLevel => 'IKO 全球级别';

  @override
  String get pedagogicalNote => '教学备注';

  @override
  String get sessionNoteHint => '课程进行得如何？';

  @override
  String get materialIncident => '设备事故？';

  @override
  String get selectEquipmentIssue => '选择有问题的设备';

  @override
  String get maintenance => '维护';

  @override
  String get damaged => '损坏';

  @override
  String get validateProgress => '验证进度';

  @override
  String get progressSaved => '进度已保存！';

  @override
  String get errorLoadingEquipment => '加载设备时出错';

  @override
  String get equipmentStatusUpdated => '设备状态已更新！';

  @override
  String get monitorSpace => '教练空间';

  @override
  String get myAbsences => '我的缺席';

  @override
  String get monitorProfileNotActive => '教练资料未激活';

  @override
  String get monitorProfileNotActiveDesc => '您的账户已创建，但管理员仍需将您添加到学校员工名单以激活您的空间。';

  @override
  String get signOut => '退出登录';

  @override
  String get lessonPlan => '课程计划';

  @override
  String get noLessonsAssigned => '今天没有分配的课程';

  @override
  String get declareAbsence => '申报缺席';

  @override
  String get noAbsencesDeclared => '没有申报的缺席。';

  @override
  String get absenceRequestTitle => '缺席申请';

  @override
  String get timeSlot => '时间段';

  @override
  String get absenceReasonHint => '原因（例如：个人、生病）';

  @override
  String get send => '发送';

  @override
  String greeting(String name) {
    return '你好，$name！🤙';
  }

  @override
  String get offSystem => '系统外';

  @override
  String get fullDay => '全天';

  @override
  String get reservations => '预订';

  @override
  String get dateLabel => '日期';

  @override
  String get noReservationsOnSlot => '此时间段没有预订';

  @override
  String get instructorUnassigned => '未分配教练';

  @override
  String get noteLabel => '备注';

  @override
  String get newReservation => '新预订';

  @override
  String get clientNameLabel => '客户姓名';

  @override
  String get instructorOptional => '教练（可选）';

  @override
  String get randomInstructor => '随机/团队';

  @override
  String get notesLabel => '注释/评论';

  @override
  String get notesHint => '例如：教练偏好...';

  @override
  String get schoolSettings => '学校设置';

  @override
  String get settingsNotFound => '错误：未找到设置';

  @override
  String get morningHours => '早上时间';

  @override
  String get afternoonHours => '下午时间';

  @override
  String get startLabel => '开始';

  @override
  String get endLabel => '结束';

  @override
  String get maxStudentsPerInstructor => '每名教练最多学生数';

  @override
  String get settingsSaved => '设置已保存！';

  @override
  String get packCatalog => '套餐目录';

  @override
  String get packCatalogSubtitle => '定义每个套餐的价格和课程';

  @override
  String get staffManagementSubtitle => '添加或修改教练';

  @override
  String get equipmentManagementSubtitle => '风筝、板和 harness 库存';

  @override
  String get schoolDashboard => '学校仪表板';

  @override
  String get keyMetrics => '关键指标';

  @override
  String get totalSales => '总销售额';

  @override
  String get totalEngagement => '承诺中';

  @override
  String get pendingAbsences => '待批准的缺席';

  @override
  String get pendingRequests => '待处理的请求';

  @override
  String get upcomingPlanning => '即将到来的计划';

  @override
  String get topClientsVolume => '顶级客户（数量）';

  @override
  String get noSessionsPlanned => '没有计划的课程';

  @override
  String get chooseInstructor => '选择教练：';

  @override
  String get confirmAndAssign => '确认并分配';

  @override
  String get noStudentsRegistered => '没有注册的学生';

  @override
  String get balanceLabel => '余额';

  @override
  String get newStudent => '新学生';

  @override
  String get createButton => '创建';

  @override
  String get noEquipmentInCategory => '此类别中没有设备。';

  @override
  String get addEquipment => '添加设备';

  @override
  String get typeLabel => '类型';

  @override
  String get brandLabel => '品牌（例如：F-One, North）';

  @override
  String get modelLabel => '型号（例如：Bandit, Rebel）';

  @override
  String get sizeLabel => '尺寸（例如：9m, 138cm）';

  @override
  String get statusAvailable => '可用';

  @override
  String get statusMaintenance => '维护中';

  @override
  String get statusDamaged => '损坏';

  @override
  String get makeAvailable => '设为可用';

  @override
  String get setMaintenance => '设为维护';

  @override
  String get setDamaged => '标记为损坏';

  @override
  String get deleteButton => '删除';

  @override
  String get myNotifications => '我的通知';

  @override
  String get noNotificationsYet => '暂无通知。';

  @override
  String get deleteAll => '全部删除';

  @override
  String get packCatalogTitle => '套餐目录';

  @override
  String get sessions => '节课';

  @override
  String get newPack => '新套餐';

  @override
  String get createPackTitle => '创建套餐';

  @override
  String get packNameLabel => '名称（例如：10 小时套餐）';

  @override
  String get numberOfCredits => '积分数量';

  @override
  String get priceLabel => '价格 (€)';

  @override
  String get defaultIkoLevel => '1 级';

  @override
  String get myAcquisitions => '我的收获';

  @override
  String get instructorNotes => '教练笔记';

  @override
  String get noNotesYet => '暂无笔记。';

  @override
  String get currentLevel => '当前级别';

  @override
  String byInstructor(Object name) {
    return '由 $name';
  }

  @override
  String get unknownInstructor => '未知教练';

  @override
  String instructorLabel(Object name) {
    return '教练：$name';
  }

  @override
  String get addLessonNote => '添加课程笔记';

  @override
  String get sessionFeedback => '课程反馈';

  @override
  String get instructor => '教练';

  @override
  String get observations => '观察';

  @override
  String get observationsHint => '例如：水上起步进展良好...';

  @override
  String currentIkoLevel(Object level) {
    return '当前 IKO 级别：$level';
  }

  @override
  String get notDefined => '未定义';

  @override
  String get progressChecklist => '进度清单';

  @override
  String get lessonPlanning => '课程计划';

  @override
  String get unknown => '未知';

  @override
  String packDetails(int credits, double price) {
    return '$credits 节课 • $price€';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get knots => '节';

  @override
  String get sunSafetyReminder => '防晒保护 ☀️';

  @override
  String get sunSafetyTip => '记得涂防晒霜，带上太阳镜！';

  @override
  String get ikoLevel1Discovery => '1 级 - 入门';

  @override
  String get ikoLevel2Intermediate => '2 级 - 中级';

  @override
  String get ikoLevel3Independent => '3 级 - 独立';

  @override
  String get ikoLevel4Advanced => '4 级 - 高级';

  @override
  String get skillPreparationSafety => '准备与安全';

  @override
  String get skillNeutralZonePiloting => '中立区操控';

  @override
  String get skillTakeoffLanding => '起飞/降落';

  @override
  String get skillBasicNavigation => '基础航行';

  @override
  String get skillTransitionsJumps => '转换与跳跃';

  @override
  String get skillJumpWithGrab => '抓板跳跃';

  @override
  String get equipmentCategories => '装备类别';

  @override
  String get addCategory => '添加类别';

  @override
  String get editCategory => '编辑类别';

  @override
  String get deleteCategory => '删除类别';

  @override
  String get confirmDeleteCategory => '您确定要删除此类别吗？';

  @override
  String cannotDeleteCategory(Object count) {
    return '无法删除：$count 个装备已关联';
  }

  @override
  String get categoryName => '类别名称';

  @override
  String get selectCategory => '选择类别';

  @override
  String get noEquipmentCategories => '无装备类别';

  @override
  String get all => '全部';

  @override
  String get createCategories => '创建类别';

  @override
  String get categoriesCreatedSuccess => '6 个装备类别创建成功！';
}
