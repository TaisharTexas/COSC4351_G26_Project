import 'package:flutter_test/flutter_test.dart';
import 'package:testered/services/auth_service.dart';
import 'package:testered/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:testered/services/db_helper.dart';

class MockDBHelper extends Mock implements DBHelper {}

void main() {
  group('AuthService Tests', () {
    final mockDBHelper = MockDBHelper();
    final authService = AuthService(dbHelper: mockDBHelper);

    test('User login success', () async {
      when(mockDBHelper.getUser('john.doe@example.com', 'password123'))
          .thenAnswer((_) async => User(email: 'john.doe@example.com', password: 'password123'));

      final user = await authService.login('john.doe@example.com', 'password123');

      expect(user, isNotNull);
      expect(user?.email, 'john.doe@example.com');
    });

    test('User login failure', () async {
      when(mockDBHelper.getUser('invalid@example.com', 'wrongPassword'))
          .thenAnswer((_) async => null);

      final user = await authService.login('invalid@example.com', 'wrongPassword');

      expect(user, isNull);
    });

    test('Register new user', () async {
      when(mockDBHelper.getUserByEmail('new.user@example.com'))
          .thenAnswer((_) async => null);

      final result = await authService.registerUser('new.user@example.com', 'newPassword123');

      expect(result, true);
      verify(mockDBHelper.insertUser(any)).called(1);
    });
  });
}
