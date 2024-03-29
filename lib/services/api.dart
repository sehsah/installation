import 'package:dio/dio.dart';
import 'package:get/get.dart' as GET;
import 'package:get_storage/get_storage.dart';

class Api {
  static final dio = Dio(BaseOptions(
      baseUrl: 'http://installation.buzz-storm.com/api/',
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('login_token')}',
      }));

  static Future<Response> login(
      {required Map<String, dynamic> loginData}) async {
    FormData formData = FormData.fromMap(loginData);
    return dio.post('/login', data: formData);
  }

  static Future<Response> register(
      {required Map<String, dynamic> registerData}) async {
    FormData formData = FormData.fromMap(registerData);
    print(formData);
    return dio.post('/users/register', data: formData);
  }

  static Future<Response> VerifiyCode(
      {required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    return dio.post('/users/forgot/confirmation', data: formData);
  }

  static Future<Response> RecovePassword(
      {required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    return dio.post('/users/forgot/change', data: formData);
  }

  static Future<Response> EditProfile(
      {required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    print("formData ${formData}");
    return dio.post('/user/edit', data: formData);
  }

  static Future<Response> ForgetPassword(
      {required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    return dio.post('/users/forgot/password', data: formData);
  }

  static Future<Response> getUser() async {
    return dio.get('/user');
  }

  static Future<Response> AcceptOrder(
      {required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    return dio.post('/order/accept', data: formData);
  }

  static Future<Response> getOrders() {
    var id = GetStorage().read('logged_user')['id'];
    return dio.get('/orders/${id}');
  }

  static Future<Response> OrderDetails(id) async {
    return dio.get('/order/${id}');
  }

  static Future<Response> addLog({required Map<String, dynamic> Data}) async {
    FormData formData = FormData.fromMap(Data);
    print(Data);
    return dio.post('/add/log', data: formData);
  }

  static Future<Response> getNotifications() {
    return dio.get('/notification');
  }

  static Future<Response> deleteNotifications(id) {
    return dio.get('/notification/delete/${id}');
  }
} //end of api
