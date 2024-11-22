import 'package:flutter_test/flutter_test.dart';
import 'package:testered/models/user_model.dart';

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

    test('User initialization with all fields', () {
      final user = User(
        email: 'jane.doe@example.com',
        password: 'anotherPassword123',
        fullName: 'Jane Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'Metropolis',
        state: 'NY',
        zipCode: '12345',
        skills: ['Dart', 'Flutter'],
        preferences: 'No preference',
        availability: [DateTime(2024, 11, 20)],
        pastEvents: ['event1'],
        isAdmin: true,
      );

      expect(user.fullName, 'Jane Doe');
      expect(user.address1, '123 Main St');
      expect(user.skills, contains('Flutter'));
      expect(user.isAdmin, true);
    });

    test('User update fields', () {
      final user = User(
        email: 'john.smith@example.com',
        password: 'password123',
      );

      user.fullName = 'John Smith';
      user.address1 = '456 Elm St';

      // Create a modifiable copy of the skills list
      final modifiableSkills = List<String>.from(user.skills);
      modifiableSkills.add('Java');
      
      // Assign the modified skills list back to the user
      user.skills = modifiableSkills;

      expect(user.fullName, 'John Smith');
      expect(user.address1, '456 Elm St');
      expect(user.skills, contains('Java'));
    });
  });
}
