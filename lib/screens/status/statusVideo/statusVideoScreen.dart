// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:saf/saf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/screens/status/statusImage/statusImageScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../app_theme/reusing_widgets.dart';
import '../../../../controller/active_app_controller.dart';
import '../../../../controller/fileController.dart';
import 'statusVideoDetailScreen.dart';

class StatusVideoScreen extends StatefulWidget {
  const StatusVideoScreen({Key? key}) : super(key: key);
  @override
  StatusVideoScreenState createState() => StatusVideoScreenState();
}

class StatusVideoScreenState extends State<StatusVideoScreen> {

  final FileController fileController = Get.put(FileController());
  final ActiveAppController _activeAppController = Get.put(ActiveAppController());

  Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');

  late Saf saf;
  var _paths = [];

  String directory = "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses";


  @override
  void initState() {
    super.initState();
    saf = Saf(directory);
    getPermission();
  }

  getPermission() async{
    await saf.getDirectoryPermission(isDynamic: true);
    getSync();
  }

  loadImage(paths) {
    var tempPaths = [];
    for (String path in paths) {
      if (path.endsWith(".mp4")) {
        tempPaths.add(path);
      }
    }
    // if (k.isNotEmpty) tempPaths.add(k);
    _paths = tempPaths;
    setState(() {});
  }

  getSync() async{
    var isSync = await saf.sync();
    if (isSync as bool) {
      var _paths = await saf.getCachedFilesPath();

      print(_paths!.map((e) => e.toString()));
      print("sdsd");
      loadImage(_paths);
    }
  }

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumbnail;
  }

  Future pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (_paths.isNotEmpty) {
          return WillPopScope(
            onWillPop: (){
              Get.offAll(StatusImageScreen());

              return null!;
            },
            child: Scaffold(
              backgroundColor: ColorsTheme.backgroundColor,
              body: RefreshIndicator(
                onRefresh: pullRefresh,
                backgroundColor: ColorsTheme.primaryColor,
                color: ColorsTheme.white,
                strokeWidth: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: GridView.builder(
                    key: PageStorageKey(widget.key),
                    itemCount: _paths.length,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.to(()=> StatusVideoDetailScreen(
                            indexNo: index,
                          ));
                        },
                        child: FutureBuilder(
                            future: getVideo(_paths[index]),
                            builder: (context, snapshot) {
                              // if (snapshot.connectionState == ConnectionState.done) {
                              //   log("done2");
                                if (snapshot.hasData) {
                                  return ReusingWidgets.getSavedData(
                                    tag: _paths[index],
                                    context: context,
                                    file: File(snapshot.data!),
                                    showPlayIcon: false,
                                    bgColor: ColorsTheme.primaryColor ,
                                    icon:Icons.save_alt,
                                    color: ColorsTheme.doneColor,
                                    onDownloadDeletePress:
                                        () {

                                      GallerySaver.saveVideo(
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
                                  );
                                }
                                else {
                                  return ReusingWidgets.loadingAnimation();
                                }
                            }),
                      );
                    },
                  )
                ),
              ),
            ),
          );
        }
        else {
          return Scaffold(
            backgroundColor: ColorsTheme.backgroundColor,
            body: Center(
              child:/* ReusingWidgets.allowPermissionButton(
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
                  text: "Fetch Statuses"),*/
              ReusingWidgets.emptyData(context: context)
            ),
          );
        }
  }
}
