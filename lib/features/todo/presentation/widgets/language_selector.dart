import 'package:cursor_test_flutter/core/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleProvider>().locale;

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) async {
        await context.read<LocaleProvider>().setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ru'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Русский'),
              if (currentLocale.languageCode == 'ru')
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('be'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Беларуская'),
              if (currentLocale.languageCode == 'be')
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
