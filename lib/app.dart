import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/navigation/router.dart';
import 'core/theme/app_theme.dart';
import 'features/secure_auth/presentation/screens/unlock_screen.dart';
import 'features/secure_auth/presentation/state/app_lock_coordinator.dart';
import 'l10n/app_localizations.dart';

/// The root application shell bootstrapping GoRouter, Custom Themes, and the Global Lock Overlay.
class BankYarApp extends ConsumerWidget {
  /// Constructor constructing complete [BankYarApp].
  const BankYarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      routerConfig: AppRouter.router,
      themeMode: ThemeMode.system,
      theme: AppTheme.createThemeLight(),
      darkTheme: AppTheme.createThemeDark(),
      locale: const Locale(
        'fa',
      ), // Sets Persian Farsi as primary native default
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English LTR support
        Locale('fa'), // Persian Farsi RTL support
      ],
      builder: (context, child) {
        return AppLifecycleObserver(
          child: Consumer(
            builder: (context, ref, _) {
              final authState = ref.watch(appLockCoordinatorProvider);

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  children: [
                    // ignore: use_null_aware_elements
                    if (child != null) child,
                    // Security overlay completely blocks interaction and shields data
                    if (!authState.isAppUnlocked)
                      Positioned.fill(
                        child: FocusScope(
                          node:
                              FocusScopeNode(), // Captures keyboard and accessibility focus mapping
                          child: const Material(child: UnlockScreen()),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Helper observer widget tracking user haptic interactions to delay auto-locks.
class AppLifecycleObserver extends ConsumerWidget {
  /// Constructor.
  const AppLifecycleObserver({super.key, required this.child});

  /// The nested UI child widget to render underneath.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) =>
          ref.read(appLockCoordinatorProvider.notifier).recordUserActivity(),
      onPanDown: (_) =>
          ref.read(appLockCoordinatorProvider.notifier).recordUserActivity(),
      child: child,
    );
  }
}
