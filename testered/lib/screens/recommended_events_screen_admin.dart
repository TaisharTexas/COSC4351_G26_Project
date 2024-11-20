import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/custom_nav_bar.dart';
import '../models/user_model.dart';  // Assuming you have user_model.dart
import '../models/event_model.dart';  // Assuming you have event_model.dart
import '../services/db_helper.dart';
import '../services/user_provider.dart';

class RecommendedEventsAdmin extends StatefulWidget {
  @override
  _RecommendedEventsAdminState createState() => _RecommendedEventsAdminState();
}

class _RecommendedEventsAdminState extends State<RecommendedEventsAdmin> {
  List<User> volunteers = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _loadVolunteersAndEvents();
  }

  Future<void> _loadVolunteersAndEvents() async {
    // Load volunteers and events from the database
    final loadedVolunteers = DBHelper().getAllUsers();
    final loadedEvents = DBHelper().getAllEvents();

    setState(() {
      volunteers = loadedVolunteers;
      events = loadedEvents;
    });
  }

  // Find events matching volunteer skills
  List<Event> _findMatchingEvents(User volunteer) {
    return events.where((event) {
      // Check if the event's requiredSkills contain any of the volunteer's skills
      return event.requiredSkills.any((skill) => volunteer.skills.contains(skill));
    }).toList();
  }

  // Check if the volunteer is assigned to the event
  bool _isAssignedToEvent(Event event, User volunteer) {
    return event.assignedVolunteers.contains(volunteer.email);
  }

  // Toggle the assignment of the volunteer to the event
  Future<void> _toggleAssignment(Event event, User volunteer, bool isAssigned) async {
    setState(() {
      if (isAssigned) {
        // Unassign the volunteer from the event
        event.assignedVolunteers.remove(volunteer.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${volunteer.fullName} unassigned from ${event.name}')),
        );
      } else {
        // Assign the volunteer to the event
        event.assignedVolunteers.add(volunteer.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${volunteer.fullName} assigned to ${event.name}')),
        );
      }
    });
    await DBHelper().updateEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;
    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: volunteers.isEmpty
          ? Center(child: Text('No volunteers available.'))
          : ListView.builder(
        itemCount: volunteers.length,
        itemBuilder: (context, index) {
          final volunteer = volunteers[index];
          final matchingEvents = _findMatchingEvents(volunteer);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display volunteer details
                  Text(
                    '${volunteer.fullName} (${volunteer.email})',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Skills: ${volunteer.skills.join(', ')}'),

                  SizedBox(height: 10),

                  // Display matching events
                  if (matchingEvents.isNotEmpty) ...[
                    Text('Matching Events:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: matchingEvents.map((event) {
                        final isAssigned = _isAssignedToEvent(event, volunteer);

                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('${event.name} (${event.urgency})'),
                              ),
                              SizedBox(width: 5), // Spacing between text and checkbox
                              Checkbox(
                                value: isAssigned,
                                onChanged: (bool? value) {
                                  _toggleAssignment(event, volunteer, isAssigned);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ] else
                    Text('No matching events.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}