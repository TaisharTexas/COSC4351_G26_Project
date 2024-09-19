import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'login.dart'; // Import the LoginPage class
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData( 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo balls Page'),
      
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 80,
        title: Image.asset('logo.webp', height: 50, width: 50,),

        flexibleSpace: Padding( //Creates the banner stuff
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[ 
                  Container(
                  decoration: BoxDecoration( //Search bar thing
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 150,
                  height: 30,
                  child:Align( //The user icon part
                    alignment: Alignment.topRight,
                    child:
                    IconButton(icon: Icon(Icons.search, size:20), onPressed:(){},),
                  ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children:<Widget>[
                      IconButton(icon: Icon(Icons.account_circle, size: 40,), onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => loginHome()));
                    }),
                    Text('Sign in.', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),),
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
              Image.asset('mainPageBanner.jpg', fit: BoxFit.fitWidth, height: 690,),           
              Text('Recent Events', style: GoogleFonts.bebasNeue(fontWeight: FontWeight.bold, fontSize: 30,),),
              Text('$_counter',style: Theme.of(context).textTheme.headlineMedium,),
          ],
        ),
        ),
      ),
    );
  }

}