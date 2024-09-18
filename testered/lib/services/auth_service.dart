import '../models/user_model.dart';

class AuthService {
  final List<User> _users = [];

  // Return nullable User for login
  User? login(String email, String password) {
    try {
      return _users.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;  // Return null if user is not found
    }
  }

  // Register a user, ensure email doesn't already exist
  bool registerUser(String email, String password) {
    if (_users.any((user) => user.email == email)) {
      return false; // User with this email already exists
    }
    _users.add(User(
      id: DateTime.now().toString(),
      email: email,
      password: password,
    ));
    return true;
  }

  // Get user by email, return nullable User
  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;  // Return null if user is not found
    }
  }
}