import 'package:hive/hive.dart';  // Make sure to import Hive
import 'package:flutter/foundation.dart';  // Add this line

part 'user_model.g.dart';  // Link the generated code to this file

@HiveType(typeId: 0)
class User {
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
  List<String> skills;

  @HiveField(9)
  String preferences;

  @HiveField(10)
  List<DateTime> availability;

  @HiveField(11)
  List<String> pastEvents;

  User({
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
  });

  // Override the == operator to compare the fields of the object
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.email == email &&
        other.password == password &&
        other.fullName == fullName &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.city == city &&
        other.state == state &&
        other.zipCode == zipCode &&
        listEquals(other.skills, skills) &&   // Use listEquals for list comparison
        other.preferences == preferences &&
        listEquals(other.availability, availability) && // Use listEquals for list comparison
        listEquals(other.pastEvents, pastEvents);  // Use listEquals for list comparison
  }

  @override
  int get hashCode {
    return email.hashCode ^
    password.hashCode ^
    fullName.hashCode ^
    address1.hashCode ^
    address2.hashCode ^
    city.hashCode ^
    state.hashCode ^
    zipCode.hashCode ^
    skills.hashCode ^
    preferences.hashCode ^
    availability.hashCode ^
    pastEvents.hashCode;
  }
}
