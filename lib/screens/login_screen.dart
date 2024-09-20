import 'package:flutter/material.dart';
import 'package:testered/main.dart';
import 'package:testered/screens/profile_screen.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
  
}

class _LoginScreen extends State<LoginScreen>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool showPas = true;
  void unhidePassword(){
    setState(() {
      showPas = !showPas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // When the back button is pressed, pop with a value of false
        Navigator.pop(context, null);
        return true;
      },

    child: Scaffold(
      appBar: AppBar(title: Text('Volunteer Login')),
      body: Center(
        child: Stack(
          children: <Widget>[ 
          Image.asset(
            'images/loginBG.jpg',
             fit: BoxFit.cover,
             height: double.infinity,
             width: double.infinity,
             ),
            Center(
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
                      Container(
                        width: 400,
                        height: 50,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Text('Sign In', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                      Container(
                        width: 400,
                        height: 10,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Container(
                        width: 400,
                        height: 1,
                        color: Colors.black,                            
                      ),
                      Container(
                        width: 400,
                        height: 20,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Email: "),
                             Container(
                              width: 58,
                              height: 20,
                              color: Colors.white.withOpacity(.7),                            
                            ),
                            Flexible(
                              child:SizedBox(
                                width: 200,
                                child:TextField(
                                  controller: emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter email',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        width: 400,
                        height: 30,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Password: "),
                             Container(
                              width: 30,
                              height: 20,
                              color: Colors.white.withOpacity(.7),                            
                            ),
                            Flexible(
                              child: SizedBox(
                                width: 200,
                                child:TextField(
                                  obscureText: showPas,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter password',
                                    suffixIcon: showPas? //Cool thing that allows user to see the password
                                      IconButton(icon: Icon(Icons.remove_red_eye, size: 20,), onPressed:(){unhidePassword();},)
                                      : 
                                      IconButton(icon: Icon(Icons.visibility_off, size: 20,), onPressed:(){unhidePassword();},)
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      Container(
                        width: 400,
                        height: 30,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      ElevatedButton(onPressed: () async {
                        String email = emailController.text;
                        String password = passwordController.text;

                        // Authenticate user (use await as it's async)
                        User? user = await authService.login(email, password);

                        if (user != null) {
                          // On successful login, navigate to homescreen and pass the User object
                          Navigator.pop(
                            context,                              
                            user
                          );
                        } else {
                          // Display error if login fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid login credentials')),
                          );
                        }
                      }, 
                      child: Text('Login')),
                      Container(
                        width: 400,
                        height: 30,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Container(
                        width: 400,
                        height: 1,
                        color: Colors.black,                            
                      ),
                      Container(
                        width: 400,
                        height: 20,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      Text("Don't have an account?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, '/register'); // Navigates to the register page
                        },
                        child: const Text(
                          'Register here',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ]
        ),
      )
      )
    );
  }
} 

            