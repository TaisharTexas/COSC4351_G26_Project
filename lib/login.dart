
import 'package:flutter/material.dart';

void dummy1(){

}

void dummy2(){

}

class loginHome extends StatefulWidget{
  @override
  _LoginHomeState createState() => _LoginHomeState();
  
}

class _LoginHomeState extends State<loginHome>{
  bool registration = true;
  bool showPas = true;
  bool showPas2 = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController passVerif = TextEditingController();
  bool filledOut = false;
  bool samePas = false;
    
  void unhidePassword(bool eye, int i){
    setState(() {
      if(i == 1){
        showPas = !showPas;
      }
      else{
        showPas2 = !showPas2;
      }
    });
  }

  void registerToggle() {
    setState(() {
      registration = !registration;  // Toggle between Text and TextField
    });
  }

  void checkPass(){
    setState(() {
      samePas = (passVerif.text == pass.text);
    });
  }

  void checkFilled(){
    setState(() {
      filledOut = (passVerif.text != "" && pass.text != "" && email.text != "");
    });
  }
  @override
  void initState() {
    super.initState();

    // Add a listener to check if the passwords match
    pass.addListener(checkPass);
    passVerif.addListener(checkPass);

    pass.addListener(checkFilled);
    email.addListener(checkFilled);
    passVerif.addListener(checkFilled);
  }

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
                child: registration? Padding(
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
                      Text('which type of account do you want to sign into?', style: TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.center,),
                      Container(
                        width: 400,
                        height: 20,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      ElevatedButton(onPressed: dummy1, style: ElevatedButton.styleFrom(minimumSize: Size(200, 60), backgroundColor: Colors.blue), child: Text('VOLUNTEER', style: TextStyle(color: Colors.white),)),
                      Container(
                        width: 400,
                        height: 20,
                        color: Colors.white.withOpacity(.7),                            
                      ),
                      ElevatedButton(onPressed: dummy2, style: ElevatedButton.styleFrom(minimumSize: Size(200, 60), backgroundColor: Colors.blue), child: Text('HOST', style: TextStyle(color: Colors.white),)),
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
                        onTap: () => registerToggle(),
                        child: const Text(
                          'Register here',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ) 
                : Padding( //This stuff comes up if the ser is not registered and has too 
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Text("Email: "),
                          Flexible(
                            child:SizedBox(
                              width: 200,
                              child:TextField(
                                controller: email,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Text("Password: "),
                          Flexible(
                            child: SizedBox(
                              width: 200,
                              child:TextField(
                                obscureText: showPas,
                                controller: pass,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter password...',
                                  suffixIcon: showPas? //Cool thing that allows user to see the password
                                    IconButton(icon: Icon(Icons.remove_red_eye, size: 20,), onPressed:(){unhidePassword(showPas, 1);},)
                                    : 
                                    IconButton(icon: Icon(Icons.visibility_off, size: 20,), onPressed:(){unhidePassword(showPas, 1);},)
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Text("Verify Password: "),
                          Flexible(
                            child:SizedBox(
                              width: 200,
                              child:TextField(
                                obscureText: showPas,
                                controller: passVerif,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: '...',
                                  suffixIcon: showPas2? //Cool thing that allows user to see the password
                                    IconButton(icon: Icon(Icons.remove_red_eye, size: 20,), onPressed:(){unhidePassword(showPas2, 2);},)
                                    : 
                                    IconButton(icon: Icon(Icons.visibility_off, size: 20,), onPressed:(){unhidePassword(showPas2, 2);},)
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
                        ElevatedButton(onPressed:(){}, child: Text("Submit"),)
                      :
                        ElevatedButton(onPressed: null, child: Text("Submit"),), //If info not filled out cant sign up
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}