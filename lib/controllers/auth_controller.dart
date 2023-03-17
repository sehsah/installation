import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:installation/models/user.dart';
import 'package:installation/responses/user_response.dart';
import 'package:installation/services/api.dart';
import 'package:installation/views/home.dart';
import 'package:installation/views/login.dart';
import 'package:installation/views/profile.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'base_controller.dart';

class AuthController extends GetxController with BaseController {
  var user = User().obs;
  var isLoggedIn = false.obs;
  final Map<String, dynamic> _Data = {};
  @override
  void onInit() async {
    //redirect();
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('login_token');
    if (token != null) {
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => Login());
    }
  } //end of redirect

  Future<void> login(
      {required Map<String, dynamic> loginData, required context}) async {
    showLoading();
    loginData['token'] = GetStorage().read("notification_token");
    var response = await Api.login(loginData: loginData);
    if (response.data['state'] == false) {
      hideLoading();
      GFToast.showToast(
        response.data['msg'],
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    } else {
      var userResponse = UserResponse.fromJson(response.data);
      GetStorage().write('login_token', userResponse.token);
      // user.value = userResponse.user;
      // isLoggedIn.value = true;
      hideLoading();

      Get.off(() => Home());
    }
  } //end of login

  Future<void> register(
      {required Map<String, dynamic> registerData, required context}) async {
    showLoading();
    var response = await Api.register(registerData: registerData);
    print(response.data['status']);
    if (response.data['status'] == 500) {
      hideLoading();
      GFToast.showToast(
        response.data['msg'],
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    } else if (response.data['status'] == 200) {
      var userResponse = UserResponse.fromJson(response.data);
      await GetStorage().write('login_token', userResponse.token);
      user.value = userResponse.user;
      isLoggedIn.value = true;
      Get.offAll(() => Home());
      hideLoading();
    }
  } //end of login

  Future<void> EditProfileData(
      {required Map<String, dynamic> Data, required context}) async {
    showLoading();
    print("Data ${Data}");
    var response = await Api.EditProfile(Data: Data);
    UserResponse.fromJson(response.data);
    hideLoading();
    GFToast.showToast(
      response.data['msg'],
      context,
      toastPosition: GFToastPosition.BOTTOM,
    );
    Get.offAll(() => Profile());
  }

  Future<void> ForgetPassword(
      {required Map<String, dynamic> Data, context}) async {
    showLoading();
    print(Data['email']);

    var response = await Api.ForgetPassword(Data: Data);
    hideLoading();
    GFToast.showToast(
      response.data['msg'],
      context,
      toastPosition: GFToastPosition.BOTTOM,
    );
    if (response.data['status'] == 200) {}
  }

  Future<void> verifiyCode(
      {required Map<String, dynamic> Data, context}) async {
    showLoading();
    var response = await Api.VerifiyCode(Data: Data);
    hideLoading();

    GFToast.showToast(
      response.data['msg'],
      context,
      toastPosition: GFToastPosition.BOTTOM,
    );
    if (response.data['status'] == 200) {}
  }

  Future<void> recovePassword(
      {required Map<String, dynamic> Data, context}) async {
    showLoading();
    var response = await Api.RecovePassword(Data: Data);
    hideLoading();
    GFToast.showToast(
      response.data['msg'],
      context,
      toastPosition: GFToastPosition.BOTTOM,
    );
    Get.to(() => Login());
  }

  Future<void> logout() async {
    await GetStorage().remove('login_token');
    GetStorage().remove('logged_user');
    isLoggedIn.value = false;
    Get.off(() => Login());
  } //end of logout

  Future<void> getUser() async {
    print("getUser");
    var response = await Api.getUser();
    var userResponse = UserResponse.fromJson(response.data);
    user.value = userResponse.user;
    isLoggedIn.value = true;
  }
} //end o