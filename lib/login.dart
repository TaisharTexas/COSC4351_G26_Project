import 'package:flutter/material.dart';

void dummy1(){

}

void dummy2(){

}

class Login extends StatelessWidget {
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
                        ElevatedButton(onPressed: dummy1, style: ElevatedButton.styleFrom(minimumSize: Size(200, 60), backgroundColor: Colors.blue), child: Text('VOLUNTEER', style: TextStyle(color: Colors.white),)),
                        ElevatedButton(onPressed: dummy2, style: ElevatedButton.styleFrom(minimumSize: Size(200, 60), backgroundColor: Colors.blue), child: Text('HOST', style: TextStyle(color: Colors.white),)),
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
}



