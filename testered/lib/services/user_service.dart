import '../models/user_model.dart';

class UserService {
  final List<User> _users = [];

  // Get a user by userId, return nullable User
  User? getUser(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;  // Return null if user is not found
    }
  }

  // Update an existing user's profile
  void updateUserProfile(User user) {
    int index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;  // Update user if found
    }
  }
}