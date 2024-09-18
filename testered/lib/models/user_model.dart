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
}