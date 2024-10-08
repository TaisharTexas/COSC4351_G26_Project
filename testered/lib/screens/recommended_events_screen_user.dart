import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';  // Assuming you have user_model.dart
import '../models/event_model.dart';  // Assuming you have event_model.dart
import '../services/db_helper.dart';
import '../services/user_provider.dart';

class RecommendedEventsUser extends StatefulWidget {
  @override
  _RecommendedEventsUserState createState() => _RecommendedEventsUserState();
}

class _RecommendedEventsUserState extends State<RecommendedEventsUser> {
  User? loggedInUser;
  List<Event> events = [];
  List<Event> matchingEvents = [];

  @override
  void initState() {
    super.initState();
    _loadUserAndEvents();
  }

  Future<void> _loadUserAndEvents() async {
    // Load the logged-in user's details and all events from the database
    final email = Provider.of<UserProvider>(context, listen: false).email;
    final loadedUser = await DBHelper().getUserByEmail(email);  // Assuming you have this method in DBHelper
    final loadedEvents = await DBHelper().getAllEvents();

    if (loadedUser != null) {
      setState(() {
        loggedInUser = loadedUser;
        events = loadedEvents;
        matchingEvents = _findMatchingEvents(loggedInUser!);
      });
    }
  }

  // Find events matching the logged-in user's skills
  List<Event> _findMatchingEvents(User user) {
    return events.where((event) {
      // Check if the event's requiredSkills contain any of the user's skills
      return event.requiredSkills.any((skill) => user.skills.contains(skill));
    }).toList();
  }

  // Check if the user is assigned to the event
  bool _isAssignedToEvent(Event event) {
    return event.assignedVolunteers.contains(loggedInUser!.email);
  }

  // Toggle the assignment of the user to the event
  Future<void> _toggleAssignment(Event event, bool isAssigned) async {
    setState(() {
      if (isAssigned) {
        // Unassign the user from the event
        event.assignedVolunteers.remove(loggedInUser!.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loggedInUser!.fullName} unassigned from ${event.name}')),
        );
      } else {
        // Assign the user to the event
        event.assignedVolunteers.add(loggedInUser!.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loggedInUser!.fullName} assigned to ${event.name}')),
        );
      }
    });
    await DBHelper().updateEvent(event);  // Assuming you have this method in DBHelper
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;

    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: loggedInUser == null
          ? Center(child: CircularProgressIndicator())
          : matchingEvents.isEmpty
          ? Center(child: Text('No matching events available.'))
          : ListView.builder(
        itemCount: matchingEvents.length,
        itemBuilder: (context, index) {
          final event = matchingEvents[index];
          final isAssigned = _isAssignedToEvent(event);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event details
                  Text(
                    '${event.name}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Urgency: ${event.urgency}'),
                  Text('Skills required: ${event.requiredSkills.join(', ')}'),

                  // Toggle Assignment Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAssigned ? 'You are assigned to this event' : 'Assign yourself to this event'),
                      Checkbox(
                        value: isAssigned,
                        onChanged: (bool? value) {
                          _toggleAssignment(event, isAssigned);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}