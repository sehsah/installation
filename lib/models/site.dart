class Site {
  late int id;
  late String createdAt;
  late String updatedAt;
  late int type;
  late int customer;
  late String name;
  late String apartmentNumber;
  late String street;
  late String additionalDirection;
  late String city;
  late String country;
  late String lat;
  late String long;

  Site.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    customer = json['customer'];
    name = json['name'];
    apartmentNumber = json['apartment_number'];
    street = json['street'];
    additionalDirection = json['additional_direction'];
    city = json['city'];
    country = json['country'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['customer'] = this.customer;
    data['name'] = this.name;
    data['apartment_number'] = this.apartmentNumber;
    data['street'] = this.street;
    data['additional_direction'] = this.additionalDirection;
    data['city'] = this.city;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
