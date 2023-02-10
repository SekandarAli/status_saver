// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/app_theme/reusing_widgets.dart';
import 'package:status_saver/app_theme/text_styles.dart';
import '../../generated/assets.dart';
import 'imageDetailScreen.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);
  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  int? storagePermissionCheck;
  Future<int>? storagePermissionChecker;
  int? androidSDK;
  Directory? whatsAppDirectory;
  Directory? whatsAppBusinessDirectory;

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
    whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
    whatsAppBusinessDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
   return Scaffold(
     backgroundColor: ColorsTheme.backroundColor,
     body: FutureBuilder(
       future: storagePermissionChecker,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.done) {
           if (snapshot.hasData) {
             if (snapshot.data == 1) {
               if (Directory(whatsAppDirectory!.path).existsSync()) {
                 final imageList = whatsAppDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg')).toList(growable: false);
                 if (imageList.isNotEmpty) {
                   return Container(
                       height: h,
                       width: w,
                       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                       child: GridView.builder(
                         key: PageStorageKey(widget.key),
                         itemCount: imageList.length,
                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 2,
                           mainAxisSpacing: 5,
                           crossAxisSpacing: 5,
                           childAspectRatio: 0.75
                         ),
                         itemBuilder: (BuildContext context, int index) {
                           return InkWell(
                             onTap: () {
                               Navigator.push(context, MaterialPageRoute(
                                   builder: (context) => ImageDetailScreen(
                                     imgPath: imageList[index],
                                   ),
                                 ),
                               );
                             },
                             child:
                                 Stack(
                                   alignment: Alignment.bottomCenter,
                                   fit: StackFit.loose,
                                   children: [
                                     Hero(
                                       tag: imageList[index],
                                       child: Container(
                                         height: h,
                                         width: w,
                                         color: Colors.white,
                                         child: ClipRRect(
                                           borderRadius: BorderRadius.all(Radius.circular(10)),
                                           child: Image.file(
                                             File(imageList[index]),
                                             fit: BoxFit.cover,
                                             filterQuality: FilterQuality.high,
                                           ),
                                         ),
                                       ),
                                     ),
                                     ReusingWidgets.bottomLayer(
                                         context: context,
                                         icon: Icons.download,
                                         color: ColorsTheme.lightThemeColor,
                                         onSharePress: (){},
                                         onDownloadDeletePress: (){},
                                     ),
                                   ],
                                 ),

                           );
                         },
                       )
                   );
                 } else {
                   return Center(
                     child: Container(
                       padding: const EdgeInsets.only(bottom: 60.0),
                       child: const Text(
                         'You have not watched any status yet!',
                         style: ThemeTexts.textStyleTitle2,
                       ),
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
               Future((){
                 showDialog(
                   context: context,
                   barrierDismissible: false,
                   builder: (context) => ReusingWidgets().permissionDialogue(
                       context: context,
                       width: w,
                       height: h,
                       onPress: (){
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
                     onPress: (){
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
         }
         else {
           return ReusingWidgets.circularProgressIndicator();
         }
       },
     ),
   );
  }
}
