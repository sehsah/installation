import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/models/order.dart';
import 'package:installation/views/notification.dart';
import 'package:installation/views/order_details.dart';
import 'package:installation/views/profile.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final homeController = Get.put(HomeController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late final users = GetStorage().read('logged_user');

  @override
  void initState() {
    super.initState();
    print('Home initState called');
    homeController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Hello ${users['first_name']} ${users['last_name']}",
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Get.to(NotificationPage());
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_sharp),
                onPressed: () {
                  Get.to(Profile());
                },
              )
            ],
          ),
          body: SmartRefresher(
            enablePullUp: true,
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: null,
            footer:
                CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("pull up load");
              } else {
                body = Text("");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            }),
            child: SingleChildScrollView(
              child: Container(
                color: Color.fromARGB(255, 243, 243, 243),
                child: Padding(
                  padding: FxSpacing.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FxSpacing.height(16),
                      FxText.titleMedium(
                        'New Orders',
                        letterSpacing: 0.5,
                        fontWeight: 700,
                      ),
                      FxSpacing.height(16),
                      Container(
                          child: posts(
                        isLoading: homeController.isLoading.value,
                        orders: homeController.orders2,
                      )),
                      FxSpacing.height(16),
                      FxText.titleMedium(
                        'My Orders',
                        letterSpacing: 0.5,
                        fontWeight: 700,
                      ),
                      FxSpacing.height(16),
                      Container(
                          child: posts(
                        isLoading: homeController.isLoading.value,
                        orders: homeController.orders,
                      )),
                      FxSpacing.height(24),
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return homeController.getOrder();
  }

  void _onLoading() async {
    print(2);
    // homeController.getOrder();
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    homeController.getOrder();
    _refreshController.refreshCompleted();
  }

  Widget posts({
    required isLoading,
    required List<Order> orders,
  }) {
    return isLoading == true
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : orders.isNotEmpty
            ? SingleChildScrollView(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: orders.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () => {Get.to(OrderDetails(orders[index].id))},
                        child: FxContainer.bordered(
                          color: Colors.white,
                          paddingAll: 16,
                          borderRadiusAll: 16,
                          child: Row(
                            children: [
                              FxContainer(
                                  width: 56,
                                  padding: FxSpacing.y(12),
                                  borderRadiusAll: 4,
                                  bordered: true,
                                  color: Color.fromARGB(0, 0, 0, 0),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FxText.bodyMedium(
                                          "${orders[index].date!.month}" +
                                              "/" +
                                              DateFormat('d')
                                                  .format(orders[index].date!),
                                          fontWeight: 700,
                                        ),
                                        FxText.bodySmall(
                                          DateFormat('EEE')
                                              .format(orders[index].date!),
                                          fontWeight: 600,
                                        ),
                                      ],
                                    ),
                                  )),
                              FxSpacing.width(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        FxText.bodySmall(
                                          orders[index].customer!.firstName ??
                                              '',
                                          fontWeight: 600,
                                        ),
                                        FxSpacing.width(4),
                                        FxText.bodySmall(
                                          orders[index].customer!.lastName ??
                                              '',
                                          fontWeight: 600,
                                        ),
                                      ],
                                    ),
                                    FxSpacing.height(4),
                                    FxText.bodySmall(
                                      orders[index].status ?? '',
                                      fontSize: 10,
                                    ),
                                    FxSpacing.height(4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                        ),
                                        FxSpacing.width(2),
                                        FxText.bodySmall(
                                          orders[index].site != null
                                              ? orders[index].site!.city
                                              : '',
                                          fontSize: 10,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              FxSpacing.width(16),
                              FxContainer.rounded(
                                paddingAll: 4,
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return FxSpacing.height(16);
                  },
                ),
              )
            : Center(child: Text("No Orders"));
  }
}
