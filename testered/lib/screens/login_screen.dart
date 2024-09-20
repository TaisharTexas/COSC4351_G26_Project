import 'package:flutter/material.dart';
import 'package:testered/screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {  // Change from StatelessWidget to StatefulWidget
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _isLoading = false;  // Loading state

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _obscurePassword = true;
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
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),

            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() {
                  _isLoading = true;  // Show loading spinner
                });

                String email = emailController.text;
                String password = passwordController.text;

                // Authenticate user (use await as it's async)
                User? user = await authService.login(email, password);

                setState(() {
                  _isLoading = false;  // Hide loading spinner
                });

                if (user != null) {
                  // On successful login, navigate to ProfileScreen and pass the User object
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user),
                    ),
                  );
                } else if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid email address')),
                  );
                  return;
                }
                  else {
                  // Display error if login fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid login credentials')),
                  );
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator()  // Show loading spinner
                  : Text('Login'),  // Show 'Login' when not loading
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
