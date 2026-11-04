import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'app/providers.dart';
import 'app/router.dart';
import 'app/theme/theme.dart';
import 'features/nudges/local_notification_gateway.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize time zones for DST-safe scheduling
  tz_data.initializeTimeZones();
  try {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // Initialize local notifications channel
  await LocalNotificationGateway.instance.initialize();

  runApp(const ProviderScope(child: RekindleApp()));
}

class RekindleApp extends ConsumerStatefulWidget {
  const RekindleApp({super.key});

  @override
  ConsumerState<RekindleApp> createState() => _RekindleAppState();
}

class _RekindleAppState extends ConsumerState<RekindleApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reconcile();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reconcile();
    }
  }

  void _reconcile() {
    ref.read(reminderReconciliationServiceProvider).reconcile().catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Rekindle',
      debugShowCheckedModeBanner: false,
      theme: RekindleTheme.light(),
      darkTheme: RekindleTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
