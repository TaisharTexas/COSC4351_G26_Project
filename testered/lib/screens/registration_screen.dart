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

  bool filledOut = true;
  bool showPas = true;
  bool showPas2 = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController passVerif = TextEditingController();

  
  void unhidePassword(int i){ //Hides and reveals the password so you can check it 
    setState(() {
      if(i == 1){
        showPas = !showPas;
      }
      else{
        showPas2 = !showPas2;
      }
    });
  }

  // States for dropdowns and multi-selects
  String selectedState = 'notSet';  // Default state selection
  List<String> selectedSkills = ['Volunteer']; //Default to just "volunteer"
  List<DateTime> selectedAvailability = [DateTime.now()]; // Default to the current time

  // Hardcoded lists for dropdowns (these would typically come from a service or API)
  final List<String> states = ['CA', 'NY', 'TX', 'FL', 'IL', 'notSet']; // Add more states as needed
  final List<String> skillsOptions = ['First Aid', 'Teaching', 'Cooking', 'Event Planning', 'Volunteer'];
  final AuthService authService = AuthService();

  List<User> existingUsers = []; // List to store existing users

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
      body: Center(
        child: Stack(
          children:<Widget>[ 
            Image.asset(
              'images/loginBG.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              ),
              // Name input field
              Center(
                  child: Container(
                    width: 400,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 5.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                    child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                          ),
                          // Email input field
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          // Password input field
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          // Confirm Password input field
                          TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
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
                          // Register button
                          ElevatedButton(
                            onPressed: () async {
                              if (passwordController.text == confirmPasswordController.text) {
                                bool success = await authService.registerUser(
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
                                  Navigator.pop(context);
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
                          // Divider between registration form and users list
                          Divider(),
                          // Display the list of existing users
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: existingUsers.length,
                              itemBuilder: (context, index) {
                                final user = existingUsers[index];
                                return ListTile(
                                  title: Text(user.fullName.isNotEmpty ? user.fullName : "No Name"),
                                  subtitle: Text('ID: ${user.email}'),
                                );
                              }, //Itembuilder
                            ),
                          )
                        ], //Children
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),  
    );
  }
}