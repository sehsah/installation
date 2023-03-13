class User {
  late int id;
  late String firstname;
  late String lastname;
  late String mobile;
  late String email;
  late String avatar;
  late String full_name;
  late int building;
  late String apartment;
  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    avatar = json['avatar'];
    mobile = json['mobile'];
    full_name = json['full_name'];
    building = json['building'];
    apartment = json['apartment'];
  }
} //end of model
