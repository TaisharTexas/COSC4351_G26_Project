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

  @override
  void initState() {
    super.initState();
    _loadExistingUsers();
  }

  Future<void> _loadExistingUsers() async {
    final users = await DBHelper().getAllUsers();
    setState(() {
      existingUsers = users;  // Update the list of existing users
    });
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty || nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
                  return;
                }

                if (!_isEmailValid(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid email')));
                  return;
                }

                if (passwordController.text == confirmPasswordController.text) {
                  try {
                    bool success = await authService.registerUser(emailController.text, passwordController.text);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully!')));
                      _loadExistingUsers();
                      Navigator.pushNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                }
              },
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(
              height: 300,  // Limit the size of the users list
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
