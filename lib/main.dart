import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/profile_screen.dart';
import 'package:testered/screens/registration_screen.dart';
import 'package:testered/services/db_helper.dart';

import 'models/user_model.dart';

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
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(title: 'Volunteer Management'),
        // '/': (context) => ProfileScreen(user: null,),
        '/login': (context) => LoginScreen(), // Add this lines
        '/register': (context) => RegistrationScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
    final String title;
    
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loggedIn = true;
  User? loggedInUser = null;

  void login(User u) {
    setState(() {
      loggedIn = false;
      loggedInUser = u;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ${loggedInUser?.email} succesfully logged in!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 80,
        title: Image.asset('images/logo.webp', height: 50, width: 50,),

        flexibleSpace: Padding( //Creates the banner stuff
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[ 
                  loggedIn? //If we're not logged in the site tells us to login
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:<Widget>[
                        IconButton(icon: Icon(Icons.account_circle, size: 40,), onPressed:() async{
                        final loggedInUser = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                        if (loggedInUser != null){
                          login(loggedInUser);
                        };
                      }),
                      Text('Sign in.', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),),
                      ]
                    )
                  :
                  Column( //If we are logged in it changed the site and we now alter account details 
                      mainAxisSize: MainAxisSize.min,
                      children:<Widget>[
                        IconButton(icon: Icon(Icons.account_circle, size: 50,), onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: loggedInUser!)),);}),
                      ]
                    ),   
              ], 
            ),
          ),
        ),

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
              Text("EVENTS:"),

              
              //Text('Recent Events', style: GoogleFonts.bebasNeue(fontWeight: FontWeight.bold, fontSize: 30,),),
          ],
        ),
        ),
      ),
    );
  }
}