import 'package:flutter_test/flutter_test.dart';

class Notification {
  final String id;
  final String message;
  final DateTime date;

  Notification({
    required this.id,
    required this.message,
    required this.date,
  });
}

void main() {
  group('Notification Class Tests', () {
    test('should create a Notification instance with correct values', () {
      // Arrange
      const String id = 'notif-001';
      const String message = 'This is a test notification.';
      final DateTime date = DateTime(2024, 11, 22, 14, 30);

      // Act
      final notification = Notification(
        id: id,
        message: message,
        date: date,
      );

      // Assert
      expect(notification.id, id);
      expect(notification.message, message);
      expect(notification.date, date);
    });

    test('should correctly handle different date values', () {
      // Arrange
      final DateTime date1 = DateTime(2024, 1, 1, 0, 0);
      final DateTime date2 = DateTime(2024, 12, 31, 23, 59);

      // Act
      final notification1 = Notification(
        id: 'notif-002',
        message: 'New Year Notification',
        date: date1,
      );

      final notification2 = Notification(
        id: 'notif-003',
        message: 'End of Year Notification',
        date: date2,
      );

      // Assert
      expect(notification1.date, date1);
      expect(notification2.date, date2);
    });
  });
}
