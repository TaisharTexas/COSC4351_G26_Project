import 'package:flutter_test/flutter_test.dart';
import 'package:testered/models/event_model.dart';

void main() {
  group('Event Model Tests', () {
    test('Event initialization with required fields', () {
      final event = Event(
        id: 'event1',
        name: 'Community Cleanup',
        description: 'Help clean up the local park',
        location: 'Central Park',
        address: '123 Park Ave',
        requiredSkills: ['Cleaning'],
        urgency: 'High',
        eventDate: DateTime(2024, 11, 25),
      );

      expect(event.name, 'Community Cleanup');
      expect(event.urgency, 'High');
      expect(event.assignedVolunteers, isEmpty);
    });

    test('Add volunteers to event', () {
      final event = Event(
        id: 'event2',
        name: 'Food Drive',
        description: 'Collect food donations',
        location: 'Community Center',
        address: '456 Main St',
        requiredSkills: ['Organizing'],
        urgency: 'Medium',
        eventDate: DateTime(2024, 11, 30),
      );

      event.assignedVolunteers.add('volunteer1@example.com');
      event.assignedVolunteers.add('volunteer2@example.com');

      expect(event.assignedVolunteers, contains('volunteer1@example.com'));
      expect(event.assignedVolunteers.length, 2);
    });
  });
}
