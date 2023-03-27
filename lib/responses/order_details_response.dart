import 'package:installation/models/order.dart';

class OrderResponseDetails {
  late Order data;

  OrderResponseDetails();

  OrderResponseDetails.fromJson(Map<String, dynamic> json) {
    print(json['data']);
    data = Order.fromJson(json['data']);
  }
}
