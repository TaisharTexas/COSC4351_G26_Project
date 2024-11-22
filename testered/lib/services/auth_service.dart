import '../models/user_model.dart';
import 'db_helper.dart';

class AuthService {
  final DBHelper dbHelper;

  AuthService({required this.dbHelper});

  Future<User?> login(String email, String password) async {
    return await dbHelper.getUser(email, password);
  }

  Future<bool> registerUser(String email, String password) async {
    User? existingUser = await dbHelper.getUserByEmail(email);

    if (existingUser != null) {
      return false;
    }

    User newUser = User(email: email, password: password);
    await dbHelper.insertUser(newUser);
    return true;
  }

  Future<bool> registerUserFull(String email, String password, String name, String address1, String address2, String city, String zipcode, String state, List<String> skills) async {
    User? existingUser = await dbHelper.getUserByEmail(email);

    if (existingUser != null) {
      return false;
    }

    User newUser = User(
      email: email,
      password: password,
      fullName: name,
      address1: address1,
      address2: address2,
      city: city,
      zipCode: zipcode,
      state: state,
      skills: skills,
    );

    await dbHelper.insertUser(newUser);
    return true;
  }
}
