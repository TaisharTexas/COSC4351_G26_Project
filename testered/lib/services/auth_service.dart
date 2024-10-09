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
  Future<bool> registerUser(String email, String password, String name, String address1, String address2, String city, String zipcode, String state, List<String> skills, int accTpye) async {
    // Check if the user already exists based on email
    User? existingUser = dbHelper.getUserByEmail(email);

    if (existingUser != null) {
      return false; // User already exists
    }

    // Create a new user with a unique ID (email)
    User newUser = User(
      email: email,
      password: password,
      fullName: name,
      address1: address1,
      address2: address2,
      city: city,
      zipCode: zipcode,
      state: state,
      skills: skills,
      accType: accTpye,
    );

    // Insert the new user into the Hive box using DBHelper
    await dbHelper.insertUser(newUser);
    return true;
  }
}