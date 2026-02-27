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
}
