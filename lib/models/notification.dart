class Notifications {
  late int id;
  late String title;
  late String message;
  late int userId;
  late String createdAt;
  late String updatedAt;

  Notifications();

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    createdAt = json['date'];
  }
}
