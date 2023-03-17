import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/theme/app_theme.dart';
import 'package:installation/theme/custom_theme.dart';
import 'package:installation/views/home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ForgetPassword extends StatefulWidget {
  static String tag = 'ForgetPassword-page';

  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordPageState();
  }
}

class _ForgetPasswordPageState extends State<ForgetPassword> {
  final authController = Get.find<AuthController>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _ForgetPasswordData = {};

  bool _passwordVisible = true;

  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    print("notification_token ${GetStorage().read("notification_token")}");

    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 3 / 10,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 20,
                right: 40,
                child: FxText.headlineSmall("ForgetPassword", fontWeight: 600),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: FxContainer.bordered(
            padding: EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 12),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  style: FxTextStyle.bodyLarge(
                      letterSpacing: 0.1, fontWeight: 500),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: FxTextStyle.titleSmall(
                        letterSpacing: 0.1, fontWeight: 500),
                    prefixIcon: Icon(MdiIcons.emailOutline),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FxButton(
                      backgroundColor: Palette.maincolor,
                      elevation: 0,
                      borderRadiusAll: 4,
                      onPressed: () {
                        if (_emailController.text == '') {
                          GFToast.showToast(
                            "Email is Required",
                            context,
                            toastPosition: GFToastPosition.BOTTOM,
                          );
                        }
                        _ForgetPasswordData['email'] = _emailController.text;
                        _ForgetPasswordData['password'] =
                            _passwordController.text;
                        authController.ForgetPassword(
                            Data: _ForgetPasswordData, context: context);
                      },
                      child: FxText.labelMedium("Send",
                          fontWeight: 600,
                          color: Colors.white,
                          letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
