import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Login'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/loginBG.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85, // Responsive width
                constraints: BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;  // Toggle visibility
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            String email = emailController.text;
                            String password = passwordController.text;
                            User? user = await authService.login(email, password);

                            setState(() {
                              _isLoading = false;
                            });

                            if (user != null) {
                              Navigator.pop(context, user);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Invalid login credentials')),
                              );
                            }
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
