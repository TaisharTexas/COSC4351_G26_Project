import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:get/get.dart';
import 'package:testered/screens/event_creation_screen.dart';
import 'package:testered/screens/event_display_screen.dart';
import 'package:testered/screens/home_screen.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/profile_screen.dart';
import 'package:testered/screens/registration_screen.dart';
import 'package:testered/screens/volunteer_display_screen.dart';
import 'package:testered/screens/volunteer_listing_screen.dart';
import 'package:testered/services/db_helper.dart';
import 'package:provider/provider.dart';
import 'models/event_model.dart';
import 'services/user_provider.dart';
import 'package:testered/screens/home_screen.dart';

import 'models/user_model.dart';

//I made main async to make sure it initialized the DB before the app startup
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await DBHelper().database;
//   runApp(VolunteerApp());
// }

//I made main async to make sure it initialized the DB before the app startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(EventAdapter());

  // Initialize the database (opens the Hive box and inserts the default user)
  await DBHelper().initDB();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provide the UserProvider globally
      ],
      child: VolunteerApp(),
    ),
  );
  // runApp(VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volunteer Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/eventList': (context) => EventDisplayScreen(),
        '/eventCreate': (context) => EventCreationScreen(),
        '/volunteerListMatch': (context) => VolunteerListingScreen(),
        '/volunteerDisplay': (context) => VolunteerDisplayScreen(),
        '/home': (context) => const MyHomePage(title: "HOME",),
      },
    );
  }
}

