import '../models/user_model.dart';
import 'db_helper.dart';

class UserService {
  final DBHelper dbHelper = DBHelper();

  // Fetch a user by ID
  Future<User?> getUser(String userId) async {
    // Implement fetching user by ID if needed
  }

  // Update user profile in the database
  Future<void> updateUserProfile(User user) async {
    await dbHelper.updateUser(user);
  }
}