import 'package:installation/models/activity.dart';
import 'package:installation/models/agent.dart';
import 'package:installation/models/customer.dart';
import 'package:installation/models/site.dart';

class Order {
  late List<Order> data;
  //late bool state;
  late int id;
  late String work_name;
  late Agent? agent;
  late Customer? customer;
  late Site? site;
  late DateTime? date;
  late String time;
  late String connectionType;
  String? connectionNumber;
  String? charger;
  String? status;
  late String status_key;
  late String new_step;
  List<Activity> activity = [];

  Order.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data.add(Order.fromJson(v));
      });
    }

    id = json['id'];
    work_name = json['work_name'];
    new_step = json['new_step'];
    agent = json['agent'] != null ? Agent.fromJson(json['agent']) : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    site = json['site'] != null ? Site.fromJson(json['site']) : null;
    date = DateTime.parse(json['date']);
    time = json['time'];
    connectionType = json['connection_type'];
    connectionNumber = json['connection_number'];
    charger = json['charger'];
    status = json['status'];
    status_key = json['status_key'];
    //state = json['state'];
    activity = (json['activity'] as List)
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    //data['state'] = state;
    return data;
  }
}
