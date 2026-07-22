import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/navigation/router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// The root application shell bootstrapping GoRouter and Custom Themes.
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
    );
  }
}
