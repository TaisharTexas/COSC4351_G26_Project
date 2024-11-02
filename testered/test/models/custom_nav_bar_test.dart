//flutter test test/models/custom_nav_bar_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:testered/models/user_model.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/profile_screen.dart';
import 'package:testered/services/user_provider.dart';
import 'package:testered/models/custom_nav_bar.dart';

class MockUserProvider extends Mock implements UserProvider {
  @override
  String get email => 'test@example.com'; // Provide a non-null email value
}

void main() {
  // Helper function to create the CustomNavBar widget with necessary providers
  Widget createWidgetUnderTest(String email) {
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => MockUserProvider(),
      child: MaterialApp(
        home: Scaffold(
          appBar: CustomNavBar(email: email),
        ),
        routes: {
          '/eventList': (_) => Scaffold(body: Text('Event List Screen')),
          '/eventCreate': (_) => Scaffold(body: Text('Create Event Screen')),
          '/volunteerListMatch': (_) => Scaffold(body: Text('Volunteer List Match Screen')),
          '/volunteerDisplay': (_) => Scaffold(body: Text('Volunteer Display Screen')),
        },
      ),
    );
  }

  testWidgets('CustomNavBar displays user email and buttons', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: createWidgetUnderTest('test@example.com'),
      ),
    );

    // Verify the email displays in the AppBar title
    expect(find.text('Welcome, test@example.com'), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Create Event'), findsOneWidget);
    expect(find.text('Volunteer-Event Matches'), findsOneWidget);
    expect(find.text('Volunteer History'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('Profile button navigates to ProfileScreen if user exists', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();

    // Mock user with required fields
    final mockUser = User(email: 'test@example.com', password: 'mockPassword');

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: createWidgetUnderTest('test@example.com'),
      ),
    );

    // Tap the 'Profile' button
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify navigation to ProfileScreen
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('Logout button clears email and navigates to LoginScreen', (WidgetTester tester) async {
    final mockUserProvider = MockUserProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<UserProvider>.value(
        value: mockUserProvider,
        child: createWidgetUnderTest('test@example.com'),
      ),
    );

    // Tap the logout icon button
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Verify email was cleared in UserProvider
    verify(mockUserProvider.setEmail('')).called(1);

    // Verify navigation to LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
