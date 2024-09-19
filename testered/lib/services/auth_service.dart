import '../models/user_model.dart';
import 'db_helper.dart';

class AuthService {
  final DBHelper dbHelper = DBHelper();

  // Authenticate user by email and password
  Future<User?> login(String email, String password) async {
    return await dbHelper.getUser(email, password);
  }

  // Register a new user
  Future<bool> registerUser(String email, String password) async {
    User? existingUser = await dbHelper.getUser(email, password);
    if (existingUser != null) {
      return false; // User already exists
    }

    // Insert new user into the database
    User newUser = User(
      id: DateTime.now().toString(),
      email: email,
      password: password,
    );
    await dbHelper.insertUser(newUser);
    return true;
  }
}