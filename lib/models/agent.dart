class Agent {
  late int id;
  late int roleId;
  late String firstName;
  late String email;
  late String avatar;
  late String type;
  late String createdAt;
  late String updatedAt;
  late String lastName;
  late String phone;
  late String company;

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    firstName = json['first_name'];
    email = json['email'];
    avatar = json['avatar'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastName = json['last_name'];
    phone = json['phone'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['company'] = this.company;
    return data;
  }
}
