class User {
  late int id;
  String? first_name;
  String? last_name;
  String? phone;
  late String email;
  late String avatar;
  late String full_name;
  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
  }
} //end of model
