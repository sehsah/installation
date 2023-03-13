import 'package:installation/models/order.dart';

class OrderResponse {
  List<Order> data = [];

  OrderResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    json['data'].forEach((orders) => data.add(Order.fromJson(orders)));
  }
} //end of response
