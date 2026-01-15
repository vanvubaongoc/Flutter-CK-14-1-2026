# Note App 📝

Một ứng dụng ghi chú cá nhân được xây dựng bằng Flutter, sử dụng kiến trúc MVVM với Provider để quản lý trạng thái.

## ✨ Tính năng

- 🔐 **Đăng ký/Đăng nhập**: Xác thực người dùng với hash mật khẩu SHA256
- 📝 **Quản lý ghi chú**: Tạo, đọc, cập nhật, xóa ghi chú
- 🏷️ **Phân loại theo tag**: Gán tag cho ghi chú để dễ quản lý
- 🔍 **Tìm kiếm**: Tìm kiếm ghi chú theo từ khóa
- 📱 **Giao diện Material Design**: UI/UX hiện đại và thân thiện
- 💾 **Lưu trữ cục bộ**: Sử dụng SQLite để lưu trữ dữ liệu

## 🏗️ Kiến trúc

Dự án sử dụng kiến trúc **MVVM (Model-View-ViewModel)** với các tầng:

```
lib/
├── models/          # Định nghĩa dữ liệu (NoteModel, UserModel)
├── repositories/    # Tầng trung gian (NoteRepository, AuthRepository)
├── services/        # Logic nghiệp vụ (DatabaseService, AuthService)
├── viewmodels/      # Quản lý trạng thái (NoteProvider, AuthProvider)
├── views/screens/   # Giao diện người dùng
├── constants/       # Hằng số và cấu hình
├── utils/           # Các tiện ích
└── animations/      # Hiệu ứng chuyển động
```

## 🚀 Cài đặt và chạy

### Yêu cầu hệ thống
- Flutter SDK >= 3.4.4
- Dart SDK >= 3.4.4
- Android Studio / VS Code với Flutter extension

### Các bước cài đặt

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd note_app
   ```

2. **Cài đặt dependencies**
   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng**
   ```bash
   # Chạy trên Android emulator/device
   flutter run

   # Chạy trên iOS simulator (chỉ trên macOS)
   flutter run -d ios

   # Chạy trên web
   flutter run -d chrome

   # Chạy trên Windows desktop
   flutter run -d windows
   ```

### Chạy tests

```bash
# Chạy tất cả tests
flutter test

# Chạy tests với coverage
flutter test --coverage

# Chạy tests cho file cụ thể
flutter test test/models/note_model_test.dart
```

## 📱 Screenshots

*(Thêm screenshots của ứng dụng ở đây)*

## 🛠️ Công nghệ sử dụng

- **Framework**: Flutter
- **State Management**: Provider (MVVM)
- **Database**: SQLite (sqflite)
- **Authentication**: SharedPreferences + SHA256 hashing
- **UI**: Material Design 3
- **Testing**: flutter_test, mockito

## 📋 API Documentation

### Models

#### NoteModel
```dart
class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String? tag;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Methods: toMap(), fromMap(), copyWith()
}
```

#### UserModel
```dart
class UserModel {
  final int? id;
  final String username;
  final String email;
  final String password; // Hashed
  final DateTime createdAt;

  // Methods: toMap(), fromMap(), copyWith()
}
```

### Services

#### DatabaseService
- `insertNote(NoteModel note)`: Thêm ghi chú mới
- `getAllNotes()`: Lấy tất cả ghi chú
- `getNoteById(int id)`: Lấy ghi chú theo ID
- `updateNote(NoteModel note)`: Cập nhật ghi chú
- `deleteNote(int id)`: Xóa ghi chú
- `searchNotes(String keyword)`: Tìm kiếm ghi chú
- `getNotesByTag(String tag)`: Lọc ghi chú theo tag

#### AuthService
- `register(...)`: Đăng ký tài khoản mới
- `login(...)`: Đăng nhập
- `getUserById(int id)`: Lấy thông tin user

## 🤝 Đóng góp

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👥 Nhóm phát triển

- **Danh** (Nhóm trưởng): Authentication System
- **Đại**: Note Management (CRUD)
- **Khanh**: UI/UX Design
- **Bao**: Database Integration
- **Ngoc**: Testing & Documentation



