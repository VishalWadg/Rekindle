import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rekindle_core/rekindle_core.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationGateway implements NotificationGateway {
  LocalNotificationGateway._();
  static final LocalNotificationGateway instance = LocalNotificationGateway._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize({
    DidReceiveNotificationResponseCallback? onNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback? onBackgroundNotificationResponse,
  }) async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationResponse,
    );

    // Create "nudges" channel with DEFAULT importance so notifications appear visibly in status bar and shade
    const androidChannel = AndroidNotificationChannel(
      'nudges',
      'Gentle nudges',
      description: 'Occasional, non-intrusive questions about things you once loved.',
      importance: Importance.defaultImportance,
      enableVibration: true,
      playSound: false,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  /// Version-agnostic permission check:
  /// - Android 13+ (API 33+): prompts runtime POST_NOTIFICATIONS dialog
  /// - Android <= 12: checks if app notifications are enabled in OS settings
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;

    // 1. Trigger runtime prompt (Android 13+)
    final granted = await android.requestNotificationsPermission();
    if (granted != null) {
      return granted;
    }

    // 2. Fallback for Android 12 and below (or if prompt was already resolved)
    final areEnabled = await android.areNotificationsEnabled();
    return areEnabled ?? true;
  }

  /// Check current notification permission state without re-prompting
  Future<bool> areNotificationsEnabled() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? true;
  }

  /// Immediate test notification for instant verification (zero alarm delay)
  Future<void> showInstantTestNotification({
    String title = 'Rekindle · A thought for you',
    String body = 'Curiosity is the engine of intellectual rediscovery. Tap to open.',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'nudges',
      'Gentle nudges',
      channelDescription: 'Occasional, non-intrusive questions about things you once loved.',
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
      actions: [
        AndroidNotificationAction('keep', 'Keep'),
        AndroidNotificationAction('skip', 'Skip'),
        AndroidNotificationAction('more', 'Tell me more', showsUserInterface: true),
      ],
    );

    await _plugin.show(
      888888,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: '{"v":1,"test":true}',
    );
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
    required List<NotificationActionInfo> actions,
  }) async {
    final androidActions = actions.map((a) {
      return AndroidNotificationAction(
        a.id,
        a.label,
        showsUserInterface: a.showsUserInterface,
        inputs: a.hasTextInput ? [const AndroidNotificationActionInput()] : const [],
      );
    }).toList();

    final androidDetails = AndroidNotificationDetails(
      'nudges',
      'Gentle nudges',
      channelDescription: 'Occasional, non-intrusive questions about things you once loved.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      autoCancel: true,
      onlyAlertOnce: false,
      timeoutAfter: 24 * 60 * 60 * 1000, // 24 hours
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'Rekindle',
      ),
      actions: androidActions,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = true;
    try {
      canExact = await android?.canScheduleExactNotifications() ?? true;
    } catch (_) {}

    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      notificationDetails,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
