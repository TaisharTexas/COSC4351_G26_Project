import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen_user.dart';  // Import the user profile screen
import '../screens/profile_screen_admin.dart'; // Import the admin profile screen
import '../services/user_provider.dart';
import '../services/user_service.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String email; // Pass the user's email (or any identifier for the logged-in user)
  static const double buttonPaddingRight = 25.0;

  CustomNavBar({required this.email});

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;

    final UserService userService = UserService();
    final User? currentUser = userService.getUserByEmail(userEmail);

    final titleText = currentUser != null && currentUser.isAdmin
        ? 'Welcome, $email (admin)'
        : 'Welcome, $email';

    return AppBar(
      title: Text(titleText),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Adjust padding to move the buttons
          child: TextButton(
            onPressed: () {
              if (currentUser != null) {
                // Navigate to ProfileScreenAdmin if the user is an admin, otherwise ProfileScreenUser
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => currentUser.isAdmin
                        ? ProfileScreenAdmin(user: currentUser)  // Admin profile screen
                        : ProfileScreenUser(user: currentUser),  // Non-admin profile screen
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

        // Event button
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add space between buttons
          child: TextButton(
            onPressed: () {
              if (currentUser != null && currentUser.isAdmin) {
                // Navigate to the admin event display screen if the user is an admin
                Navigator.pushNamed(context, '/eventListAdmin');
              } else {
                // Navigate to the user event display screen if the user is not an admin
                Navigator.pushNamed(context, '/eventListUser');
              }
            },
            child: Text(
              'Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),

        // Conditionally show "Create Event" button only if the user is an admin
        if (currentUser != null && currentUser.isAdmin)
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

        // Padding(
        //   padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the button
        //   child: TextButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/recommendedEventsAdmin'); // Navigate to volunteer event match screen
        //     },
        //     child: Text(
        //       'Recommended Events',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   ),
        // ),

        // Recommended Events button
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight), // Add space between buttons
          child: TextButton(
            onPressed: () {
              if (currentUser != null && currentUser.isAdmin) {
                // Navigate to the admin event display screen if the user is an admin
                Navigator.pushNamed(context, '/recommendedEventsAdmin');
              } else {
                // Navigate to the user event display screen if the user is not an admin
                Navigator.pushNamed(context, '/recommendedEventsUser');
              }
            },
            child: Text(
              'Recommended Events',
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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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