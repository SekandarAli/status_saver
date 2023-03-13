// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saf/saf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/constants/constant.dart';
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
import '../../controller/permission_controller.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({Key? key}) : super(key: key);

  @override
  State<StatusTabScreen> createState() => _StatusTabScreenState();
}

class _StatusTabScreenState extends State<StatusTabScreen> with TickerProviderStateMixin{

  int? androidSDK;

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath;
  late Directory savedDirectory;

  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  final FileController fileController = Get.put(FileController());
  final PermissionController _permissionController = Get.put(PermissionController());
  late final TabController _tabController = TabController(length: 2, vsync: this,animationDuration: Duration(microseconds: 1));

  int tabIndex = 0;
  late Saf saf;
  String? directory;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    createFolder();
    createFolderBusiness();
    getPrefs();

    saf = _activeAppController.activeApp.value == 1  ? Saf(Constant.whatsAppPath) : Saf(Constant.businessWhatsAppPath);

    // checkAndroidVersion(_activeAppController.activeApp.value);
    print("Status Tab Screen");

  }

  createFolder() async {
    const folderName = "StatusSaver";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      print("Path Exist tab");
    }
    else {
      path.create();
      print("Path created tab");
    }
  }

  createFolderBusiness() async {
    const folderName = "StatusSaverBusiness";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      print("Path Exist tab");
    }
    else {
      path.create();
      print("Path created tab");
    }
  }

  getPrefs() async {
    _prefs =  await SharedPreferences.getInstance();
   }

  getPermissionsWhatsApp() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? permission =  preferences.getBool('isGrantedWhatsApp');

    if(permission == null || permission == false){
      _permissionController.permissionGrantedWhatsApp.value = false;
      bool? isGranted = await saf.getDirectoryPermission(isDynamic: false);

      if(isGranted == null || isGranted == false ){
        _permissionController.changePermissionWhatsApp(false);
      }
      else{
        _permissionController.changePermissionWhatsApp(true);
      }
    }
    else{
      _permissionController.permissionGrantedWhatsApp.value = true;
    }

    if(_permissionController.permissionGrantedWhatsApp.value){
      List<String>? directoriesPath = await Saf.getPersistedPermissionDirectories();
      await getSync();
    }
  }

  getPermissionsBusinessWhatsApp() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? permission =  preferences.getBool('isGrantedBusinessWhatsApp');

    if(permission == null || permission == false){
      _permissionController.permissionGrantedBusinessWhatsApp.value = false;
      bool? isGranted = await saf.getDirectoryPermission(isDynamic: false);

      if(isGranted == null || isGranted == false ){
        _permissionController.changePermissionBusinessWhatsApp(false);
      }
      else{
        _permissionController.changePermissionBusinessWhatsApp(true);
      }
    }
    else{
      _permissionController.permissionGrantedBusinessWhatsApp.value = true;
    }

    if(_permissionController.permissionGrantedBusinessWhatsApp.value){
      List<String>? directoriesPath = await Saf.getPersistedPermissionDirectories();
      log("directoriesPath$directoriesPath");
      await getSync();

    }
  }

  checkAndroidVersion(int newValue) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      print("greater than 30");
      if (newValue == 1)  {
        try {
          try {
            bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
            if (isInstalled) {
              saf = Saf(Constant.whatsAppPath);
              directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
              savedDirectory = Directory(Constant.savedDirectoryWhatsApp);
              if (Directory(directoryPath.path).existsSync()) {
                getPermissionsWhatsApp();
                getSelectedDetails();
                _prefs.setInt("statusValue", 1);
                _activeAppController.changeActiveApp(1);
              }

              else{
                ReusingWidgets.snackBar(text: "WhatsApp found but Not Logged In",context: context);
              }
            }
            else {
              ReusingWidgets.snackBar(text: "No WhatsApp Found",context: context);
            }
          }
          catch (e) {
            ReusingWidgets.snackBar(text: e.toString(),context: context);
          }
        }
        catch (e) {
          print("Error is $e");
          if (context.mounted) {
            ReusingWidgets.snackBar(text: "No WhatsApp Found",context: context);
            // _prefs.setInt("statusValue", 2);
          }
        }
      }

      else  if (newValue == 2) {
        try {
          try {
            bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
            if (isInstalled) {
              saf = Saf(Constant.businessWhatsAppPath);
              directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
              savedDirectory = Directory(Constant.savedDirectoryBusinessWhatsApp);
              if (Directory(directoryPath.path).existsSync()) {
                getPermissionsBusinessWhatsApp();
                getSelectedDetails();
                _prefs.setInt("statusValue", 2);
                _activeAppController.changeActiveApp(2);
              }
              else{
                ReusingWidgets.snackBar(text: "Business WhatsApp found but Not Logged In",context: context);
              }
            }
            else {
              ReusingWidgets.snackBar(text: "No WhatsApp Business Found",context: context);
            }
          }
          catch (e) {
            ReusingWidgets.snackBar(text: e.toString(),context: context);
          }
        }
        catch (e) {
          print("Error is $e");
          if (context.mounted) {
            ReusingWidgets.snackBar(text: "No WhatsApp Business Found",context: context);
            // _prefs.setInt("statusValue", 2);
          }
        }
      }
    /*  else if (newValue == 2) {
        try {

          print("Version 2222222");

          saf = Saf(Constant.businessWhatsAppPath);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory(Constant.savedDirectoryBusinessWhatsApp);

          getPermissionsBusinessWhatsApp();
          getSelectedDetails();
          _prefs.setInt("statusValue", 2);
          _activeAppController.changeActiveApp(2);

        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.snackBar(text: "No Business WhatsdssdApp Found", context: context);
          // _prefs.setInt("statusValue", 1);
        }
      }*/
      else {
        print("ERROR 1111");
      }
    }
    else if (androidSDK! < 30) {
      print("less than 30");
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
          ReusingWidgets.snackBar(text: "No WhatsApp Found",context: context);
          // _prefs.setInt("statusValue", 2);
        }
      }
      else  if (newValue == 2) {
        try {
          try {
            bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp.w4b');
            if (isInstalled) {
              _prefs.setInt("statusValue", 2);
              directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
              savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
              if (Directory(directoryPath.path).existsSync()) {
                getSelectedDetails();
                _activeAppController.changeActiveApp(2);
              }
              else{
                ReusingWidgets.snackBar(text: "Business WhatsApp found but Not Logged In",context: context);
              }
            }
            else {
              ReusingWidgets.snackBar(text: "No Business WhatsApp Found",context: context);
            }
          }
          catch (e) {
            ReusingWidgets.snackBar(text: e.toString(),context: context);
          }
        }
        catch (e) {
          print("Error is $e");
          if (context.mounted) {
            ReusingWidgets.snackBar(text: "No Business WhatsApp Found",context: context);
            // _prefs.setInt("statusValue", 2);
          }
        }
      }
      /*else if (newValue == 2) {
        try {
          _prefs.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');
          getSelectedDetails();
          _activeAppController.changeActiveApp(2);
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.snackBar(text: "No Business WhatsApp Found",context: context);
          // _prefs.setInt("statusValue", 1);
        }
      }*/
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
    getSync();

  }

  getImageData() {
    fileController.allStatusImages.value = [];
    if (imageList.isNotEmpty) {
      for (var element in imageList) {
        if (_activeAppController.activeApp.value == 1){
          if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          }
          else {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }
        }
        else if(_activeAppController.activeApp.value == 2){
          if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          }
          else {
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
        if (_activeAppController.activeApp.value == 1){
          if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          }
          else {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          }
        }
        else if(_activeAppController.activeApp.value == 2){
          if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first.toString()).
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

  getSync() async{
    var cachedFilesPath = await saf.cache();
    if (cachedFilesPath != null) {
      loadImage(cachedFilesPath);
      loadVideos(cachedFilesPath);
    }
  }

/*  getSync() async{
    var isSync = await saf.sync();
    if (isSync as bool) {
      var paths = await saf.getCachedFilesPath();
      loadImage(paths);
      loadVideos(paths);
    }
  }*/

  loadImage(paths) {

    fileController.allStatusImages.value = [];
    for (var element in paths) {
      if (element.endsWith(".jpg")) {
        if (_activeAppController.activeApp.value == 1){

          savedDirectory = Directory(Constant.savedDirectoryWhatsApp);
          savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith(".mp4")).toList(growable: false);


          if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first
              .replaceAll(" (1)","").replaceAll(" (2)","").replaceAll(" (3)","").toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          }
          else{
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }
        }
        else if (_activeAppController.activeApp.value == 2){

          savedDirectory = Directory(Constant.savedDirectoryBusinessWhatsApp);
          savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith(".mp4")).toList(growable: false);

          if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first
              .replaceAll(" (1)","").replaceAll(" (2)","").replaceAll(" (3)","").toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: true));
          }
          else{
            fileController.allStatusImages.add(FileModel(filePath: element, isSaved: false));
          }

        }
      }
    }


    setState(() {});
  }

  loadVideos(paths) {

    fileController.allStatusVideos.value = [];

    for (String element in paths) {
      if (element.endsWith(".mp4")) {
        if (_activeAppController.activeApp.value == 1){

          savedDirectory = Directory(Constant.savedDirectoryWhatsApp);
          savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith(".mp4")).toList(growable: false);

          if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first
              .replaceAll(" (1)","").replaceAll(" (2)","").replaceAll(" (3)","").toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          }
          else{
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          }
        }
        else if (_activeAppController.activeApp.value == 2){

          savedDirectory = Directory(Constant.savedDirectoryBusinessWhatsApp);
          savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith(".mp4")).toList(growable: false);

          if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first
              .replaceAll(" (1)","").replaceAll(" (2)","").replaceAll(" (3)","").toString()).
          contains(element.split(".Statuses/").last.split(".").first)) {
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          }
          else{
            fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          }
        }
      }
    }
    setState(() {});
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
                              ReusingWidgets.snackBar(text: "Opening WhatsApp...",context: context);
                            });
                          } else {
                            launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                          }
                        } catch (e) {
                          ReusingWidgets.snackBar(text: e.toString(),context: context);
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
                              ReusingWidgets.snackBar(text: "Opening Business WhatsApp...",context: context);
                            });
                          } else {
                            launchUrl(Uri.parse("market://details?id=com.whatsapp.w4b"));
                          }
                        } catch (e) {
                          ReusingWidgets.snackBar(text: e.toString(),context: context);
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
                    // setState(() async {
                    //   _activeAppController.activeApp.value = 1;
                      // getPermissionsWhatsApp();
                      await checkAndroidVersion(1);
                      // getSelectedDetails();
                    // });

                  }
                  else if (value == 2) {
                    // setState(() async {
                    //   _activeAppController.activeApp.value = 2;
                      // getPermissionsWhatsApp();
                      // getSelectedDetails();
                      await checkAndroidVersion(2);
                    // });

                  }
                },
              )
          ],
          backgroundColor: ColorsTheme.primaryColor,
          elevation: 0,
          bottom: TabBar(
            physics: BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,
            indicatorSize: TabBarIndicatorSize.tab,
            // isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal:40,vertical: 0),
            unselectedLabelColor: ColorsTheme.lightWhite,
            labelColor: ColorsTheme.white,
            indicatorColor: ColorsTheme.lightWhite,
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
