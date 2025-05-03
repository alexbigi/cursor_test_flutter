import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/di.dart';
import 'features/counter/presentation/pages/counter_page.dart';
import 'features/counter/presentation/provider/counter_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<CounterProvider>()..loadCounter()),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const CounterPage(),
      ),
    );
  }
} 