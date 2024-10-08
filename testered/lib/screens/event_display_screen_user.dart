import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../services/db_helper.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';
import '../services/user_provider.dart';

class EventDisplayScreenUser extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventDisplayScreenUser> {
  List<Event> events = [];
  List<User> volunteers = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadVolunteers();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = DBHelper().getAllEvents();
    setState(() {
      events = loadedEvents;
    });
  }

  Future<void> _loadVolunteers() async {
    final loadedVolunteers = DBHelper().getAllUsers(); // Assuming this method exists to get all users
    setState(() {
      volunteers = loadedVolunteers;
    });
  }

  Future<void> _assignVolunteersToEvent(String eventId, List<String> assignedVolunteers) async {
    final event = DBHelper().getEventById(eventId);
    if (event != null) {
      event.assignedVolunteers = assignedVolunteers;
      await DBHelper().updateEvent(event);  // Assuming you have an updateEvent method in DBHelper
      _loadEvents();  // Refresh the event list after assignment

      // Display success message with SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Volunteers updated successfully for ${event.name}!')),
      );
    }
  }

  void _showAssignVolunteersDialog(Event event) {
    final userEmail = Provider.of<UserProvider>(context, listen: false).email;
    List<String> selectedVolunteers = List.from(event.assignedVolunteers);  // Copy to avoid mutating directly
    bool isUserAssigned = selectedVolunteers.contains(userEmail);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(  // Use StatefulBuilder to manage dialog state
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("Assign Yourself to ${event.name}"),
              content: CheckboxListTile(
                title: Text(userEmail),
                value: isUserAssigned,
                onChanged: (bool? value) {
                  setStateDialog(() {
                    if (value == true) {
                      selectedVolunteers.add(userEmail);  // Add user to selected volunteers
                    } else {
                      selectedVolunteers.remove(userEmail);  // Remove user from selected volunteers
                    }
                    isUserAssigned = value ?? false;  // Update state
                  });
                },
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();  // Close the dialog without saving
                  },
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () async {
                    await _assignVolunteersToEvent(event.id, selectedVolunteers);  // Save the selected volunteers
                    Navigator.of(context).pop();  // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;
    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: events.isEmpty
          ? Center(child: Text('No events available.'))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          List<String> selectedVolunteers = event.assignedVolunteers;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),  // Add padding to each card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          event.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,  // Ensure title does not overflow
                        ),
                      ),
                      Text(
                        DateFormat('MM/dd/yyyy').format(event.eventDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  // Location and Address
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location: ${event.location}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Address: ${event.address}',  // Display address here
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // Skills
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Skills: ${event.requiredSkills.join(', ')}',
                      overflow: TextOverflow.ellipsis,  // Ensure skills don't overflow
                      maxLines: 1,
                    ),
                  ),

                  // Assigned Volunteers (Display list of assigned volunteers)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Assigned Volunteers: ${selectedVolunteers.join(', ')}',
                      overflow: TextOverflow.ellipsis,  // Ensure text doesn't overflow
                      maxLines: 1,
                    ),
                  ),

                  // Urgency and Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Urgency: ${event.urgency}',
                        style: TextStyle(color: Colors.red),
                      ),

                      // Action Buttons (Assign Volunteers)
                      IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () {
                          _showAssignVolunteersDialog(event);  // Show dialog to assign volunteers
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