import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';
import 'package:testered/screens/home_screen.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../services/user_provider.dart';
import '../services/user_service.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String? email; // Pass the user's email (or any identifier for the logged-in user)
  static const double buttonPaddingRight = 25.0;

  CustomNavBar({required this.email});

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;

    final UserService userService = UserService();
    final User? currentUser = userService.getUserByEmail(userEmail);


    return AppBar(
      title: Text('Welcome, $email'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Adjust padding to move the buttons
          child: TextButton(
            onPressed: () {
              if (currentUser != null) {
                // Directly push to ProfileScreen and pass the current User object
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: currentUser),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User $email not found')));
              }
            },
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),  // Ensure the text is visible
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add space between buttons
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eventList'); // Navigate to Event List screen
            },
            child: Text(
              'Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the last button
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eventCreate'); // Navigate to Event Creation screen
            },
            child: Text(
              'Create Event',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the button
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/volunteerListMatch'); // Navigate to volunteer event match screen
            },
            child: Text(
              'Volunteer-Event Matches',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the button
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/volunteerDisplay'); // Navigate to volunteer event match screen
            },
            child: Text(
              'Volunteer History',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),  // Logout icon button
            onPressed: () {
              // Clear the user session
              Provider.of<UserProvider>(context, listen: false).setEmail('');  // Clear the email from UserProvider

              // Navigate back to the login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: "Welcome, Guest")),
                    (Route<dynamic> route) => false,  // Clear the entire navigation stack
              );
            },
          ),
        ),
      ],
      backgroundColor: Colors.white, // Set a light background to contrast the buttons
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard height for AppBar
}