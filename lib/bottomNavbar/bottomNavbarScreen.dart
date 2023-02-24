// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, avoid_unnecessary_containers, library_private_types_in_public_api, null_check_always_fails, use_build_context_synchronously

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:status_saver/screens/home/homeScreen.dart';
import '../app_theme/color.dart';
import '../app_theme/reusing_widgets.dart';
import '../controller/fileController.dart';
import '../drawer/drawerScreen.dart';
import '../model/fileModel.dart';
import '../screens/setting/settingScreen.dart';
import '../screens/whatsapp/saved/savedTabBar.dart';
import '../screens/whatsapp/status/statusTabBar.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
class _BottomNavBarScreenState extends State<BottomNavBarScreen> with TickerProviderStateMixin{

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath ;
  late Directory savedDirectory;
  final FileController fileController = Get.put(FileController());

  int? androidSDK;

  int tabIndex = 0;
  late TabController tabController = TabController(length: 3, vsync: this,animationDuration: Duration(microseconds: 1));

  @override
  void initState() {
    super.initState();
    tabController.addListener(() {
      if (tabController.index == 0) {
        setState(() {
          tabIndex = 0;
          tabController.index = tabIndex;
        });
      }
      else if (tabController.index == 1) {
        setState(() {
          tabIndex = 1;
          tabController.index = tabIndex;
        });
      }
      else if (tabController.index == 2) {
        setState(() {
          tabIndex = 2;
          tabController.index = tabIndex;
        });
      }
    });
    createFolder();
    checkAndroidVersion();
  }


  checkAndroidVersion() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      print("Version Greater than 30");
      try {
        print("Version Greater");
        directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
        getSelectedDetails();
      }
      catch (e) {
        print("Error is $e");
        //
        // ReusingWidgets.toast(text: e.toString());
        // print(e);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NoWhatsAppFound(
        //       text: "WhatsApp",
        //       packageName: "com.whatsapp",
        //       packageUrl: "market://details?id=com.whatsapp",
        //     )));
      }
    }
    else if (androidSDK! < 30) {
      print("Version Less than 30");
      try {
        print("Version Less");
        directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
        savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
        getSelectedDetails();
      }
      catch (e) {
        print("Error is $e");
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NoWhatsAppFound(
        //       text: "WhatsApp",
        //       packageName: "com.whatsapp",
        //       packageUrl: "market://details?id=com.whatsapp",
        //     )));
      }
    }

    else{
      print("ERROR");
    }
  }

  createFolder() async {
    const folderName = "StatusSaver";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      // savedDirectory = Directory('/storage/emulated/0/DCIM/$folderName');
      print("Path Exist");
    }
    else {
      path.create();
    }
  }

  getSelectedDetails(){
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
  }

  getImageData() {
    fileController.allStatusImages.value = [];
    if (imageList.isNotEmpty) {
      for (var element in imageList) {
        if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
        } else {
          // print("ELSE${element.substring(72,104)}");
          fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  getVideoData() {
    fileController.allStatusVideos.value = [];
    if (videoList.isNotEmpty) {
      for (var element in videoList) {
        if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
        } else {
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {

        if(scaffoldKey.currentState!.isDrawerOpen){
          scaffoldKey.currentState!.closeDrawer();
        }
      else if (tabController.index == 0) {
         // Get.offAll(()=> HomeScreen());
          ReusingWidgets.exitDialogueBox(
              context: context,
              onPress: (){
                Future.delayed(Duration(milliseconds: 1),() {
                  exit(0);
                });
              },
          );
      }
      else {
        tabIndex = 0;
        tabController.index = tabIndex;
      }
        return null!;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: DrawerScreen(),
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              color: ColorsTheme.white,
              height: 60,
              padding: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        tabIndex = 0;
                        tabController.index = tabIndex;
                      },
                      child: bottomWidget(
                        0,
                        "Status",
                        Icons.data_saver_on_sharp,
                        Icons.data_saver_off,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        tabIndex = 1;
                        tabController.index = tabIndex;
                      },
                      child: bottomWidget(
                        1,
                        "Saved",
                        Icons.save,
                        Icons.save_outlined,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          tabIndex = 2;
                          tabController.index = tabIndex;
                        },
                        child: bottomWidget(
                          2,
                          "Settings",
                          Icons.settings,
                          Icons.settings_outlined,
                        )),
                  ),
                ],
              ),
            )),
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: StatusTabScreen(),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: SavedTabScreen(),
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: SettingScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget bottomWidget(int index, String title, IconData icon1, IconData icon2,) {
    return Column(
      children: [

        Icon(tabIndex == index ? icon1 : icon2,
          color: tabIndex == index
            ? ColorsTheme.primaryColor
            : ColorsTheme.lightGrey,),
        Text(
          title,
          style: TextStyle(
            color: tabIndex == index
                ? ColorsTheme.primaryColor
                : ColorsTheme.lightGrey,
          )
        )
      ],
    );
  }
}
