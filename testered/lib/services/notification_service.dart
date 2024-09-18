import '../models/notification_model.dart';

class NotificationService {
  final List<Notification> _notifications = [];

  void addNotification(String message) {
    _notifications.add(Notification(
      id: DateTime.now().toString(),
      message: message,
      date: DateTime.now(),
    ));
  }

  List<Notification> getNotifications() {
    return _notifications;
  }
}