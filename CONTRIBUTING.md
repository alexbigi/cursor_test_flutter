# Contributing Guide

## Development Process

### 1. Feature Development

When adding a new feature:

1. Create a new branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Follow the Clean Architecture pattern:
   - Add domain entities first
   - Add repository interfaces
   - Implement repositories
   - Add use cases
   - Implement presentation layer (BLoC + UI)

3. Write tests for each layer:
   - Unit tests for entities
   - Unit tests for repositories
   - Unit tests for use cases
   - Unit tests for BLoC
   - Widget tests for UI components

### 2. Testing Requirements

- All new features must have tests
- Test coverage should not decrease
- Follow the AAA pattern (Arrange-Act-Assert)
- Test both success and error scenarios
- Use meaningful test descriptions

Example test structure:
```dart
group('FeatureName', () {
  test('should do something when condition', () async {
    // Arrange
    // Act
    // Assert
  });
});
```

### 3. Documentation

- Document all public APIs
- Update README.md if needed
- Add comments for complex logic
- Document test scenarios

### 4. Code Review Process

1. Create a Pull Request
2. Ensure all CI checks pass
3. Request review from team members
4. Address review comments
5. Merge after approval

### 5. Quality Checks

Before submitting a PR:

1. Run tests:
   ```bash
   flutter test
   ```

2. Check code quality:
   ```bash
   flutter analyze
   ```

3. Format code:
   ```bash
   flutter format .
   ```

### 6. Testing Guidelines

#### BLoC Testing
- Test all events
- Test all states
- Test error scenarios
- Test edge cases

#### Repository Testing
- Test all CRUD operations
- Test error handling
- Test data persistence

#### UI Testing
- Test widget rendering
- Test user interactions
- Test state changes

### 7. Documentation Guidelines

#### Code Documentation
```dart
/// Brief description
/// 
/// Detailed description if needed
/// 
/// Example:
/// ```dart
/// final todo = Todo(title: 'Test');
/// ```
class YourClass {
  /// Field description
  final String field;
}
```

#### Test Documentation
```dart
/// Tests for [YourClass] functionality
/// 
/// This test suite covers:
/// - Feature 1
/// - Feature 2
/// - Edge cases
group('YourClass', () {
  // Tests
});
```

### 8. Common Pitfalls to Avoid

1. Missing tests for new features
2. Decreasing test coverage
3. Undocumented public APIs
4. Complex logic without comments
5. Ignoring CI failures

### 9. Getting Help

If you're unsure about:
- Architecture decisions
- Testing approach
- Documentation requirements

Please ask in the team chat or create an issue for discussion. 