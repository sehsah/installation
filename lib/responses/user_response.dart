import 'package:get_storage/get_storage.dart';
import 'package:installation/models/user.dart';

class UserResponse {
  late User user;
  late String? token;

  UserResponse.fromJson(Map<String, dynamic> json) {
    GetStorage().write('logged_user', json['data']);
    user = User.fromJson(json['data']);
    token = json['data']['access_token'];
  }
} //end of response
