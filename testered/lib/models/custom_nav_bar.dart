import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';
import 'package:testered/screens/home_screen.dart';
import 'package:testered/services/notification_provider.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

import '../models/user_model.dart';
import '../models/event_model.dart'; // Assuming you have an Event model
import '../services/user_provider.dart';
import '../services/user_service.dart';
import '../services/db_helper.dart';  // Assuming you have a DBHelper to fetch events

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/user_model.dart';
import 'package:testered/screens/home_screen.dart';
import 'package:testered/services/notification_provider.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';

import '../models/user_model.dart';
import '../models/event_model.dart'; // Assuming you have an Event model
import '../services/user_provider.dart';
import '../services/user_service.dart';
import '../services/db_helper.dart';  // Assuming you have a DBHelper to fetch events


class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String email;  // Declare the email parameter

  // Constructor with the required email parameter
  CustomNavBar({required this.email});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  static const double buttonPaddingRight = 25.0;
  final UserService userService = UserService();
  bool notifsOpen = false;
  OverlayEntry? _overlayEntry;
  List<Event> notifications = []; // Initialize here

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<NotificationProvider>().loadNotifications(widget.email);
    });
  }

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

  Widget build(BuildContext context) {
    final userEmail = Provider.of<UserProvider>(context).email;
    final User? currentUser = userService.getUserByEmail(userEmail);
    List<Event> notifications = context.read<NotificationProvider>().notifications;
    
    return AppBar(
      title: Text('Welcome, ${currentUser!.fullName}'),
      actions: Provider.of<UserProvider>(context, listen: false).isHost() ? [ //If you're an admin you get all this
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: currentUser),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User ${widget.email} not found')),
                );
              }
            },
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eventList');
            },
            child: Text(
              'Manage Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/volunteerListMatch');
            },
            child: Text(
              'Volunteer-Event Matches',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/volunteerDisplay');
            },
            child: Text(
              'Volunteer History',
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
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).logIn();
              Provider.of<UserProvider>(context, listen: false).setEmail('');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: "Welcome, Guest")),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
      ]
    : [ //For users and not hosts
       Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eventList');
            },
            child: Text(
              'Available Events',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: TextButton(
            onPressed: () {
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: currentUser),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User ${widget.email} not found')),
                );
              }
            },
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
            
        Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications, size: 30.0), 
              onPressed: () {
                notifsOpen = !notifsOpen;
                if(notifsOpen){
                  _showNotifications(context, notifications);
                }
                else{
                  _removeOverlay();
                }       
                for(Event e in notifications){
                  print(e.name);
                }
              }
            ),
            if(notifications.length > 0)  // Only show if there are notifications
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
         Padding(
          padding: const EdgeInsets.only(right: buttonPaddingRight),
          child: IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).logIn();
              Provider.of<UserProvider>(context, listen: false).setEmail('');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: "Welcome, Guest")),
                (Route<dynamic> route) => false,
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