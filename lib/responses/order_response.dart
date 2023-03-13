import 'package:installation/models/order.dart';

class OrderResponse {
  List<Order> data = [];
  List<Order> data2 = [];
  OrderResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    json['data'].forEach((orders) => data.add(Order.fromJson(orders)));
    json['data2'].forEach((orders2) => data2.add(Order.fromJson(orders2)));
  }
} //end of response
