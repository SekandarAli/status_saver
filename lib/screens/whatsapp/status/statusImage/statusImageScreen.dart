// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import 'package:status_saver/controller/fileController.dart';
import 'package:status_saver/model/fileModel.dart';
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
  Directory? savedImagesDirectory;

  // Directory? whatsAppBusinessDirectory;
  final FileController fileController = Get.put(FileController());
  // List<String>? imageList;
  // List<String>? savedList;

  // Directory whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
  // Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

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

  createFolder() async {
    const folderName = "StatusSaver";
    final path = Directory('/storage/emulated/0/DCIM/$folderName');
    if ((await path.exists())) {
      savedImagesDirectory = Directory('/storage/emulated/0/DCIM/$folderName');
    }
    else {
      path.create();
    }
  }

  // getImageData() {
  //   fileController.allStatusImages.value = [];
  //   if (imageList!.isNotEmpty) {
  //     for (var element in imageList!) {
  //       if (savedList!.map((e) => e.split("StatusSaver/").last.split(".").first.toString()).contains(element.split(".Statuses/").last.split(".").first)) {
  //         // print("IF$element");
  //         fileController.allStatusImages.add(
  //             FileModel(filePath: element, isSaved: true));
  //       }
  //       else {
  //         // print("ELSE$element");
  //         fileController.allStatusImages.add(
  //             FileModel(filePath: element, isSaved: false));
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();

    // imageList = whatsAppDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
    // savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
    // whatsAppBusinessDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');


    // log(fileController.allStatusImages.map((element) => element.filePath).toString());
    createFolder();
    // getImageData();
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
            log("done");
            if (snapshot.hasData) {
              if (snapshot.data == 1) {
                // if (Directory(whatsAppDirectory.path).existsSync()) {
                  if (fileController.allStatusImages.isNotEmpty) {
                    return RefreshIndicator(
                      backgroundColor: ColorsTheme.primaryColor,
                      color: ColorsTheme.white,
                      strokeWidth: 2,
                      onRefresh: pullRefresh,
                      child: Container(
                        height: h,
                        width: w,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Obx(() =>
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

                                // log("aaa${(fileController.allStatusImages.elementAt(index).filePath)}");
                                log("qqqqqqq${(fileController.allStatusImages.elementAt(index).isSaved)}");
                                return InkWell(
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
                                        // fileController.allStatusSaved.add(
                                        //     FileModel(
                                        //       filePath: fileController.allStatusImages.elementAt(index).filePath.replaceAll("%20"," "),
                                        //       isSaved: fileController.allStatusImages.elementAt(index).isSaved,));
                                        fileController.allStatusImages.refresh();
                                        // fileController.allStatusSaved.refresh();
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
                                );
                              },
                            )),
                      ),
                    );
                  }
                  else {
                    return Center(
                      child: Text(
                        'You have not watched any status yet!',
                        style: ThemeTexts.textStyleTitle2,
                      ),
                    );
                  }
                }
                else {
                  return Center(
                    child: Text(
                      'No WhatsApp Found!',
                      style: ThemeTexts.textStyleTitle3,
                    ),
                  );
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
                return Center(child: Padding(
                  padding: EdgeInsets.all(30),
                  child: ReusingWidgets.allowPermissionButton(
                      onPress: () {
                        setState(() {
                          storagePermissionChecker = requestPermission();
                        });
                      },
                      context: context,
                      text: "Allow Permission"),
                ));
              }
            }
            else if (snapshot.hasError) {
              return ReusingWidgets.circularProgressIndicator();
            }
            else {
              return ReusingWidgets.circularProgressIndicator();
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