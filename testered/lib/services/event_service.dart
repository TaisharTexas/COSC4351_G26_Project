import '../models/event_model.dart';

class EventService {
  final List<Event> _events = [];

  void createEvent(Event event) {
    _events.add(event);
  }

  List<Event> getAllEvents() {
    return _events;
  }

  List<Event> getMatchingEvents(List<String> skills) {
    return _events.where((event) => event.requiredSkills.any((skill) => skills.contains(skill))).toList();
  }
}