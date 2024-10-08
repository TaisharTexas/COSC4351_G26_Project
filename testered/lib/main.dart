import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testered/screens/event_creation_screen.dart';
import 'package:testered/screens/event_display_screen_admin.dart';
import 'package:testered/screens/event_display_screen_user.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/recommended_events_screen_admin.dart';
import 'package:testered/screens/recommended_events_screen_user.dart';
import 'package:testered/screens/registration_screen_user.dart';
import 'package:testered/screens/volunteer_display_screen.dart';
import 'package:testered/services/db_helper.dart';
import 'package:provider/provider.dart';
import 'models/event_model.dart';
import 'services/user_provider.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/eventListAdmin': (context) => EventDisplayScreenAdmin(),
        '/eventListUser': (context) => EventDisplayScreenUser(),
        '/eventCreate': (context) => EventCreationScreen(),
        '/recommendedEventsAdmin': (context) => RecommendedEventsAdmin(),
        '/recommendedEventsUser': (context) => RecommendedEventsUser(),
        '/volunteerDisplay': (context) => VolunteerDisplayScreen(),

      },
    );
  }
}