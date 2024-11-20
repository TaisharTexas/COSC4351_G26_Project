import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/custom_nav_bar.dart';
import '../services/db_helper.dart';
import '../models/event_model.dart';
import '../services/user_provider.dart';

class EventCreationScreen extends StatefulWidget {
  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController(); // New address field controller

  // Date picker for event date
  DateTime selectedEventDate = DateTime.now();

  // Skill options (same as user profile skills)
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning', 'Volunteer'];
  List<String> selectedRequiredSkills = []; // Track selected required skills

  String urgency = 'Low'; // Default urgency

  final DBHelper dbHelper = DBHelper();

  // Function to pick event date
  Future<void> _pickEventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedEventDate) {
      setState(() {
        selectedEventDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;
    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location (Venue Name)'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address (Street Address)'), // Address field
              ),
              SizedBox(height: 10),
              // Event Date Picker
              Text('Event Date: ${DateFormat('MM/dd/yyyy').format(selectedEventDate)}'),
              ElevatedButton(
                onPressed: () => _pickEventDate(context),
                child: Text('Pick Event Date'),
              ),
              SizedBox(height: 10),

              // Urgency Dropdown
              DropdownButtonFormField<String>(
                value: urgency,
                items: ['Low', 'Medium', 'High'].map((String urgencyLevel) {
                  return DropdownMenuItem<String>(
                    value: urgencyLevel,
                    child: Text(urgencyLevel),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Urgency'),
                onChanged: (String? newValue) {
                  setState(() {
                    urgency = newValue!;
                  });
                },
              ),

              SizedBox(height: 10),

              // Required Skills Multi-select Dropdown (Checkboxes)
              Text('Required Skills', style: TextStyle(fontSize: 16)),
              Wrap(
                children: skillsOptions.map((skill) {
                  return CheckboxListTile(
                    value: selectedRequiredSkills.contains(skill),
                    title: Text(skill),
                    onChanged: (bool? isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          selectedRequiredSkills.add(skill);
                        } else {
                          selectedRequiredSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Save Event Button
              ElevatedButton(
                onPressed: () async {
                  // Generate a unique ID for the event
                  String eventId = DateTime.now().millisecondsSinceEpoch.toString();

                  // Create a new Event object
                  Event newEvent = Event(
                    id: eventId,
                    name: nameController.text,
                    description: descriptionController.text,
                    location: locationController.text,
                    address: addressController.text, // Save the address field
                    requiredSkills: selectedRequiredSkills,
                    urgency: urgency,
                    eventDate: selectedEventDate,
                  );

                  // Insert the event into the database
                  await dbHelper.insertEvent(newEvent);

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Event created successfully!')),
                  );

                  // Navigate back or clear the form (depends on your flow)
                  Navigator.pop(context);
                },
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}