// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/screens/whatsapp/saved/savedVideo/savedVideoDetailScreen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../app_theme/color.dart';
import '../../../../app_theme/reusing_widgets.dart';
import '../../../../app_theme/text_styles.dart';
import '../../../../controller/fileController.dart';

class SavedVideoScreen extends StatefulWidget {
  const SavedVideoScreen({Key? key}) : super(key: key);
  @override
  SavedVideoScreenState createState() => SavedVideoScreenState();
}

class SavedVideoScreenState extends State<SavedVideoScreen> {

  Directory? savedImagesDirectory;
  FileController fileController = Get.put(FileController());

  @override
  void initState() {
    savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
    super.initState();
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
         unawaited(file.delete());
       // file.deleteSync(recursive: false);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    log("build");
    // log(fileController.allStatusSaved.length.toString());

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (Directory(savedImagesDirectory!.path).existsSync()) {
      final videoList = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
      if (videoList.isNotEmpty) {
        return Scaffold(
          backgroundColor: ColorsTheme.backgroundColor,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              key: PageStorageKey(widget.key),
              itemCount: videoList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext context, int index) {
                log("index is $index");
                return FutureBuilder(
                    future: getVideo(videoList[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  SavedVideoDetailScreen(
                                      videoPath: File(videoList[index]),
                                      indexNo: index
                                  ))).then((value) => setState((){}));
                            },
                            child: ReusingWidgets.getSavedData(
                                tag: videoList[index],
                                context: context,
                                file: File(snapshot.data!),
                                showPlayIcon: false,
                                bgColor: ColorsTheme.dismissColor,
                                icon: Icons.delete,
                                color: ColorsTheme.dismissColor,
                                onSharePress: (){
                                  Share.shareXFiles(
                                    text: "Have a look on this Status",
                                    [XFile(Uri.parse(videoList[index]).path)],
                                  );
                                },
                                onDownloadDeletePress: (){
                                    // deleteFile(File(videoList[index]));
                                    File(videoList[index]).delete().then((value) => setState((){}));
                                    fileController.allStatusVideos.elementAt(index).isSaved = false;
                                    fileController.allStatusVideos.refresh();
                                    fileController.allStatusSaved.refresh();
                                    // ReusingWidgets.snackBar(context: context, text: "Video Deleted Successfully");
                                    ReusingWidgets.toast(text: "Video Deleted Successfully");
                                },
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                      else {
                        return Hero(tag:videoList[index],
                          child: ReusingWidgets.loadingAnimation(),
                        );
                      }
                    });
              },
            ),
          ),
        );
      }
      else {
        return ReusingWidgets.emptyData(context: context);
      }
    }
    else {
      return Center(
        child: Text(
          'StatusSaved Directory not Exist',
          style: ThemeTexts.textStyleTitle3,
        ),
      );
    }
  }
}
