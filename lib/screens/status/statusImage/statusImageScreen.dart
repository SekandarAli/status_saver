// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/active_app_controller.dart';
import '../../../../model/fileModel.dart';
import 'statusImageDetailScreen.dart';

class StatusImageScreen extends StatefulWidget {
  const StatusImageScreen({Key? key}) : super(key: key);
  @override
  StatusImageScreenState createState() => StatusImageScreenState();
}

class StatusImageScreenState extends State<StatusImageScreen> {
  int? storagePermissionCheck;
  Future<int>? storagePermissionChecker;
  int? androidSDK;
  FileController fileController = Get.put(FileController());


  late List<String> imageList;
  late List<String> videoList;
  late List<String> savedList;

  late Directory directoryPath ;
  late Directory savedDirectory;

  int checkWhatsAppValue = 1;

  late SharedPreferences _prefs;

  final ActiveAppController _activeAppController = Get.put(ActiveAppController());

  late Saf saf;
  var _paths = [];

  String directory = "/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses";
  // String directory = "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";



  @override
  void initState() {
    super.initState();

    saf = Saf(directory);

    getPrefs();
    storagePermission();
    createFolder();
    createFolderBusiness();
  }
  storagePermission(){
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

  loadImage(paths) {

    var tempPaths = [];
    for (String path in paths) {
      if (path.endsWith(".jpg")) {
        tempPaths.add(path);
      }
    }
    // if (k.isNotEmpty) {
    //   tempPaths.add(k);
    //   print("aaa");
    // }

    _paths = tempPaths;
    setState(() {});
  }

  getSync() async{
    var isSync = await saf.sync();
    if (isSync as bool) {
      var paths = await saf.getCachedFilesPath();
      loadImage(paths);
      // getImageData(_paths);
    }
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

          saf = Saf(directory);

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

          saf = Saf(directory);


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

  createFolderBusiness() async {
    const folderName = "StatusSaverBusiness";
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
    // getImageData();
    getVideoData();
    createFolder();
    createFolderBusiness();
  }

  getImageData(paths) {
    directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    fileController.allStatusImages.value = [];
    if (imageList.isNotEmpty) {
      for (var element in paths) {
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

  Future<int> loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {


      bool? permission = await saf.getDirectoryPermission(isDynamic: true,);
      // var permission = await Saf.getPersistedPermissionDirectories();

      print("directory${saf.getCachedFilesPath().toString()}");
      print("directory${saf.getFilesPath().toString()}");
      print("directory${permission.toString()}");

      // bool permissison = FilePicker.platform.getDirectoryPath();

      if(permission == true){
        getSync();
        return 1;
      }
      else {
        return 0;
      }
    }
    else {
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

/*  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      bool? permission = await saf.getDirectoryPermission(isDynamic: true);
      // var permission = await Saf.getPersistedPermissionDirectories();
      if(permission == true){
        getSync();
        return 1;
      }
      else {
        return 0;
      }
    } else {
      final requestStatusStorage = await Permission.storage.request();
      if (requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }*/

  getPrefs() async {
    _prefs =  await SharedPreferences.getInstance();
  }

  Future pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (_paths.isNotEmpty) {
      return Scaffold(
        body: RefreshIndicator(

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
                itemCount: _paths.length,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.75
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StatusImageDetailScreen(indexNo: index)));

                      // Get.to(() => StatusImageDetailScreen(indexNo: index));
                    },
                    child:
                    ReusingWidgets.getSavedData(
                      tag: _paths[index],
                      context: context,
                      file: File(_paths[index]),
                      showPlayIcon: true,
                      bgColor: ColorsTheme.primaryColor ,
                      icon:Icons.save_alt,
                      color: ColorsTheme.doneColor,
                      onDownloadDeletePress:
                          () {

                        GallerySaver.saveImage(
                            Uri.parse(_paths[index]).path,
                            albumName: "StatusSaver",
                            toDcim: true);
                        ReusingWidgets.toast(text: "Image Saved");
                      },
                      onSharePress: () async{
                        // Share.shareXFiles(
                        // text: "Have a look on this Status",
                        // [XFile(Uri.parse(
                        //     fileController.allStatusImages.elementAt(index).filePath).path)
                        // ],
                        // );
                        Share.shareFiles(
                          [Uri.parse(_paths[index]).path.replaceAll("%20"," ")],
                          text: 'Have a look on this Status',
                        );
                      },
                    ),
                  );
                },
              )),
        ),
      );
    }
    else {

      // checkAndroidVersion(_activeAppController.activeApp.value);
      // createFolder();
      // createFolderBusiness();

      return Scaffold(
        body: Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.imagesPermission,
                      width: w, height: h / 3.5),
                  SizedBox(height: 5),
                  Text("You haven't seen any Status Yet!",style: ThemeTexts.textStyleTitle3.copyWith(color: ColorsTheme.textColor),),
                  SizedBox(height: 10),
                  ReusingWidgets.allowPermissionButton(
                      onPress: ()async {
                        try {
                          bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
                          if (isInstalled) {


                            // final androidInfo = await DeviceInfoPlugin().androidInfo;
                            // setState(() {
                            //   androidSDK = androidInfo.version.sdkInt;
                            // });
                            // if (androidSDK! >= 30) {
                            //
                            //   bool? permission = await saf.getDirectoryPermission(isDynamic: true);
                            //   if(permission == true){
                            //     getSync();
                            //     storagePermission();
                            //     return 1;
                            //   }
                            //   else {
                            //     checkAndroidVersion(1);
                            //     return 0;
                            //   }
                            // }
                            // else {
                            //   final currentStatusStorage = await Permission.storage.status;
                            //   if (currentStatusStorage.isGranted) {
                            //     getSync();
                            //     storagePermission();
                            //     return 1;
                            //   } else {
                            //     return 0;
                            //   }
                            // }
                            // getSync();
                            DeviceApps.openApp("com.whatsapp").then((value){
                              ReusingWidgets.toast(text: "Opening WhatsApp...");
                            });
                          }
                          else {
                            launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                          }
                        } catch (e) {
                          ReusingWidgets.toast(text: e.toString());
                        }
                      },

                      context: context,
                      text: "Watch Status"),
                ],
              ),
            )),
      );
    }

    /*Scaffold(
      backgroundColor: ColorsTheme.backgroundColor,
      body: FutureBuilder(
        future: storagePermissionChecker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print("hello1");
              if (snapshot.data == 1) {
                print("hello32");
                // if (Directory(whatsAppDirectory.path).existsSync()) {
                if (_paths.isNotEmpty) {
                  print("hello");
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
                          itemCount: _paths.length,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.75
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>StatusImageDetailScreen(indexNo: index)));

                                // Get.to(() => StatusImageDetailScreen(indexNo: index));
                              },
                              child:
                              ReusingWidgets.getSavedData(
                                tag: _paths[index],
                                context: context,
                                file: File(_paths[index]),
                                showPlayIcon: true,
                                bgColor: ColorsTheme.primaryColor ,
                                icon:Icons.save_alt,
                                color: ColorsTheme.doneColor,
                                onDownloadDeletePress:
                                    () {

                                  GallerySaver.saveImage(
                                      Uri.parse(_paths[index]).path,
                                      albumName: "StatusSaver",
                                      toDcim: true);
                                  ReusingWidgets.toast(text: "Image Saved");
                                },
                                onSharePress: () async{
                                  // Share.shareXFiles(
                                  // text: "Have a look on this Status",
                                  // [XFile(Uri.parse(
                                  //     fileController.allStatusImages.elementAt(index).filePath).path)
                                  // ],
                                  // );
                                  Share.shareFiles(
                                    [Uri.parse(_paths[index]).path.replaceAll("%20"," ")],
                                    text: 'Have a look on this Status',
                                  );

                                },
                              ),
                            );
                          },
                        )),
                  );
                }
                else {

                  // checkAndroidVersion(_activeAppController.activeApp.value);
                  // createFolder();
                  // createFolderBusiness();

                  return Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.imagesPermission,
                                width: w, height: h / 3.5),
                            SizedBox(height: 5),
                            Text("You haven't seen any Status Yet!",style: ThemeTexts.textStyleTitle3,),
                            SizedBox(height: 10),
                            ReusingWidgets.allowPermissionButton(
                                onPress: ()async {
                                  try {
                                    bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
                                    if (isInstalled) {

                                      getSync();
                                      // DeviceApps.openApp("com.whatsapp").then((value){
                                      //   ReusingWidgets.toast(text: "Opening WhatsApp...");
                                      // });
                                    }
                                    else {
                                      launchUrl(Uri.parse("market://details?id=com.whatsapp"));
                                    }
                                  } catch (e) {
                                    ReusingWidgets.toast(text: e.toString());
                                  }
                                },

                                context: context,
                                text: "Fetch Statuses"),
                          ],
                        ),
                      ));
                }
              }
              else {
                Future(() {
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
                              });
                            }
                        ),
                  );
                });
                return Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Assets.imagesPermission,
                              width: w, height: h / 3.5),
                          SizedBox(height: 15),
                          ReusingWidgets.allowPermissionButton(
                              onPress: () {
                                setState(() {
                                  storagePermissionChecker = requestPermission();
                                });
                              },
                              context: context,
                              text: "Allow Permission"),
                        ],
                      ),
                    ));
              }
            }
            else {
              return ReusingWidgets.loadingAnimation();
            }
          }
          else if (snapshot.hasError) {
            ReusingWidgets.toast(text: snapshot.error.toString());
            return Container();
          }
          else {
            return ReusingWidgets.loadingAnimation();
          }
          // }
          // else {
          //   return ReusingWidgets.circularProgressIndicator();
          // }
        },
      ),
    );*/
  }
}