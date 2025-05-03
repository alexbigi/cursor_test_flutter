import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/todo/presentation/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) {
        context.read<LocaleProvider>().setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ru'),
          child: Text('Русский'),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('be'),
          child: Text('Беларуская'),
        ),
      ],
    );
  }
}
