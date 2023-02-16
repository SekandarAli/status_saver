// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../app_theme/color.dart';
import '../../app_theme/reusing_widgets.dart';
import '../../controller/fileController.dart';
import '../../model/fileModel.dart';
import 'videoController.dart';

class VideoDetailScreen extends StatefulWidget {
  int indexNo;

  VideoDetailScreen({Key? key, required this.indexNo})
      : super(key: key);

  @override
  _VideoDetailScreenState createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {

  Uri? myUri;

  // bool? imageData;
  // List? savedImagesFolder;
  // Directory? savedImagesDirectory;
  FileController fileController = Get.put(FileController());


  @override
  void initState() {
    super.initState();
    myUri = Uri.parse(fileController.allStatusVideos.elementAt(widget.indexNo).filePath);
    // savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver');

    // log("aaaaaaaaaaa${fileController.allStatusVideos.elementAt(widget.indexNo).isSaved.toString()}");
    log("aaaaaaaaaaa${File(fileController.allStatusVideos.elementAt(widget.indexNo).filePath)}");
    log("aaaaaaaaaaa${fileController.allStatusVideos.elementAt(widget.indexNo).filePath}");
  }

  @override
  void dispose() {
    super.dispose();
    // VideoPlayerController.file(File(widget.videoFile)).dispose();
  }

  @override
  Widget build(BuildContext context) {
    // savedImagesFolder = savedImagesDirectory!.listSync().map((item) => item.path).where((item) => item.endsWith('.jpg') ||item.endsWith('.mp4') || item.endsWith('.jpeg')).toList(growable: false);
    // imageData = savedImagesFolder!.map((e) => e.substring(37,69).toString()).contains(widget.videoFile.substring(72,104));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Video"),
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            // if (VideoPlayerController.file(File(widget.videoFile)).value.isPlaying) {
            //   VideoPlayerController.file(File(widget.videoFile)).pause();
            // }
            // else {
            //   Navigator.pop(context);
            // }
            Get.back();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles(text: "Have a look on this Status", [XFile(myUri!.path)],);
          },
              icon: Icon(Icons.share)),
          Obx(() =>
             Visibility(
              visible: fileController.allStatusVideos.elementAt(widget.indexNo).isSaved,
              child: IconButton(
                  onPressed: () {
                    print("bbbbbbbbbb");

                    ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
                  }, icon: Icon(Icons.done)),
            )
          ),
          Obx(() =>
             Visibility(
              visible: !(fileController.allStatusVideos.elementAt(widget.indexNo).isSaved),
              child: IconButton(onPressed: () {


                GallerySaver.saveVideo(Uri.parse(fileController.allStatusVideos.elementAt(widget.indexNo).filePath).path,albumName: "StatusSaver",toDcim: true ).then((value) =>
                fileController.allStatusVideos.elementAt(widget.indexNo).isSaved = true);
                fileController.allStatusSaved.add(FileModel(filePath: fileController.allStatusVideos.elementAt(widget.indexNo).filePath, isSaved: fileController.allStatusVideos.elementAt(widget.indexNo).isSaved));
                fileController.allStatusSaved.refresh();
                fileController.allStatusVideos.refresh();
                ReusingWidgets.snackBar(
                  context: context,
                  text: "Video Saved",
                );


                // GallerySaver.saveVideo(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) =>
                // fileController.allStatusVideos.elementAt(widget.indexNo).isSaved = true);
                // fileController.allStatusVideos.refresh();
                // print("aaaaaaaaaaaa");
                // ReusingWidgets.dialogueAnimated(
                //   context: context,
                //   dialogType: DialogType.success,
                //   color: ColorsTheme.primaryColor,
                //   title: "Video Saved",
                //   desc: "Video saved to File Manager > Internal Storage > >DCIM > StatusSaver",
                // );
              }, icon: Icon(Icons.save_alt)),
            )
          )
        ],
      ),
      body: VideoController(
        videoPlayerController:
        VideoPlayerController.file(File(fileController.allStatusVideos.elementAt(widget.indexNo).filePath)),
      ),
    );
  }
}


