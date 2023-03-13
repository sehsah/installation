import 'package:installation/models/activity.dart';
import 'package:installation/models/agent.dart';
import 'package:installation/models/customer.dart';
import 'package:installation/models/site.dart';

class Order {
  late List<Order> data;
  late bool state;
  late int id;
  late Agent agent;
  late Customer customer;
  late Site site;
  late String date;
  late String time;
  late int connectionType;
  late int connectionNumber;
  late String charger;
  late String status;
  List<Activity> activity = [];

  Order.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data.add(Order.fromJson(v));
      });
    }
    id = json['id'];
    // agent = json['agent'];
    agent = (json['agent'] != null ? Agent.fromJson(json['agent']) : null)!;
    customer = (json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null)!;
    site = (json['site'] != null ? Site.fromJson(json['site']) : null)!;
    date = json['date'];
    time = json['time'];
    connectionType = json['connection_type'];
    connectionNumber = json['connection_number'];
    charger = json['charger'];
    status = json['status'];
    state = json['state'];
    activity = (json['activity'] as List)
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();
    //activity = json['activity'] != null ? Activity.fromJson(json['activity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    data['state'] = state;
    return data;
  }
}