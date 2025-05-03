# ADR 0002: Локализация приложения

## Статус
Принято

## Контекст
Необходимо добавить поддержку нескольких языков:
- Английский (основной)
- Русский
- Белорусский

Требования:
- Простота добавления новых языков
- Поддержка RTL
- Форматирование дат и чисел
- Плюрализация
- Динамическое переключение языка

## Решение
Использование пакета `flutter_localizations` и `intl`:

1. Структура:
```
lib/
├── l10n/
│   ├── arb/
│   │   ├── app_en.arb
│   │   ├── app_ru.arb
│   │   └── app_be.arb
│   ├── l10n.dart
│   └── generated/
```

2. Формат файлов:
```json
{
  "appTitle": "Todo App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "todos": "{count, plural, =0{No todos}=1{1 todo}other{{count} todos}}",
  "@todos": {
    "description": "Number of todos",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

3. Генерация:
- Автоматическая генерация кода
- Поддержка IDE
- Валидация переводов

## Последствия
### Положительные
- Стандартный подход
- Поддержка IDE
- Автоматическая генерация
- Простота добавления языков

### Отрицательные
- Дополнительные зависимости
- Необходимость генерации
- Обучение команды

## Примеры
```dart
// Использование в коде
Text(AppLocalizations.of(context)!.appTitle);

// Плюрализация
Text(AppLocalizations.of(context)!.todos(5));

// Форматирование
final date = DateFormat.yMd().format(DateTime.now());
``` 