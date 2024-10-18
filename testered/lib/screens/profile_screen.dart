import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../models/event_model.dart'; // Assuming you have an Event model
import '../services/user_provider.dart';
import '../services/user_service.dart';
import '../services/db_helper.dart';  // Assuming you have a DBHelper to fetch events

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenUserState createState() => _ProfileScreenUserState();
}

class _ProfileScreenUserState extends State<ProfileScreen> {
  final UserService userService = UserService();

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  // States for dropdowns and multi-selects
  String selectedState = 'notSet';  // Default state selection
  List<String> selectedSkills = ['Volunteer']; // Default to just "volunteer"
  List<DateTime> selectedAvailability = [DateTime.now()]; // Default to the current time

  List<Event> volunteerHistory = []; // List to store past events

  // Hardcoded lists for dropdowns (these would typically come from a service or API)
  final List<String> states = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
    'notSet'
  ];
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning', 'Volunteer'];

  @override
  void initState() {
    super.initState();

    // Pre-fill the form with existing user data
    fullNameController.text = widget.user.fullName;
    address1Controller.text = widget.user.address1;
    address2Controller.text = widget.user.address2;
    cityController.text = widget.user.city;
    zipCodeController.text = widget.user.zipCode;
    preferencesController.text = widget.user.preferences;
    selectedState = widget.user.state;
    selectedSkills = widget.user.skills;
    selectedAvailability = widget.user.availability;

    // Load user's volunteer history
    _loadVolunteerHistory();

    // Check for upcoming events after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUpcomingEvents();
    });
  }

  // Function to load user's volunteer history based on their past events
  Future<void> _loadVolunteerHistory() async {
    List<Event> events = [];
    for (String eventId in widget.user.pastEvents) {
      final event = await DBHelper().getEventById(eventId); // Assuming DBHelper has a getEventById method
      if (event != null) {
        events.add(event);
      }
    }
    setState(() {
      volunteerHistory = events;
    });
  }

  // Function to check for upcoming events within the next 5 days
  void _checkUpcomingEvents() async {
    final DBHelper dbHelper = DBHelper();
    final now = DateTime.now();

    // Fetch all events and filter by those assigned to the current user and happening in the next 5 days
    List<Event> allEvents = dbHelper.getAllEvents();
    List<Event> upcomingEvents = allEvents.where((event) {
      bool isUpcoming = event.eventDate.isAfter(now) && event.eventDate.isBefore(now.add(Duration(days: 5)));
      bool isUserAssigned = event.assignedVolunteers.contains(widget.user.email);
      return isUpcoming && isUserAssigned;
    }).toList();

    if (upcomingEvents.isNotEmpty) {
      // Access the provider to ensure we show the notification only once
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (!userProvider.hasShownUpcomingEventsNotification) {
        // Show tray notification with the upcoming events
        _showUpcomingEventsTray(upcomingEvents);

        // Mark the notification as shown to avoid showing it again
        userProvider.setHasShownUpcomingEventsNotification(true);
      }
    }
  }

  // Method to show a tray-style notification at the bottom of the screen for upcoming events
  void _showUpcomingEventsTray(List<Event> upcomingEvents) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upcoming Events in the next 5 days:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...upcomingEvents.map((event) {
              return Text('${event.name} on ${DateFormat('MM/dd/yyyy').format(event.eventDate)}');
            }).toList(),
          ],
        ),
        duration: Duration(seconds: 10), // Display the tray for 10 seconds
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // User clicked on the close action.
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Function to display DatePicker and add selected dates to the list
  Future<void> _pickAvailabilityDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && !selectedAvailability.contains(picked)) {
      setState(() {
        selectedAvailability.add(picked);
      });
    }
  }

  // Function to remove a selected date
  void _removeAvailabilityDate(DateTime date) {
    setState(() {
      selectedAvailability.remove(date);
    });
  }

  // Save the user profile
  void _saveProfile() {
    // Update user with form data
    widget.user.fullName = fullNameController.text;
    widget.user.address1 = address1Controller.text;
    widget.user.address2 = address2Controller.text;
    widget.user.city = cityController.text;
    widget.user.zipCode = zipCodeController.text;
    widget.user.state = selectedState;
    widget.user.skills = selectedSkills;
    widget.user.preferences = preferencesController.text;
    widget.user.availability = selectedAvailability;

    // Save user profile using the service
    userService.updateUserProfile(widget.user);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    // Access the email from the UserProvider
    final userEmail = Provider.of<UserProvider>(context).email;

    return Scaffold(
      appBar: CustomNavBar(email: userEmail),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),

              // Address 1
              TextField(
                controller: address1Controller,
                decoration: InputDecoration(labelText: 'Address 1'),
              ),

              // Address 2 (optional)
              TextField(
                controller: address2Controller,
                decoration: InputDecoration(labelText: 'Address 2 (Optional)'),
              ),

              // City
              TextField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),

              // State Dropdown
              DropdownButtonFormField<String>(
                value: selectedState,
                items: states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'State'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedState = newValue!;
                  });
                },
              ),

              // Zip Code
              TextField(
                controller: zipCodeController,
                decoration: InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number,
                maxLength: 9,
              ),

              // Skills Multi-select Dropdown (Checkboxes)
              Text('Skills', style: TextStyle(fontSize: 16)),
              Wrap(
                children: skillsOptions.map((skill) {
                  return CheckboxListTile(
                    value: selectedSkills.contains(skill),
                    title: Text(skill),
                    onChanged: (bool? isSelected) {
                      setState(() {
                        if (isSelected == true) {
                          selectedSkills.add(skill);
                        } else {
                          selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // Preferences (Text area, optional)
              TextField(
                controller: preferencesController,
                decoration: InputDecoration(labelText: 'Preferences (Optional)'),
                maxLines: 3,
              ),

              // Availability Date Picker (multiple dates)
              SizedBox(height: 10),
              Text('Availability', style: TextStyle(fontSize: 16)),
              ElevatedButton(
                onPressed: () => _pickAvailabilityDate(context),
                child: Text('Pick Availability Date'),
              ),
              Wrap(
                children: selectedAvailability.map((date) {
                  return Chip(
                    label: Text(DateFormat('MM/dd/yyyy').format(date)),
                    onDeleted: () => _removeAvailabilityDate(date),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Save Profile Button
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save Profile'),
              ),

              SizedBox(height: 20),

              // Volunteer History Section
              Divider(),
              Text(
                'Volunteer History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              volunteerHistory.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true, // Important for embedding in scrollable views
                itemCount: volunteerHistory.length,
                itemBuilder: (context, index) {
                  final event = volunteerHistory[index];
                  return ListTile(
                    title: Text(event.name),
                    subtitle: Text('Date: ${DateFormat('MM/dd/yyyy').format(event.eventDate)}'),
                  );
                },
              )
                  : Text('No volunteer history available.'),
            ],
          ),
        ),
      ),
    );
  }
}