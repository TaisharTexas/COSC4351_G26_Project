import 'package:hive/hive.dart';
import '../models/user_model.dart';

class UserService {
  final Box<User> userBox = Hive.box<User>('usersBox');  // Access the Hive box for users

  // Fetch a user by ID
  Future<User?> getUser(String userId) async {
    try {
      // Get the user by ID from the Hive box
      return userBox.get(userId);
    } catch (error) {
      print('Error fetching user by ID: $error');
      return null;
    }
  }

  // Update user profile in the database (Hive)
  Future<void> updateUserProfile(User user) async {
    try {
      // Put (update) the user in the Hive box, replacing the existing user with the same ID
      await userBox.put(user.id, user);
    } catch (error) {
      print('Error updating user profile: $error');
    }
  }
}