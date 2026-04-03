import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'services/notification_service.dart';
import 'providers/app_lock_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize notifications after first frame to avoid blocking app startup.
    _notificationService = NotificationService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.initFCM();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      // App going to background
      final isBiometricEnabled = ref.read(biometricSettingsProvider).value ?? false;
      if (isBiometricEnabled) {
        ref.read(appLockProvider.notifier).lock();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'UCHAT',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
