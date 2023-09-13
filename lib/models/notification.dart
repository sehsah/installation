class Notifications {
  late int id;
  late int order_id;
  late String title;
  late String message;
  late int userId;
  late String date;
  late String updatedAt;

  Notifications();

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order_id = json['order_id'];
    title = json['title'];
    message = json['message'];
    date = json['date'];
  }
}
