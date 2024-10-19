import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';
import '../models/custom_nav_bar.dart';
import '../models/user_model.dart';
import '../services/user_provider.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  final _formKey = GlobalKey<FormState>();  // Form key for validation

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  // States for dropdowns and multi-selects
  String selectedState = 'notSet';  // Default state selection
  List<String> selectedSkills = []; // Default to an empty skill list
  List<DateTime> selectedAvailability = []; // Default to an empty list

  // Hardcoded lists for dropdowns (these would typically come from a service or API)
  final List<String> states = ['CA', 'NY', 'TX', 'FL', 'IL', 'notSet'];
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning', 'Volunteer'];

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with existing user data
    _initializeUserData();
  }

  // Pre-fill the form with existing user data
  void _initializeUserData() {
    fullNameController.text = widget.user.fullName;
    address1Controller.text = widget.user.address1;
    address2Controller.text = widget.user.address2;
    cityController.text = widget.user.city;
    zipCodeController.text = widget.user.zipCode;
    preferencesController.text = widget.user.preferences;
    selectedState = widget.user.state;
    selectedSkills = List.from(widget.user.skills);  // Deep copy to prevent modification issues
    selectedAvailability = List.from(widget.user.availability);
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
    if (_formKey.currentState!.validate()) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
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
          child: Form(
            key: _formKey,  // Adding form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(fullNameController, 'Full Name', 'Please enter your full name'),
                _buildTextFormField(address1Controller, 'Address 1', 'Please enter your address'),
                _buildTextFormField(address2Controller, 'Address 2 (Optional)', null),
                _buildTextFormField(cityController, 'City', 'Please enter your city'),
                _buildStateDropdown(),
                _buildZipCodeField(),
                _buildSkillsCheckboxes(),
                _buildPreferencesField(),
                _buildAvailabilityPicker(),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create TextFormField with validation
  Widget _buildTextFormField(TextEditingController controller, String label, String? validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (validationMessage != null && (value == null || value.isEmpty)) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  // Helper method for the state dropdown
  Widget _buildStateDropdown() {
    return DropdownButtonFormField<String>(
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
      validator: (value) {
        if (value == null || value == 'notSet') {
          return 'Please select a state';
        }
        return null;
      },
    );
  }

  // Helper method for the zip code field
  Widget _buildZipCodeField() {
    return TextFormField(
      controller: zipCodeController,
      decoration: InputDecoration(labelText: 'Zip Code'),
      keyboardType: TextInputType.number,
      maxLength: 9,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 5) {
          return 'Please enter a valid zip code';
        }
        return null;
      },
    );
  }

  // Helper method for skills checkboxes
  Widget _buildSkillsCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  // Helper method for preferences field
  Widget _buildPreferencesField() {
    return TextFormField(
      controller: preferencesController,
      decoration: InputDecoration(labelText: 'Preferences (Optional)'),
      maxLines: 3,
    );
  }

  // Helper method for availability date picker
  Widget _buildAvailabilityPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  // Helper method for save button
  Widget _buildSaveButton() {
    return SizedBox(
      height: 20,
      child: ElevatedButton(
        onPressed: _saveProfile,
        child: Text('Save Profile'),
      ),
    );
  }
}
