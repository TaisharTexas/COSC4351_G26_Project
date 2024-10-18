import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testered/screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../services/user_provider.dart';
import 'package:testered/main.dart';
import 'package:testered/screens/login_screen.dart';
import '../models/custom_nav_bar.dart';
import 'package:testered/screens/event_display_screen.dart';
import 'package:testered/services/user_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loggedIn = false; //Bool that tells us if we're logged in
  User? loggedInUser; //User logged in 
  static const double buttonPaddingRight = 25.0; 
  String userEmail = ''; //User email for the welcome message 
  int accType = -1;

  void login(User u) {
    setState(() {
      loggedIn = Provider.of<UserProvider>(context, listen: false).loggedIn;
      loggedInUser = u;
      userEmail = Provider.of<UserProvider>(context, listen: false).email;
      accType = Provider.of<UserProvider>(context, listen: false).accountType;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ${loggedInUser?.email} succesfully logged in!')),
    );
  }

  String getAccType(int i){
    switch (i) {
      case 0:
        return "VOLUNTEER";
      case 1:
        return "HOST";
      default:
        return "???";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !loggedIn? 
        AppBar(
        title: Row(
          children: [
            Image.asset(
              'images/logo.webp',
              height: 40, // Adjust height or width as needed
            ),
            SizedBox(width: 10), // Adds spacing between image and text
            Text("Welcome, Guest"),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: buttonPaddingRight), // Add space between buttons
            child: Tooltip(
              message: "Login to use this feature!",
              child: TextButton(
                onPressed: () {
                },
                child: Text(
                'Manage Events',
                style: TextStyle(color: Colors.black),
                 ),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: buttonPaddingRight),// Add more space for the last button
            child: Tooltip(
              message: "Login to use this feature!",
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Create Event',
                  style: TextStyle(color: const Color.fromARGB(255, 105, 105, 105)),
                ),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the button
            child: Tooltip(
              message: "Login to use this feature!",
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Volunteer-Event Matches',
                  style: TextStyle(color: const Color.fromARGB(255, 105, 105, 105)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: buttonPaddingRight), // Add more space for the button
            child: Tooltip(
              message: "Login to use this feature!", 
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Volunteer History',
                  style: TextStyle(color: const Color.fromARGB(255, 105, 105, 105)),
                ),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: buttonPaddingRight),
            child: IconButton(
              icon: Icon(Icons.person_rounded, color: Colors.black),  // Login icon button
              onPressed: () async{
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                if(result != null){
                  setState(() {
                    login(result);   
                  });
                }
              },
            ),
          ),
        ],
          backgroundColor: Colors.white, // Set a light background to contrast the buttons
      )
      :
      CustomNavBar(email: userEmail),
    
      body: 
      Padding( //Actual site stuff
        padding: const EdgeInsets.all(0.0),  
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[  
              Image.asset('images/mainPageBanner.jpg', fit: BoxFit.fitWidth, height: 690,),
              Text("WELCOME USER OF LEVEL ${getAccType(accType)}"),
              Text("WELCOME USER OF LEVEL ${Provider.of<UserProvider>(context, listen: false).accountType}"),
              Text("WELCOME USER ${Provider.of<UserProvider>(context, listen: false).email}"),
          ],
        ),
        )
      ),
    );
  }
}