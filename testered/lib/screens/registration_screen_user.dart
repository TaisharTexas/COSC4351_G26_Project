import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../services/db_helper.dart';
import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  // Error messages
  String? emailErrorText;
  String? passwordErrorText;

  // Email validation function
  bool _isEmailValid(String email) {
    final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  // Password validation function
  bool _isPasswordValid(String password) {
    final RegExp passwordRegExp = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  // Submit registration
  Future<void> _submitRegistration() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (!_isEmailValid(email)) {
      setState(() {
        emailErrorText = 'Enter a valid email';
      });
      return;
    }
    if (!_isPasswordValid(password)) {
      setState(() {
        passwordErrorText = 'Password must have 8 characters, 1 number, and 1 symbol';
      });
      return;
    }

    setState(() {
      emailErrorText = null;
      passwordErrorText = null;
    });

    if (password == confirmPassword) {
      bool success = await authService.registerUser(email, password);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered successfully!')));
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/registrationBG.jpeg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: Container(
                width: 600,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 5.0, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      width: 400,
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        errorText: emailErrorText,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        errorText: passwordErrorText,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitRegistration,
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    const Text("Already have an account?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: const Text(
                        'Login here',
                        style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}