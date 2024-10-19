import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import the intl package here
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../services/db_helper.dart';
import '../services/user_provider.dart';

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
    final loadedVolunteers = await DBHelper().getAllUsers();
    final loadedEvents = await DBHelper().getAllEvents();

    setState(() {
      volunteers = loadedVolunteers;
      events = loadedEvents;
    });
  }

  Event _getEventById(String eventId) {
    return events.firstWhere(
          (event) => event.id == eventId,
      orElse: () => Event(
        id: 'N/A',
        name: 'Event not found',
        description: '',
        location: '',
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

          return VolunteerCard(volunteer: volunteer, getEventById: _getEventById);
        },
      ),
    );
  }
}

class VolunteerCard extends StatelessWidget {
  final User volunteer;
  final Function(String) getEventById;

  const VolunteerCard({
    Key? key,
    required this.volunteer,
    required this.getEventById,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${volunteer.fullName} (${volunteer.email})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Skills: ${volunteer.skills.join(', ')}'),
            SizedBox(height: 4),
            Text('Preferences: ${volunteer.preferences}'),

            SizedBox(height: 10),

            if (volunteer.pastEvents.isNotEmpty) ...[
              Text('Past Events:', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: volunteer.pastEvents.map((eventId) {
                  final event = getEventById(eventId);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '- ${event.name} (Date: ${DateFormat('MM/dd/yyyy').format(event.eventDate)})',
                    ),
                  );
                }).toList(),
              ),
            ] else
              Text('No past events.'),
          ],
        ),
      ),
    );
  }
}
