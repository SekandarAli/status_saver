// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/bottomNavbar/bottomNavbarScreen.dart';
import 'package:status_saver/controller/active_app_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Status Saver",
        color: ColorsTheme.primaryColor,
        home: MyApp(),
    ));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  @override
  void initState() {
    super.initState();
    getActiveApp();
  }

  getActiveApp() async{

   final SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? statusValue= _prefs.getInt('statusValue');
    if(statusValue != null){
      _activeAppController.changeActiveApp(statusValue);
      log("bbbbbbbb${_activeAppController.activeApp.value.toString()}");
    }
    else{
      _activeAppController.changeActiveApp(1);
      log("aaaaaaaaaaaa");
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavBarScreen();
  }
}

