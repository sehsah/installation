import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetails extends StatefulWidget {
  final int id;
  const OrderDetails(this.id);
  @override
  // ignore: library_private_types_in_public_api
  _OrderDetails createState() => _OrderDetails();
}

class _OrderDetails extends State<OrderDetails>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(AuthController());
  final homeController = Get.put(HomeController());
  late bool consumption_meter, industrial_socket, isolator;
  TabController? _tabController;
  int _currentIndex = 0;
  late int _currentStep = 0;
  late ThemeData theme;
  File? image1;
  File? image2;
  File? image3;
  String cable_type = "63";
  String breaker = "S32";
  final _commentController = TextEditingController();
  final _cable_lengthController = TextEditingController();
  final _pvc_lengthController = TextEditingController();
  final Map<String, dynamic> _ActionData = {};
  final Map<String, dynamic> _Data = {};

  @override
  void initState() {
    theme = AppTheme.theme;
    consumption_meter = false;
    industrial_socket = false;
    isolator = false;
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.animation!.addListener(() {
      final aniValue = _tabController!.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    homeController.getOrderDetails(widget.id);
    super.initState();
  }

  List<DropdownMenuItem<String>> get dropdownItemsBreaker {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "S32", child: Text("Single Phase 32A")),
      DropdownMenuItem(value: "S40", child: Text("Single Phase 40A")),
      DropdownMenuItem(value: "T40", child: Text("Three Phases 40A")),
      DropdownMenuItem(value: "T63", child: Text("Three Phases 63A")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsCableType {
    List<DropdownMenuItem<String>> menuItems2 = [
      DropdownMenuItem(value: "63", child: Text("6.0mm 3-Core")),
      DropdownMenuItem(value: "10-3", child: Text("10.0mm 3-Core")),
      DropdownMenuItem(value: "6-3", child: Text("6.0mm 5-Core")),
      DropdownMenuItem(value: "10-5", child: Text("10.0mm 5-Core")),
    ];
    return menuItems2;
  }

  Future<void> _showChoiceDialog(
      BuildContext context, Function(File?) setImage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Select Option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openImagePicker(context, setImage);
                    },
                    title: Text(
                      "gallery",
                    ),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context, setImage);
                    },
                    title: Text(
                      "camera",
                    ),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _openImagePicker(
      BuildContext context, Function(File?) nameImg) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        nameImg(File(pickedFile.path));
      }
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('faild ${e}');
    }
  }

  Future<void> _openCamera(
      BuildContext context, Function(File?) nameImg) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 150,
        imageQuality: 90,
      );
      if (pickedFile != null) {
        nameImg(File(pickedFile.path));
      }

      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('faild ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Palette.maincolor,
              ),
              foregroundColor: Palette.maincolor,
              title: Text('Order Details'),
              backgroundColor: Colors.white,
              bottom: TabBar(
                  tabs: [
                    Tab(text: "customer"),
                    Tab(text: "Site"),
                    Tab(text: "Details"),
                    Tab(text: "Actions"),
                    Tab(text: "Logs"),
                  ],
                  labelColor: Palette.maincolor,
                  indicatorColor: Palette.maincolor,
                  unselectedLabelColor: Colors.black),
            ),
            body: homeController.isLoadingDetails.value
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: customerWdiget()),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: SiteWdiget()),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: DetailsWdiget()),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: ActionsWdiget()),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: LogWdiget()),
                    ],
                  ),
          ),
        ));
  }

  Widget DetailsWidget({
    required isLoading,
    required orders,
  }) {
    return Column(
      children: [Text(orders.toString())],
    );
  }

  Widget customerWdiget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
          child: Text("Customer Information",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: 5, top: 10),
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("First Name :",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w500)),
                ),
                Text(homeController.order.value!.customer!.firstName,
                    style: TextStyle(fontSize: 14.0))
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Last Name : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(homeController.order.value!.customer!.lastName,
                      style: TextStyle(fontSize: 14.0)),
                ],
              ),
            )),
        Container(
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Mobile Number :",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(homeController.order.value!.customer!.phone,
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Email Address :",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(homeController.order.value!.customer!.email,
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Palette.maincolor, // Background color
                ),
                onPressed: () =>
                    openDialPad(homeController.order.value!.customer!.phone),
                child: Row(
                  children: [
                    Icon(MdiIcons.phone, size: 20),
                    FxSpacing.width(5),
                    Text('Call Phone '),
                  ],
                ),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Palette.maincolor, // Background color
                ),
                onPressed: () => launchWhatsApp(
                    '971${homeController.order.value!.customer!.phone}'),
                child: Row(
                  children: [
                    Icon(MdiIcons.whatsapp, size: 20),
                    FxSpacing.width(5),
                    Text('whatapp'),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget SiteWdiget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
            child: Text("Site Information",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 5),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Site Name ".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(homeController.order.value!.site!.name,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal)),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 0, top: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Apartment Number".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "${homeController.order.value!.site!.apartmentNumber}",
                        style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 0, top: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Street Name".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("${homeController.order.value!.site!.street}",
                        style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 0, top: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Additional Direction".toUpperCase(),
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "${homeController.order.value!.site!.additionalDirection}",
                        style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("City : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text("${homeController.order.value!.site!.city}",
                        style: TextStyle(fontSize: 14.0)),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Country : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${homeController.order.value!.site!.country}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin:
                EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Palette.maincolor, // Background color
              ),
              onPressed: () => _openMaps(),
              child: Text('Open Location '),
            ),
          ),
        ],
      ),
    );
  }

  Widget DetailsWdiget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
            child: Text("Order Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Work Order : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${homeController.order.value!.work_name}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Work Order Status : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${homeController.order.value?.status}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Assigned To: ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${homeController.order.value!.agent?.firstName}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Preferred Date : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(
                      "${homeController.order.value!.date!.weekday}/${homeController.order.value!.date!.month}/${homeController.order.value!.date!.year}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Preferred Time : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(" ${homeController.order.value!.time}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Connection Type : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(" ${homeController.order.value!.connectionType}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Connection Number : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(" ${homeController.order.value!.connectionNumber}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: 5, top: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Charger : ",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(" ${homeController.order.value!.charger}",
                      style: TextStyle(fontSize: 14.0))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ActionsWdiget() {
    print(homeController.order.value!.agent);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: homeController.order.value!.status_key == "COMPLETED"
                ? Center(
                    child: Text(
                    "This Site is Completed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                : homeController.order.value!.agent != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              labelText: "Comment",
                              border: theme.inputDecorationTheme.border,
                              enabledBorder: theme.inputDecorationTheme.border,
                              focusedBorder:
                                  theme.inputDecorationTheme.focusedBorder,
                            ),
                          ),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _cable_lengthController,
                                    decoration: InputDecoration(
                                      labelText: "Cable Length",
                                      border: theme.inputDecorationTheme.border,
                                      enabledBorder:
                                          theme.inputDecorationTheme.border,
                                      focusedBorder: theme
                                          .inputDecorationTheme.focusedBorder,
                                    ),
                                  ),
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _pvc_lengthController,
                                    decoration: InputDecoration(
                                      labelText: "PVC Trunking Length",
                                      border: theme.inputDecorationTheme.border,
                                      enabledBorder:
                                          theme.inputDecorationTheme.border,
                                      focusedBorder: theme
                                          .inputDecorationTheme.focusedBorder,
                                    ),
                                  ),
                                )
                              : Container(),
                          FxSpacing.height(10),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? DropdownButton(
                                  isExpanded: true,
                                  value: '63',
                                  items: dropdownItemsCableType,
                                  onChanged: (value) {
                                    setState(() {
                                      cable_type = value!;
                                    });
                                  },
                                )
                              : Container(),
                          FxSpacing.height(10),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? DropdownButton(
                                  isExpanded: true,
                                  value: 'S32',
                                  items: dropdownItemsBreaker,
                                  onChanged: (value) {
                                    setState(() {
                                      breaker = value!;
                                    });
                                  },
                                )
                              : Container(),
                          FxSpacing.height(10),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? SwitchListTile(
                                  activeColor: Palette.maincolor,
                                  dense: true,
                                  contentPadding: FxSpacing.zero,
                                  title: FxText.bodyMedium(
                                    "Consumption Meter",
                                    letterSpacing: 0,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      consumption_meter == false
                                          ? consumption_meter = true
                                          : consumption_meter = false;
                                    });
                                  },
                                  value: consumption_meter,
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? SwitchListTile(
                                  activeColor: Palette.maincolor,
                                  dense: true,
                                  contentPadding: FxSpacing.zero,
                                  title: FxText.bodyMedium(
                                    "Industrial Socket",
                                    letterSpacing: 0,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      industrial_socket == false
                                          ? industrial_socket = true
                                          : industrial_socket = false;
                                    });
                                  },
                                  value: industrial_socket,
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? SwitchListTile(
                                  activeColor: Palette.maincolor,
                                  dense: true,
                                  contentPadding: FxSpacing.zero,
                                  title: FxText.bodyMedium(
                                    "Isolator",
                                    letterSpacing: 0,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      isolator == false
                                          ? isolator = true
                                          : isolator = false;
                                    });
                                  },
                                  value: isolator,
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: GFBorder(
                                    radius: Radius.circular(20),
                                    color: Palette.maincolor,
                                    dashedLine: [3, 0],
                                    child: InkWell(
                                      onTap: () {
                                        _showChoiceDialog(context, (image) {
                                          setState(() {
                                            image1 = image;
                                          });
                                        });
                                      },
                                      child: image1 == null
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              color: Palette.maincolor,
                                              child: Center(
                                                  child: GFButton(
                                                textColor: Colors.white,
                                                onPressed: null,
                                                color: Palette.maincolor,
                                                text: "Upload File",
                                                icon: Icon(
                                                  Icons.upload,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showChoiceDialog(context,
                                                    (image) {
                                                  setState(() {
                                                    image1 = image;
                                                  });
                                                });
                                              },
                                              child: Image.file(
                                                image1!,
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: GFBorder(
                                    radius: Radius.circular(20),
                                    color: Palette.maincolor,
                                    dashedLine: [3, 0],
                                    child: InkWell(
                                      onTap: () {
                                        _showChoiceDialog(context, (image) {
                                          setState(() {
                                            image2 = image;
                                          });
                                        });
                                      },
                                      child: image2 == null
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              color: Palette.maincolor,
                                              child: Center(
                                                  child: GFButton(
                                                textColor: Colors.white,
                                                onPressed: null,
                                                color: Palette.maincolor,
                                                text: "Upload File",
                                                icon: Icon(
                                                  Icons.upload,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showChoiceDialog(context,
                                                    (image) {
                                                  setState(() {
                                                    image2 = image;
                                                  });
                                                });
                                              },
                                              child: Image.file(
                                                image2!,
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              : Container(),
                          homeController.order.value!.status ==
                                  'Customer Contacted'
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: GFBorder(
                                    radius: Radius.circular(20),
                                    color: Palette.maincolor,
                                    dashedLine: [3, 0],
                                    child: InkWell(
                                      onTap: () {
                                        _showChoiceDialog(context, (image) {
                                          setState(() {
                                            image3 = image;
                                          });
                                        });
                                      },
                                      child: image3 == null
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              color: Palette.maincolor,
                                              child: Center(
                                                  child: GFButton(
                                                textColor: Colors.white,
                                                onPressed: null,
                                                color: Palette.maincolor,
                                                text: "Upload File",
                                                icon: Icon(
                                                  Icons.upload,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                _showChoiceDialog(context,
                                                    (image) {
                                                  setState(() {
                                                    image3 = image;
                                                  });
                                                });
                                              },
                                              child: Image.file(
                                                image3!,
                                                width: 100.0,
                                                height: 100.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        theme.colorScheme.primary.withAlpha(28),
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_commentController.text == "") {
                                      Get.snackbar(
                                        "Error",
                                        "Please Enter Comment",
                                      );
                                      return;
                                    }
                                    _ActionData['comment'] =
                                        _commentController.text;
                                    _ActionData['cable_length'] =
                                        _cable_lengthController.text;
                                    _ActionData['pvc_length'] =
                                        _pvc_lengthController.text;
                                    _ActionData['cable_type'] = cable_type;
                                    _ActionData['breaker'] = breaker;
                                    _ActionData['consumption_meter'] =
                                        consumption_meter == false ? 0 : 1;
                                    _ActionData['industrial_socket'] =
                                        industrial_socket == false ? 0 : 1;
                                    _ActionData['isolator'] =
                                        isolator == false ? 0 : 1;
                                    _ActionData['user_id'] = GetStorage()
                                        .read('logged_user')['id']
                                        .toString();
                                    _ActionData['order_id'] =
                                        homeController.order.value!.id;
                                    _ActionData['image1'] = image1 != null
                                        ? getBase64FormateFile(image1!)
                                        : "";
                                    _ActionData['image2'] = image2 != null
                                        ? getBase64FormateFile(image2!)
                                        : "";
                                    _ActionData['image3'] = image3 != null
                                        ? getBase64FormateFile(image3!)
                                        : "";
                                    print(_ActionData);
                                    homeController.addLog(
                                        Data: _ActionData, context: context);
                                    _commentController.clear();
                                    _pvc_lengthController.clear();
                                    cable_type = "null";
                                    breaker = "null";
                                    consumption_meter = false;
                                    industrial_socket = false;
                                    isolator = false;
                                    image1 = null;
                                    image2 = null;
                                    image3 = null;
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Palette.maincolor),
                                      padding: MaterialStateProperty.all(
                                          FxSpacing.xy(16, 0))),
                                  child: FxText.bodyMedium(
                                      "Update To ${homeController.order.value!.new_step}",
                                      fontWeight: 700,
                                      letterSpacing: 0.2,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          _Data['id'] = homeController.order.value!.id;
                          homeController.AcceptOrder(Data: _Data);
                        },
                        child: FxButton(
                          backgroundColor: Palette.maincolor,
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  dynamic getBase64FormateFile(path) {
    String base64Image = base64Encode(path.readAsBytesSync());
    return 'data:image/jpeg;base64,$base64Image';
  }

  Widget LogWdiget() {
    return Container(
      height: 200,
      child: homeController.order.value!.activity.isNotEmpty
          ? Stepper(
              physics: ClampingScrollPhysics(),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container();
              },
              currentStep: _currentStep,
              onStepTapped: (pos) {
                setState(() {
                  _currentStep = pos;
                });
              },
              steps: <Step>[
                for (int i = 0;
                    i < homeController.order.value!.activity.length;
                    i++)
                  Step(
                    isActive: true,
                    state: StepState.complete,
                    title: FxText.bodyLarge(
                        homeController.order.value!.activity[i].comment,
                        fontWeight: 600),
                    content: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(MdiIcons.account, size: 24),
                        FxSpacing.width(10),
                        FxText.bodyMedium(
                            "${homeController.order.value!.activity[i].name}  | ${homeController.order.value!.activity[i].date}",
                            fontWeight: 400)
                      ],
                    ),
                  ),
              ],
            )
          : Container(),
    );
  }

  openDialPad(String phoneNumber) async {
    String url = 'tel://' + phoneNumber;
    launch(url);
  }

  launchWhatsApp(String phoneNumber) async {
    if (Platform.isAndroid) {
      launchUrl(Uri.parse("whatsapp://send?phone=${phoneNumber}&text=hi"));
    } else {
      launchUrl(
        Uri.parse(
          'whatsapp://send?phone=${phoneNumber}', //put your number here
        ),
      );
    }
  }

  Future<void> _openMaps() async {
    Uri googleMapsUrl = Uri.parse(
        "google.navigation:q=${homeController.order.value!.site!.lat},${homeController.order.value!.site!.long}&mode=d");
    print(googleMapsUrl);
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${homeController.order.value!.site!.lat},${homeController.order.value!.site!.long}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
