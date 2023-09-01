import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ImageSourceType { gallery, camera }

class EditProfile extends StatefulWidget {
  const EditProfile();

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final double circleRadius = 200.0;
  final double circleBorderWidth = 1.0;
  final _keyValidationForm = GlobalKey<FormState>();
  final _textEditfirstname = TextEditingController();
  final _textEditlastname = TextEditingController();
  final _textEditEmail = TextEditingController();
  final _textEditPhone = TextEditingController();
  final TextEditingController _textEditConPassword = TextEditingController();
  final TextEditingController _textEditConConfirmPassword =
      TextEditingController();
  final bool isPasswordVisible = false;
  final bool isConfirmPasswordVisible = false;
  bool _passwordInVisible = true;
  final authController = Get.find<AuthController>();
  final Map<String, dynamic> _Data = {};
  File? image;
  late final users = GetStorage().read('logged_user');

  @override
  void initState() {
    super.initState();
    print(users);
    users['first_name'] != null
        ? _textEditfirstname.text = users['first_name']
        : '';
    users['last_name'] != null
        ? _textEditlastname.text = users['last_name']
        : '';
    users['last_name'] != null ? _textEditEmail.text = users['email'] : '';
    users['last_name'] != null ? _textEditPhone.text = users['phone'] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.maincolor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("profile"),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: DataPage(),
          )),
    );
  }

  Widget DataPage() {
    return Column(children: <Widget>[
      Stack(alignment: Alignment.topCenter, children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: circleRadius / 1.5),
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: circleRadius,
          height: circleRadius,
          decoration: ShapeDecoration(shape: CircleBorder()),
          child: Center(
            child: Stack(children: <Widget>[
              Card(
                shape: CircleBorder(),
                child: Container(
                  child: image == null
                      ? ClipOval(
                          child: Image.network(
                            users['avatar'],
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipOval(
                          child: Image.file(
                          image!,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        )),
                ),
              ),
              Positioned(
                  bottom: 6,
                  right: 15,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Palette.maincolor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo,
                          color: Colors.white, size: 16),
                      onPressed: () {
                        _showChoiceDialog(context);
                      },
                    ),
                  )),
            ]),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 200),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            color: Colors.white,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: _keyValidationForm,
                    child: Column(children: <Widget>[
                      // title: login
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _textEditfirstname,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String value) {},
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.first_name,
                              //prefixIcon: Icon(Icons.email),
                              icon: const Icon(Icons.perm_identity)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _textEditlastname,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String value) {},
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.last_name,
                              //prefixIcon: Icon(Icons.email),
                              icon: Icon(Icons.perm_identity)),
                        ),
                      ), //text field : user name
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _textEditEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.email,
                              //prefixIcon: Icon(Icons.email),
                              icon: Icon(Icons.email)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _textEditPhone,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.mobile,
                              //prefixIcon: Icon(Icons.email),
                              icon: Icon(Icons.phone)),
                        ),
                      ), //text field: email
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          obscureText: _passwordInVisible,
                          controller: _textEditConPassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordInVisible = !_passwordInVisible;
                                  });
                                },
                              ),
                              icon: Icon(Icons.vpn_key)),
                        ),
                      ), //text field: password
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                            obscureText: _passwordInVisible,
                            controller: _textEditConConfirmPassword,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!
                                    .confirm_password,
                                suffixIcon: IconButton(
                                  icon: Icon(isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordInVisible = !_passwordInVisible;
                                    });
                                  },
                                ),
                                icon: Icon(Icons.vpn_key))),
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                          width: double.infinity,
                          child: FxButton(
                              backgroundColor: Palette.maincolor,
                              elevation: 0,
                              borderRadiusAll: 4,
                              onPressed: () {
                                if (_textEditfirstname.text == '' ||
                                    _textEditlastname.text == '' ||
                                    _textEditPhone.text == '' ||
                                    _textEditEmail.text == '') {
                                  GFToast.showToast(
                                    "Email and Password And Phone is Required",
                                    context,
                                    toastPosition: GFToastPosition.BOTTOM,
                                  );
                                }

                                _Data['email'] = _textEditEmail.text;
                                _Data['first_name'] = _textEditfirstname.text;
                                _Data['last_name'] = _textEditlastname.text;
                                _Data['email'] = _textEditEmail.text;
                                _Data['phone'] = _textEditPhone.text;
                                _Data['avatar'] = image != null
                                    ? "data:image/png;base64,${base64Encode(image!.readAsBytesSync())}"
                                    : "";
                                authController.EditProfileData(
                                    Data: _Data, context: context);
                              },
                              child: FxText.labelMedium("Update",
                                  fontWeight: 600,
                                  color: Colors.white,
                                  letterSpacing: 0.5))),
                    ])),
              )
            ])),
      ]),
    ]);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.choose_option,
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
                      _openImagePicker(context);
                    },
                    title: Text(
                      AppLocalizations.of(context)!.gallery,
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
                      AppLocalizations.of(context)!.camera,
                      style: TextStyle(
                        fontFamily: GetStorage().read('Lang') == 'en'
                            ? 'OpenSans'
                            : 'Almarai',
                      ),
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

  Future<void> _openImagePicker(BuildContext context) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        image = File(pickedFile!.path);
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
}
