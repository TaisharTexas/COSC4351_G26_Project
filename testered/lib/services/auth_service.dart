import '../models/user_model.dart';
import 'db_helper.dart';

class AuthService {
  final DBHelper dbHelper = DBHelper();

  // Authenticate user by email and password
  Future<User?> login(String email, String password) async {
    // Use DBHelper's getUser method to find user by email and password
    User? user = dbHelper.getUser(email, password);
    return user;
  }

  // Register a new user
  Future<bool> registerUser(String email, String password) async {
    // Check if the user already exists based on email
    User? existingUser = dbHelper.getUserByEmail(email);

    if (existingUser != null) {
      return false; // User already exists
    }

    // Create a new user with a unique ID (timestamp or UUID)
    User newUser = User(
      id: DateTime.now().toString(),
      email: email,
      password: password,
    );

    // Insert the new user into the Hive box using DBHelper
    await dbHelper.insertUser(newUser);
    return true;
  }
}