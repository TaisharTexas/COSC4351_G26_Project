import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/db_helper.dart';  // Import the DBHelper to fetch users
import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService authService = AuthService();

  bool filledOut = true;
  bool showPas = true;
  bool showPas2 = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController passVerif = TextEditingController();

  List<User> existingUsers = []; // List to store existing users

  void checkFilled(){ //Checks if everything on the form is filled out 
    setState(() {
      filledOut = (emailController.text != "" && passwordController.text != "" && nameController.text != "" && nameController != "");
    });
  }
  
  void unhidePassword(int i){ //Hides and reveals the password so you can check it 
    setState(() {
      if(i == 1){
        showPas = !showPas;
      }
      else{
        showPas2 = !showPas2;
      }
    });
  }
  
  // Fetch all users from the database on screen load
  @override
  void initState() {
    super.initState();
    _loadExistingUsers();
  }

  // Load existing users from the database
  Future<void> _loadExistingUsers() async {
    final users = await DBHelper().getAllUsers();
    setState(() {
      existingUsers = users;  // Update the list of existing users
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
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
                  child:
                    Padding( //This stuff comes up if the ser is not registered and has too 
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Container(
                          width: 400,
                          height: 50,
                          color: Colors.white.withOpacity(.7),                            
                        ),
                        Text('Create your account', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                        Container(
                          width: 400,
                          height: 20,
                          color: Colors.white.withOpacity(.7),                            
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Name: "),
                            Container(
                              width: 56,
                              height: 20,
                              color: Colors.white.withOpacity(.7),                            
                            ),
                            Flexible(
                              child:SizedBox(
                                width: 200,
                                child:TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter name',
                                  ),
                                ),
                              )
                            )
                          ],
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
                                    labelText: 'Enter email...',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 400,
                          height: 20,
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
                                      IconButton(icon: Icon(Icons.remove_red_eye, size: 20,), onPressed:(){unhidePassword(1);},)
                                      : 
                                      IconButton(icon: Icon(Icons.visibility_off, size: 20,), onPressed:(){unhidePassword(1);},)
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 400,
                          height: 20,
                          color: Colors.white.withOpacity(.7),                            
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Confirm Password: "),
                            Flexible(
                              child:SizedBox(
                                width: 200,
                                child:TextField(
                                  obscureText: showPas2,
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Re-enter Password',
                                    suffixIcon: showPas2? //Cool thing that allows user to see the password
                                      IconButton(icon: Icon(Icons.remove_red_eye, size: 20,), onPressed:(){unhidePassword(2);},)
                                      : 
                                      IconButton(icon: Icon(Icons.visibility_off, size: 20,), onPressed:(){unhidePassword(2);},)
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                        Container(
                          width: 400,
                          height: 20,
                          color: Colors.white.withOpacity(.7),                            
                        ),
                        filledOut?
                          ElevatedButton(onPressed: () async {
                            if (passwordController.text == confirmPasswordController.text) {
                              bool success = await authService.registerUser(emailController.text, passwordController.text);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully!')));
                                _loadExistingUsers();
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User already exists')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
                            }
                          }, 
                          child: Text("Submit"),)
                        :
                          ElevatedButton(onPressed: null, child: Text("Submit"),), //If info not filled out cant sign up
                    ],
                  ),
                ), 
              ), 
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: 600), // Adjust this as needed
                child: Column(
                  children: [
                    Divider(), // Divider at the bottom
                    Expanded(
                      child: Container(
                        color: Colors.lightBlue,
                        child: ListView.builder(
                          itemCount: existingUsers.length,
                          itemBuilder: (context, index) {
                            final user = existingUsers[index];
                            return ListTile(
                              title: Text(user.fullName.isNotEmpty ? user.fullName : "No Name"),
                              subtitle: Text('ID: ${user.id}'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}

