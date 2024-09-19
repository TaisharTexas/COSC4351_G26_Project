import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();

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
                  // Ensure password and confirm password match
                  bool success = await authService.registerUser(emailController.text, passwordController.text);

                  if (success) {
                    // User successfully registered, show success message and navigate to login
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully!')));
                    Navigator.pushNamed(context, '/login');
                  } else {
                    // User already exists, show error message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
                  }
                } else {
                  // Passwords don't match, show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                }
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}