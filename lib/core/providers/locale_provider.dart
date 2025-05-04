import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  final SharedPreferences _prefs;
  Locale _locale;

  LocaleProvider(this._prefs) : _locale = _getLocaleFromPrefs(_prefs);

  Locale get locale => _locale;

  static Locale _getLocaleFromPrefs(SharedPreferences prefs) {
    final localeString = prefs.getString(_localeKey);
    if (localeString == null) return const Locale('en');
    return Locale(localeString);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
