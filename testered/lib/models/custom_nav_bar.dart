import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';
import 'package:intl/intl.dart';  // For date formatting
import '../screens/login_screen.dart';
import '../screens/profile_screen_user.dart';
import '../screens/profile_screen_admin.dart';
import '../services/user_provider.dart';
import '../services/user_service.dart';
import 'package:testered/screens/home_screen.dart';
import '../services/db_helper.dart';
import '../models/event_model.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String email;
  static const double buttonPaddingRight = 25.0;
  bool notifsOpen = false;
  OverlayEntry? _overlayEntry;
  List<Event> notifications = []; // Initialize here

  CustomNavBar({required this.email});

  void _showNotifications(BuildContext context, List<Event> notifications){
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height,
        left: (offset.dx + 550 + size.width / 2),
        width: 200,
        child: Material(
          elevation: 4.0,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(notifications[index].name),
                        onTap: () {
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              notifications.removeAt(index);
                              _updateOverlay();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      notifications.clear();
                      _removeOverlay();
                      _updateOverlay();
                    });
                  },
                  child: Text('Clear All'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }
  void _updateOverlay() {
    // If the overlay is already displayed, update it
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild(); // Rebuild the overlay to reflect changes
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;

    final UserService userService = UserService();
    final User? currentUser = userService.getUserByEmail(userEmail);

    final titleText = currentUser != null && currentUser.isAdmin
        ? 'Welcome, $email (admin)'
        : 'Welcome, $email';

    // Check for upcoming events and show notification popup on first login
    // if (currentUser != null) {
    //   _checkUpcomingEvents(context, currentUser);
    // }

    return AppBar(
      title: Text(titleText),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User $email not found')));
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
          padding: const EdgeInsets.only(right: buttonPaddingRight),
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
            padding: const EdgeInsets.only(right: buttonPaddingRight),
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
          padding: const EdgeInsets.only(right: buttonPaddingRight),
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
        Padding(padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: Stack(
            children: <Widget>[
              IconButton(
                icon: Stack(
                  children: <Widget>[
                    Icon(Icons.notifications, size: 30.0), //Bell for notifs
                    if (notifications.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${notifications.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Notifications"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: notifications.map((notification) {
                              return ListTile(
                                title: Text(notification.name),
                              );
                            }).toList(),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        // LOGOUT BUTTON
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Standard height for AppBar

  // // Method to check for upcoming events within the next 5 days
  // void _checkUpcomingEvents(BuildContext context, User currentUser) async {
  //   final DBHelper dbHelper = DBHelper();
  //
  //   // Fetch all events and filter by those assigned to the current user and happening in the next 5 days
  //   List<Event> allEvents = dbHelper.getAllEvents();
  //   DateTime now = DateTime.now();
  //
  //   List<Event> upcomingEvents = allEvents.where((event) {
  //     bool isUpcoming = event.eventDate.isAfter(now) && event.eventDate.isBefore(now.add(Duration(days: 5)));
  //     bool isUserAssigned = event.assignedVolunteers.contains(currentUser.email);
  //     return isUpcoming && isUserAssigned;
  //   }).toList();
  //
  //   if (upcomingEvents.isNotEmpty) {
  //     // Check if notification has already been shown
  //     final userProvider = Provider.of<UserProvider>(context, listen: false);
  //     if (!userProvider.hasShownUpcomingEventsNotification) {
  //       // Show popup with the upcoming events
  //       _showUpcomingEventsNotification(context, upcomingEvents);
  //
  //       // Mark the notification as shown to avoid showing it again
  //       userProvider.setHasShownUpcomingEventsNotification(true);
  //     }
  //   }
  // }

  // // Method to show a notification popup with the upcoming events
  // void _showUpcomingEventsNotification(BuildContext context, List<Event> upcomingEvents) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,  // Allow dismissing the dialog by tapping outside
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Upcoming Events"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: upcomingEvents.map((event) {
  //               return ListTile(
  //                 title: Text(event.name),
  //                 subtitle: Text('Date: ${DateFormat('MM/dd/yyyy').format(event.eventDate)}'),
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text("Close"),
  //             onPressed: () {
  //               Navigator.of(context, rootNavigator: true).pop();  // Ensure we pop the dialog properly
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}