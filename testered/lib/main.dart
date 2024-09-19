import 'package:flutter/material.dart';
import 'package:testered/screens/profile_screen.dart';
import 'screens/login_screen_ld.dart';
import 'screens/registration_screen_old.dart';

void main() {
  runApp(VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        // '/': (context) => ProfileScreen(user: null,),
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}