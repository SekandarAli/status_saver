// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/controller/active_app_controller.dart';
import 'package:status_saver/screens/whatsapp/saved/savedImage/savedImageDetailScreen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../app_theme/color.dart';
import '../../../../app_theme/reusing_widgets.dart';
import '../../../../app_theme/text_styles.dart';
import '../../../../controller/fileController.dart';
import '../../../../model/fileModel.dart';

class SavedImageScreen extends StatefulWidget {
  const SavedImageScreen({Key? key}) : super(key: key);
  @override
  SavedImageScreenState createState() => SavedImageScreenState();
}

class SavedImageScreenState extends State<SavedImageScreen> {

  Directory? savedImagesDirectory;
  Future<int>? storagePermissionChecker;
  int? storagePermissionCheck;
  int? androidSDK;
  final FileController fileController = Get.put(FileController());
  final ActiveAppController _activeAppController = Get.put(ActiveAppController());
  final MediaModel mediaModel = MediaModel();

  @override
  void initState() {
    log("checkkkkkkkkk");
    getDetails();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SavedImageScreen oldWidget){
    getDetails();
    super.didUpdateWidget(oldWidget);
  }

  getDetails(){

    savedImagesDirectory = _activeAppController.activeApp.value == 1 ?
    Directory('/storage/emulated/0/DCIM/StatusSaver/') :
    Directory('/storage/emulated/0/DCIM/StatusSaverBusiness/');

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

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (Directory(savedImagesDirectory!.path).existsSync()) {
      final imageList = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg')).toList(growable: false);
      if (imageList.isNotEmpty) {

        log("message");
        return Scaffold(
          backgroundColor: ColorsTheme.backgroundColor,
          body: FutureBuilder(
              future: storagePermissionChecker,
              builder: (context, snapshot) {
                log("futureBuilder");
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: GridView.builder(
                          physics: BouncingScrollPhysics(),
                          key: PageStorageKey(widget.key),
                          itemCount: imageList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    SavedImageDetailScreen(
                                      // imgPath: File(imageList[index]),
                                      // imgListIndex: imageList[index],
                                        imgList: imageList,
                                        indexNo: index
                                    ))).then((value) => setState((){}));
                              },
                              child: ReusingWidgets.getSavedData(
                                tag: imageList[index],
                                context: context,
                                file: File(imageList[index]),
                                showPlayIcon: true,
                                bgColor: ColorsTheme.dismissColor,
                                icon: Icons.delete,
                                color: ColorsTheme.dismissColor,
                                onSharePress: (){

                                  Share.shareXFiles(
                                    text: "Have a look on this Status",
                                    [XFile(Uri.parse(imageList[index]).path)],
                                  );
                                },
                                onDownloadDeletePress: (){

                                  _activeAppController.activeApp.value == 1 ?
                                  setState(() {
                                    mediaModel.deleteFile(context, File(imageList[index]));
                                    // File(imageList[index]).delete();
                                    for (var element in fileController.allStatusImages) {
                                      if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                                      contains(File(imageList[index]).toString().split("StatusSaver/").last.split(".").first)){
                                        element.isSaved = false;
                                      }
                                    }
                                  }) :
                                  setState(() {
                                    mediaModel.deleteFile(context, File(imageList[index]));
                                    // File(imageList[index]).delete();
                                    for (var element in fileController.allStatusImages) {
                                      if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                                      contains(File(imageList[index]).toString().split("StatusSaverBusiness/").last.split(".").first)){
                                        element.isSaved = false;
                                      }
                                    }
                                  });
                                  ReusingWidgets.toast(text: "Image Deleted Successfully!");
                                },
                              ),
                            );
                          }
                      ),
                    );
                  } else {
                    return ReusingWidgets.loadingAnimation();
                  }
                }
                else {
                  return ReusingWidgets.loadingAnimation();
                }
              }),
        );
      }
      else {
        return ReusingWidgets.emptyData(context: context);
      }
    }
    else {
      return ReusingWidgets.emptyData(context: context);
    }
  }
}


class MediaModel extends ChangeNotifier {

  Future<void> deleteFile(BuildContext context, File file) async {
    file.deleteSync();
    notifyListeners();
  }
}

