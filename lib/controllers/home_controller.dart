import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/base_controller.dart';
import 'package:installation/models/order.dart';
import 'package:installation/responses/order_details_response.dart';
import 'package:installation/responses/order_response.dart';
import 'package:installation/services/api.dart';

class HomeController extends GetxController with BaseController {
  RxBool isLoading = true.obs;
  RxList<Order> orders = <Order>[].obs;
  RxList<Order> orders2 = <Order>[].obs;
  final order = Rx<Order?>(null);
  RxBool isLoadingDetails = true.obs;

  @override
  void onInit() {
    super.onInit();
    getOrder();
  }

  Future<void> refreshData() async {
    await getOrder();
  }

  Future<void> getOrder() async {
    isLoading.value = true;
    orders.clear();
    orders2.clear();
    var response = await Api.getOrders();
    var orderResponse = OrderResponse.fromJson(response.data);
    orders.addAll(orderResponse.data);
    orders2.addAll(orderResponse.data2);
    isLoading.value = false;
  }

  getOrderDetails(id) async {
    isLoadingDetails.value = true;
    try {
      var response = await Api.OrderDetails(id);
      var orderResponse = OrderResponseDetails.fromJson(response.data);
      order.value = orderResponse.data;
    } catch (error) {
      print("Error: $error");
    }
    isLoadingDetails.value = false;
  }

  Future<void> addLog({required Data, context}) async {
    showLoading();
    var response = await Api.addLog(Data: Data);
    await Api.OrderDetails(Data['order_id']);
    hideLoading();
    getOrderDetails(Data['order_id']);

    if (response.data['state'] == true) {
      _showDialog("Your Comment Added", context);
    }
  }

  Future<void> AcceptOrder({required Data, context}) async {
    showLoading();
    var response = await Api.AcceptOrder(Data: Data);
    hideLoading();
    getOrder();
    if (response.data['state'] == true) {
      _showDialog("Approved successfully", context);
    }
  }

  _showDialog(msg, context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: FxText.titleMedium('Success', fontWeight: 600),
          content: Container(
            margin: FxSpacing.top(16),
            child: FxText.bodyLarge(msg, fontWeight: 400),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: FxText.titleMedium('OK',
                  color: Palette.maincolor,
                  fontWeight: 700,
                  letterSpacing: 0.3),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
