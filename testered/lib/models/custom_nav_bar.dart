import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';

import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
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

    return AppBar(
      title: Text('Welcome, $email'),
      actions: _buildNavButtons(context, currentUser),
      backgroundColor: Colors.white, // Set a light background to contrast the buttons
    );
  }

  // Method to build navigation buttons
  List<Widget> _buildNavButtons(BuildContext context, User? currentUser) {
    final List<Map<String, dynamic>> navItems = [
      {
        'label': 'Profile',
        'onPressed': () {
          if (currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(user: currentUser),
              ),
            );
          } else {
            _showErrorSnackBar(context, 'User not found. Please try again.');
          }
        },
      },
      {
        'label': 'Events',
        'onPressed': () => Navigator.pushNamed(context, '/eventList'),
      },
      {
        'label': 'Create Event',
        'onPressed': () => Navigator.pushNamed(context, '/eventCreate'),
      },
      {
        'label': 'Volunteer-Event Matches',
        'onPressed': () => Navigator.pushNamed(context, '/volunteerListMatch'),
      },
      {
        'label': 'Volunteer History',
        'onPressed': () => Navigator.pushNamed(context, '/volunteerDisplay'),
      },
      {
        'label': 'Logout',
        'onPressed': () {
          Provider.of<UserProvider>(context, listen: false).setEmail('');  // Clear the email from UserProvider
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,  // Clear the entire navigation stack
          );
        },
        'icon': Icons.logout,
        'isIconButton': true,
      },
    ];

    return navItems.map((item) {
      if (item['isIconButton'] == true) {
        return Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: IconButton(
            icon: Icon(item['icon'], color: Colors.black),
            onPressed: item['onPressed'],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: item['onPressed'],
            child: Text(
              item['label'],
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    }).toList();
  }

  // Method to show error SnackBar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard height for AppBar
}
