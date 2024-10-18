import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:testered/services/db_helper.dart';
class NotificationProvider with ChangeNotifier {
  List<Event> _notifications = [];

  List<Event> get notifications => _notifications;

  // Load notifications asynchronously
  Future<void> loadNotifications(String userEmail) async {
    _notifications = await _fetchUpcomingEvents(userEmail);
    notifyListeners();
  }

  // Fetch upcoming events from DB
  Future<List<Event>> _fetchUpcomingEvents(String userEmail) async {
    final DBHelper dbHelper = DBHelper();
    final now = DateTime.now();

    // Fetch events from the database
    final events = await dbHelper.getAllEvents();
    return events.where((event) {
      bool isUpcoming = event.eventDate.isAfter(now) &&
          event.eventDate.isBefore(now.add(Duration(days: 5)));
      bool isUserAssigned = event.assignedVolunteers.contains(userEmail);
      return isUpcoming && isUserAssigned;
    }).toList();
  }

  void removeNotification(Event event) {
    _notifications.remove(event);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void debugNotifs(){
    for(Event v in notifications){
      print("${v.name} added to notifs");
    }
  }
}

