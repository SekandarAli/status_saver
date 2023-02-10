// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_saver/generated/assets.dart';
import '../../app_theme/text_styles.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);
  @override
  SavedScreenState createState() => SavedScreenState();
}

class SavedScreenState extends State<SavedScreen> {

  Directory? savedImagesDirectory;
  Future<int>? storagePermissionChecker;
  int? storagePermissionCheck;
  int? androidSDK;


  @override
  void initState() {
    savedImagesDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

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
    super.initState();
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

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (Directory(savedImagesDirectory!.path).existsSync()) {
      final imageList = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
      if (imageList.isNotEmpty) {
        return Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: GridView.builder(
              key: PageStorageKey(widget.key),
              itemCount: imageList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: FutureBuilder(
                        future: storagePermissionChecker,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Hero(
                                tag: imageList[index],
                                child: Image.file(
                                  File(imageList[index]),
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return  Hero(
                                tag: imageList[index],
                                child: Image.asset(Assets.imagesVideoLoader,fit: BoxFit.cover,width: 30,height: 30),
                              );
                            }
                          } else {
                            return Hero(
                              tag: imageList[index],
                              child: Image.asset(Assets.imagesVideoLoader,fit: BoxFit.cover,width: 30,height: 30),
                            );
                          }
                        }),
                  ),
                );
              },
            ),
          ),
        );
      }
      else {
        return Center(
          child: Text(
            'Sorry, No Videos Found.',
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
}
