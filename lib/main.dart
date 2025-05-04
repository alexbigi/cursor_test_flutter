import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cursor_test_flutter/features/todo/domain/entities/todo.dart';
import 'package:cursor_test_flutter/app.dart';
import 'package:cursor_test_flutter/core/di/di.dart';
import 'package:cursor_test_flutter/core/utils/logger.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>('todos');
    Logger.info('Hive initialized successfully');

    // Initialize dependencies
    await init();

    runApp(const App());
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize app', e, stackTrace);
    rethrow;
  }
}
