class Activity {
  late int id;
  late String comment;
  late String image1;
  late String image2;
  late String image3;
  late String name;
  late String date;
  late int cableLength;
  late int pvcLength;
  late String cableType;
  late String breaker;
  late int consumptionMeter;
  late String industrialSocket;
  late int isolator;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    data['cable_length'] = this.cableLength;
    data['pvc_length'] = this.pvcLength;
    data['cable_type'] = this.cableType;
    data['breaker'] = this.breaker;
    data['consumption_meter'] = this.consumptionMeter;
    data['Industrial_socket'] = this.industrialSocket;
    data['isolator'] = this.isolator;
    return data;
  }
}
