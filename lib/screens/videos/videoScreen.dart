// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:status_saver/app_theme/color.dart';
import 'package:status_saver/generated/assets.dart';
import 'package:status_saver/model/fileModel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../app_theme/reusing_widgets.dart';
import '../../app_theme/text_styles.dart';
import '../../controller/fileController.dart';
import 'videoDetailScreen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {

  final FileController fileController = Get.put(FileController());
  late List<String> videoList;
  late List<String> savedList;
  Directory? whatsAppDirectory;
  Directory savedDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver/');


  @override
  void initState() {
    whatsAppDirectory = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
    videoList = whatsAppDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
    savedList = savedDirectory.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') || item.endsWith('.jpeg') || item.endsWith('.mp4')).toList(growable: false);
    getVideoData();
    super.initState();
  }

  Future<String?> getVideo(videoPathUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumbnail;
  }


  getVideoData(){
    fileController.allStatusVideos.value = [];
    if(videoList.isNotEmpty){
      for (var element in videoList) {
        if(savedList.map((e) => e.substring(37,69).toString()).contains(element.substring(72,104))){
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: true));
          print("aaa");
        }
        else{
          fileController.allStatusVideos.add(FileModel(filePath: element, isSaved: false));
          print("bbb");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    if (Directory(whatsAppDirectory!.path).existsSync()) {
      // final videoList = whatsAppDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.mp4')).toList(growable: false);
      // List savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) =>  item.endsWith('.mp4')).toList(growable: false);
      if (fileController.allStatusVideos.isNotEmpty) {
          return Scaffold(
            body: Container(
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
                  // var imageData = savedImagesFolder.map((e) => e.substring(37,69).toString()).contains(videoList[index].substring(72,104));
                   return InkWell(
                    onTap: () {
                      Get.to(()=> VideoDetailScreen(
                        indexNo: index,
                      ));
                    },
                    child: FutureBuilder(
                        future: getVideo(fileController.allStatusVideos.elementAt(index).filePath),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return
                                ReusingWidgets.getSavedData(
                                tag: fileController.allStatusVideos.elementAt(index).filePath,
                                context: context,
                                file: File(snapshot.data!),
                                showPlayIcon: false,
                                icon: fileController.allStatusVideos.elementAt(index).isSaved == false
                                    ? Icons.save_alt : Icons.done,
                                color: ColorsTheme.themeColor,
                                onSharePress: (){
                                  Share.shareXFiles(text: "Have a look on this Status",
                                    [XFile(Uri.parse(fileController.allStatusVideos.elementAt(index).filePath).path)],
                                  );
                                },
                                onDownloadDeletePress: fileController.allStatusVideos.elementAt(index).isSaved == false ?
                                    (){
                                    GallerySaver.saveVideo(Uri.parse(fileController.allStatusVideos.elementAt(index).filePath).path,albumName: "StatusSaver",toDcim: true ).then((value) =>
                                    fileController.allStatusVideos.elementAt(index).isSaved = true);
                                    fileController.allStatusSaved.add(FileModel(filePath: fileController.allStatusVideos.elementAt(index).filePath, isSaved: fileController.allStatusVideos.elementAt(index).isSaved));
                                    fileController.allStatusVideos.refresh();
                                    ReusingWidgets.snackBar(context: context, text: "Video Saved");
                                }
                                    : () {
                                  ReusingWidgets.snackBar(context: context, text: "Video Already Saved");
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          } else {
                            return Hero(
                              tag: fileController.allStatusVideos.elementAt(index).filePath,
                              child: Image.asset(Assets.imagesVideoLoader,fit: BoxFit.cover,width: 30,height: 30),
                            );
                          }
                        }),
                  );
                },
              ))
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
