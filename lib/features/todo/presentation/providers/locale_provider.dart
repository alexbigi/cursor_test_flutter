import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  final SharedPreferences _prefs;
  Locale? _locale;

  LocaleProvider(this._prefs) {
    final String? localeString = _prefs.getString(_localeKey);
    if (localeString != null) {
      final parts = localeString.split('_');
      _locale = Locale(parts[0]);
    }
  }

  Locale? get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      await _prefs.setString(_localeKey, locale.languageCode);
      notifyListeners();
    }
  }
}
