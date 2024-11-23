import 'package:flutter_test/flutter_test.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String location;
  final List<String> requiredSkills;
  final String urgency;
  final DateTime eventDate;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.requiredSkills,
    required this.urgency,
    required this.eventDate,
  });
}

void main() {
  group('Event Class Tests', () {
    test('should create an Event instance with correct values', () {
      // Arrange
      const String id = '123';
      const String name = 'Sample Event';
      const String description = 'This is a test event.';
      const String location = 'New York';
      const List<String> requiredSkills = ['Coding', 'Design'];
      const String urgency = 'High';
      final DateTime eventDate = DateTime(2024, 12, 31);

      // Act
      final event = Event(
        id: id,
        name: name,
        description: description,
        location: location,
        requiredSkills: requiredSkills,
        urgency: urgency,
        eventDate: eventDate,
      );

      // Assert
      expect(event.id, id);
      expect(event.name, name);
      expect(event.description, description);
      expect(event.location, location);
      expect(event.requiredSkills, requiredSkills);
      expect(event.urgency, urgency);
      expect(event.eventDate, eventDate);
    });
  });
}
