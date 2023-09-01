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
import 'package:installation/views/forget_password.dart';
import 'package:installation/views/home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<Login> {
  final authController = Get.find<AuthController>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _loginData = {};

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
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login-Page-2.png"),
                fit: BoxFit.cover),
          ),
          height: MediaQuery.of(context).size.height * 2 / 10,
        ),
        FxSpacing.height(20),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/logo2.png"), fit: BoxFit.contain),
          ),
          height: 80,
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
                  child: TextFormField(
                    controller: _passwordController,
                    style: FxTextStyle.bodyLarge(
                        letterSpacing: 0.1, fontWeight: 500),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: FxTextStyle.titleSmall(
                          letterSpacing: 0.1, fontWeight: 500),
                      prefixIcon: Icon(MdiIcons.lockOutline),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? MdiIcons.eyeOutline
                            : MdiIcons.eyeOffOutline),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: _passwordVisible,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Get.to(ForgetPassword());
                      },
                      child: FxText.bodySmall("Forgot Password ?",
                          fontWeight: 500)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FxButton(
                      backgroundColor: Palette.maincolor,
                      elevation: 0,
                      borderRadiusAll: 4,
                      onPressed: () {
                        if (_emailController.text == '' ||
                            _passwordController.text == '') {
                          GFToast.showToast(
                            "Email and Password is Required",
                            context,
                            toastPosition: GFToastPosition.BOTTOM,
                          );
                        }
                        _loginData['email'] = _emailController.text;
                        _loginData['password'] = _passwordController.text;
                        authController.login(
                            loginData: _loginData, context: context);
                      },
                      child: FxText.labelMedium("LOGIN",
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
