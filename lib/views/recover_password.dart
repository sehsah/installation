import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecovePassword extends StatefulWidget {
  final String email;
  RecovePassword(this.email);
  @override
  _RecovePasswordState createState() => _RecovePasswordState();
}

class _RecovePasswordState extends State<RecovePassword> {
  final authController = Get.find<AuthController>();
  final _passwordController = TextEditingController();
  final _ConConfirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _RecovePasswordData = {};
  final bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_user.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(children: <Widget>[buildTopBanner(), buildForm()])),
    );
  }

  Widget buildTopBanner() {
    return Stack(
      // alignment: Alignment.bottomLeft,
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 60),
                  Image.asset('assets/ic-actions-closed-user.png', scale: 1.1),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.forgetpassword,
                      style: TextStyle(
                          fontFamily: GetStorage().read('Lang') == 'en'
                              ? 'OpenSans'
                              : 'Almarai',
                          fontSize: 29,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)
                ]),
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );
  } // end of TopBanner

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Form(
        // autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            //email
            Text(AppLocalizations.of(context)!.recovePasswordtext,
                style: TextStyle(
                    fontSize: 13,
                    height: 2,
                    color: Colors.white60,
                    fontFamily: GetStorage().read('Lang') == 'en'
                        ? 'OpenSans'
                        : 'Almarai',
                    fontWeight: FontWeight.bold)),
            Container(padding: EdgeInsets.only(bottom: 0), child: Text("btn")),
            Container(padding: EdgeInsets.only(bottom: 5), child: Text("btn")),
            SizedBox(height: 20),

            SizedBox(width: 200, child: Text("btn")),
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  } // end of Form
} //end of widget


