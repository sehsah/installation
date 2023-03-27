import 'package:installation/models/notification.dart';

class NotificationResponse {
  List<Notifications> data = [];
  NotificationResponse.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((notificationData) =>
        data.add(Notifications.fromJson(notificationData)));
  }
}
