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