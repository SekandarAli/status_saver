// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
  // Future<int>? storagePermissionChecker;
  // int? storagePermissionCheck;
  // int? androidSDK;
  final FileController fileController = Get.put(FileController());

  @override
  void initState() {
    savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');
    super.initState();
  }

  // Future<void> deleteFile(File file) async {
  //   try {
  //     if (await file.exists()) {
  //        unawaited(file.delete());
  //      // file.deleteSync(recursive: false);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }


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
        return Scaffold(
          backgroundColor: ColorsTheme.backgroundColor,
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
                return FutureBuilder(
                    future: getVideo(imageList[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
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
                              onDownloadDeletePress: ()async{

                                setState(() {
                                  print("qqqqqqqqqq${fileController.allStatusImages.elementAt(index).isSaved.toString()}");
                                  print("ddddddd${fileController.allStatusImages.elementAt(index).filePath.toString().split(".Statuses/").last.split(".").first}");
                                  print("aaaaaaa${imageList[index].toString().split("StatusSaver/").last.split(".").first}");

                                  File(imageList[index]).delete();

                                  // if(fileController.allStatusImages.elementAt(index).filePath.toString().split(".Statuses/").last.split(".").first ==
                                  //     File(imageList[index]).toString().split("StatusSaver/").last.split(".").first)
                                  //   {
                                  //     // fileController.allStatusImages.elementAt(index).isSaved = false;
                                  //     // fileController.allStatusImages.refresh();
                                  //
                                  //
                                  //     print("aaaaaaaaaaaaaaaaaa");
                                  //   }
                                  //
                                  // else{
                                  //   print("bbbbbbbbbbbb");
                                  // }


                                  for (var element in fileController.allStatusImages) {



                                    if(element.filePath.toString().split(".Statuses/").last.split(".").first.
                                    contains(File(imageList[index]).toString().split("StatusSaver/").last.split(".").first)){

                                      element.isSaved = false;

                                      // fileController.allStatusImages.refresh();

                                      print("qwqwqw${element.filePath.toString().split(".Statuses/").last.split(".").first.
                                      contains(File(imageList[index]).toString().split("StatusSaver/").last.split(".").first)}");

                                    }

                                  }


                                });

                                // File(imageList[index]).delete().then((value) => setState((){
                                //
                                //
                                // }));
                                // fileController.allStatusImages.elementAt(index).isSaved = false;
                                // // fileController.allStatusVideos.elementAt(index).isSaved = false;
                                // fileController.allStatusImages.refresh();
                                // // fileController.allStatusVideos.refresh();
                                // // fileController.allStatusSaved.refresh();
                                  // ReusingWidgets.snackBar(context: context, text: "Image Deleted Successfully");
                                ReusingWidgets.toast(text: "Image Deleted Successfully");
                              },
                            ),
                          );
                        }
                      }
                      else {
                        return Hero(tag:imageList[index],
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
