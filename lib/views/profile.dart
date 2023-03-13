import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/palette.dart';
import 'edit_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String mobile;
  final String avatar;
  final int id;
  final int building;
  final String apartment;
  Profile(this.id, this.firstname, this.lastname, this.mobile, this.avatar,
      this.building, this.apartment);

  final double circleRadius = 200.0;
  final double circleBorderWidth = 1.0;
  final myid = 4;
  late final users = GetStorage().read('logged_user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.maincolor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              // margin: EdgeInsets.only(top: 30),
              child: profileView(context))),
    );
  }

  Widget profileView(context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: circleRadius / 1.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                height: 100,
              ),
            ),
            Container(
              width: circleRadius,
              height: circleRadius,
              decoration: ShapeDecoration(shape: CircleBorder()),
              child: Center(
                child: Card(
                  shape: CircleBorder(),
                  child: ClipOval(
                    child: Image.network(
                      avatar,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              padding: EdgeInsets.only(bottom: 100),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    "${firstname} ${lastname}",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        "${building.toString()} - ${apartment}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26),
                      ),
                    ),
                  ),
                  users['id'] == id
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              var firstname = users['firstname'];
                              var lastname = users['lastname'];
                              var mobile = users['mobile'];
                              var avatar = users['avatar'];
                              var id = users['id'];
                              Get.to(EditProfile(
                                  id, firstname, lastname, mobile, avatar));
                            },
                            child: Text(
                                AppLocalizations.of(context)!.edit_profile,
                                style: TextStyle(
                                    fontFamily:
                                        GetStorage().read('Lang') == 'en'
                                            ? 'OpenSans'
                                            : 'Almarai')),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              primary: Palette.maincolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                          ))
                      : Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.send_message,
                              style: TextStyle(
                                  fontFamily: GetStorage().read('Lang') == 'en'
                                      ? 'OpenSans'
                                      : 'Almarai'),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              primary: Palette.maincolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
