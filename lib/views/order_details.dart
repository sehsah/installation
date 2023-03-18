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
import 'package:installation/models/order.dart';
import 'package:installation/theme/app_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails(this.order);
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
  File? image;
  File? image2;
  File? image3;
  String cable_type = "63";
  String breaker = "S32";
  final _commentController = TextEditingController();
  final _cable_lengthController = TextEditingController();
  final _pvc_lengthController = TextEditingController();
  final Map<String, dynamic> _ActionData = {};

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
      DropdownMenuItem(value: "10-3", child: Text("10.0mm 5-Core")),
    ];
    return menuItems2;
  }

  Future<void> _showChoiceDialog(BuildContext context, nameImg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Selecte Option",
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
                      _openImagePicker(context, nameImg);
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
                      _openCamera(context);
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

  Future<void> _openImagePicker(BuildContext context, nameImg) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        nameImg = File(pickedFile!.path);
      });

      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('faild ${e}');
    }
  }

  void _openCamera(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        image = File(pickedFile!.path);
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print('faild ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
        body: TabBarView(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: customerWdiget()),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: SiteWdiget()),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: DetailsWdiget()),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: ActionsWdiget()),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child: LogWdiget()),
          ],
        ),
      ),
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(widget.order.customer!.firstName,
                    style: TextStyle(fontSize: 16.0))
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
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(widget.order.customer!.lastName,
                      style: TextStyle(fontSize: 16.0)),
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
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(widget.order.customer!.phone,
                      style: TextStyle(fontSize: 16.0))
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
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(widget.order.customer!.email,
                      style: TextStyle(fontSize: 16.0))
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
                onPressed: () => openDialPad('+201021212121'),
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
                onPressed: () => launchWhatsApp("+1 555-555-5555"),
                child: Row(
                  children: [
                    Icon(MdiIcons.whatsapp, size: 20),
                    FxSpacing.width(5),
                    Text('Chat With whatapp '),
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
    return Flexible(
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
            margin: EdgeInsets.only(bottom: 5, top: 10),
            color: Colors.grey[200],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Site Name : ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text(widget.order.site.name, style: TextStyle(fontSize: 16.0))
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
                    child: Text("Apartment Number : ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${widget.order.site.apartmentNumber}",
                      style: TextStyle(fontSize: 16.0))
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
                    child: Text("Street Name Street Name sgsdg  : ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${widget.order.site.street}",
                      style: TextStyle(fontSize: 16.0))
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
                    child: Text("Additional Direction : ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${widget.order.site.additionalDirection}",
                      style: TextStyle(fontSize: 16.0))
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
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${widget.order.site.city}",
                      style: TextStyle(fontSize: 16.0))
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
                            fontSize: 16.0, fontWeight: FontWeight.w500)),
                  ),
                  Text("${widget.order.site.country}",
                      style: TextStyle(fontSize: 16.0))
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
          child: Text("Site Information",
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text("${widget.order.work_name}",
                    style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text("${widget.order.status}", style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text("${widget.order.agent?.firstName}",
                    style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(
                    "${widget.order.date!.weekday}/${widget.order.date!.month}/${widget.order.date!.year}",
                    style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(" ${widget.order.time}", style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(" ${widget.order.connectionType}",
                    style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(" ${widget.order.connectionNumber}",
                    style: TextStyle(fontSize: 16.0))
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
                          fontSize: 16.0, fontWeight: FontWeight.w500)),
                ),
                Text(" ${widget.order.charger}",
                    style: TextStyle(fontSize: 16.0))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget ActionsWdiget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "Comment",
                  border: theme.inputDecorationTheme.border,
                  enabledBorder: theme.inputDecorationTheme.border,
                  focusedBorder: theme.inputDecorationTheme.focusedBorder,
                ),
              ),
              widget.order.status == 'Customer Contacted'
                  ? Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _cable_lengthController,
                        decoration: InputDecoration(
                          labelText: "Cable Length",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                        ),
                      ),
                    )
                  : Container(),
              widget.order.status == 'Customer Contacted'
                  ? Container(
                      margin: EdgeInsets.only(top: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _pvc_lengthController,
                        decoration: InputDecoration(
                          labelText: "PVC Trunking Length",
                          border: theme.inputDecorationTheme.border,
                          enabledBorder: theme.inputDecorationTheme.border,
                          focusedBorder:
                              theme.inputDecorationTheme.focusedBorder,
                        ),
                      ),
                    )
                  : Container(),
              FxSpacing.height(10),
              widget.order.status == 'Customer Contacted'
                  ? DropdownButton(
                      isExpanded: true,
                      value: cable_type,
                      items: dropdownItemsCableType,
                      onChanged: (value) {
                        setState(() {
                          cable_type = value!;
                        });
                      },
                    )
                  : Container(),
              FxSpacing.height(10),
              widget.order.status == 'Customer Contacted'
                  ? DropdownButton(
                      isExpanded: true,
                      value: breaker,
                      items: dropdownItemsBreaker,
                      onChanged: (value) {
                        setState(() {
                          breaker = value!;
                        });
                      },
                    )
                  : Container(),
              FxSpacing.height(10),
              widget.order.status == 'Customer Contacted'
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
              widget.order.status == 'Customer Contacted'
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
              widget.order.status == 'Customer Contacted'
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
              widget.order.status == 'Customer Contacted'
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: GFBorder(
                        radius: Radius.circular(20),
                        color: Palette.maincolor,
                        dashedLine: [3, 0],
                        child: InkWell(
                          onTap: () => _showChoiceDialog(context, image),
                          child: image == null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
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
                                  onTap: () =>
                                      _showChoiceDialog(context, image),
                                  child: Image.file(
                                    image!,
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : Container(),
              widget.order.status == 'Customer Contacted'
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: GFBorder(
                        radius: Radius.circular(20),
                        color: Palette.maincolor,
                        dashedLine: [3, 0],
                        child: InkWell(
                          onTap: () => _showChoiceDialog(context, image2),
                          child: image2 == null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
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
                                  onTap: () =>
                                      _showChoiceDialog(context, image2),
                                  child: Image.file(
                                    image!,
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    )
                  : Container(),
              widget.order.status == 'Customer Contacted'
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: GFBorder(
                        radius: Radius.circular(20),
                        color: Palette.maincolor,
                        dashedLine: [3, 0],
                        child: InkWell(
                          onTap: () => _showChoiceDialog(context, image3),
                          child: image3 == null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  color: Palette.maincolor,
                                  child: Center(
                                      child: GFButton(
                                    textColor: Colors.white,
                                    onPressed: null,
                                    color: Palette.maincolor,
                                    textStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily:
                                          GetStorage().read('Lang') == 'en'
                                              ? 'OpenSans'
                                              : 'Almarai',
                                    ),
                                    text: "Upload File",
                                    icon: Icon(
                                      Icons.upload,
                                      color: Colors.white,
                                    ),
                                  )),
                                )
                              : InkWell(
                                  onTap: () =>
                                      _showChoiceDialog(context, image3),
                                  child: Image.file(
                                    image!,
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
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(28),
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        _ActionData['comment'] = _commentController.text;
                        _ActionData['cable_length'] =
                            _cable_lengthController.text;
                        _ActionData['pvc_length'] = _pvc_lengthController.text;
                        _ActionData['cable_type'] = cable_type;
                        _ActionData['breaker'] = breaker;
                        _ActionData['consumption_meter'] =
                            consumption_meter == false ? 0 : 1;
                        _ActionData['industrial_socket'] =
                            industrial_socket == false ? 0 : 1;
                        _ActionData['isolator'] = isolator == false ? 0 : 1;
                        _ActionData['user_id'] =
                            GetStorage().read('logged_user')['id'].toString();
                        _ActionData['order_id'] = widget.order.id;
                        _ActionData['image1'] = image != null
                            ? "data:image/png;base64,${base64Encode(image!.readAsBytesSync())}"
                            : "";
                        _ActionData['image2'] = image2 != null
                            ? "data:image/png;base64,${base64Encode(image2!.readAsBytesSync())}"
                            : "";
                        _ActionData['image3'] = image3 != null
                            ? "data:image/png;base64,${base64Encode(image3!.readAsBytesSync())}"
                            : "";
                        print(_ActionData);

                        _commentController.clear();
                        _pvc_lengthController.clear();
                        cable_type = "null";
                        breaker = "null";
                        consumption_meter = false;
                        industrial_socket = false;
                        isolator = false;
                        image = null;
                        image2 = null;
                        image3 = null;
                        homeController.addLog(
                            Data: _ActionData, context: context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Palette.maincolor),
                          padding:
                              MaterialStateProperty.all(FxSpacing.xy(16, 0))),
                      child: FxText.bodyMedium("Update",
                          fontWeight: 700,
                          letterSpacing: 0.2,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LogWdiget() {
    return Container(
      height: 200,
      child: widget.order.activity.isNotEmpty
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
                for (int i = 0; i < widget.order.activity.length; i++)
                  Step(
                    isActive: true,
                    state: StepState.complete,
                    title: FxText.bodyLarge(widget.order.activity[i].comment,
                        fontWeight: 600),
                    content: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(MdiIcons.account, size: 24),
                        FxSpacing.width(10),
                        FxText.bodyMedium(
                            "${widget.order.activity[i].name}  | : ${widget.order.activity[i].date}",
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
      launchUrl(Uri.parse("https://wa.me/966558604666"));
    } else {
      launchUrl(Uri.parse("https://wa.me/966558604666"));
    }
  }

  Future<void> _openMaps() async {
    Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${widget.order.site.lat},${widget.order.site.long}');
    launchUrl(googleMapsUrl);
  }
}
