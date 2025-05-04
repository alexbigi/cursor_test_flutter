import 'package:cursor_test_flutter/core/providers/locale_provider.dart';
import 'package:cursor_test_flutter/core/providers/theme_provider.dart';
import 'package:cursor_test_flutter/features/todo/presentation/pages/todo_list_page.dart';
import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = GetIt.instance<ThemeProvider>();
    final localeProvider = GetIt.instance<LocaleProvider>();

    if (kDebugMode) {
      print('ThemeProvider: $themeProvider');
      print('LocaleProvider: $localeProvider');
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'Todo App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0175C2),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0175C2),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
              Locale('be'),
            ],
            home: Builder(
              builder: (context) =>
                  TodoListPage(l10n: AppLocalizations.of(context)!),
            ),
          );
        },
      ),
    );
  }
}
