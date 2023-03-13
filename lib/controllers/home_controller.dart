import 'package:get/get.dart';
import 'package:installation/models/order.dart';
import 'package:installation/responses/order_response.dart';
import 'package:installation/services/api.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  List<Order> orders = [];
  var isDisabled = true.obs;

  @override
  void onInit() {
    getOrder();
    super.onInit();
  }

  Future<void> getOrder() async {
    isLoading.value = true;
    var response = await Api.getOrders();
    var userResponse = OrderResponse.fromJson(response.data);
    orders.addAll(userResponse.data);
    isLoading.value = false;
  }
}