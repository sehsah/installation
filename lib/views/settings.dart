import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  @override
  SwitchClass createState() => SwitchClass();
}

class SwitchClass extends State {
  bool isEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.maincolor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text("ddd"),
        ),
      ),
    );
  }
}
