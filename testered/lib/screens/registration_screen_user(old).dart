import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import '../services/db_helper.dart';  // Import the DBHelper to fetch users
import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController preferencesController = TextEditingController();

  // States for dropdowns and multi-selects
  String selectedState = 'notSet';  // Default state selection
  List<String> selectedSkills = ['Volunteer']; // Default to just "volunteer"
  List<DateTime> selectedAvailability = [DateTime.now()]; // Default to the current time

  // Hardcoded lists for dropdowns (these would typically come from a service or API)
  final List<String> states = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
    'notSet'
  ]; // Add more states as needed
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning', 'Volunteer'];
  final AuthService authService = AuthService();

  List<User> existingUsers = []; // List to store existing users

  // Error texts for email and password validation
  String? emailErrorText;
  String? passwordErrorText;

  // Fetch all users from the database on screen load
  @override
  void initState() {
    super.initState();
    _loadExistingUsers();
  }

  // Load existing users from the database
  Future<void> _loadExistingUsers() async {
    final users = await DBHelper().getAllUsers();
    setState(() {
      existingUsers = users;  // Update the list of existing users
    });
  }

  // Function to validate email format
  bool _isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegExp.hasMatch(email);
  }

  // Function to validate password format
  bool _isPasswordValid(String password) {
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{8,}$'
    );
    return passwordRegExp.hasMatch(password);
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

  void _removeAvailabilityDate(DateTime date) {
    setState(() {
      selectedAvailability.remove(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Email input field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailErrorText,  // Display error if email is invalid
                ),
              ),
              // Password input field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: passwordErrorText,  // Display error if password is invalid
                ),
                obscureText: true,
              ),
              // Confirm Password input field
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              // Register button
              ElevatedButton(
                onPressed: () async {
                  // Validate email and password
                  if (!_isEmailValid(emailController.text)) {
                    setState(() {
                      emailErrorText = 'Please enter a valid email address';
                    });
                    return; // Stop further execution if email is invalid
                  }

                  if (!_isPasswordValid(passwordController.text)) {
                    setState(() {
                      passwordErrorText = 'Password must be at least 8 characters long and include at least one number and one symbol';
                    });
                    return; // Stop further execution if password is invalid
                  }

                  // Reset error texts if valid
                  setState(() {
                    emailErrorText = null;
                    passwordErrorText = null;
                  });

                  // Check if passwords match
                  if (passwordController.text == confirmPasswordController.text) {
                    bool success = await authService.registerUserFull(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      address1Controller.text,
                      address2Controller.text,
                      cityController.text,
                      zipCodeController.text,
                      selectedState,
                      selectedSkills,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully!')));
                      _loadExistingUsers();
                      Navigator.pushNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}