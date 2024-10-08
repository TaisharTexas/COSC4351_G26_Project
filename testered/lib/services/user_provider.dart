import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _email = ''; // Initially empty, can be set when the user logs in
  bool loggedIn = false; //Golbal bool to tell us if we're logged in
  int accountType = -1; //-1 is not logged in, 0 is a volunteer, 1 is a host account? 
   String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();  // Notifies all listeners that the email has changed
  }

  void logIn(bool status){
    loggedIn = !status;
  }

  void setAccountType(int i){
    accountType = i;
  }

  bool isVol(){
    return accountType == 0;  
  }

  bool isHost(){
    return accountType == 1;  
  }

}