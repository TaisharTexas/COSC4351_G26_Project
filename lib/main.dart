import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'login.dart'; // Import the LoginPage class

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

        title: Image.asset('logo.webp', height: 50, width: 50,),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle, size: 50,), onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
          }),    
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

/*class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[ 
          Image.asset(
            'loginBG.jpg',
             fit: BoxFit.cover,
             height: double.infinity,
             width: double.infinity,
             ),
          Center(
            child: Opacity( 
              opacity: 0.7,
                child: Container(
                  width: 400,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 5.0,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sign In', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('which type of account do you want to sign into?', style: TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.center,),
                        ElevatedButton(onPressed: onPressed, child: Text('VOLUNTEER', style: TextStyle(color: Colors.white),)),
                        ElevatedButton(onPressed: onPressed, child: Text('HOST', style: TextStyle(color: Colors.white),)),
                      ],
                    ),
                ),
                )
            )
          )
          ], //Widgets
        ), //Column
      ),
    );
  }
} */

