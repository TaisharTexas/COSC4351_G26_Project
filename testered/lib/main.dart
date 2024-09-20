import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/registration_screen.dart';
import 'package:testered/services/db_helper.dart';

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

  // Register the UserAdapter for Hive
  Hive.registerAdapter(UserAdapter());

  // Initialize the database (opens the Hive box and inserts the default user)
  await DBHelper().initDB();

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