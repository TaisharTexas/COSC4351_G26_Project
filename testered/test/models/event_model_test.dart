import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:testered/models/event_model.dart';

// You can create a Mock class if necessary, but for this case we can directly use the Directory path.
class MockPathProvider {
  Future<Directory> getApplicationDocumentsDirectory() async {
    return Directory('/fake/path');
  }
}

void main() async {
  // Ensure Flutter binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the path provider
  final mockPathProvider = MockPathProvider();

  // Setup Hive for tests
  setUpAll(() async {
    // Initialize Hive
    final dir = await mockPathProvider.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(EventAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('Event Model Tests', () {
    test('Event object should be created with correct properties', () {
      final event = Event(
        id: '1',
        name: 'Volunteer Cleanup',
        description: 'A community cleanup event',
        location: 'Community Park',
        requiredSkills: ['Teamwork', 'Endurance'],
        urgency: 'High',
        eventDate: DateTime(2024, 12, 25),
        assignedVolunteers: ['volunteer1', 'volunteer2'],
      );

      expect(event.id, '1');
      expect(event.name, 'Volunteer Cleanup');
      expect(event.description, 'A community cleanup event');
      expect(event.location, 'Community Park');
      expect(event.requiredSkills, ['Teamwork', 'Endurance']);
      expect(event.urgency, 'High');
      expect(event.eventDate, DateTime(2024, 12, 25));
      expect(event.assignedVolunteers, ['volunteer1', 'volunteer2']);
    });

    test('Event should be saved and retrieved correctly from Hive', () async {
      final box = await Hive.openBox<Event>('eventBox');

      final event = Event(
        id: '2',
        name: 'Tree Planting',
        description: 'Plant trees in the community park',
        location: 'Community Park',
        requiredSkills: ['Gardening', 'Teamwork'],
        urgency: 'Medium',
        eventDate: DateTime(2025, 5, 15),
        assignedVolunteers: ['volunteer3'],
      );

      await box.put(event.id, event);

      final retrievedEvent = box.get(event.id);

      expect(retrievedEvent, isNotNull);
      expect(retrievedEvent?.id, '2');
      expect(retrievedEvent?.name, 'Tree Planting');
      expect(retrievedEvent?.description, 'Plant trees in the community park');
      expect(retrievedEvent?.location, 'Community Park');
      expect(retrievedEvent?.requiredSkills, ['Gardening', 'Teamwork']);
      expect(retrievedEvent?.urgency, 'Medium');
      expect(retrievedEvent?.eventDate, DateTime(2025, 5, 15));
      expect(retrievedEvent?.assignedVolunteers, ['volunteer3']);

      await box.delete(event.id);
      await box.close();
    });
  });
}
