// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/controller/active_app_controller.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/screens/whatsapp/saved/savedImage/savedImageScreen.dart';
import 'package:status_saver/screens/whatsapp/saved/savedVideo/savedVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_theme/color.dart';
import '../../../app_theme/text_styles.dart';
import '../../../bottomNavbar/bottomNavbarScreen.dart';
import '../../../controller/fileController.dart';
import '../../../model/fileModel.dart';

class SavedTabScreen extends StatefulWidget {
  const SavedTabScreen({Key? key}) : super(key: key);

  @override
  State<SavedTabScreen> createState() => _SavedTabScreenState();
}

class _SavedTabScreenState extends State<SavedTabScreen> {
  int? androidSDK;
  FileController fileController = Get.put(FileController());

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath;
  late Directory savedDirectory;

  late SharedPreferences _prefs;

  final ActiveAppController _activeAppController = Get.put(ActiveAppController());

  @override
  void initState() {
    super.initState();
    getPrefs();

    log("checkkkkkkkkkwwwwww");
  }
  getPrefs() async {
    _prefs =  await SharedPreferences.getInstance();
  }

  checkAndroidVersion(int newValue) async {
    log("qqqqqqqqqqq");
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      if (newValue == 1) {
        try {
          print("Version Greater");
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

          _prefs.setInt("statusValue", 1);
          _activeAppController.changeActiveApp(1);
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No WhatsApp Found");
          // pre.setInt("statusValue", 2);
        }
      } else if (newValue == 2) {
        try {
          _prefs.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');

          _activeAppController.changeActiveApp(2);
          getSelectedDetails();


        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          _prefs.setInt("statusValue", 1);
        }
      } else if (newValue == 3) {
        try {
          _prefs.setInt("statusValue", 3);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.gb/GB WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

          _activeAppController.changeActiveApp(3);
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
        }
      } else {
        print("ERROR 1111");
      }
    }
    else if (androidSDK! < 30) {
      if (newValue == 1) {
        try {
          _prefs.setInt("statusValue", 1);
          directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

          _activeAppController.changeActiveApp(1);
          getSelectedDetails();
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

          _activeAppController.changeActiveApp(2);
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          _prefs.setInt("statusValue", 1);
        }
      }
      else if (newValue == 3) {
        try {
          _prefs.setInt("statusValue", 3);
          directoryPath = Directory('/storage/emulated/0/GB WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

          _activeAppController.changeActiveApp(3);
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No GB WhatsApp Found");
        }
      } else {
        print("ERROR 2");
      }
    }
    else {
      print("ERROR");
    }
    log("iiiiiiiiiiiiii ${  _activeAppController.activeApp.value}");
    // setState(() {
    //
    // });
  }


  getSelectedDetails() {
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
  }

  getImageData() {
    log("44444444444");
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
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }
        }else if(_activeAppController.activeApp.value == 2){
          if (savedList.map((e) =>
              e.split("StatusSaverBusiness/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          } else {
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
            'Saved',
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
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.imagesGbWhatsappIcon,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("GB WhatsApp"),
                      Spacer(),
                      Obx(() {
                        return Image.asset(
                          _activeAppController.activeApp.value == 3 ? Assets
                              .imagesCheck : Assets.imagesUnCheck,
                          width: 20,
                          height: 20,
                        );
                      }),
                    ],
                  ),
                ),
              ],
              offset: Offset(0, 50),
              elevation: 2,
              onSelected: (value) async {

                if (value == 1) {
                  try {
                    // SharedPreferences pre = await SharedPreferences.getInstance();
                    //  pre.setInt("statusValue", 1);

                    await checkAndroidVersion(1);

                  } catch (e) {
                    ReusingWidgets.toast(text: "No WhatsApp Found");
                  }
                } else if (value == 2) {
                  try {
                    await checkAndroidVersion(2);
                  } catch (e) {
                    ReusingWidgets.toast(text: "No WhatsApp Business Found");
                    print("eeeeeeeeeee $e");
                  }
                } else if (value == 3) {
                  ReusingWidgets.toast(text: "Not Available");
                }
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
          children: [
            SavedImageScreen(),
            SavedVideoScreen(),
            // SavedScreen()
          ],
        ),
      ),
    );
  }
}
