// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:url_launcher/url_launcher.dart';
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

  checkAndroidVersion() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      SharedPreferences pre = await SharedPreferences.getInstance();
      // int? checkWhatsApp = pre.getInt("statusValue");
      if (checkWhatsAppValue == 1) {
        try {
          // checkWhatsAppValue = 1;
          pre.setInt("statusValue", 1);
          print("Version Greater");
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No WhatsApp Found");
          pre.setInt("statusValue", 2);
        }
      } else if (checkWhatsAppValue == 2) {
        try {
          // checkWhatsAppValue = 2;
          pre.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          pre.setInt("statusValue", 1);
        }
      } else if (checkWhatsAppValue == 3) {
        try {
          // checkWhatsAppValue = 3;
          pre.setInt("statusValue", 3);
          directoryPath = Directory('/storage/emulated/0/Android/media/com.whatsapp.gb/GB WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
        }
      } else {
        print("ERROR 1111222222");
      }
    }
    else if (androidSDK! < 30) {
      SharedPreferences pre = await SharedPreferences.getInstance();
      // int? checkWhatsApp = pre.getInt("statusValue");
      if (checkWhatsAppValue == 1) {
        try {
          // checkWhatsAppValue = 1;
          pre.setInt("statusValue", 1);
          directoryPath = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No WhatsApp Found");
          pre.setInt("statusValue", 2);
        }
      }
      else if (checkWhatsAppValue == 2) {
        try {
          // checkWhatsAppValue = 2;
          pre.setInt("statusValue", 2);
          directoryPath = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No Business WhatsApp Found");
          pre.setInt("statusValue", 1);
        }
      }
      else if (checkWhatsAppValue == 3) {
        try {
          // checkWhatsAppValue = 3;
          pre.setInt("statusValue", 3);
          directoryPath = Directory('/storage/emulated/0/GB WhatsApp/Media/.Statuses');
          savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
          getSelectedDetails();
        }
        catch (e) {
          print("Error is $e");
          ReusingWidgets.toast(text: "No GB WhatsApp Found");
        }
      } else {
        print("ERROR 2");
      }
    } else {
      print("ERROR");
    }
  }

  getValue() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getInt('statusValue') != null) {
      checkWhatsAppValue = _prefs.getInt('statusValue')!;
    } else {
      checkWhatsAppValue = 1;
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

  getSelectedDetails(){
    imageList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
    videoList = directoryPath.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.mp4')).toList(growable: false);
    getImageData();
    getVideoData();
    createFolder();
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

  Future<int> loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      final currentStatusManaged = await Permission.manageExternalStorage.status;
      if (currentStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      final requestStatusManaged =
      await Permission.manageExternalStorage.request();
      if (requestStatusManaged.isGranted) {
        return 1;
      } else {
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
  }

  @override
  void initState() {
    super.initState();
    print("Status Image Screen");
    getValue();
    // checkAndroidVersion();
    storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (storagePermissionCheck == null || storagePermissionCheck == 0) {
        storagePermissionCheck = await loadPermission();
      } else {
        storagePermissionCheck = 1;
      }
      if (storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }
      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }
      return finalPermission;
    })();
  }

  Future pullRefresh() async {
    setState(() {});
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
          if (snapshot.connectionState == ConnectionState.done) {
            log("done1");
            if (snapshot.hasData) {
              log("done2");
              if (snapshot.data == 1) {
                log("done3");
                // if (Directory(whatsAppDirectory.path).existsSync()) {
                  if (fileController.allStatusImages.isNotEmpty) {
                    log("done4");

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
                                return Obx(() => InkWell(
                                  onTap: () {
                                    Get.to(() =>
                                        StatusImageDetailScreen(
                                          indexNo: index,
                                        ));
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
                                      GallerySaver.saveImage(Uri.parse(
                                          fileController.allStatusImages.elementAt(index).filePath).path.replaceAll("%20"," "),
                                          albumName: "StatusSaver",
                                          toDcim: true).then((value) {
                                        fileController.allStatusImages.elementAt(index).isSaved = true;
                                       fileController.allStatusImages.refresh();
                                      });
                                      // ReusingWidgets.snackBar(context: context, text: "Image Saved");
                                      ReusingWidgets.toast(text: "Image Saved");
                                    }
                                        : () {
                                      // ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
                                      ReusingWidgets.toast(
                                          text: "Image Already Saved");
                                    },
                                    onSharePress: () {
                                       // Share.shareXFiles(
                                        // text: "Have a look on this Status",
                                        // [XFile(Uri.parse(
                                        //     fileController.allStatusImages.elementAt(index).filePath).path)
                                        // ],
                                      // );
                                      log(Uri.parse(fileController.allStatusImages.elementAt(index).filePath).path.replaceAll("%20"," "));
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
                    log("done5");

                    checkAndroidVersion();
                    createFolder();

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
                                  text: "Open WhatsApp"),
                            ],
                          ),
                        ));
                  }
                }
              else {
                log("done6");

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
              log("done7");

              return ReusingWidgets.loadingAnimation();
              }
          }
            else if (snapshot.hasError) {
            log("done8");

            ReusingWidgets.toast(text: snapshot.error.toString());
              return Container();
              // return ReusingWidgets.circularProgressIndicator();
            }
            else {
            log("done9");
            return ReusingWidgets.loadingAnimation();
            }
          // }
          // else {
          //   return ReusingWidgets.circularProgressIndicator();
          // }
        },
      ),
    );
  }
}