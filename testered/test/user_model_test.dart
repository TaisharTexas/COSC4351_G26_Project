import 'package:test/test.dart';
import 'package:testered/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('User objects should be equal if all fields match', () {
      final user1 = User(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'John Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'Cityville',
        state: 'State',
        zipCode: '12345',
        skills: ['Flutter', 'Dart'],
        preferences: 'Preference text',
        availability: [DateTime(2024, 1, 1)],
        pastEvents: ['Event1', 'Event2'],
      );

      final user2 = User(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'John Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'Cityville',
        state: 'State',
        zipCode: '12345',
        skills: ['Flutter', 'Dart'],
        preferences: 'Preference text',
        availability: [DateTime(2024, 1, 1)],
        pastEvents: ['Event1', 'Event2'],
      );

      expect(user1, equals(user2));  // Check if both users are equal
    });

    test('User skills and events can be updated', () {
      final user = User(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'John Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'Cityville',
        state: 'State',
        zipCode: '12345',
        skills: ['Flutter', 'Dart'],
        preferences: 'Preference text',
        availability: [DateTime(2024, 1, 1)],
        pastEvents: ['Event1', 'Event2'],
      );

      // Updating skills and events
      user.skills.add('Java');
      user.pastEvents.add('Event3');

      // Since the `skills` and `pastEvents` lists are modifiable,
      // let's check if they have been updated correctly
      expect(user.skills, contains('Java'));
      expect(user.pastEvents, contains('Event3'));
    });

    test('User skills and events are immutable when the list is unmodifiable', () {
      final user = User(
        email: 'test@example.com',
        password: 'password123',
        fullName: 'John Doe',
        address1: '123 Main St',
        address2: 'Apt 4B',
        city: 'Cityville',
        state: 'State',
        zipCode: '12345',
        skills: List.unmodifiable(['Flutter', 'Dart']),
        preferences: 'Preference text',
        availability: [DateTime(2024, 1, 1)],
        pastEvents: List.unmodifiable(['Event1', 'Event2']),
      );

      // Trying to modify an unmodifiable list
      expect(() => user.skills.add('Java'), throwsA(isA<UnsupportedError>()));
      expect(() => user.pastEvents.add('Event3'), throwsA(isA<UnsupportedError>()));
    });
  });
}
