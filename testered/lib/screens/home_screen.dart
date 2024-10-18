import 'package:flutter/material.dart';
import 'package:testered/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Banner Image
              Image.asset(
                'images/mainPageBanner.jpg',
                fit: BoxFit.fitWidth,
                height: 690,
                width: double.infinity,
              ),

              SizedBox(height: 30), // Adds space between banner and button

              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Button size
                  backgroundColor: Colors.blue, // Button background color
                  textStyle: TextStyle(fontSize: 18), // Button text size
                ),
                child: Text('Login to Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}