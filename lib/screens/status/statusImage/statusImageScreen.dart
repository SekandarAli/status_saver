// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/constants/constant.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/controller/permission_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/active_app_controller.dart';
import '../../../../model/fileModel.dart';
import '../../../app_theme/reusing_widgets.dart';
import '../../../app_theme/text_styles.dart';
import '../../../generated/assets.dart';
import 'statusImageDetailScreen.dart';


class StatusImageScreen extends StatefulWidget {
  const StatusImageScreen({Key? key}) : super(key: key);
  @override
  StatusImageScreenState createState() => StatusImageScreenState();
}

class StatusImageScreenState extends State<StatusImageScreen> with WidgetsBindingObserver{


  int? storagePermissionCheck;
  Future<int>? storagePermissionChecker;
  int? androidSDK;

  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath ;
  late Directory savedDirectory;

  int checkWhatsAppValue = 1;

  bool permission = false;

  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  FileController fileController = Get.put(FileController());
  final PermissionController _permissionController = Get.put(PermissionController());

  late SharedPreferences _prefs;
  late Saf saf;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    createFolder();
    createFolderBusiness();

    saf = _activeAppController.activeApp.value == 1  ? Saf(Constant.whatsAppPath) : Saf(Constant.businessWhatsAppPath);

    getPrefs();
    getSync();
    storagePermission();

    print("Status Image Screen");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

