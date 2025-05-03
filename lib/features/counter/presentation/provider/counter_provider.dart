import 'package:flutter/material.dart';
import '../../domain/entities/counter_entity.dart';
import '../../domain/usecases/increment_counter.dart';

class CounterProvider extends ChangeNotifier {
  final IncrementCounter incrementCounter;
  CounterEntity _counter = const CounterEntity(0);
  bool _initialized = false;

  CounterProvider(this.incrementCounter);

  CounterEntity get counter => _counter;

  Future<void> loadCounter() async {
    if (_initialized) return;
    _counter = await incrementCounter.repository.getCounter();
    _initialized = true;
    notifyListeners();
  }

  Future<void> increment() async {
    _counter = await incrementCounter();
    notifyListeners();
  }
} 