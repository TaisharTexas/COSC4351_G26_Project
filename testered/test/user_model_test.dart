import 'package:flutter_test/flutter_test.dart';
import 'package:testered/lib/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('User initialization with required fields', () {
      final user = User(
        email: 'john.doe@example.com',
        password: 'securePassword123',
      );

      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'securePassword123');
      expect(user.fullName, '');
      expect(user.isAdmin, false);
    });
  });
}
