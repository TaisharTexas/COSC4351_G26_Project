import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/user_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Adding form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Email input field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password input field with visibility toggle
              TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Login button with loading indicator
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    String email = emailController.text;
                    String password = passwordController.text;

                    // Authenticate user
                    User? user = await authService.login(email, password);
                    setState(() {
                      _isLoading = false;
                    });
                    if (user != null) {
                      // On successful login, update the provider and navigate to ProfileScreen
                      Provider.of<UserProvider>(context, listen: false).setEmail(email);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: user),
                        ),
                      );
                    } else {
                      // Show error if login fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid login credentials')),
                      );
                    }
                  }
                },
                child: Center(
                  child: Text('Login'),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Register button
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Don’t have an account? Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
