# Developer Guide - Note App

## Tổng quan

Hướng dẫn này dành cho các developer muốn đóng góp vào dự án Note App. Dự án sử dụng kiến trúc MVVM với Flutter và Provider.

## Cấu trúc dự án

```
lib/
├── models/              # Data models
│   ├── note_model.dart
│   └── user_model.dart
├── repositories/        # Data access layer
│   ├── note_repository.dart
│   └── auth_repository.dart
├── services/           # Business logic layer
│   ├── database_service.dart
│   └── auth_service.dart
├── viewmodels/         # State management (MVVM)
│   ├── note_provider.dart
│   └── auth_provider.dart
├── views/
│   ├── screens/        # Main screens
│   └── widgets/        # Reusable widgets
├── constants/          # App constants
├── utils/             # Utility functions
├── animations/        # Animation components
└── bindings/          # Dependency injection
```

## Kiến trúc MVVM

### Model
- Định nghĩa cấu trúc dữ liệu
- Chuyển đổi dữ liệu (toMap/fromMap)
- Validation logic

### View
- UI components (Screens, Widgets)
- Sử dụng Consumer để listen state changes
- Không chứa business logic

### ViewModel
- Quản lý state của View
- Gọi Repository để lấy dữ liệu
- Implement business logic cho View
- Extends ChangeNotifier

## Coding Standards

### Naming Conventions
- **Classes**: PascalCase (NoteModel, AuthProvider)
- **Methods/Variables**: camelCase (getAllNotes, isLoading)
- **Constants**: SCREAMING_SNAKE_CASE (APP_NAME)
- **Files**: snake_case (note_model.dart)

### Code Style
- Sử dụng `const` cho widgets không thay đổi
- Sử dụng `final` cho variables không reassigned
- Comment đầy đủ cho classes và methods phức tạp
- Sử dụng meaningful variable names

### Error Handling
```dart
try {
  // Operation that might fail
  final result = await someAsyncOperation();
  return {'success': true, 'data': result};
} catch (e) {
  debugPrint('Error: $e');
  return {'success': false, 'message': 'Operation failed'};
}
```

## Testing

### Unit Tests
- Test models: constructors, methods, serialization
- Test services: database operations, auth logic
- Test repositories: data access methods
- Test viewmodels: state management

### Widget Tests
- Test UI components rendering
- Test user interactions
- Test state changes
- Test navigation

### Integration Tests
Integration tests verify complete user flows and app behavior:

#### Setup Integration Tests
```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

#### Running Integration Tests
```bash
# Run all integration tests
flutter test integration_test/

# Run specific integration test
flutter test integration_test/auth_flow_test.dart

# Run on specific device
flutter test integration_test/ -d emulator-5554
```

#### Integration Test Structure
```
test/integration_test/
├── auth_flow_test.dart      # Authentication flows
├── note_management_test.dart # Note CRUD operations
├── performance_test.dart    # Performance and error handling
└── app_test.dart           # General app flows
```

#### Example Integration Test
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete user flow', (WidgetTester tester) async {
    // Setup app
    await tester.pumpWidget(MyApp());

    // Navigate and interact
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Fill forms, submit, verify results
    await tester.enterText(find.byType(TextFormField).at(0), 'username');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Assert expected behavior
    expect(find.text('Success'), findsOneWidget);
  });
}
```

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/note_model_test.dart
```

## Database Schema

### Notes Table
```sql
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  tag TEXT,
  createdAt TEXT NOT NULL,
  updatedAt TEXT NOT NULL
);
```

### Users Table
```sql
CREATE TABLE users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  createdAt TEXT NOT NULL
);
```

## Authentication Flow

1. User đăng ký → Hash password → Lưu vào database
2. User đăng nhập → Hash password → So sánh với database
3. Thành công → Lưu userId vào SharedPreferences
4. App khởi động → Kiểm tra SharedPreferences → Auto login

## State Management với Provider

### Setup
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Usage in View
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: provider.notes.length,
          itemBuilder: (context, index) {
            final note = provider.notes[index];
            return ListTile(title: Text(note.title));
          },
        );
      },
    );
  }
}
```

## Adding New Features

### 1. Tạo Model
```dart
class NewFeatureModel {
  final int? id;
  final String name;
  final DateTime createdAt;

  NewFeatureModel({
    this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NewFeatureModel.fromMap(Map<String, dynamic> map) => NewFeatureModel(
    id: map['id'],
    name: map['name'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
```

