// ignore_for_file: must_be_immutable, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../../../../app_theme/color.dart';
import '../../../../app_theme/reusing_widgets.dart';
import '../../../../controller/fileController.dart';
import '../../../../model/fileModel.dart';

class StatusVideoDetailScreen extends StatefulWidget {
  int indexNo;

  StatusVideoDetailScreen({Key? key, required this.indexNo}) : super(key: key);

  @override
  _StatusVideoDetailScreenState createState() => _StatusVideoDetailScreenState();
}

class _StatusVideoDetailScreenState extends State<StatusVideoDetailScreen> {

  Uri? myUri;
  FileController fileController = Get.put(FileController());

  @override
  void initState() {
    super.initState();
    myUri = Uri.parse(fileController.allStatusVideos.elementAt(widget.indexNo).filePath);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Status Video"),
        leading: IconButton(
          color: ColorsTheme.white,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
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
                    // ReusingWidgets.snackBar(context: context, text: "Image Already Saved");
                    ReusingWidgets.toast(text: "Image Already Saved");
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
                fileController.allStatusVideos.refresh();
                // ReusingWidgets.snackBar(context: context, text: "Video Saved");
                ReusingWidgets.toast(text: "Video Saved");
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



class VideoController extends StatefulWidget {
  VideoController({Key? key, required this.videoPlayerController}) : super(key: key);

  VideoPlayerController videoPlayerController;

  @override
  State<VideoController> createState() => _VideoControllerState();
}

class _VideoControllerState extends State<VideoController> {

  ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      looping: true,
      autoPlay: true,
      allowFullScreen: true,
      showOptions: false,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      showControls: true,
      additionalOptions: (context) {
        return [
          OptionItem(
            onTap: () => debugPrint('My option works!'),
            iconData: Icons.chat,
            title: 'My localized title',
          ),
          OptionItem(
            onTap: () =>
                debugPrint('Another option working!'),
            iconData: Icons.chat,
            title: 'Another localized title',
          ),
        ];
      },
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 0),
          child: Chewie(
            controller: chewieController!,
          ),
        ),
      ),
    );
  }
}




