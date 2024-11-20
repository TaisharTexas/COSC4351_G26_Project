import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';
import 'package:intl/intl.dart';  // For date formatting
import '../screens/login_screen.dart';
import '../screens/profile_screen_user.dart';
import '../screens/profile_screen_admin.dart';
import 'user_provider.dart';
import 'user_service.dart';
import 'package:testered/screens/home_screen.dart';
import 'db_helper.dart';
import '../models/event_model.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String email;
  static const double buttonPaddingRight = 25.0;

  CustomNavBar({required this.email});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard height for AppBar
}

class _CustomNavBarState extends State<CustomNavBar> {
  List<Event> _upcomingEvents = [];
  bool _hasNotifications = false;

  @override
  void initState() {
    super.initState();
    // Call the method to check for upcoming events when the navbar is initialized
    _checkUpcomingEvents();
  }

  // Function to check for upcoming events within the next 5 days
  void _checkUpcomingEvents() async {
    final DBHelper dbHelper = DBHelper();
    final now = DateTime.now();

    // Fetch all events and filter by those assigned to the current user and happening in the next 5 days
    List<Event> allEvents = await dbHelper.getAllEvents();
    List<Event> upcomingEvents = allEvents.where((event) {
      bool isUpcoming = event.eventDate.isAfter(now) && event.eventDate.isBefore(now.add(Duration(days: 5)));
      bool isUserAssigned = event.assignedVolunteers.contains(widget.email);  // Use the email from widget
      return isUpcoming && isUserAssigned;
    }).toList();

    if (upcomingEvents.isNotEmpty) {
      setState(() {
        _upcomingEvents = upcomingEvents;
        _hasNotifications = true;  // Set to true if there are upcoming events
      });
    }
  }

  // Dropdown to show upcoming events when notification button is pressed
  void _showNotificationsDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(10.0),
          children: _upcomingEvents.isNotEmpty
              ? _upcomingEvents.map((event) {
            return ListTile(
              title: Text(event.name),
              subtitle: Text('Date: ${DateFormat('MM/dd/yyyy').format(event.eventDate)}'),
            );
          }).toList()
              : [
            ListTile(
              title: Text("No upcoming events"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;

    final UserService userService = UserService();
    final User? currentUser = userService.getUserByEmail(userEmail);

    final titleText = currentUser != null && currentUser.isAdmin
        ? 'Welcome, ${widget.email} (admin)'
        : 'Welcome, ${widget.email}';

    return AppBar(
      title: Text(titleText),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => currentUser.isAdmin
                        ? ProfileScreenAdmin(user: currentUser)
                        : ProfileScreenUser(user: currentUser),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ${widget.email} not found')));
              }
            },
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),

        // Event button
        Padding(
          padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              if (currentUser != null && currentUser.isAdmin) {
                Navigator.pushNamed(context, '/eventListAdmin');
              } else {
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
            padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/eventCreate');
              },
              child: Text(
                'Create Event',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

        // Recommended Events button
        Padding(
          padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              if (currentUser != null && currentUser.isAdmin) {
                Navigator.pushNamed(context, '/recommendedEventsAdmin');
              } else {
                Navigator.pushNamed(context, '/recommendedEventsUser');
              }
            },
            child: Text(
              'Recommended Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),

        // Notifications Button with Indicator if there are upcoming events
        Padding(
          padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  _showNotificationsDropdown(context);  // Show dropdown with upcoming events
                },
              ),
              if (_hasNotifications)  // Show the indicator if there are notifications
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '!',  // Customize the badge content (could be number of notifications)
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Logout button
        Padding(
          padding: const EdgeInsets.only(right: CustomNavBar.buttonPaddingRight),
          child: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).setEmail('');  // Clear the email from UserProvider
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}