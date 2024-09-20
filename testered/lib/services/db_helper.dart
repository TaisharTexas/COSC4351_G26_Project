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

    if(_userBox!.isEmpty){
      await _insertDummyUsers();
    }
    if(_eventBox!.isEmpty){
      await _insertDummyEvents();
    }
  }

  // Function to insert dummy users into the users box
  Future<void> _insertDummyUsers() async {
    List<User> dummyUsers = [
      User(
        email: 'janedoe@hotmail.com',
        password: 'spiketail',
        fullName: 'Jane Doe',
        address1: '123 Doe St',
        city: 'Cool City',
        state: 'TX',
        zipCode: '12345',
        skills: ['Volunteer'],
        preferences: 'I love helping people',
        availability: [DateTime.now()],
      ),
      User(
        email: 'johndoe@gmail.com',
        password: 'john',
        fullName: 'John Doe',
        address1: '456 Main St',
        city: 'Great City',
        state: 'NY',
        zipCode: '67890',
        skills: ['Teaching', 'Volunteer'],
        preferences: 'Enjoy teaching kids',
        availability: [DateTime.now().add(Duration(days: 2))],
      ),
      User(
        email: 'annsmith@yahoo.com',
        password: 'ann',
        fullName: 'Ann Smith',
        address1: '789 Broadway',
        city: 'Awesome City',
        state: 'CA',
        zipCode: '54321',
        skills: ['First Aid', 'Volunteer'],
        preferences: 'Available for first aid duties',
        availability: [DateTime.now().add(Duration(days: 5))],
      ),
    ];

    for (User user in dummyUsers) {
      await _userBox!.put(user.email, user);  // Use email as the key
    }
    print('Dummy users inserted into the database.');
  }

  // Function to insert dummy events into the events box
  Future<void> _insertDummyEvents() async {
    List<Event> dummyEvents = [
      Event(
        id: '1',
        name: 'Community Cleanup',
        description: 'Join us to clean up the local park and surrounding areas.',
        location: 'Central Park',
        requiredSkills: ['Volunteer'],
        urgency: 'Medium',
        eventDate: DateTime.now().add(Duration(days: 7)),
      ),
      Event(
        id: '2',
        name: 'First Aid Workshop',
        description: 'A workshop on first aid basics, open to all.',
        location: 'Community Center',
        requiredSkills: ['First Aid'],
        urgency: 'Low',
        eventDate: DateTime.now().add(Duration(days: 14)),
      ),
      Event(
        id: '3',
        name: 'Charity Fun Run',
        description: 'Help organize a charity fun run to raise money for local causes.',
        location: 'Main Street',
        requiredSkills: ['Event Planning', 'Volunteer'],
        urgency: 'High',
        eventDate: DateTime.now().add(Duration(days: 21)),
      ),
    ];

    for (Event event in dummyEvents) {
      await _eventBox!.put(event.id, event);  // Use event ID as the key
    }
    print('Dummy events inserted into the database.');
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

  Future<void> updateEvent(Event event) async {
    try {
      await _eventBox!.put(event.id, event);
    } catch (error) {
      print('Error updating event: $error');
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