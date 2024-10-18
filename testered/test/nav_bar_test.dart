import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:testered/models/custom_nav_bar.dart';
import 'package:testered/services/user_service.dart';
import 'package:testered/services/user_provider.dart';
import 'package:testered/models/user_model.dart';

// Mock UserService to return admin user without Hive dependency
class MockUserService extends Mock implements UserService {}

// Mock UserProvider for test
class MockUserProvider extends ChangeNotifier implements UserProvider {
  String _email = 'admin@test.com';
  bool _hasShownUpcomingEventsNotification = false;

  @override
  String get email => _email;

  @override
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  @override
  bool get hasShownUpcomingEventsNotification => _hasShownUpcomingEventsNotification;

  @override
  void setHasShownUpcomingEventsNotification(bool hasShown) {
    _hasShownUpcomingEventsNotification = hasShown;
    notifyListeners();
  }
}

void main() {
  // Test for CustomNavBar Admin Login displaying the correct welcome message for admin user
  testWidgets('displays correct welcome message for admin user', (WidgetTester tester) async {
    // Mock UserService and UserProvider
    final mockUserService = MockUserService();
    final mockUserProvider = MockUserProvider();

    // Create a mock admin user
    final adminUser = User(email: 'admin@test.com', fullName: 'Admin User', isAdmin: true, password: '');

    // Mock the getUserByEmail method to return the admin user
    when(mockUserService.getUserByEmail('admin@test.com')).thenReturn(adminUser);

    // Build the widget and pump
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
          Provider<UserService>.value(value: mockUserService),
        ],
        child: MaterialApp(
          home: Scaffold(
            appBar: CustomNavBar(email: 'admin@test.com'),
          ),
        ),
      ),
    );

    // Check if the correct admin text is displayed
    expect(find.text('Welcome, admin@test.com (admin)'), findsOneWidget);
  });
}