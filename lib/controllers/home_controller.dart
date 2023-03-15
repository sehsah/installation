import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/base_controller.dart';
import 'package:installation/models/order.dart';
import 'package:installation/responses/order_response.dart';
import 'package:installation/services/api.dart';

class HomeController extends GetxController with BaseController {
  RxBool isLoading = true.obs;
  RxList<Order> orders = <Order>[].obs;
  RxList<Order> orders2 = <Order>[].obs;

  @override
  void onInit() {
    getOrder();
    super.onInit();
  }

  Future<void> getOrder() async {
    isLoading.value = true;
    var response = await Api.getOrders();
    var orderResponse = OrderResponse.fromJson(response.data);
    orders.addAll(orderResponse.data);
    orders2.addAll(orderResponse.data2);
    isLoading.value = false;
  }

  Future<void> getOrderDetails(id) async {
    var response = await Api.OrderDetails(id);
    return response.data;
  }

  Future<void> addLog({required Data, context}) async {
    showLoading();
    var response = await Api.addLog(Data: Data);
    await Api.OrderDetails(Data['order_id']);
    hideLoading();
    if (response.data['state'] == true) {
      _showDialog(context);
    }
  }

  _showDialog(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: FxText.titleMedium('Success', fontWeight: 600),
          content: Container(
            margin: FxSpacing.top(16),
            child: FxText.bodyLarge('Your Comment Added', fontWeight: 400),
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
