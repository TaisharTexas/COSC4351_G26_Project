import 'package:hive/hive.dart';

part 'user_model.g.dart';  // Hive TypeAdapter will be generated

@HiveType(typeId: 0)  // Assign a unique typeId for User class
class User {
  // @HiveField(0)
  // final String id;  // Hive doesn't support auto-increment, so use a string ID (or manage manually if needed)

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  String fullName;

  @HiveField(4)
  String address1;

  @HiveField(5)
  String address2;

  @HiveField(6)
  String city;

  @HiveField(7)
  String state;

  @HiveField(8)
  String zipCode;

  @HiveField(9)
  List<String> skills;  // Hive can handle basic lists like List<String>

  @HiveField(10)
  String preferences;

  @HiveField(11)
  List<DateTime> availability;  // For DateTime, Hive stores this as a list

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
  });
}