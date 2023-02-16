// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/model/fileModel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../app_theme/color.dart';
import '../../app_theme/reusing_widgets.dart';
import '../../app_theme/text_styles.dart';
import '../../controller/fileController.dart';

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
  // final FileController fileController = Get.put(FileController());


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
      final imageList = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
      if (imageList.isNotEmpty) {
        return Scaffold(
          body: Container(
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
                log("index is $index");
                return InkWell(
                  onTap: (){},
                  child: FutureBuilder(
                      future: getVideo(imageList[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return ReusingWidgets.getSavedData(
                                tag: imageList[index],
                                context: context,
                                file: File(snapshot.data!),
                                showPlayIcon: false,
                                icon: Icons.delete,
                                color: ColorsTheme.dismissColor,
                                onSharePress: (){
                                  Share.shareXFiles(
                                    text: "Have a look on this Status",
                                    [XFile(Uri.parse(imageList[index]).path)],
                                  );
                                },
                                onDownloadDeletePress: (){
                                    // deleteFile(File(imageList[index]));
                                    File(imageList[index]).delete().then((value) => setState((){}));
                                    ReusingWidgets.snackBar(
                                      context: context,
                                      text: "Video Deleted Successfully",
                                    );
                                },
                            );
                          } else {
                            return ReusingWidgets.getSavedData(
                              tag: imageList[index],
                              context: context,
                              file: File(imageList[index]),
                              showPlayIcon: true,
                              icon: Icons.delete,
                              color: ColorsTheme.dismissColor,
                              onSharePress: (){
                                Share.shareXFiles(
                                  text: "Have a look on this Status",
                                  [XFile(Uri.parse(imageList[index]).path)],
                                );
                              },
                              onDownloadDeletePress: (){
                                  // File(imageList[index]).delete();
/*

                                log("aaaaaaaaaaaaa");
                                log(fileController.allStatusSaved.elementAt(index).filePath.split("StatusSaver/").last.split('.').first);
                                log("bbbbbbbbbbbb");
                               // log(fileController.allStatusImages.elementAt(index).filePath.split(".Statuses/").last.split('.').first);
                                log(fileController.allStatusImages.where((item) => (item.filePath.split(".Statuses/").last.split('.').first) == (fileController.allStatusSaved.elementAt(index).filePath.split("StatusSaver/").last.split('.').first)).first.filePath);
                                fileController.allStatusImages.where((item) => (item.filePath.split(".Statuses/").last.split('.').first) == (fileController.allStatusSaved.elementAt(index).filePath.split("StatusSaver/").last.split('.').first)).first.isSaved = false;
*/

                                // deleteFile(File(fileController.allStatusSaved.elementAt(index).filePath));
                                File(imageList[index]).delete().then((value) => setState((){}));
                              //  fileController.allStatusSaved.removeAt(index);
                               /* log(fileController.allStatusSaved.length.toString());
                                log('remove fileController.allStatusSaved.length.toString()');*/

                               // fileController.allStatusImages.where((p0) => p0.filePath == fileController.allStatusSaved.elementAt(index).filePath);
                              // fileController.allStatusSaved.refresh();


                                /*if(fileController.allStatusSaved.elementAt(index).isImage){
                                  log("aaaaaaaaaaaaaaaaaaaaaaa");
                              //    fileController.allStatusImages.where((element) => (element.filePath.substring(72,104) == fileController.allStatusSaved.elementAt(index).filePath.substring(37,69))).first.isSaved = false;
                                  log("bbbbbbbbbbbbbbbbbbbbbbb");
                                  fileController.allStatusSaved.remove(FileModel(filePath: fileController.allStatusSaved.elementAt(index).filePath, isSaved: fileController.allStatusSaved.elementAt(index).isSaved, isImage: fileController.allStatusSaved.elementAt(index).isImage));

                                  fileController.allStatusSaved.refresh();
                                }*/

                                      //     fileController.allStatusSaved.refresh();
                                //   fileController.allStatusImages.remove(FileModel(filePath: fileController.allStatusSaved.elementAt(index).filePath, isSaved: fileController.allStatusSaved.elementAt(index).isSaved, isImage: fileController.allStatusSaved.elementAt(index).isImage));
                                // if(fileController.allStatusSaved.elementAt(index).filePath.split('.').)
                                  ReusingWidgets.snackBar(
                                    context: context,
                                    text: "Image Deleted Successfully",
                                  );
                              },
                            );
                          }
                        } else {
                          return Hero(
                            tag:imageList[index],
                            child: Image.asset(Assets.imagesVideoLoader,fit: BoxFit.cover,width: 30,height: 30),
                          );
                        }
                      }),
                );
              },
            ),
          ),
        );
      }
      else {
        return Center(
          child: Text(
            'Oops! No Saved Data Found.',
            style: ThemeTexts.textStyleTitle2,
          ),
        );
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
