import 'package:hive/hive.dart';

part 'event_model.g.dart';  // Required for Hive type adapter generation

@HiveType(typeId: 1)  // Assign a unique typeId for the Event model
class Event {
  @HiveField(0)
  final String id;

  @HiveField(1)
  late final String name;

  @HiveField(2)
  late final String description;

  @HiveField(3)
  late final String location;

  @HiveField(4)
  late final String address;

  @HiveField(5)
  late final List<String> requiredSkills;

  @HiveField(6)
  late final String urgency;

  @HiveField(7)
  late final DateTime eventDate;

  @HiveField(8)
  List<String> assignedVolunteers;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.requiredSkills,
    required this.urgency,
    required this.eventDate,
    this.assignedVolunteers = const [],
  });
}