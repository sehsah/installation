import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:installation/views/home.dart';
import 'package:installation/views/notification.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'edit_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatelessWidget {
  Profile();

  final double circleRadius = 200.0;
  final double circleBorderWidth = 1.0;
  final myid = 4;
  late final users = GetStorage().read('logged_user');
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Get.off(Home()),
        ),
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            height: 2,
            child: Container(
              height: 2,
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: FxSpacing.all(20),
      children: [
        Center(
          child: FxContainer(
            margin: EdgeInsets.only(top: 40),
            color: Colors.transparent,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Palette.maincolor,
              child: ClipOval(
                child: Image.network(
                  users['avatar'],
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
        FxSpacing.height(24),
        FxText.titleLarge(
          '${users['first_name'] ?? '' + ' ' + users['last_name']}',
          textAlign: TextAlign.center,
          fontWeight: 600,
          letterSpacing: 0.8,
        ),
        FxSpacing.height(24),
        FxText.bodySmall(
          'General',
          xMuted: true,
        ),
        FxSpacing.height(30),
        _buildSingleRow(
            title: 'Profile settings', icon: MdiIcons.account, path: 1),
        FxSpacing.height(8),
        Divider(),
        FxSpacing.height(8),
        _buildSingleRow(title: 'Notifications', icon: MdiIcons.bell, path: 2),
        FxSpacing.height(8),
        Divider(),
        FxSpacing.height(8),
        _buildSingleRow(title: 'Logout', icon: MdiIcons.logout, path: 3),
      ],
    );
  }

  Widget _buildSingleRow({String? title, IconData? icon, path}) {
    return InkWell(
      onTap: () => {
        if (path == 1)
          {Get.to(() => EditProfile())}
        else if (path == 2)
          {Get.to(() => NotificationPage())}
        else if (path == 3)
          {authController.logout()}
      },
      child: Row(
        children: [
          FxContainer(
            paddingAll: 8,
            borderRadiusAll: 4,
            child: Icon(
              icon,
              size: 20,
            ),
          ),
          FxSpacing.width(16),
          Expanded(
            child: FxText.bodySmall(
              title!,
              letterSpacing: 0.5,
            ),
          ),
          FxSpacing.width(16),
          Icon(
            Icons.keyboard_arrow_right,
          ),
        ],
      ),
    );
  }
}
