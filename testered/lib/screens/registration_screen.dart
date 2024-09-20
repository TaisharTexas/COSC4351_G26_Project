import 'package:flutter/material.dart';
import '../services/auth_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name input field
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
            SizedBox(height: 20),
            // Register button
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  bool success = await authService.registerUser(emailController.text, passwordController.text);
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
            // Divider between registration form and users list
            Divider(),
            // Display the list of existing users
            Expanded(
              child: ListView.builder(
                itemCount: existingUsers.length,
                itemBuilder: (context, index) {
                  final user = existingUsers[index];
                  return ListTile(
                    title: Text(user.fullName.isNotEmpty ? user.fullName : "No Name"),
                    subtitle: Text('ID: ${user.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}