import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../services/db_helper.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';
import '../services/user_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class EventDisplayScreenAdmin extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventDisplayScreenAdmin> {
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

  Future<void> _exportEventsToCSV() async {
    List<List<dynamic>> rows = [
      ["Event Name", "Description", "Location", "Date", "Address", "Urgency", "Skills", "Volunteers"]
    ];

    for (Event event in events) {
      List<dynamic> row = [
        event.name,
        event.description,
        event.location,
        DateFormat('MM/dd/yyyy').format(event.eventDate),
        event.address,
        event.urgency,
        event.requiredSkills.join(", "),
        event.assignedVolunteers.join(", ")
      ];
      rows.add(row);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/events.csv";
    final file = File(path);
    await file.writeAsString(csvData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("CSV file saved at $path")),
    );
  }

  Future<void> _exportEventsToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(event.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text("Date: ${DateFormat('MM/dd/yyyy').format(event.eventDate)}"),
                  pw.Text("Location: ${event.location}"),
                  pw.Text("Address: ${event.address}"),
                  pw.Text("Urgency: ${event.urgency}"),
                  pw.Text("Skills: ${event.requiredSkills.join(', ')}"),
                  pw.Text("Assigned Volunteers: ${event.assignedVolunteers.join(', ')}"),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );}

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

    // Show a dialog to edit event details
  // Show a dialog to edit event details
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
    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: events.isEmpty
          ? Center(child: Text('No events available.'))
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _exportEventsToCSV,
                child: Text("Export to CSV"),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _exportEventsToPDF,
                child: Text("Export to PDF"),
              ),
              SizedBox(width: 20),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                List<String> selectedVolunteers = event.assignedVolunteers;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                'Address: ${event.address}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Skills: ${event.requiredSkills.join(', ')}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Assigned Volunteers: ${selectedVolunteers.join(', ')}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Urgency: ${event.urgency}',
                              style: TextStyle(color: Colors.red),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () {
                                    _showAssignVolunteersDialog(event);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showEditEventDialog(event);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _deleteEvent(event.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}