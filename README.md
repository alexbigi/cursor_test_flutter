# Todo App

A Flutter application for managing todo items, built with clean architecture principles.

## Features

- Create, read, update, and delete todo items
- Mark todos as completed
- Persistent storage using Hive
- Clean architecture implementation
- Unit tests with mockito

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running Tests

To run all tests:
```bash
flutter test
```

To run tests with coverage:
```bash
flutter test --coverage
```

To run a specific test file:
```bash
flutter test test/features/todo/presentation/bloc/todo_bloc_test.dart
```

### Running the App

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   └── constants/
├── features/
│   └── todo/
│       ├── data/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## Testing

The project includes comprehensive unit tests for the TodoBloc. Tests cover:
- Loading todos
- Adding new todos
- Updating existing todos
- Deleting todos
- Toggling todo status

Each operation is tested for both success and error scenarios.

## Dependencies

- flutter_bloc: State management
- hive: Local storage
- get_it: Dependency injection
- mockito: Testing
- equatable: Value equality
- uuid: ID generation

## Device Selection

### Ways to select a device:
1. Через панель запуска:
   - Откройте панель "Run and Debug" (Ctrl+Shift+D)
   - В выпадающем списке выберите нужное устройство
   - Нажмите ▶️ для запуска

2. Через командную палитру:
   - Нажмите `Ctrl + Shift + P`
   - Введите "Flutter: Select Device"
   - Выберите нужное устройство из списка

3. Через терминал:
   - `flutter devices` - показать список доступных устройств
   - `flutter run -d <device_id>` - запустить на конкретном устройстве

### Доступные устройства:
- `linux` - Локальное Linux устройство
- `windows` - Локальное Windows устройство
- `macos` - Локальное macOS устройство
- `chrome` - Запуск в Chrome
- `edge` - Запуск в Edge
- `android` - Android эмулятор или устройство
- `ios` - iOS симулятор или устройство

## Keyboard Shortcuts

### Navigation
- `Ctrl + Click` - Перейти к определению класса/метода
- `Ctrl + P` - Быстрый поиск файлов
- `Ctrl + Shift + P` - Командная палитра
- `Ctrl + Shift + F` - Поиск по всему проекту
- `Ctrl + F` - Поиск в файле

### Code Editing
- `Ctrl + .` - Открыть контекстное меню (обернуть виджет, импортировать и т.д.)
- `Ctrl + /` - Закомментировать/раскомментировать
- `Ctrl + D` - Дублировать строку
- `Ctrl + X` - Вырезать строку
- `Alt + Enter` - Быстрые исправления и действия

### Flutter Specific
- `Ctrl + F5` - Запуск приложения
- `Ctrl + Shift + F5` - Hot Restart
- `Ctrl + F5` - Hot Reload
- `Ctrl + Shift + F5` - Остановить приложение

### Debug
- `F5` - Запустить отладку
- `Shift + F5` - Остановить отладку
- `F9` - Установить/снять точку останова
- `F10` - Шаг через
- `F11` - Шаг внутрь
