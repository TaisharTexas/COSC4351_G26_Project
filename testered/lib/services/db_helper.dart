import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._();
  static Box<User>? _userBox;
  static Box<Event>? _eventBox;

  DBHelper._();

  // Factory constructor for singleton
  factory DBHelper() {
    return _instance;
  }

  // Initialize Hive and open the box for users
  Future<void> initDB() async {
    if (_userBox != null && _eventBox != null) return;  // Box already opened

    // Open the Hive box for users
    _userBox = await Hive.openBox<User>('usersBox');
    // Open the Hive box for events
    _eventBox = await Hive.openBox<Event>('eventsBox');

    // Insert default user on initialization
    if (_userBox!.isEmpty) {
      await _userBox!.put('1', User(
          // id: '1',
          email: 'janedoe@hotmail.com',
          password: 'spiketail',
          fullName: 'Jane Doe',
          address1: '123 Doe St',
          city: 'Cool City',
          state: 'TX',
          zipCode: '12345',
          skills: ['Volunteer'],
          preferences: 'I like to stab people',
          availability: [DateTime.now()]
      ));
    }
  }

  // ---- User Methods ---- //

  // Insert a new user
  Future<void> insertUser(User user) async {
    try {
      await _userBox!.put(user.email, user);  // Use email as the key
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
      await _userBox!.put(user.email, user);  // Replace the existing user with the same ID
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

  // Delete a user by email
  Future<void> deleteUser(String email) async {
    try {
      await _userBox!.delete(email);
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  // ---- Event Methods ---- //

  // Insert a new event
  Future<void> insertEvent(Event event) async {
    try {
      await _eventBox!.put(event.id, event);  // Use id as the key
    } catch (error) {
      print('Error inserting event: $error');
    }
  }

  // Fetch all events
  List<Event> getAllEvents() {
    try {
      return _eventBox!.values.toList();
    } catch (error) {
      print('Error fetching all events: $error');
      return [];
    }
  }

  // Delete an event by id
  Future<void> deleteEvent(String id) async {
    try {
      await _eventBox!.delete(id);
    } catch (error) {
      print('Error deleting event: $error');
    }
  }

  // Fetch a specific event by id
  Event? getEventById(String id) {
    try {
      return _eventBox!.get(id);
    } catch (error) {
      print('Error fetching event by id: $error');
      return null;
    }
  }
}