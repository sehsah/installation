import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/models/order.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int _currentStep = 1;
  TabController? _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.maincolor, // <-- SEE HERE
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
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
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
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
          child: Text("First Name : ${widget.order.customer!.firstName}",
              style: TextStyle(fontSize: 16.0)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Last Name :  ${widget.order.customer!.lastName}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Mobile Number :  ${widget.order.customer!.phone}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Email Address :  ${widget.order.customer!.email}",
                style: TextStyle(fontSize: 16.0))),
      ],
    );
  }

  Widget SiteWdiget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10),
          child: Text("Site Information",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
          child: Text("Site Name	 : ${widget.order.site!.name}",
              style: TextStyle(fontSize: 16.0)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text(
                "Apartment Number	 :  ${widget.order.site!.apartmentNumber}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Street Name :  ${widget.order.site!.street}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text(
                "Additional Direction	 :  ${widget.order.site!.additionalDirection}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("City:  ${widget.order.site!.city}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Country:  ${widget.order.site!.country}",
                style: TextStyle(fontSize: 16.0))),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Palette.maincolor, // Background color
            ),
            onPressed: () => _openMaps(),
            child: Text('Open Location '),
          ),
        ),
      ],
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
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
          child: Text("Work Order	 : ${widget.order.site!.name}",
              style: TextStyle(fontSize: 16.0)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Work Order Status:  ${widget.order.status}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Assigned To:  ${widget.order.agent?.firstName}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Preferred Date:  ${widget.order.date}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Preferred Time	:  ${widget.order.time}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Connection Type	:  ${widget.order.connectionType}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Connection Number	:  ${widget.order.connectionNumber}",
                style: TextStyle(fontSize: 16.0))),
        Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15),
            child: Text("Charger:  ${widget.order.charger}",
                style: TextStyle(fontSize: 16.0))),
      ],
    );
  }

  Widget ActionsWdiget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Comment',
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
              child: Text('Update'),
            ),
          ),
        ],
      ),
    );
  }

  Widget LogWdiget() {
    return Container(
      height: 200,
      child: Stepper(
        physics: ClampingScrollPhysics(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Container();
        },
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
              content: Container(),
            ),
        ],
      ),
    );
  }

  Future<void> _openMaps() async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${widget.order.site.lat},${widget.order.site.long}';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
