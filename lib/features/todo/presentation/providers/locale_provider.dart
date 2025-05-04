import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cursor_test_flutter/core/utils/logger.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  final SharedPreferences _prefs;
  Locale _locale;

  LocaleProvider(this._prefs) : _locale = _loadLocale(_prefs);

  static Locale _loadLocale(SharedPreferences prefs) {
    final localeString = prefs.getString(_localeKey);
    if (localeString != null) {
      return Locale(localeString);
    }
    return const Locale('en');
  }

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    try {
      Logger.debug('Clearing locale');
      _locale = const Locale('en');
      notifyListeners();
      Logger.debug('Locale cleared successfully');
    } catch (e, stackTrace) {
      Logger.error('Failed to clear locale', e, stackTrace);
      rethrow;
    }
  }
}
