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

    // Create "nudges" channel with LOW importance
    const androidChannel = AndroidNotificationChannel(
      'nudges',
      'Gentle nudges',
      description: 'Occasional, non-intrusive questions about things you once loved.',
      importance: Importance.low,
      enableVibration: false,
      playSound: false,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
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
      importance: Importance.low,
      priority: Priority.low,
      autoCancel: true,
      onlyAlertOnce: true,
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

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
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
