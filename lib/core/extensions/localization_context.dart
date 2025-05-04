import 'package:cursor_test_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
