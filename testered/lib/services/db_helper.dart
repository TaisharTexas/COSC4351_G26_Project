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
      pastEvents: ['1', '3'],
      isAdmin: true,
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
      pastEvents: ['2', '5'],
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
      pastEvents: ['4'],
    ),
    User(
      email: 'michaeljohnson@gmail.com',
      password: 'michael123',
      fullName: 'Michael Johnson',
      address1: '22 Oak St',
      city: 'Sunnyville',
      state: 'FL',
      zipCode: '23456',
      skills: ['Volunteer', 'Cooking'],
      preferences: 'Enjoys cooking and helping in the kitchen',
      availability: [DateTime.now().add(Duration(days: 7))],
      pastEvents: ['2', '4'],
    ),
    User(
      email: 'lindawilson@outlook.com',
      password: 'lindapass',
      fullName: 'Linda Wilson',
      address1: '15 Pine Rd',
      city: 'Greenfield',
      state: 'IL',
      zipCode: '67891',
      skills: ['First Aid', 'Volunteer'],
      preferences: 'Interested in providing first aid support',
      availability: [DateTime.now().add(Duration(days: 3))],
      pastEvents: ['1'],
    ),
    User(
      email: 'robertsmith@gmail.com',
      password: 'robertpass',
      fullName: 'Robert Smith',
      address1: '89 Maple Ave',
      city: 'Springtown',
      state: 'CA',
      zipCode: '54321',
      skills: ['Event Planning', 'Volunteer'],
      preferences: 'Available for event organization',
      availability: [DateTime.now().add(Duration(days: 10))],
      pastEvents: ['3'],
    ),
    User(
      email: 'susanbrown@yahoo.com',
      password: 'susan123',
      fullName: 'Susan Brown',
      address1: '77 Cedar Dr',
      city: 'Westfield',
      state: 'NY',
      zipCode: '12345',
      skills: ['Teaching', 'Volunteer'],
      preferences: 'Enjoys teaching and working with children',
      availability: [DateTime.now().add(Duration(days: 12))],
      pastEvents: ['2', '3', '5'],
    ),
    User(
      email: 'davidlee@outlook.com',
      password: 'davidpass',
      fullName: 'David Lee',
      address1: '66 Willow St',
      city: 'Brookfield',
      state: 'TX',
      zipCode: '67892',
      skills: ['Volunteer', 'First Aid'],
      preferences: 'Interested in community service and first aid',
      availability: [DateTime.now().add(Duration(days: 8))],
    ),
    User(
      email: 'karendavis@gmail.com',
      password: 'karenpass',
      fullName: 'Karen Davis',
      address1: '12 Elm St',
      city: 'Fairview',
      state: 'CA',
      zipCode: '54322',
      skills: ['Cooking', 'Volunteer'],
      preferences: 'Loves cooking and helping in food drives',
      availability: [DateTime.now().add(Duration(days: 5))],
    ),
    User(
      email: 'chriswhite@gmail.com',
      password: 'chrispass',
      fullName: 'Chris White',
      address1: '10 Birch St',
      city: 'Sunset',
      state: 'FL',
      zipCode: '67893',
      skills: ['Event Planning', 'Volunteer'],
      preferences: 'Available for planning community events',
      availability: [DateTime.now().add(Duration(days: 15))],
    ),
    User(
      email: 'nancyjones@yahoo.com',
      password: 'nancypass',
      fullName: 'Nancy Jones',
      address1: '33 Spruce St',
      city: 'Hilltop',
      state: 'NY',
      zipCode: '12346',
      skills: ['Teaching'],
      preferences: 'Loves to teach and mentor students',
      availability: [DateTime.now().add(Duration(days: 20))],
    ),
    User(
      email: 'peterparker@gmail.com',
      password: 'spiderman123',
      fullName: 'Peter Parker',
      address1: '20 Web St',
      city: 'Queens',
      state: 'NY',
      zipCode: '11101',
      skills: ['Event Planning', 'Volunteer', 'First Aid'],
      preferences: 'Available for first aid, event planning, and volunteering',
      availability: [DateTime.now().add(Duration(days: 2))],
    ),
    User(
      email: 'alicegreen@gmail.com',
      password: 'alicepass',
      fullName: 'Alice Green',
      address1: '18 Ash St',
      city: 'Oceanview',
      state: 'TX',
      zipCode: '67894',
      skills: ['Volunteer'],
      preferences: 'Happy to volunteer for any community activity',
      availability: [DateTime.now().add(Duration(days: 25))],
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
      address: '59th St to 110th St, Manhattan, NY 10022', // Address for Central Park
      requiredSkills: ['Volunteer'],
      urgency: 'Medium',
      eventDate: DateTime.now().add(Duration(days: 7)),  // This event is not within 5 days
      assignedVolunteers: ['janedoe@hotmail.com'],  // Assign Jane Doe as a volunteer
    ),
    Event(
      id: '2',
      name: 'First Aid Workshop',
      description: 'A workshop on first aid basics, open to all.',
      location: 'Community Center',
      address: '1234 Main St, Anytown, USA 12345', // Example address for a Community Center
      requiredSkills: ['First Aid'],
      urgency: 'Low',
      eventDate: DateTime.now().add(Duration(days: 2)),  // This event is within the next 5 days
      assignedVolunteers: ['lindawilson@outlook.com', 'michaeljohnson@gmail.com', 'janedoe@hotmail.com'],  // Assign Linda Wilson and Michael Johnson
    ),
    Event(
      id: '3',
      name: 'Charity Fun Run',
      description: 'Help organize a charity fun run to raise money for local causes.',
      location: 'Main Street',
      address: '100 Main St, Springfield, IL 62701', // Address for Main Street
      requiredSkills: ['Event Planning', 'Volunteer'],
      urgency: 'High',
      eventDate: DateTime.now().add(Duration(days: 21)),
      assignedVolunteers: ['robertsmith@gmail.com'],  // Assign Robert Smith
    ),
    Event(
      id: '4',
      name: 'Food Drive',
      description: 'Help us collect and distribute food to those in need.',
      location: 'Food Bank',
      address: '456 Elm St, Foodtown, CA 90210', // Address for a Food Bank
      requiredSkills: ['Volunteer', 'Cooking'],
      urgency: 'High',
      eventDate: DateTime.now().add(Duration(days: 5)),  // This event is within the next 5 days
      assignedVolunteers: ['janedoe@hotmail.com', 'michaeljohnson@gmail.com'],  // Assign Jane Doe and Michael Johnson
    ),
    Event(
      id: '5',
      name: 'Blood Donation Camp',
      description: 'Assist in organizing a blood donation camp for the community.',
      location: 'Community Hall',
      address: '789 Maple Ave, Bloodville, NY 11223', // Address for a Community Hall
      requiredSkills: ['First Aid', 'Volunteer'],
      urgency: 'Urgent',
      eventDate: DateTime.now().add(Duration(days: 10)),
      assignedVolunteers: ['annsmith@yahoo.com'],  // Assign Ann Smith
    ),
    Event(
      id: '6',
      name: 'Disaster Relief Training',
      description: 'Learn and help others with basic disaster relief training.',
      location: 'Disaster Management Center',
      address: '1010 Oak St, Safetyville, TX 77001', // Address for Disaster Management Center
      requiredSkills: ['First Aid', 'Event Planning'],
      urgency: 'Medium',
      eventDate: DateTime.now().add(Duration(days: 12)),
      assignedVolunteers: ['johndoe@gmail.com'],  // Assign John Doe
    ),
    Event(
      id: '7',
      name: 'Animal Shelter Volunteering',
      description: 'Volunteer to take care of the animals at the local shelter.',
      location: 'Animal Shelter',
      address: '1111 Paw St, Petville, FL 33101', // Address for an Animal Shelter
      requiredSkills: ['Volunteer'],
      urgency: 'Low',
      eventDate: DateTime.now().add(Duration(days: 12)),
    ),
    Event(
      id: '8',
      name: 'Teaching Kids Coding',
      description: 'Teach basic coding skills to underprivileged children.',
      location: 'Local School',
      address: '2222 Code Ave, Teacherville, CA 90210', // Address for a Local School
      requiredSkills: ['Teaching'],
      urgency: 'Medium',
      eventDate: DateTime.now().add(Duration(days: 30)),
    ),
    Event(
      id: '9',
      name: 'Community Garden Project',
      description: 'Help us plant and maintain a community garden.',
      location: 'Community Garden',
      address: '3333 Green St, Garden City, NY 10001', // Address for a Community Garden
      requiredSkills: ['Event Planning', 'Volunteer'],
      urgency: 'Low',
      eventDate: DateTime.now().add(Duration(days: 15)),
    ),
  ];

  for (Event event in dummyEvents) {
    await _eventBox!.put(event.id, event);  // Use event ID as the key
  }
  print('Dummy events with volunteers and upcoming dates inserted into the database.');
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