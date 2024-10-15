// Import dummy class
import 'package:testered/counter.dart';
//Service imports
import 'package:testered/services/auth_service.dart';
import 'package:testered/services/db_helper.dart';
import 'package:testered/services/event_service.dart';
import 'package:testered/services/notification_service.dart';
import 'package:testered/services/user_provider.dart';
import 'package:testered/services/user_service.dart';
//Model imports
import 'package:testered/models/custom_nav_bar.dart';
import 'package:testered/models/event_model.dart';
import 'package:testered/models/notification_model.dart';
import 'package:testered/models/user_model.dart';
//Screen imports
import 'package:testered/screens/event_creation_screen.dart';
import 'package:testered/screens/event_display_screen_admin.dart';
import 'package:testered/screens/event_display_screen_user.dart';
import 'package:testered/screens/login_screen.dart';
import 'package:testered/screens/profile_screen_admin.dart';
import 'package:testered/screens/profile_screen_user.dart';
import 'package:testered/screens/recommended_events_screen_admin.dart';
import 'package:testered/screens/recommended_events_screen_user.dart';
import 'package:testered/screens/registration_screen_user.dart';
import 'package:testered/screens/volunteer_display_screen.dart';
//Test import
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
}