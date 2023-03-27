import 'package:get/get.dart';
import 'package:installation/controllers/base_controller.dart';
import 'package:installation/responses/notification_response.dart';
import 'package:installation/services/api.dart';
import 'package:installation/models/notification.dart';

class NotificationController extends GetxController with BaseController {
  RxBool isLoading = true.obs;
  List<Notifications> notifications = <Notifications>[];

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    isLoading.value = true;
    notifications.clear();
    var response = await Api.getNotifications();
    var ResponseData = NotificationResponse.fromJson(response.data);
    notifications.addAll(ResponseData.data);
    isLoading.value = false;
  }

  Future<void> deleteNotification(id) async {
    isLoading.value = true;
    await Api.deleteNotifications(id);
    getData();
    isLoading.value = false;
  }
}
