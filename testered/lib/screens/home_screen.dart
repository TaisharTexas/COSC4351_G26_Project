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
              // Stack for overlaying text on the banner image
              Stack(
                alignment: Alignment.center, // Center the text over the image
                children: [
                  // Banner Image
                  Image.asset(
                    'images/mainPageBanner.jpg',
                    fit: BoxFit.fitWidth,
                    height: 690,
                    width: double.infinity,
                  ),
                  // Overlayed Title Text
                  Positioned(
                    top: 150, // Adjust the vertical position of the text
                    left: 20,
                    right: 20, // Ensure the text is not too close to the edges
                    child: Text(
                      "Hi, if this were a real volunteer organization, this page would have info about the org and cool things you can do to make the whole thing look appealing to people just finding the site!",
                      textAlign: TextAlign.center, // Center the text horizontally
                      style: TextStyle(
                        color: Colors.white, // White text to stand out against the image
                        fontSize: 24, // Large font size for visibility
                        fontWeight: FontWeight.bold, // Bold text for emphasis
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.6), // Slight shadow for readability
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30), // Adds space between the banner and button

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