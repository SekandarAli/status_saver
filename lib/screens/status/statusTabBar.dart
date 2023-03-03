// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saf/saf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/controller/active_app_controller.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/screens/status/statusImage/statusImageScreen.dart';
import 'package:status_saver/screens/status/statusVideo/statusVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../../bottomNavbar/bottomNavbarScreen.dart';
import '../../../controller/fileController.dart';
import '../../../model/fileModel.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({Key? key}) : super(key: key);

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> with TickerProviderStateMixin{
  int? androidSDK;
  FileController fileController = Get.put(FileController());

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath;
  late Directory savedDirectory;

  late SharedPreferences _prefs;

  final ActiveAppController _activeAppController = Get.put(ActiveAppController());

  late final TabController _tabController = TabController(length: 2, vsync: this,animationDuration: Duration(microseconds: 1));
  int tabIndex = 0;

  late Saf saf;
  var _paths = [];

  String? directory;


  @override
  void initState() {
    super.initState();
    getPrefs();

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          tabIndex = 0;
          _tabController.index =  tabIndex;
        });
      }
      else if (_tabController.index == 1) {
        setState(() {
          tabIndex = 1;
          _tabController.index = tabIndex;
        });
      }
      else if (_tabController.index == 2) {
        setState(() {
          tabIndex = 2;
          _tabController.index =  tabIndex;
        });
      }
    });
  }

  getPrefs() async {
    _prefs =  await SharedPreferences.getInstance();
   }

  checkAndroidVersion(int newValue) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      if (newValue == 1) {
        try {
          print("Version Greater");

          directory = "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";

          saf = Saf(directory!);

          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
          _prefs.setInt("statusValue", 1);
          _activeAppController.changeActiveApp(1);
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No WhatsApp Found");
          // pre.setInt("statusValue", 2);
        }
      } else if (newValue == 2) {
        try {

          directory = "/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";

          saf = Saf(directory!);


          _prefs.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
          getSelectedDetails();
          _activeAppController.changeActiveApp(2);
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          _prefs.setInt("statusValue", 1);
        }
      }
      else {
        print("ERROR 1111");
      }
    }
    else if (androidSDK! < 30) {
      if (newValue == 1) {
        try {
          _prefs.setInt("statusValue", 1);
          directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
          _activeAppController.changeActiveApp(1);
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No WhatsApp Found");
          _prefs.setInt("statusValue", 2);
        }
      }
      else if (newValue == 2) {
        try {
          _prefs.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
          getSelectedDetails();
          _activeAppController.changeActiveApp(2);
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          _prefs.setInt("statusValue", 1);
        }
      }
      else {
        print("ERROR 2");
      }
    }
    else {
      print("ERROR");
    }
    setState(() {});
  }

  getSelectedDetails() {
    imageList =directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
  }

  getImageData() {
    fileController.allStatusImages.value = [];
    if (imageList.isNotEmpty) {
      for (var element in imageList) {
        // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {
        if (_activeAppController.activeApp.value == 1){
          if (savedList.map((e) =>
              e.split("StatusSaver/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {

            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          } else {
            // print("ELSE${element.substring(72,104)}");

            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }
        }else if(_activeAppController.activeApp.value == 2){
          if (savedList.map((e) =>
              e.split("StatusSaverBusiness/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          } else {
            // print("ELSE${element.substring(72,104)}");
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }
        }

      }
    }
  }

  getVideoData() {
    fileController.allStatusVideos.value = [];
    if (videoList.isNotEmpty) {
      for (var element in videoList) {
        // if (savedList.map((e) => e.substring(37, 69).toString()).contains(element.substring(72, 104))) {


        if (_activeAppController.activeApp.value == 1){
          if (savedList.map((e) =>
              e.split("StatusSaver/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          } else {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          }
        }
        else if(_activeAppController.activeApp.value == 2){
          if (savedList.map((e) =>
              e.split("StatusSaverBusiness/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          }
          else {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: ColorsTheme.primaryColor,
        appBar: AppBar(
          title: Text(
            'Status Saver',
            style: ThemeTexts.textStyleTitle2.copyWith(color: ColorsTheme.white, letterSpacing: 1),
          ),
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                } else {
                  scaffoldKey.currentState!.openDrawer();
                }
              },
              child: Icon(Icons.menu)),
          actions: [
            Obx(() {
              return Visibility(
                visible: _activeAppController.activeApp.value == 1,
                child: Tooltip(
                  message: "Open WhatsApp",
                  child: GestureDetector(
                      onTap: () async {
                        try {
                          bool isInstalled =
                          await DeviceApps.isAppInstalled('com.whatsapp');
                          if (isInstalled) {
                            DeviceApps.openApp("com.whatsapp").then((value) {
                              ReusingWidgets.toast(text: "Opening WhatsApp...");
                            });
                          } else {
                            launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                          }
                        } catch (e) {
                          ReusingWidgets.toast(text: e.toString());
                        }
                      },
                      child: Image.asset(
                        Assets.imagesWhatsappIcon,
                        height: 25,
                        width: 25,
                      )),
                ),
              );
            }),
            Obx(() {
              return Visibility(
                visible: _activeAppController.activeApp.value == 2,
                child: Tooltip(
                  message: "Open Business WhatsApp",
                  child: GestureDetector(
                      onTap: () async {
                        try {
                          bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
                          if (isInstalled) {
                            DeviceApps.openApp("com.whatsapp.w4b").then((value) {
                              ReusingWidgets.toast(text: "Opening Business WhatsApp...");
                            });
                          } else {
                            launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
                          }
                        } catch (e) {
                          ReusingWidgets.toast(text: e.toString());
                        }
                      },
                      child: Image.asset(
                        Assets.imagesWhatsappBusinessIcon,
                        height: 25,
                        width: 25,
                      )),
                ),
              );
            }),
            // SizedBox(width: 10),
           PopupMenuButton(
                icon: Icon(
                  Icons.add_circle,
                  color: ColorsTheme.white,
                ),
                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.imagesWhatsappIcon,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("WhatsApp"),
                        Spacer(),
                        Image.asset(
                          _activeAppController.activeApp.value == 1 ? Assets
                              .imagesCheck : Assets.imagesUnCheck,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.imagesWhatsappBusinessIcon,
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Business WhatsApp"),
                        Spacer(),
                        Image.asset(
                          _activeAppController.activeApp.value == 2 ? Assets
                              .imagesCheck : Assets.imagesUnCheck,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
                offset: Offset(0, 50),
                elevation: 2,
                onSelected: (value) async {

                  if (value == 1) {
                    try {

                      try {
                        bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
                        if (isInstalled) {
                          await checkAndroidVersion(1);
                        }
                        else {
                          ReusingWidgets.toast(text: "No WhatsApp Found");
                        }
                      } catch (e) {
                        ReusingWidgets.toast(text: e.toString());
                      }

                    } catch (e) {
                      ReusingWidgets.toast(text: "No WhatsApp Found");
                    }
                  }
                  else if (value == 2) {
                    try {

                      try {
                        bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
                        if (isInstalled) {
                          await checkAndroidVersion(2);
                        } else {
                          ReusingWidgets.toast(text: "No WhatsApp Business Found");
                        }
                      } catch (e) {
                        ReusingWidgets.toast(text: e.toString());
                      }
                    }
                    catch (e) {
                      ReusingWidgets.toast(text: "No WhatsApp Business Found");
                    }
                  }
                  fileController.allStatusImages.forEach((element) {
                    log("ELEMENT IS ${element.isSaved}");
                  });
                },
              )
          ],
          backgroundColor: ColorsTheme.primaryColor,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: ColorsTheme.lightWhite,
            labelColor: ColorsTheme.white,
            indicatorColor: ColorsTheme.lightWhite,
            labelPadding: EdgeInsets.symmetric(horizontal: 2),
            indicatorWeight: 3,
            tabs: [
              Tab(text: "IMAGES"),
              Tab(text: "VIDEOS"),
              // Tab(text: "SAVED"),
            ],
          ),
        ),
        body: TabBarView(
          // controller: _tabController,
          children: [
            StatusImageScreen(),
            StatusVideoScreen(),
            // SavedScreen()
          ],
        ),
      ),
    );
  }
}
