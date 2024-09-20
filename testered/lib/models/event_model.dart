import 'package:hive/hive.dart';

part 'event_model.g.dart';  // Required for Hive type adapter generation

@HiveType(typeId: 1)  // Assign a unique typeId for the Event model
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final List<String> requiredSkills;

  @HiveField(5)
  final String urgency;

  @HiveField(6)
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