            if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).
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

            if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first.toString()).
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

          if (savedList.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).
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

          if (savedList.map((e) => e.split("StatusSaverBusiness/").last.split(".").first.toString()).
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

  storagePermission() {
    storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (storagePermissionCheck == null || storagePermissionCheck == 0) {
        storagePermissionCheck = await loadPermission();
      }
      else {
        storagePermissionCheck = 1;
      }
      if (storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      }
      else {
        storagePermissionCheckInt = 0;
      }
      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      }
      else {
        finalPermission = 0;
      }
      return finalPermission;
    })();
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

  getSelectedDetails(){
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
    createFolder();
    createFolderBusiness();
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

  createFolder() async {
    const folderName = "StatusSaver";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      print("Path Exist image");
    }
    else {
      path.create();
      print("Path created image");
    }
  }

  createFolderBusiness() async {
    const folderName = "StatusSaverBusiness";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      print("Path Exist image");
    }
    else {
      path.create();
      print("Path created image");
    }
  }

  Future<int> loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      // getPermissions();
      return 1;
    }
    else {
      print("less thanddd 30");
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      }
      else if(currentStatusStorage.isPermanentlyDenied){
        // await Permission.storage.request();
        return 2;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      // getPermissions();
      return 1;
    }

    else {
      print("less than 30");
      final requestStatusStorage = await Permission.storage.request();
      if (requestStatusStorage.isGranted) {
        return 1;
      }

      else if(requestStatusStorage.isPermanentlyDenied){
        // await Permission.storage.request();
        return 2;
      }
      else{
        return 0;
      }
    }
  }

  getPrefs() async {
    _prefs =  await SharedPreferences.getInstance();
  }

  Future pullRefresh() async {
    setState(() {
      storagePermissionChecker = requestPermission();
      log("pull to refresh");
    });
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
    setState(() {});
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
    setState(() {});
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        log("resumed");
        storagePermissionChecker = requestPermission();
      });
    }
    else if (state == AppLifecycleState.paused) {
      log("paused");
    }

    else if (state == AppLifecycleState.inactive) {
      log("inactive");
    }
    else if (state == AppLifecycleState.detached) {
      log("detached");
    }
    else{
      log(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: FutureBuilder(
          future: storagePermissionChecker,
          builder: (context, snapshot) {
            print("hello44441");
            // if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print("hello1");
              if (snapshot.data == 1) {
                print("snapshot.data == 1");

              /*  if (!Directory(directoryPath.path).existsSync()) {
                  return ReusingWidgets().noWhatsAppFound(
                      context: context,
                      title: "App Not Installed",
                      buttonText: "Open WhatsApp",
                      titleColor: ColorsTheme.primaryColor,
                      width: w,
                      height: h,
                      onPress: () {
                        ReusingWidgets.snackBar(context: context, text: "Opening WhatsApp...");
                      }
                  );
                }
                else */
                if (fileController.allStatusImages.isNotEmpty) {
                  print("hello2222222");
                  return RefreshIndicator(
                    backgroundColor: ColorsTheme.primaryColor,
                    color: ColorsTheme.white,
                    strokeWidth: 2,
                    onRefresh: pullRefresh,
                    child: Container(
                        height: h,
                        width: w,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child:
                        GridView.builder(
                          key: PageStorageKey(widget.key),
                          itemCount: fileController.allStatusImages.length,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.75
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(()=> InkWell(
                              onTap: () {
                                Get.to(() => StatusImageDetailScreen(indexNo: index));
                              },
                              child:
                              ReusingWidgets.getSavedData(
                                tag: fileController.allStatusImages.elementAt(index).filePath,
                                context: context,
                                file: File(fileController.allStatusImages.elementAt(index).filePath),
                                showPlayIcon: true,
                                bgColor: fileController.allStatusImages.elementAt(index).isSaved == false ?
                                ColorsTheme.primaryColor : ColorsTheme.doneColor,
                                icon:
                                fileController.allStatusImages.elementAt(index).isSaved == false
                                    ? Icons.save_alt : Icons.done,
                                color: fileController.allStatusImages.elementAt(index).isSaved == false ?
                                ColorsTheme.white : ColorsTheme.doneColor,
                                onDownloadDeletePress: fileController.allStatusImages.elementAt(index).isSaved == false ?
                                    () {
                                  _activeAppController.activeApp.value == 1 ?
                                  GallerySaver.saveImage(Uri.parse(
                                      fileController.allStatusImages.elementAt(index).filePath).path.replaceAll("%20"," "),
                                      albumName: "StatusSaver",
                                      toDcim: true).then((value) {
                                    fileController.allStatusImages.elementAt(index).isSaved = true;
                                    fileController.allStatusImages.refresh();
                                  }) :
                                  GallerySaver.saveImage(Uri.parse(
                                      fileController.allStatusImages.elementAt(index).filePath).path.replaceAll("%20"," "),
                                      albumName: "StatusSaverBusiness",
                                      toDcim: true).then((value) {
                                    fileController.allStatusImages.elementAt(index).isSaved = true;
                                    fileController.allStatusImages.refresh();
                                  });
                                  ReusingWidgets.snackBar(text: "Image Saved",context: context);
                                }
                                    : () {
                                  ReusingWidgets.snackBar(text: "Image Already Saved",context: context);
                                },
                                onSharePress: () {
                                  // Share.shareXFiles(
                                  // text: "Have a look on this Status",
                                  // [XFile(Uri.parse(
                                  //     fileController.allStatusImages.elementAt(index).filePath).path)
                                  // ],
                                  // );
                                  Share.shareFiles(
                                    [Uri.parse(fileController.allStatusImages.elementAt(index).filePath).path.replaceAll("%20"," ")],
                                    text: 'Have a look on this Status',
                                  );
                                },
                              ),
                            ));
                          },
                        )),
                  );
                }

                else {
                  print("Check Android Version");
                  // checkAndroidVersion(_activeAppController.activeApp.value);
                  // return ReusingWidgets.emptyData(context: context);
                  // return ReusingWidgets.loadingAnimation();
                  if(_permissionController.permissionGrantedWhatsApp.value){
                    log("Permission Given");
                    return ReusingWidgets.loadingAnimation();
                  }else{
                    log("Permission Not Given");
                    return ReusingWidgets().permissionDialogue(
                        context: context,
                        title: "Allow Permission",
                        buttonText: "Allow permission",
                        titleColor: ColorsTheme.primaryColor,
                        width: w,
                        height: h,
                        onPress: () {
                          setState(() {
                            getPermissionsWhatsApp();
                          });
                        }
                    );
                  }

                }
              }
              else if (snapshot.data == 2){
                print("snapshot.data == 2");
                return ReusingWidgets().permissionDialogue(
                    context: context,
                    title: "Permission Denied",
                    buttonText: "Open Settings",
                    titleColor: ColorsTheme.dismissColor,
                    width: w,
                    height: h,
                    onPress: () {
                      AppSettings.openAppSettings(callback: () {
                        print("sample callback function called");
                        ReusingWidgets.snackBar(context: context, text: "Opening Settings please wait...");
                      });
                    }
                );
              }
              else {
                print("snapshot.data == 0");
                return ReusingWidgets().permissionDialogue(
                    context: context,
                    title: "Allow Permission",
                    buttonText: "Allow permission",
                    titleColor: ColorsTheme.primaryColor,
                    width: w,
                    height: h,
                    onPress: () {
                      setState(() {
                        storagePermissionChecker = requestPermission();
                        log( storagePermissionChecker.toString());
                      });
                    }
                );
              }
            }
            else {
              return ReusingWidgets.loadingAnimation();
            }
          },
        ));



  }
}

/* Future(() {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          ReusingWidgets().permissionDialogue(
                              context: context,
                              width: w,
                              height: h,
                              onPress: () {
                                setState(() {
                                  storagePermissionChecker = requestPermission();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                          ),
                    );
                  });*/
