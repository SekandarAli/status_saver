// ignore_for_file: prefer_const_constructors, null_check_always_fails

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/screens/status/statusImage/statusImageScreen.dart';
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


  @override
  void initState() {
    super.initState();
  }

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl,quality: 0);
    return thumbnail;
  }

  Future pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (fileController.allStatusVideos.isNotEmpty) {
      return Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          backgroundColor: ColorsTheme.primaryColor,
          color: ColorsTheme.white,
          strokeWidth: 2,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Obx(()=> GridView.builder(
                key: PageStorageKey(widget.key),
                itemCount: fileController.allStatusVideos.length,
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
                        future: getVideo(fileController.allStatusVideos.elementAt(index).filePath),
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState == ConnectionState.done) {
                          //   log("done2");
                          if (snapshot.hasData) {
                            return ReusingWidgets.getSavedData(
                              tag: fileController.allStatusVideos.elementAt(index).filePath,
                              context: context,
                              file: File(snapshot.data!),
                              showPlayIcon: false,
                              bgColor: fileController.allStatusVideos.elementAt(index).isSaved == false ?
                              ColorsTheme.primaryColor : ColorsTheme.doneColor,
                              icon: fileController.allStatusVideos.elementAt(index).isSaved == false
                                  ? Icons.save_alt : Icons.done,
                              color: fileController.allStatusVideos.elementAt(index).isSaved == false ?
                              ColorsTheme.white : ColorsTheme.doneColor,
                              onSharePress: (){
                                Share.shareXFiles(text: "Have a look on this Status",
                                  [XFile(Uri.parse(fileController.allStatusVideos.elementAt(index).filePath).path)],
                                );
                              },
                              onDownloadDeletePress: fileController.allStatusVideos.elementAt(index).isSaved == false ?
                                  (){

                                _activeAppController.activeApp.value == 1 ?
                                GallerySaver.saveVideo(Uri.parse(
                                    fileController.allStatusVideos.elementAt(index).filePath).path.replaceAll("%20"," "),
                                    albumName: "StatusSaver",
                                    toDcim: true).then((value) {
                                  fileController.allStatusVideos.elementAt(index).isSaved = true;
                                  fileController.allStatusVideos.refresh();
                                }) :
                                GallerySaver.saveVideo(Uri.parse(
                                    fileController.allStatusVideos.elementAt(index).filePath).path.replaceAll("%20"," "),
                                    albumName: "StatusSaverBusiness",
                                    toDcim: true).then((value) {
                                  fileController.allStatusVideos.elementAt(index).isSaved = true;
                                  fileController.allStatusVideos.refresh();
                                });
                                // ReusingWidgets.snackBar(context: context, text: "Image Saved");
                                ReusingWidgets.snackBar(text: "Video Saved Successfully!",context: context);


                              } : (){
                                ReusingWidgets.snackBar(text: "Video Already Saved",context: context);
                              },
                            );
                          }
                          else {
                            return ReusingWidgets.shimmerEffect(context: context);
                          }
                        }),
                  );
                },
              ))
          ),
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: ColorsTheme.backgroundColor,
        body: Center(
            child: ReusingWidgets.emptyData(context: context)
        ),
      );
    }
  }
}