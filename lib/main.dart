import 'package:cursor_test_flutter/app.dart';
import 'package:cursor_test_flutter/core/di/di.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (kDebugMode) {
      print('Initializing dependencies...');
    }
    await init();
    if (kDebugMode) {
      print('Dependencies initialized successfully');
    }
    runApp(const App());
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error during initialization: $e');
      print('Stack trace: $stackTrace');
    }
    rethrow;
  }
}
