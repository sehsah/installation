import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifiyCode extends StatefulWidget {
  final String email;
  VerifiyCode(this.email);
  @override
  _VerifiyCodeState createState() => _VerifiyCodeState();
}

class _VerifiyCodeState extends State<VerifiyCode> {
  final authController = Get.find<AuthController>();
  final _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _verifiyCodeData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
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
            Text(AppLocalizations.of(context)!.verifiyCodetext,
                style: TextStyle(
                    fontSize: 13,
                    height: 2,
                    color: Colors.white60,
                    fontFamily: GetStorage().read('Lang') == 'en'
                        ? 'OpenSans'
                        : 'Almarai',
                    fontWeight: FontWeight.bold)),

            SizedBox(height: 20),
            SizedBox(width: 200, child: Text("btn")),
            SizedBox(height: 0),
          ],
        ),
      ),
    );
  } // end of Form
} //end of widget


