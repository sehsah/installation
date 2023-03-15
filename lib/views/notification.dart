import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: Text(
          "Notification ",
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_sharp),
            tooltip: 'Show Snackbar',
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Center(child: Text('No Notification')),
      ),
    );
  }
}
