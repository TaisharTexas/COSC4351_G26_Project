import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../services/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../models/event_model.dart'; // Assuming you have an Event model
import '../services/user_provider.dart';
import '../services/user_service.dart';
import '../services/db_helper.dart';  // Assuming you have a DBHelper to fetch events
import '../services/exporter.dart';

class ProfileScreenAdmin extends StatefulWidget {
  final User user;

  ProfileScreenAdmin({required this.user});

  @override
  _ProfileScreenAdminState createState() => _ProfileScreenAdminState();
}

class _ProfileScreenAdminState extends State<ProfileScreenAdmin> {
  final UserService userService = UserService();
  List<User> users = []; // List of all users
  User? selectedUser; // Currently selected user

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
    // Load the list of users and set the selected user
    _loadUsers();
    // Check for upcoming events when the screen loads
    //_checkUpcomingEvents();
  }

  Future<void> _loadUsers() async {
    List<User> loadedUsers = await userService.getAllUsers();
    setState(() {
      users = loadedUsers;
      selectedUser = widget.user; // Default to the user passed in the constructor
      _loadUserData(selectedUser!); // Load the initial user's data
    });
  }

  void _loadUserData(User user) {
    // Pre-fill the form with selected user's data
    fullNameController.text = user.fullName;
    address1Controller.text = user.address1;
    address2Controller.text = user.address2;
    cityController.text = user.city;
    zipCodeController.text = user.zipCode;
    preferencesController.text = user.preferences;
    selectedState = user.state;
    selectedSkills = user.skills;
    selectedAvailability = user.availability;

    // Load the user's volunteer history
    _loadVolunteerHistory(user);
  }

  // Function to load the volunteer history of the selected user
  Future<void> _loadVolunteerHistory(User user) async {
    List<Event> events = [];
    for (String eventId in user.pastEvents) {
      final event = await DBHelper().getEventById(eventId) as Event?; // Assuming DBHelper has a getEventById method
      if (event != null) {
        events.add(event);
      }
    }
    setState(() {
      volunteerHistory = events;
    });
  }

  // Check for upcoming events within the next 5 days
  void _checkUpcomingEvents() async {
    final DBHelper dbHelper = DBHelper();
    DateTime now = DateTime.now();

    // Fetch all events and filter by those assigned to the current user and happening in the next 5 days
    List<Event> allEvents = dbHelper.getAllEvents();
    List<Event> upcomingEvents = allEvents.where((event) {
      bool isUpcoming = event.eventDate.isAfter(now) && event.eventDate.isBefore(now.add(Duration(days: 5)));
      bool isUserAssigned = event.assignedVolunteers.contains(widget.user.email);
      return isUpcoming && isUserAssigned;
    }).toList();

    if (upcomingEvents.isNotEmpty) {
      // Show the tray notification using a SnackBar
      _showUpcomingEventsTray(upcomingEvents);
    }
  }

  // Function to show upcoming events in a tray (SnackBar) at the bottom
  void _showUpcomingEventsTray(List<Event> upcomingEvents) {
    final eventNames = upcomingEvents.map((e) => e.name).join(', ');
    final eventCount = upcomingEvents.length;
    final message = 'You have $eventCount upcoming event(s): $eventNames';

    // Show SnackBar as a tray notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Action to view events (could navigate to the events page)
            Navigator.pushNamed(context, '/eventListAdmin');
          },
        ),
      ),
    );
  }

  // Save the selected user's profile
  void _saveProfile() {
    if (selectedUser != null) {
      // Update user with form data
      selectedUser!.fullName = fullNameController.text;
      selectedUser!.address1 = address1Controller.text;
      selectedUser!.address2 = address2Controller.text;
      selectedUser!.city = cityController.text;
      selectedUser!.zipCode = zipCodeController.text;
      selectedUser!.state = selectedState;
      selectedUser!.skills = selectedSkills;
      selectedUser!.preferences = preferencesController.text;
      selectedUser!.availability = selectedAvailability;

      // Save the selected user's profile using the service
      userService.updateUserProfile(selectedUser!);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    }
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
              // Add Export to CSV Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await exportUserBoxToCsvWeb(users); // Call the export function
                    },
                    child: Text("Export Users to CSV"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final DBHelper dbHelper = DBHelper();
                      String allEvents = dbHelper.getEventById('2')!.name;
                      await exportUserBoxToPdfWeb(users); // Call the export function
                    },
                    child: Text("Export Users to PDF"),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Currently Viewing Text
              Text(
                'Currently Viewing: ${selectedUser?.fullName ?? 'No user selected'}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              // Dropdown to select a user (visually enhanced)
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select User Profile',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<User>(
                    value: selectedUser,
                    items: users.map((User user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.fullName),
                      );
                    }).toList(),
                    onChanged: (User? newUser) {
                      setState(() {
                        selectedUser = newUser;
                        if (newUser != null) {
                          _loadUserData(newUser);
                        }
                      });
                    },
                    isExpanded: true,
                    hint: Text("Select a user"),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Conditionally show Admin Toggle Switch
              if (selectedUser?.email != userEmail)  // Hide the toggle when the admin is viewing their own profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Admin Status",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: selectedUser?.isAdmin ?? false,
                      onChanged: (bool value) {
                        setState(() {
                          if (selectedUser != null) {
                            selectedUser!.isAdmin = value;
                            userService.updateUserProfile(selectedUser!);
                          }
                        });
                      },
                    ),
                  ],
                ),

              SizedBox(height: 20),

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
