# Integration Tests

This directory contains integration tests for the Note App. Integration tests verify complete user flows and ensure the app works correctly end-to-end.

**Location**: This directory is placed at the root level of the Flutter project, following Flutter's standard project structure.

## Test Files

### `auth_flow_test.dart`
Tests the complete authentication flow:
- User registration
- Login with valid credentials
- Login with invalid credentials
- Session persistence
- Logout functionality

### `note_management_test.dart`
Tests note management features:
- Loading notes on home screen
- Add note button presence
- Search functionality
- Note count display
- Pull-to-refresh (if implemented)

### `performance_test.dart`
Tests performance and error handling:
- App startup time
- Memory leak prevention
- Network error handling
- Large dataset performance
- App lifecycle handling
- Accessibility compliance

### `app_test.dart`
General app flow tests (placeholder for future implementation).

## Running Integration Tests

### Prerequisites
1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

2. Run `flutter pub get`

### Execute Tests
```bash
# Run all integration tests
flutter test integration_test/

# Run specific test file
flutter test integration_test/auth_flow_test.dart

# Run on specific device
flutter test integration_test/ -d <device-id>

# Run with verbose output
flutter test integration_test/ -v
```

### Test Results
- Tests will run on a connected device or emulator
- Results show pass/fail status
- Failed tests provide detailed error messages
- Screenshots can be captured on failure for debugging

## Best Practices

### Writing Integration Tests
1. **Use descriptive test names** that explain the user flow
2. **Test complete user journeys**, not isolated components
3. **Include setup and teardown** for test data
4. **Verify UI state changes** after actions
5. **Test error scenarios** and edge cases

### Test Data Management
- Create test users/data at the beginning of tests
- Clean up test data after tests complete
- Use unique identifiers to avoid conflicts
- Consider using in-memory database for faster tests

### Performance Testing
- Measure startup times
- Test with large datasets
- Verify smooth scrolling and animations
- Check memory usage patterns

## Troubleshooting

### Common Issues
1. **Device not connected**: Ensure a device/emulator is running
2. **Package not found**: Run `flutter pub get`
3. **Test timeouts**: Increase timeout for slow operations
4. **Database conflicts**: Use unique test data identifiers

### Debugging Failed Tests
1. Run test with `-v` flag for detailed output
2. Use `tester.pumpAndSettle()` to wait for animations
3. Check widget tree with `find.byType()` and `find.text()`
4. Add debug prints to understand test flow

## Integration with CI/CD

These tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Run Integration Tests
  run: flutter test integration_test/
  working-directory: .
```

## Coverage

Integration tests complement unit and widget tests by:
- Testing real user interactions
- Verifying complete workflows
- Catching integration bugs
- Ensuring app stability

Aim for integration tests to cover:
- ✅ Critical user paths (registration → login → main features)
- ✅ Error scenarios (network failures, invalid inputs)
- ✅ Performance requirements (startup time, responsiveness)
- ✅ Accessibility features (screen readers, keyboard navigation)