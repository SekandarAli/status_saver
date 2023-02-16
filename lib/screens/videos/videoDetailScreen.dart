// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

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
import 'videoController.dart';

class VideoDetailScreen extends StatefulWidget {
  String videoFile;
  int index;

  VideoDetailScreen({Key? key, required this.videoFile, required this.index})
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
    myUri = Uri.parse(widget.videoFile);
    // savedImagesDirectory = Directory('/storage/emulated/0/DCIM/StatusSaver');
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
          IconButton(onPressed: () {
            Share.shareXFiles(
              text: "Have a look on this Status",
              [XFile(myUri!.path)],
            );
          }, icon: Icon(Icons.share)),
          fileController.allStatusVideos.elementAt(widget.index).isSaved == true ?
          Obx(() {
            return Visibility(
              visible: fileController.allStatusVideos.elementAt(widget.index).isSaved,
              child: IconButton(
                  onPressed: () {
                    ReusingWidgets.snackBar(
                        context: context, text: "Image Already Saved");
                  }, icon: Icon(Icons.done)),
            );
          }) :

          Obx(() {
            return Visibility(
              visible: !(fileController.allStatusVideos.elementAt(widget.index).isSaved),
              child: IconButton(onPressed: () {
                GallerySaver.saveVideo(myUri!.path, albumName: "StatusSaver", toDcim: true).then((value) =>
                fileController.allStatusVideos.elementAt(widget.index).isSaved = true);
                fileController.allStatusVideos.refresh();
                ReusingWidgets.dialogueAnimated(
                  context: context,
                  dialogType: DialogType.success,
                  color: ColorsTheme.primaryColor,
                  title: "Video Saved",
                  desc: "Video saved to File Manager > Internal Storage > >DCIM > StatusSaver",
                );
              }, icon: Icon(Icons.save_alt)),
            );
          })
        ],
      ),
      body: VideoController(
        videoPlayerController:
        VideoPlayerController.file(File(widget.videoFile)),
      ),
    );
  }
}


