class User {
  final String id;
  final String email;
  final String password;
  String fullName;
  String address1;
  String address2;
  String city;
  String state;
  String zipCode;
  List<String> skills;
  String preferences;
  List<DateTime> availability;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.fullName = '',
    this.address1 = '',
    this.address2 = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.skills = const [],
    this.preferences = '',
    this.availability = const [],
  });

  // Convert a User object into a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'skills': skills.join(','), // Store skills as comma-separated string
      'preferences': preferences,
      'availability': availability.map((e) => e.toIso8601String()).join(','), // Store availability as comma-separated dates
    };
  }

  // Convert a map from SQLite back into a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      skills: (map['skills'] as String).split(','),
      preferences: map['preferences'] ?? '',
      availability: (map['availability'] as String)
          .split(',')
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }
}