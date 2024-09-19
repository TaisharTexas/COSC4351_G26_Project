import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  // Factory constructor for singleton
  factory DBHelper() {
    return _instance;
  }

  // Get the database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    // Define the path to the database file
    String path = join(await getDatabasesPath(), 'volunteer_management.db');

    // Open the database and create it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the tables
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT,
        address1 TEXT,
        address2 TEXT,
        city TEXT,
        state TEXT,
        zipCode TEXT,
        skills TEXT,
        preferences TEXT,
        availability TEXT
      )
    ''');
  }

  // Insert a new user (returns void)
  Future<void> insertUser(User user) async {
    final db = await database;
    try {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace if user exists
      );
    } catch (error) {
      print('Error inserting user: $error');
    }
  }

  // Fetch a user by email and password (returns User? if found, else null)
  Future<User?> getUser(String email, String password) async {
    final db = await database;
    try {
      final maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        return null; // No user found with matching credentials
      }
    } catch (error) {
      print('Error fetching user: $error');
      return null;
    }
  }

  // Fetch a user by email (for registration check)
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    try {
      final maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        return null; // No user found with the given email
      }
    } catch (error) {
      print('Error fetching user by email: $error');
      return null;
    }
  }

  // Update user profile (returns void)
  Future<void> updateUser(User user) async {
    final db = await database;
    try {
      await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (error) {
      print('Error updating user: $error');
    }
  }

  // Get all users (optional - for admin or testing purposes)
  Future<List<User>> getAllUsers() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('users');

      // Convert list of maps to list of User objects
      return List.generate(maps.length, (i) {
        return User.fromMap(maps[i]);
      });
    } catch (error) {
      print('Error fetching all users: $error');
      return [];
    }
  }

  // Delete a user by ID (optional)
  Future<void> deleteUser(String id) async {
    final db = await database;
    try {
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (error) {
      print('Error deleting user: $error');
    }
  }
}