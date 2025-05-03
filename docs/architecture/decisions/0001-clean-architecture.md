# ADR 0001: Использование Clean Architecture

## Статус
Принято

## Контекст
Нам нужно выбрать архитектурный подход для приложения, который обеспечит:
- Тестируемость
- Масштабируемость
- Поддерживаемость
- Независимость от фреймворков

## Решение
Мы используем Clean Architecture, разделяя приложение на слои:

### Domain Layer
- Entities (бизнес-сущности)
- Repository Interfaces
- Use Cases

### Data Layer
- Repository Implementations
- Data Sources
- DTOs

### Presentation Layer
- BLoC (State Management)
- UI Components
- Pages

### Core Layer
- Constants
- Utilities
- Shared Types

## Последствия
### Положительные
- Четкое разделение ответственности
- Легкость тестирования
- Независимость от внешних фреймворков
- Простота замены компонентов

### Отрицательные
- Больше boilerplate кода
- Сложнее начать разработку
- Требуется больше времени на рефакторинг

## Примеры
```dart
// Domain Layer
class Todo {
  final String id;
  final String title;
  final bool isCompleted;
}

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
}

class GetTodosUseCase {
  final TodoRepository repository;
  // ...
}

// Data Layer
class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource dataSource;
  // ...
}

// Presentation Layer
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  // ...
}
``` 