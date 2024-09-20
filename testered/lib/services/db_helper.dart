import 'package:hive/hive.dart';
import '../models/user_model.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._();
  static Box<User>? _userBox;

  DBHelper._();

  // Factory constructor for singleton
  factory DBHelper() {
    return _instance;
  }

  // Initialize Hive and open the box for users
  Future<void> initDB() async {
    if (_userBox != null) return;  // Box already opened

    // Open the Hive box for users
    _userBox = await Hive.openBox<User>('usersBox');

    // Insert default user on initialization
    if (_userBox!.isEmpty) {
      await _userBox!.put('1', User(
          id: '1',
          email: 'janedoe@hotmail.com',
          password: 'spiketail',
          fullName: 'Jane Doe',
          address1: '123 Doe St',
          city: 'Cool City',
          state: 'Serenrae',
          zipCode: '12345',
          skills: ['stabbing things'],
          preferences: 'stabbing things',
          availability: [DateTime.now()]
      ));
    }
  }

  // Insert a new user
  Future<void> insertUser(User user) async {
    try {
      await _userBox!.put(user.id, user);  // Use user ID as the key
    } catch (error) {
      print('Error inserting user: $error');
    }
  }

  // Fetch a user by email and password
  User? getUser(String email, String password) {
    try {
      // Search through all users to find the matching credentials
      final users = _userBox!.values
          .where((user) => user.email == email && user.password == password)
          .toList();

      // Return the first matching user if found, else return null
      if (users.isNotEmpty) {
        return users.first;
      } else {
        return null;  // Return null if no user is found
      }
    } catch (error) {
      print('Error fetching user: $error');
      return null;
    }
  }

  // Fetch a user by email
  User? getUserByEmail(String email) {
    try {
      final users = _userBox!.values.where((user) => user.email == email).toList();

      if (users.isNotEmpty) {
        return users.first;
      } else {
        return null;  // Return null if no user is found
      }
    } catch (error) {
      print('Error fetching user by email: $error');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUser(User user) async {
    try {
      await _userBox!.put(user.id, user);  // Replace the existing user with the same ID
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  // Get all users
  List<User> getAllUsers() {
    try {
      return _userBox!.values.toList();
    } catch (error) {
      print('Error fetching all users: $error');
      return [];
    }
  }

  // Delete a user by ID
  Future<void> deleteUser(String id) async {
    try {
      await _userBox!.delete(id);
    } catch (error) {
      print('Error deleting user: $error');
    }
  }
}