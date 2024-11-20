import 'package:test/test.dart';
import 'package:testered/models/user_model.dart'; // Corrected import path

void main() {
  group('User Model Tests', () {
    test('User initialization with required fields', () {
      final user = User(
        email: 'john.doe@example.com',
        password: 'securePassword123',
      );

      expect(user.email, 'john.doe@example.com');
      expect(user.password, 'securePassword123');
      expect(user.fullName, ''); // Default value
      expect(user.isAdmin, false); // Default value
    });

    test('User initialization with all fields', () {
      final user = User(
        email: 'jane.doe@example.com',
        password: 'anotherSecurePassword',
        fullName: 'Jane Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        skills: ['Programming', 'Design'],
        preferences: 'Remote work',
        availability: [DateTime(2024, 11, 20)],
        pastEvents: ['Event1', 'Event2'],
        isAdmin: true,
      );

      expect(user.fullName, 'Jane Doe');
      expect(user.address1, '123 Main St');
      expect(user.skills, contains('Programming'));
      expect(user.isAdmin, true);
      expect(user.availability.first, DateTime(2024, 11, 20));
    });
  });
}
