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

    // Create "rekindle_reminders" channel with HIGH importance for deliberate user reminders
    const remindersChannel = AndroidNotificationChannel(
      'rekindle_reminders',
      'Reminders',
      description: 'Scheduled reminders to revisit saved thoughts and topics.',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(androidChannel);
    await androidImpl?.createNotificationChannel(remindersChannel);

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

  /// Check whether exact alarm permission is currently granted
  Future<bool> canScheduleExactNotifications() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    try {
      return await android?.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request exact alarms permission (opens Alarms & reminders settings on Android 13/14+)
  Future<bool?> requestExactAlarmsPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    try {
      return await android?.requestExactAlarmsPermission();
    } catch (_) {
      return null;
    }
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
    var safeTzDate = tzDate;
    final nowTz = tz.TZDateTime.now(tz.local);
    if (!safeTzDate.isAfter(nowTz)) {
      safeTzDate = nowTz.add(const Duration(seconds: 5));
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = false;
    try {
      canExact = await android?.canScheduleExactNotifications() ?? false;
    } catch (_) {}

    if (canExact) {
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          safeTzDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
        return;
      } catch (_) {
        // Fallback to inexact if exact schedule fails or throws SecurityException on Android 13/14
      }
    }

    // Safe fallback that never requires exact alarm permissions and never throws SecurityException
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      safeTzDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
