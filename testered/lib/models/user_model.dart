import 'package:hive/hive.dart';

part 'user_model.g.dart';  // Hive TypeAdapter will be generated

@HiveType(typeId: 0)  // Assign a unique typeId for User class
class User {
  // @HiveField(0)
  // final String id;  // Hive doesn't support auto-increment, so use a string ID (or manage manually if needed)

  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  String fullName;

  @HiveField(3)
  String address1;

  @HiveField(4)
  String address2;

  @HiveField(5)
  String city;

  @HiveField(6)
  String state;

  @HiveField(7)
  String zipCode;

  @HiveField(8)
  List<String> skills;  // Hive can handle basic lists like List<String>

  @HiveField(9)
  String preferences;

  @HiveField(10)
  List<DateTime> availability;

  @HiveField(11)
  List<String> pastEvents;

  @HiveField(12)
  bool isAdmin;


  // For DateTime, Hive stores this as a list

  User({
    // required this.id,
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
    this.pastEvents = const [],
    this.isAdmin = false,
  });
}