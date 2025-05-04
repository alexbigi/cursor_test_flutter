import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Interface for localization
abstract class LocalizationInterface {
  String get errorLoadingTodos;
  String get errorSavingTodo;
  String get errorDeletingTodo;
  String get appTitle;
  String get noTodos;
  String get retry;
  String get add;
  String get title;
  String get description;
  String get cancel;
  String get delete;
  String get settings;
  String get language;
  String get theme;
  String get dark;
  String get light;
  String get system;
}

/// Extension for BuildContext to get localization
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
