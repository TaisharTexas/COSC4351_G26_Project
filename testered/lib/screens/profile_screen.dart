import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/user_model.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  // States for dropdowns and multi-selects
  String selectedState = 'CA';  // Default state selection
  List<String> selectedSkills = [];
  List<DateTime> selectedAvailability = [];

  // Hardcoded lists for dropdowns (these would typically come from a service or API)
  final List<String> states = ['CA', 'NY', 'TX', 'FL', 'IL']; // Add more states as needed
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning'];

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
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
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
            ],
          ),
        ),
      ),
    );
  }
}