### 2. Tạo Service
```dart
class NewFeatureService {
  Future<List<NewFeatureModel>> getAllFeatures() async {
    final db = await _databaseService.database;
    final maps = await db.query('features');
    return maps.map((map) => NewFeatureModel.fromMap(map)).toList();
  }
}
```

### 3. Tạo Repository
```dart
class NewFeatureRepository {
  final NewFeatureService _service = NewFeatureService();

  Future<List<NewFeatureModel>> getAllFeatures() async {
    return await _service.getAllFeatures();
  }
}
```

### 4. Tạo ViewModel
```dart
class NewFeatureProvider extends ChangeNotifier {
  final NewFeatureRepository _repository = NewFeatureRepository();

  List<NewFeatureModel> _features = [];
  bool _isLoading = false;

  List<NewFeatureModel> get features => _features;
  bool get isLoading => _isLoading;

  Future<void> loadFeatures() async {
    _isLoading = true;
    notifyListeners();

    try {
      _features = await _repository.getAllFeatures();
    } catch (e) {
      debugPrint('Error loading features: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 5. Tạo View
```dart
class NewFeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Features')),
      body: Consumer<NewFeatureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.features.length,
            itemBuilder: (context, index) {
              final feature = provider.features[index];
              return ListTile(title: Text(feature.name));
            },
          );
        },
      ),
    );
  }
}
```

## Deployment

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Troubleshooting

### Common Issues

1. **Database not initialized**
   - Đảm bảo gọi `initializeAuthTables()` trước khi sử dụng auth

2. **Provider not found**
   - Kiểm tra MultiProvider setup trong main.dart

3. **Hot reload not working**
   - Restart app hoặc check for syntax errors

4. **Tests failing**
   - Đảm bảo database được reset giữa các test
   - Sử dụng in-memory database cho testing

## Testing

### Test Structure

```
test/
├── models/              # Unit tests for models
├── services/           # Unit tests for services
├── repositories/       # Unit tests for repositories
├── viewmodels/         # Unit tests for viewmodels
├── screens/            # Widget tests for screens
└── widgets/            # Widget tests for widgets

integration_test/       # Integration tests (root level)
├── auth_flow_test.dart
├── note_management_test.dart
├── performance_test.dart
└── README.md
```

### Chạy kiểm thử

#### Kiểm thử đơn vị & Kiểm thử Widget
```bash
# Chạy tất cả các bài kiểm thử
flutter test

# Chạy tệp kiểm thử cụ thể
flutter test test/models/note_model_test.dart

# Chạy với độ phủ mã
flutter test --coverage
```

#### Kiểm thử tích hợp
```bash
# Chạy tất cả các bài kiểm thử tích hợp
flutter test integration_test/

# Chạy bài kiểm thử tích hợp cụ thể
flutter test integration_test/auth_flow_test.dart

# Chạy trên thiết bị cụ thể
flutter test integration_test/ -d <device-id>
```

### Viết bài kiểm thử

#### Kiểm thử đơn vị
- Kiểm thử logic nghiệp vụ trong các service, repository, viewmodel
- Sử dụng mockito để tạo các dependency
- Tập trung vào các chức năng riêng biệt

#### Kiểm thử Widget
- Kiểm thử các thành phần giao diện người dùng và tương tác
- Sử dụng `WidgetTester` để mô phỏng hành động của người dùng
- Xác minh các thay đổi trạng thái giao diện người dùng

#### Kiểm thử tích hợp
- Kiểm thử toàn bộ luồng người dùng Kiểm thử từ đầu đến cuối
- Yêu cầu thiết bị/trình giả lập thực tế
- Xác minh ứng dụng hoạt động chính xác trong môi trường thực

### Các phương pháp kiểm thử tốt nhất

1. **Mẫu Arrange-Act-Assert**
2. **Tên kiểm thử mô tả rõ ràng**
3. **Một khẳng định cho mỗi kiểm thử nếu có thể**
4. **Mô phỏng các phụ thuộc bên ngoài**
5. **Dọn dẹp sau khi kiểm thử**
6. **Kiểm thử các trường hợp ngoại lệ và kịch bản lỗi**

## Hướng dẫn đóng góp

1. Tạo issue trước khi triển khai tính năng
2. Tuân thủ các tiêu chuẩn mã hóa
3. Viết kiểm thử cho mã mới
4. Cập nhật tài liệu
5. Tạo pull request với mô tả chi tiết

