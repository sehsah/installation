import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/models/order.dart';
import 'package:installation/views/order_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final authController = Get.put(AuthController());
  final homeController = Get.put(HomeController());
  late final users = GetStorage().read('logged_user');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Hello ${users['first_name']} ${users['last_name']}",
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications),
              tooltip: 'Show Snackbar',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_sharp),
              tooltip: 'Show Snackbar',
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            child: posts(
          isLoading: homeController.isLoading.value,
          orders: homeController.orders,
        )),
      );
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return homeController.getOrder();
  }

  Widget posts({
    required bool isLoading,
    required List<Order> orders,
  }) {
    return isLoading == true
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {Get.to(OrderDetails(orders[index]))},
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 2.0),
                                      child: Text(
                                        orders[index].site.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 2.0),
                          child: Text(
                            orders[index].date.toString(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 1.0, left: 8.0, right: 8.0),
                          child: Container(
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }
}
