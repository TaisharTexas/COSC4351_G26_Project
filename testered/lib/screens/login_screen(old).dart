import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/screens/profile_screen_user.dart';
import 'package:testered/screens/profile_screen_admin.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/user_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
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

            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;
                // Authenticate user (use await as it's async)
                User? user = await authService.login(email, password);
                if (user != null) {
                  // Set the global email in the UserProvider
                  Provider.of<UserProvider>(context, listen: false).setEmail(email);

                  // Navigate to the appropriate screen based on whether the user is an admin
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => user.isAdmin
                          ? ProfileScreenAdmin(user: user)  // Navigate to admin profile screen if admin
                          : ProfileScreenUser(user: user),  // Navigate to user profile screen if not admin
                    ),
                  );
                } else {
                  // Display error if login fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid login credentials')),
                  );
                }
              },
              child: Text('Login'),
            ),

            // Register button
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}