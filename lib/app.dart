import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/di/di.dart';
import 'features/counter/presentation/provider/counter_provider.dart';
import 'features/todo/presentation/pages/todo_list_page.dart';
import 'features/todo/presentation/providers/locale_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => sl<CounterProvider>()..loadCounter(),
            ),
            ChangeNotifierProvider(
              create: (_) => sl<LocaleProvider>(),
            ),
          ],
          child: Consumer<LocaleProvider>(
            builder: (context, localeProvider, _) {
              return MaterialApp(
                title: 'Flutter Clean Architecture',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
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
                  builder: (context) {
                    final l10n = AppLocalizations.of(context);
                    if (l10n == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return TodoListPage(l10n: l10n);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _initializeApp() async {
    // Инициализируем только необходимые компоненты
    await init();
  }
}
