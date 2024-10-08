import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';  // Assuming you have user_model.dart
import '../models/event_model.dart';  // Assuming you have event_model.dart
import '../services/db_helper.dart';
import '../services/user_provider.dart';  // Assuming you have db_helper.dart

class VolunteerDisplayScreen extends StatefulWidget {
  @override
  _VolunteerDisplayScreenState createState() => _VolunteerDisplayScreenState();
}

class _VolunteerDisplayScreenState extends State<VolunteerDisplayScreen> {
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

  // Get event details based on event ID
    Event _getEventById(String eventId) {
      return events.firstWhere(
            (event) => event.id == eventId,
        orElse: () => Event(
          id: 'N/A',
          name: 'Event not found',
          description: '',
          location: '',
          address: '',
          requiredSkills: [],
          urgency: 'N/A',
          eventDate: DateTime.now(),
          assignedVolunteers: [],
        ),
      );
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

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display volunteer details
                  Text(
                    '${volunteer.fullName} (${volunteer.email})',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Skills: ${volunteer.skills.join(', ')}'),
                  Text('Preferences: ${volunteer.preferences}'),

                  SizedBox(height: 10),

                  // Display past events
                  if (volunteer.pastEvents.isNotEmpty) ...[
                    Text('Past Events:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: volunteer.pastEvents.map((eventId) {
                        final event = _getEventById(eventId);
                        if (event != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                                '- ${event.name} (Date: ${event.eventDate.toLocal().toString().split(' ')[0]})'),
                          );
                        } else {
                          return Text('- Event not found (ID: $eventId)');
                        }
                      }).toList(),
                    ),
                  ] else
                    Text('No past events.'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}