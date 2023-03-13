import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GET;
import 'package:get_storage/get_storage.dart';

class Api {
  static final dio = Dio(
    BaseOptions(
        baseUrl: 'https://www.quikrev.com/ins/api',
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('login_token')}',
        }),
  );

  static void initializeInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        var token = await GetStorage().read('login_token');
        print("token ${token}");
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 12|PmLPUknRPY0i96sslOLR7IPLuOKgqEkDBDoBcLNT',
        };
        request.headers.addAll(headers);
        return handler.next(request); //continue
      },
      onResponse: (response, handler) {
        log('response3 ${response.data}');
        if (response.data['status'] == 200) {
          // GET.Get.snackbar(
          //   'Alert'.tr,
          //   '${response.data['msg']}',
          //   snackPosition: GET.SnackPosition.BOTTOM,
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          // );
        } else if (response.data['status'] == 500) {
          // GET.Get.snackbar(
          //   'Alert'.tr,
          //   '${response.data['msg']}',
          //   snackPosition: GET.SnackPosition.BOTTOM,
          //   backgroundColor: Colors.red,
          //   colorText: Colors.white,
          // );
        }

        return handler.next(response); // continue
      },
      onError: (error, handler) {
        if (GET.Get.isDialogOpen == true) {
          GET.Get.back();
        }

        GET.Get.snackbar(
          'error'.tr,
          '${error.message}',
          snackPosition: GET.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return handler.next(error); //continue
      },
    ));
  }

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
      {required Map<String, dynamic> editProfileData}) async {
    initializeInterceptors();
    FormData formData = FormData.fromMap(editProfileData);

    return dio.post('/user/edit', data: formData);
  }

  static Future<Response> ForgetPassword(
      {required Map<String, dynamic> Data}) async {
    initializeInterceptors();
    FormData formData = FormData.fromMap(Data);
    return dio.post('/users/forgot/password', data: formData);
  }

  static Future<Response> getUser() async {
    return dio.get('/user');
  }

  static Future<Response> AcceptOrder(
      {required Map<String, dynamic> Data}) async {
    initializeInterceptors();
    FormData formData = FormData.fromMap(Data);
    return dio.post('/order/accept', data: formData);
  }

  static Future<Response> getOrders() async {
    return dio.get('/orders');
  }

  static Future<Response> OrderDetails(id) async {
    return dio.get('/order/${id}');
  }
} //end of api
