import 'package:hive/hive.dart';

part 'todo.g.dart';

/// Represents a Todo item in the application.
///
/// This class is used to store todo information including its completion status
/// and timestamps. It's also configured to work with Hive for persistence.
@HiveType(typeId: 0)
class Todo extends HiveObject {
  /// Unique identifier for the todo item
  @HiveField(0)
  final String id;

  /// Title of the todo item
  @HiveField(1)
  final String title;

  /// Detailed description of the todo item
  @HiveField(2)
  final String description;

  /// Whether the todo item is completed
  @HiveField(3)
  final bool isCompleted;

  /// When the todo item was created
  @HiveField(4)
  final DateTime createdAt;

  /// When the todo item was completed (null if not completed)
  @HiveField(5)
  final DateTime? completedAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a copy of this todo item with the given fields replaced with new values.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
