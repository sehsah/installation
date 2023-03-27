import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:installation/controllers/notification_controller.dart';
import 'package:installation/models/notification.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final notificationController = Get.put(NotificationController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
            child: posts(
          isLoading: notificationController.isLoading.value,
          notifications: notificationController.notifications,
        )),
      );
    });
  }

  Widget posts({
    required isLoading,
    required List<Notifications> notifications,
  }) {
    print(notifications);
    return isLoading == true
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : notifications.isNotEmpty
            ? ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return FxContainer.bordered(
                    color: Colors.white,
                    paddingAll: 16,
                    borderRadiusAll: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  FxSpacing.width(4),
                                  Expanded(
                                    child: FxText.bodySmall(
                                      notifications[index].message,
                                      fontWeight: 600,
                                    ),
                                  ),
                                ],
                              ),
                              FxSpacing.height(5),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  notifications[index].createdAt,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            notificationController
                                .deleteNotification(notifications[index].id);
                          },
                          child: FxContainer.rounded(
                            paddingAll: 4,
                            child: Icon(
                              Icons.delete,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return FxSpacing.height(0);
                },
              )
            : Center(child: Text("No Notification"));
  }
}
