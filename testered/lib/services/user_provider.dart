import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _email = ''; // Initially empty, can be set when the user logs in

  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();  // Notifies all listeners that the email has changed
  }
}