import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../services/db_helper.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';
import '../services/user_provider.dart';
import '../services/user_service.dart';
import 'package:testered/services/notification_provider.dart';

class EventDisplayScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventDisplayScreen> {
  List<Event> events = [];
  List<User> volunteers = [];

  void initState() {
    super.initState();
    _loadVolunteers();
    context.read<NotificationProvider>();
  }

  int calculateMatchScore(User? user, Event event) { //Used for finding what the cur user is good at 
    int score = 0;
    for (String skill in user!.skills) {
      if (event.requiredSkills.contains(skill)) {
        score++;  // Increment score for each matching skill
      }
    }

    return score;
  }

  void sortEventsBySkillMatch(User? user, List<Event> events) {
    events.sort((a, b) {
      int scoreA = calculateMatchScore(user, a);
      int scoreB = calculateMatchScore(user, b);
      
      return scoreB.compareTo(scoreA);  // Sort in descending order (best match first)
    });
  }

  Future<void> _loadEvents() async {
    final loadedEvents = DBHelper().getAllEvents();
    UserService userService = UserService();
    final User? currentUser = userService.getUserByEmail(Provider.of<UserProvider>(context).email);

    setState(() {
      events = loadedEvents;
      sortEventsBySkillMatch(currentUser, events);
    });
  }

  Future<void> _loadVolunteers() async {
    final loadedVolunteers = DBHelper().getAllUsers(); // Assuming this method exists to get all users
    setState(() {
      volunteers = loadedVolunteers;
    });
  }

  Future<void> _deleteEvent(String eventId) async {
    await DBHelper().deleteEvent(eventId);
    _loadEvents();  // Refresh the event list after deletion
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


  
  // Show a dialog with checkboxes for assigning volunteers
  void _showAssignVolunteersDialog(Event event) {
    List<String> selectedVolunteers = List.from(event.assignedVolunteers);  // Make a copy to avoid mutating directly

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(  // Use StatefulBuilder to manage dialog state
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text("Assign Volunteers"),
              content: SingleChildScrollView(
                child: Column(
                  children: volunteers.map((User volunteer) {
                    return CheckboxListTile(
                      title: Text(volunteer.fullName),
                      value: selectedVolunteers.contains(volunteer.email),
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            selectedVolunteers.add(volunteer.email);
                          } else {
                            selectedVolunteers.remove(volunteer.email);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
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
                    await _assignVolunteersToEvent(event.id, selectedVolunteers);  // Save the assigned volunteers
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
void _showEditEventDialog(Event event) {
  // Controllers for editing event fields
  TextEditingController nameController = TextEditingController(text: event.name);
  TextEditingController descriptionController = TextEditingController(text: event.description);
  TextEditingController locationController = TextEditingController(text: event.location);
  TextEditingController addressController = TextEditingController(text: event.address);
  TextEditingController urgencyController = TextEditingController(text: event.urgency);
  TextEditingController skillsController = TextEditingController(text: event.requiredSkills.join(', ')); // Convert list to comma-separated string
  DateTime selectedDate = event.eventDate;

  // Show dialog to edit the event
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialog) {
          return AlertDialog(
            title: Text("Edit Event Details"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Event Name
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Event Name'),
                  ),
                  SizedBox(height: 10),

                  // Event Description
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 10),

                  // Event Location
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  SizedBox(height: 10),

                  // Event Address
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  SizedBox(height: 10),

                  // Event Urgency
                  TextField(
                    controller: urgencyController,
                    decoration: InputDecoration(labelText: 'Urgency'),
                  ),
                  SizedBox(height: 10),

                  // Required Skills
                  TextField(
                    controller: skillsController,
                    decoration: InputDecoration(labelText: 'Required Skills (comma-separated)'),
                  ),
                  SizedBox(height: 10),

                  // Event Date Picker
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != selectedDate) {
                        setStateDialog(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      'Event Date: ${DateFormat('MM/dd/yyyy').format(selectedDate)}',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog without saving
                },
              ),
              TextButton(
                child: Text("Save"),
                onPressed: () async {
                  // Create a new event object with updated details
                  Event updatedEvent = Event(
                    id: event.id,  // Retain the original event ID
                    name: nameController.text,
                    description: descriptionController.text,
                    location: locationController.text,
                    address: addressController.text,
                    urgency: urgencyController.text,
                    requiredSkills: skillsController.text.split(',').map((e) => e.trim()).toList(), // Convert back to List
                    eventDate: selectedDate,
                    assignedVolunteers: event.assignedVolunteers,  // Retain the assigned volunteers
                  );

                  // Overwrite the event in the database
                  await DBHelper().updateEvent(updatedEvent);

                  // Refresh the events list after updating
                  setState(() {
                    _loadEvents();
                  });

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Event updated successfully!')),
                  );
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
    bool loggedIn = Provider.of<UserProvider>(context, listen: false).loggedIn;
    int accType = Provider.of<UserProvider>(context, listen: false).accountType;
    bool isHost = Provider.of<UserProvider>(context, listen: false).isHost();
    UserService userService = UserService();
    _loadEvents();

    return Scaffold(
      appBar: loggedIn?
      CustomNavBar(email: userEmail)
      : AppBar(title: Text("Welcome, guest"),),
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
                          overflow: TextOverflow.ellipsis,  
                        ),
                      ),
                      Text(
                        DateFormat('MM/dd/yyyy').format(event.eventDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
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

                      // Action Buttons (Delete, Assign Volunteers)

                      Provider.of<UserProvider>(context, listen: false).isHost()? //Only hosts can delete and add Vols to events
                        Row( 
                          children: [
                            // Delete Button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _deleteEvent(event.id);  // Delete event
                              },
                            ),
                            IconButton(   // Edit event Button
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditEventDialog(event);  // Show dialog to edit event
                              },
                            ),
                            // Assign Volunteers Button
                            IconButton(
                              icon: Icon(Icons.person_add),
                              onPressed: () {
                                _showAssignVolunteersDialog(event);  // Show dialog to assign volunteers
                              },
                            ),
                          ],
                        )
                        : //Vols can add themselves to events?
                        !event.assignedVolunteers.contains(userService.getUserByEmail(userEmail)!.email)? //If user is not in the event
                          IconButton (
                            icon: Icon(Icons.person_add),
                            onPressed: () async {
                              setState(() {
                                selectedVolunteers.add(userService.getUserByEmail(userEmail)!.email);
                                _loadEvents();
                              });
                              await Provider.of<NotificationProvider>(context, listen: false).loadNotifications(userEmail);
                              Provider.of<NotificationProvider>(context, listen: false).debugNotifs();
                            }
                          )
                          :IconButton ( //prevents user from being able to register multiple times
                            icon: Icon(Icons.check),
                            onPressed: () {}
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