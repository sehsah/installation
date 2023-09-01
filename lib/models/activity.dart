class Activity {
  late int id;
  late String comment;
  String? image1;
  String? image2;
  String? image3;
  String? name;
  String? date;
  String? cableLength;
  String? pvcLength;
  String? cableType;
  String? breaker;
  String? consumptionMeter;
  String? industrialSocket;
  String? isolator;

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    cableLength = json['cable_length'];
    name = json['user'];
    date = json['date'];
    pvcLength = json['pvc_length'];
    cableType = json['cable_type'];
    breaker = json['breaker'];
    consumptionMeter = json['consumption_meter'];
    industrialSocket = json['Industrial_socket'];
    isolator = json['isolator'];
  }
}
