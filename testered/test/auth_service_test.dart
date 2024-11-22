import 'package:flutter_test/flutter_test.dart';
import 'package:testered/services/auth_service.dart';
import 'package:testered/models/user_model.dart';
import 'package:mockito/mockito.dart';

// Mock DBHelper
class MockDBHelper extends Mock {
  User? getUser(String email, String password);
  Future<void> insertUser(User user);
  User? getUserByEmail(String email);
}

void main() {
  group('AuthService Tests', () {
    final mockDBHelper = MockDBHelper();
    final authService = AuthService();

    test('User login success', () async {
      when(mockDBHelper.getUser('john.doe@example.com', 'password123'))
          .thenReturn(User(email: 'john.doe@example.com', password: 'password123'));

      final user = await authService.login('john.doe@example.com', 'password123');
      expect(user, isNotNull);
      expect(user?.email, 'john.doe@example.com');
    });

    test('User login failure', () async {
      when(mockDBHelper.getUser('invalid@example.com', 'wrongPassword')).thenReturn(null);

      final user = await authService.login('invalid@example.com', 'wrongPassword');
      expect(user, isNull);
    });

    test('Register new user', () async {
      when(mockDBHelper.getUserByEmail('new.user@example.com')).thenReturn(null);

      final result = await authService.registerUser('new.user@example.com', 'newPassword123');
      expect(result, true);
    });
  });
}
